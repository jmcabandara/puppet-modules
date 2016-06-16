class php::oauth (
    $version = '5',
) {

    if !defined(Package["php${version}-oauth"]) {
        package { "php${version}-oauth":
            require => Package["php${version}-cli"],
        }
    }

    file { '/etc/php5/mods-available/oauth.ini':
        content => template('php/etc/php5/mods-available/oauth.ini.erb'),
        require => Package["php${version}-oauth"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::oauth::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL oauth',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-oauth.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/oauth.ini'],
        notify   => Exec['php::restart'],
    }

}
