class bind (
    $directory = '/var/cache/bind',
    $forwarders = [],
    $zone_notify = 'yes',
    $also_notify = [],
    $recursion = 'yes',
) {

    if !defined(Package['bind9']) {
        package { 'bind9': }
    }

    file { '/etc/bind/named.conf.options':
        content => template('bind/etc/bind/named.conf.options.erb'),
        require => Package['bind9'],
        notify  => Service['bind9'],
    }

    service { 'bind9':
        ensure => running,
        enable => true,
    }

}
