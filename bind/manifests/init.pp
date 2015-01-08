class bind (
    $forwarders = [],
    $allow_new_zones = true,
    $response_policy = undef,
) {

    if !defined(Package['bind9']) { package { 'bind9': } }

    service { 'bind9':
        ensure => running,
        enable => true,
    }

    file { '/etc/bind/named.conf.options':
        content => template('bind/etc/bind/named.conf.options.erb'),
        require => Package['bind9'],
        notify  => Service['bind9'],
    }

    # Get a fresh copy of the active zones
    exec { 'bind::dump.db':
        command => "rndc dumpdb -zones",
        require => Service['bind9'],
    }

}
