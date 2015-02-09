class duply {

    if !defined(Package['duply']) {
        package { 'duply': }
    }

    file { '/etc/duply':
        ensure => directory,
    }

}
