class apache::mod::ldap (
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
        ensure => '/etc/apache2/mods-available/ldap.load',
    }

    file { '/etc/apache2/mods-available/ldap.conf':
        content => template('apache/etc/apache2/mods-available/ldap.conf.erb');
    }

    file { '/etc/apache2/mods-enabled/ldap.conf':
        ensure => '/etc/apache2/mods-available/ldap.conf',
    }
}
