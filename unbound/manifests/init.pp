class unbound (
    $resolvconf = true,
) {

    if !defined(Package['unbound']) {
        package { 'unbound': }
    }

    file { '/etc/default/unbound':
        content => template('unbound/etc/default/unbound.erb'),
        require => Package['unbound'],
        notify  => Service['unbound'],
    }

    service { 'unbound':
        ensure  => running,
        enable  => true,
        require => Package['unbound'],
    }

}
