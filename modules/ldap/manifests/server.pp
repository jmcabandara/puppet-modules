class ldap::server {
    if !defined(Package['slapd']) { package { 'slapd': } }
    if !defined(Package['ldap-utils']) { package { 'ldap-utils': } }

    service { 'slapd':
        ensure  => running,
        enable  => true,
        require => Package['slapd'],
    }
}
