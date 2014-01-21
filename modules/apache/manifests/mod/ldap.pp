class apache::mod::ldap (
    $enabled = true,
    $require_ip = {},
    $require_host = {},
) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/ldap.load':
        ensure => $enabled ? {
            true    => '/etc/apache2/mods-available/ldap.load',
            default => 'absent',
        },
    }

    file { '/etc/apache2/mods-available/ldap.conf':
        content => template('apache/etc/apache2/mods-available/ldap.conf.erb');
    }
    file { '/etc/apache2/mods-enabled/ldap.conf':
        ensure => $enabled ? {
            true    => '/etc/apache2/mods-available/ldap.conf',
            default => 'absent',
        },
    }
}
