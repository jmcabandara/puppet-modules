class netatalk (
    $protocol = '-tcp -noddp',
    $uamlist = 'uams_dhx.so,uams_dhx2.so',
    $password = '-nosavepassword',
    $guestname = 'nobody',
    $mimicmodel = 'Xserve',
    $volumes = { '~/' => 'Home Directory' },
) {

    File {
        require => Package['netatalk'],
        notify  => Service['netatalk'],
    }

    if !defined(Package['netatalk']) { package { 'netatalk': } }

    file { '/etc/netatalk/afpd.conf':
        content => template('netatalk/etc/netatalk/afpd.conf.erb'),
    }

    file { '/etc/netatalk/AppleVolumes.default':
        content => template('netatalk/etc/netatalk/AppleVolumes.default.erb'),
    }

    service { 'netatalk':
        ensure    => running,
        enable    => true,
        hasstatus => false,
        status    => 'ps -h --pid `cat /var/run/afpd.pid`',
        require   => Package['netatalk'],
    }
}
