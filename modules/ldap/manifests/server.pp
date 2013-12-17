class ldap::server (
    $services = 'ldap:/// ldapi:///',
) {
    if !defined(Package['slapd']) { package { 'slapd': } }
    if !defined(Package['ldap-utils']) { package { 'ldap-utils': } }

    service { 'slapd':
        ensure  => running,
        enable  => true,
        require => Package['slapd'],
    }

    file { '/etc/default/slapd':
        content => template('ldap/etc/default/slapd.erb'),
        require => Package['slapd'],
        notify  => Service['slapd'],
    }
}
