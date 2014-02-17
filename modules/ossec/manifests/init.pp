class ossec (
    $version                 = '2.7.1', 
    $email_notification      = 'no',
    $email_to                = {},
    $email_from              = undef,
    $smtp_server             = 'localhost',
    $rules                   = {},
    $directories             = {},
    $ignore                  = {},
    $whitelist               = {},
    $log_alert_level         = 1,
    $email_alert_level       = 7,
    $active_response         = 'disabled',
    $active_response_level   = 10,
    $active_response_timeout = '600',
    $localfile               = {},
) {

    File {
        ensure => present,
        owner  => 'root',
        group  => 'ossec',
        mode   => '0440',
        notify => Service['ossec'],
        require => Exec['ossec::install'],
    }

    if !defined(Package['build-essential']) { package { 'build-essential': } }
    if !defined(Package['wget']) { package { 'wget': } }

    user { ['ossec', 'ossecm', 'ossecr']:
        home   => '/var/ossec',
        shell  => '/bin/false',
        before => Exec['ossec::download'],
    }

    exec { 'ossec::download':
        command => "wget http://www.ossec.net/files/ossec-hids-${version}.tar.gz",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/ossec-hids-${version}.tar.gz",
        require => Package['build-essential', 'wget'],
    }

    exec { 'ossec::unpack':
        command => "tar -zxf ossec-hids-${version}.tar.gz",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/ossec-hids-${version}",
        require => Exec['ossec::download'],
    }

    file { '/usr/local/src/ossec-generic_samples.c.patch':
        source  => 'puppet:///modules/ossec/usr/local/src/ossec-generic_samples.c.patch',
        require => undef,
    }

    exec { 'ossec::patch':
        command => 'patch -p 1 src/analysisd/compiled_rules/generic_samples.c ../ossec-generic_samples.c.patch',
        cwd     => "/usr/local/src/ossec-hids-${version}",
        require => [File['/usr/local/src/ossec-generic_samples.c.patch'], Exec['ossec::unpack']],
        unless  => 'grep "https://support.google.com/webmasters/answer/80553" src/analysisd/compiled_rules/generic_samples.c',
    }

    exec { 'ossec::make::all':
        command => 'make all',
        cwd     => "/usr/local/src/ossec-hids-${version}/src",
        creates => "/usr/local/src/ossec-hids-${version}/src/Config.OS",
        require => Exec['ossec::patch'],
    }

    exec { 'ossec::make::build':
        command => 'make build',
        cwd     => "/usr/local/src/ossec-hids-${version}/src",
        creates => "/usr/local/src/ossec-hids-${version}/bin/ossec-execd",
        require => Exec['ossec::make::all'],
        notify  => Exec['ossec::install'],
    }

    exec { 'ossec::install':
        command     => "/usr/local/src/ossec-hids-${version}/src/InstallServer.sh local",
        cwd         => "/usr/local/src/ossec-hids-${version}/src",
        require     => Exec['ossec::make::build'],
        refreshonly => true,
        notify      => Service['ossec'],
    }

    # Generates /etc/ossec-init.conf
    exec { 'ossec::initfile':
        command => "echo \"DIRECTORY=/var/ossec/\" > /etc/ossec-init.conf;
                    echo \"VERSION=`cat /usr/local/src/ossec-hids-${version}/src/VERSION`\" >> /etc/ossec-init.conf;
                    echo \"DATE=\\\"`date`\\\"\" >> /etc/ossec-init.conf;
                    echo \"TYPE=local\" >> /etc/ossec-init.conf",
        creates => '/etc/ossec-init.conf',
        require => Exec['ossec::install'],
    }

    file { '/etc/ossec-init.conf':
        mode    => '0600',
        require => Exec['ossec::initfile'],
    }

    file { '/var/ossec/ossec-init.conf':
        source  => '/etc/ossec-init.conf',
        require => File['/etc/ossec-init.conf'],
    }

    file { '/etc/init.d/ossec':
        source  => "/usr/local/src/ossec-hids-${version}/src/init/ossec-hids-debian.init",
        mode    => '0755',
    }

    file { '/var/ossec/etc/decoder.xml':
        source => 'puppet:///modules/ossec/var/ossec/etc/decoder.xml',
    }

    file { '/var/ossec/active-response/bin/ferm-drop.sh':
        source => 'puppet:///modules/ossec/var/ossec/active-response/bin/ferm-drop.sh',
        mode   => '0775',
    }

    file { '/var/ossec/etc/ossec.conf':
        content => template('ossec/etc/ossec.conf.erb'),
    }

    service { 'ossec':
        ensure     => running,
        enable     => true,
        hasrestart => false,
        require    => File['/etc/init.d/ossec'],
    }

}
