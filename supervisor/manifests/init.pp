class supervisor {

    if !defined(Package['supervisor']) {
        package { 'supervisor': }
    }

    file { '/etc/supervisor/conf.d':
        ensure  => directory,
        recurse => true,
        purge   => true,
        require => Package['supervisor'],
        notify  => Exec['supervisor::reload'],
    }

    service { 'supervisor':
        ensure  => running,
        enable  => true,
        require => Package['supervisor'],
    }

    exec { 'supervisor::reload':
        command     => 'supervisorctl reread && supervisorctl update',
        require     => Service['supervisor'],
        refreshonly => true,
    }

    file { '/usr/local/bin/sv':
        ensure => '/usr/bin/supervisorctl',
    }
}
