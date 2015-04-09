class memcached (
    $daemon = true,
    $memory = 64,
    $port = 11211,
    $user = 'memcache',
    $listen = '127.0.0.1',
    $connections = 1024,
) {
    if !defined(Package['memcached']) { package { 'memcached': } }

    service { 'memcached':
        ensure  => running,
        enable  => true,
        require => Package['memcached'],
    }

    file { '/etc/memcached.conf':
        content => template('memcached/etc/memcached.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['memcached'],
        notify  => Service['memcached'],
    }
}
