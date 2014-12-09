define bind::zone (
    $zone = $title,
    $options = '',
    $force = false,
) {

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
