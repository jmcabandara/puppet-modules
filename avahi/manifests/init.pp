class avahi (
    $domain_name = 'local',
) {

    if !defined(Package['avahi-daemon']) {
        package { 'avahi-daemon': }
    }

    file { '/etc/avahi/avahi-daemon.conf':
        content => template('avahi/etc/avahi/avahi-daemon.conf.erb'),
        require => Package['avahi-daemon'],
        notify  => Service['avahi-daemon'],
    }

    service { 'avahi-daemon':
        ensure  => running,
        enable  => true,
        require => Package['avahi-daemon'],
    }

}
