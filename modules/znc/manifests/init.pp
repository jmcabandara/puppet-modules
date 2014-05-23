class znc (
    $port = 6667,
    $ssl = false,
    $ipv6 = false,
    $host = undef,
    $partyline = true,
    $webadmin = true,
) {

    if !defined(Package['znc']) { package { 'znc': } }

    user { 'znc':
        home       => '/var/lib/znc',
        managehome => true,
    }

    file { '/etc/init.d/znc':
        source => 'puppet:///modules/znc/etc/init.d/znc',
    }

    file { ['/var/lib/znc/configs', '/var/lib/znc/modules', '/var/lib/znc/users']:
        ensure  => directory,
        owner   => 'znc',
        group   => 'znc',
        require => User['znc'],
        before  => Service['znc'],
    }

    file { '/var/lib/znc/configs/znc.conf':
        content => template('znc/var/lib/znc/configs/znc.conf.erb'),
        replace => false,
        owner   => 'znc',
        group   => 'znc',
        require => File['/var/lib/znc/configs'],
        before  => Service['znc'],
    }

    service { 'znc':
        ensure  => running,
        enable  => true,
        require => [Package['znc'], User['znc'], File['/etc/init.d/znc']],
    }
}
