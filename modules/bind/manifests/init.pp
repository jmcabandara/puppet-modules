class bind {

    if !defined(Package['bind9']) { package { 'bind9': } }

    service { 'bind9':
        ensure => running,
        enable => true,
    }

    file { '/etc/bind/named.conf.options':
        source  => 'puppet:///modules/bind/etc/bind/named.conf.options',
        require => Package['bind9'],
        notify  => Service['bind9'],
    }

    # Get a fresh copy of the active zones
    exec { 'bind::dump.db':
        command => "rndc dumpdb -zones",
        require => Service['bind9'],
    }

}
