define unbound::local_zone (
    $zone = $title,
    $type,
    $local_data = [],
    $local_data_ptr = [],
) {

    file { "/etc/unbound/unbound.conf.d/${title}.conf":
        content => template('unbound/etc/unbound/unbound.conf.d/zone.conf.erb'),
        require => Package['unbound'],
        notify  => Service['unbound'],
    }

}
