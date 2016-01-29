class bind (
    $directory = '/var/cache/bind',
    $forwarders = [],
    $zone_notify = [],
    $also_notify = [],
) {

    if !defined(Package['bind9']) {
        package { 'bind9': }
    }

    file { '/etc/bind':
        ensure => directory,
        require => Package['bind9'],
        mode    => '0775',
    }

    file { '/etc/bind/named.conf.options':
        content => template('bind/etc/bind/named.conf.options.erb'),
        require => Package['bind9'],
        notify  => Service['bind9'],
    }

    file { '/etc/bind/named.conf.local':
        ensure  => present,
        require => Package['bind9'],
        mode    => '0664',
    }

    service { 'bind9':
        ensure => running,
        enable => true,
    }

}
