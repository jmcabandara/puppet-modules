class asterisk (
    $version = '11.7.0',
    $odbc = true,
    $opus = true
) {

    File { ensure => present }

    if !defined(Package['build-essential']) { package { 'build-essential': } }
    if !defined(Package['autoconf']) { package { 'autoconf': } }
    if !defined(Package['git']) { package { 'git': } }
    if !defined(Package['libncurses5-dev']) { package { 'libncurses5-dev': } }
    if !defined(Package['libssl-dev']) { package { 'libssl-dev': } }
    if !defined(Package['libxml2-dev']) { package { 'libxml2-dev': } }
    if !defined(Package['libsqlite3-dev']) { package { 'libsqlite3-dev': } }
    if !defined(Package['uuid-dev']) { package { 'uuid-dev': } }
    if !defined(Package['libnewt-dev']) { package { 'libnewt-dev': } }
    if !defined(Package['libcurl4-openssl-dev']) { package { 'libcurl4-openssl-dev': } }
    if !defined(Package['libsrtp0-dev']) { package { 'libsrtp0-dev': } }
    if !defined(Package['libiksemel-dev']) { package { 'libiksemel-dev': } }
    if !defined(Package['libneon27-dev']) { package { 'libneon27-dev': } }
    if !defined(Package['libical-dev']) { package { 'libical-dev': } }
    if !defined(Package['libopus-dev']) { package { 'libopus-dev': } }
    if !defined(Package['ntp']) { package { 'ntp': } }
    if !defined(Package['wget']) { package { 'wget': } }

    if $odbc { class { 'asterisk::odbc': } }

    user { 'asterisk':
        home  => '/var/lib/asterisk',
        shell => '/bin/bash',
    }

    exec { 'asterisk::download':
        command => "wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${version}.tar.gz",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/asterisk-${version}.tar.gz",
        require => Package['build-essential', 'autoconf', 'ntp', 'libncurses5-dev', 'libssl-dev', 'libxml2-dev', 'libsqlite3-dev', 'uuid-dev', 'libnewt-dev', 'libcurl4-openssl-dev', 'libsrtp0-dev', 'libiksemel-dev', 'libneon27-dev', 'libical-dev', 'libopus-dev', 'wget'],
    }

    exec { 'asterisk::patch-18345::download':
        command => 'wget -O ASTERISK-18345.patch https://issues.asterisk.org/jira/secure/attachment/43792/tls_read.patch',
        cwd     => '/usr/local/src',
        creates => '/usr/local/src/ASTERISK-18345.patch',
        require => Package['wget'],
    }

    exec { 'asterisk::patch-20827::download':
        command => 'wget -O ASTERISK-20827.patch https://issues.asterisk.org/jira/secure/attachment/46265/asterisk-20827-confbridge-events.diff',
        cwd     => '/usr/local/src',
        creates => '/usr/local/src/ASTERISK-20827.patch',
        require => Package['wget'],
    }

    exec { 'asterisk::unpack':
        command => "tar -zxf asterisk-${version}.tar.gz",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::download'],
    }

    exec { 'asterisk::patch-18345::apply':
        command => 'patch -p 1 main/tcptls.c ../ASTERISK-18345.patch',
        cwd     => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::unpack', 'asterisk::patch-18345::download'],
        before  => Exec['asterisk::bootstrap'],
        unless  => 'grep "ssl_read should block and wait for the SSL layer to provide all data" main/tcptls.c',
    }

    exec { 'asterisk::patch-20827::apply':
        command => 'patch apps/app_confbridge.c ../ASTERISK-20827.patch',
        cwd     => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::unpack', 'asterisk::patch-20827::download'],
        before  => Exec['asterisk::bootstrap'],
        unless  => 'grep "static void send_mute_event" apps/app_confbridge.c',
    }


    if $opus {
        exec { 'asterisk::patch-opus::download':
            command => 'git clone https://github.com/netaskd/asterisk-opus.git',
            cwd     => '/usr/local/src',
            creates => '/usr/local/src/asterisk-opus',
            require => Package['git'],
        }

        exec { 'asterisk::patch-opus::apply':
            command => 'patch -p1 -u < ../asterisk-opus/asterisk-11.5.0_opus+vp8.diff',
            cwd     => "/usr/local/src/asterisk-${version}",
            require => Exec['asterisk::unpack', 'asterisk::patch-opus::download'],
            before  => Exec['asterisk::bootstrap'],
            unless  => 'grep AST_FORMAT_OPUS channels/chan_sip.c',
        }
    }

    exec { 'asterisk::bootstrap':
        command => "/usr/local/src/asterisk-${version}/bootstrap.sh",
        cwd     => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::unpack'],
        creates => "/usr/local/src/asterisk-${version}/aclocal.m4",
    }

    exec { 'asterisk::configure':
        command => "/usr/local/src/asterisk-${version}/configure",
        cwd     => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::bootstrap'],
        creates => "/usr/local/src/asterisk-${version}/config.log",
    }

    file { "/usr/local/src/asterisk-${version}/menuselect.makeopts":
        source  => 'puppet:///modules/asterisk/menuselect.makeopts',
        require => Exec['asterisk::configure'],
        notify  => Exec['asterisk::make'],
        owner   => 'root',
        group   => 'root',
    }

    exec { 'asterisk::make':
        command => 'make',
        cwd     => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::configure'],
        creates => "/usr/local/src/asterisk-${version}/defaults.h",
        notify  => Exec['asterisk::make::install'],
    }

    exec { 'asterisk::make::install':
        command     => 'make install',
        cwd         => "/usr/local/src/asterisk-${version}",
        require     => Exec['asterisk::make'],
        refreshonly => true,
        notify      => Service['asterisk'],
    }

    file { '/etc/init.d/asterisk':
        source => 'puppet:///modules/asterisk/rc.debian.asterisk',
        mode   => 0755,
        notify => Service['asterisk'],
    }

    file { '/etc/default/asterisk':
        source => 'puppet:///modules/asterisk/asterisk.default',
        notify => Service['asterisk'],
    }

    file { '/var/run/asterisk': 
        ensure  => directory,
        owner   => 'asterisk',
        group   => 'asterisk',
        require => Exec['asterisk::make::install'],
    }

    exec { 'asterisk::chown::var/lib/asterisk':
        command => 'chown -R asterisk:asterisk /var/lib/asterisk',
        require => Exec['asterisk::make::install'],
    }

    exec { 'asterisk::chown::var/spool/asterisk':
        command => 'chown -R asterisk:asterisk /var/spool/asterisk',
        require => Exec['asterisk::make::install'],
    }

    exec { 'asterisk::chown::var/log/asterisk':
        command => 'chown -R asterisk:asterisk /var/log/asterisk',
        require => Exec['asterisk::make::install'],
    }

    service { 'asterisk':
        ensure  => running,
        enable  => true,
        require => File['/etc/init.d/asterisk', '/etc/default/asterisk'],
    }

}
