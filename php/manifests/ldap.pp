class php::ldap (
    $max_links = undef,
    $version = '5',
) {

    if !defined(Package["php${version}-ldap"]) {
        package { "php${version}-ldap":
            require => Package["php${version}-cli"],
        }
    }

    file { '/etc/php5/mods-available/ldap.ini':
        content => template('php/etc/php5/mods-available/ldap.ini.erb'),
        require => Package["php${version}-ldap"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::ldap::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL ldap',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-ldap.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/ldap.ini'],
        notify   => Exec['php::restart'],
    }

}
