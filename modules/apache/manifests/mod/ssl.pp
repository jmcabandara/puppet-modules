class apache::mod::ssl ($enabled = true) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/ssl.conf':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/ssl.conf',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/ssl.load':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/ssl.load',
            default => 'absent',
        },
    }
}
