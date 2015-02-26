class redis (
    $appendonly = 'no',
    $appendfsync = 'everysec',
) {

    package { 'redis-server': }

    file { '/etc/default/redis-server':
        content => template('redis/etc/default/redis-server.erb'),
        notify  => Service['redis-server'],
    }

    file { '/etc/redis/redis.conf':
        content => template('redis/etc/redis/redis.conf.erb'),
        notify  => Service['redis-server'],
    }

    service { 'redis-server':
        ensure  => running,
        enable  => true,
        require => Package['redis-server'],
    }

}
