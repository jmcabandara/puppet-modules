class apache::mod::authnz_ldap ($enabled = true) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/authnz_ldap.load':
        ensure => $enabled ? {
            true    => '/etc/apache2/mods-available/authnz_ldap.load',
            default => 'absent',
        },
    }
}
