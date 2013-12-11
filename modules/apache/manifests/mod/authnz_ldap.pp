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
    file { '/etc/apache2/mods-enabled/ldap.load':
        ensure => $enabled ? {
            true    => '/etc/apache2/mods-available/ldap.load',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/ldap.conf':
        ensure => $enabled ? {
            true    => 'present',
            default => 'absent',
        },
        content => 'LDAPTrustedGlobalCert CA_DER /etc/ssl/certs/ca-certificates.crt',
    }
}
