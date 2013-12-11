class apache::mod::headers ($enabled = true) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/headers.load':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/headers.load',
            default => 'absent',
        },
    }

}
