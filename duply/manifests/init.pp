class duply {

    if !defined(Package['duply']) {
        package { 'duply': }
    }

    if !defined(Package['python-boto']) {
        package { 'python-boto': }
    }

    file { '/etc/duply':
        ensure => directory,
    }

}
