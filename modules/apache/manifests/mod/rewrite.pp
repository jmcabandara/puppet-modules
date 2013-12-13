class apache::mod::rewrite ($enabled = true) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/rewrite.load':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/rewrite.load',
            default => 'absent',
        },
    }
}