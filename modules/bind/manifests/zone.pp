define bind::zone (
    $zone = $title,
    $options = '',
    $force = false,
) {

    if !defined(Exec['bind::dump.db']) {
        exec { 'bind::dump.db':
            command => "rndc dumpdb -zones",
            require => Service['bind9'],
        }
    }

    exec { "bind::zone::${zone}":
        command => "rndc addzone ${zone} '${options}'",
        unless  => "grep \"Zone dump of '${zone}/IN'\" /var/cache/bind/named_dump.db",
        require => [Service['bind9'], Exec['bind::dump.db']],
    }

    if $force {
        exec { "bind::zone::delete::${zone}":
            command => "rndc delzone ${zone}",
            before  => Exec["bind::zone::${zone}"],
            require => Service['bind9'],
        }
    }

}
