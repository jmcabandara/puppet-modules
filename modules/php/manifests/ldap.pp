class php::ldap (
    $max_links = undef,
) {
    if !defined(Package['php5-ldap']) { package { 'php5-ldap': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/ldap.ini':
        content => template('php/etc/php5/mods-available/ldap.ini.erb'),
        require => Package['php5-ldap'],
        notify  => Exec['php::restart'],
    }
}
