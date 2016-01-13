class mongodb (
    $bind_ip = '127.0.0.1',
    $syslog = false,
    $smallfiles = false,
) {

    include apt

    apt::source { 'mongodb':
        location    => 'http://repo.mongodb.org/apt/ubuntu',
        release     => 'trusty/mongodb-org/3.0',
        repos       => 'multiverse',
        key         => '7F0CEB10',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false,
        before      => Package['mongodb'],
    }

    if !defined(Package['mongodb']) {
        package { 'mongodb':
            name => 'mongodb-org',
        }
    }

    file { '/etc/mongod.conf':
        content => template('mongodb/etc/mongod.conf.erb'),
        require => Package['mongodb'],
        notify  => Service['mongod'],
    }

    service { 'mongod':
        ensure  => running,
        enable  => true,
        require => [File['/etc/mongod.conf'], Package['mongodb']],
    }
}
