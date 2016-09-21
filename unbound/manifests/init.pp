class unbound {

    if !defined(Package['unbound']) {
        package { 'unbound': }
    }

    service { 'unbound':
        ensure  => running,
        enable  => true,
        require => Package['unbound'],
    }

}
