class apache::mod::status ($enabled = true) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/status.load':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/status.load',
            default => 'absent',
        },
    }

    file { '/etc/apache2/conf.d/server-status':
        source  => 'puppet:///modules/apache/etc/apache2/conf.d/server-status',
    }
}
