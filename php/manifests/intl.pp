class php::intl (
    $default_locale = undef,
    $error_level = undef,
    $use_exceptions = undef,
    $version = '5',
) {

    if !defined(Package["php${version}-intl"]) {
        package { "php${version}-intl":
            require => Package["php${version}-cli"],
        }
    }

    file { '/etc/php5/mods-available/intl.ini':
        content => template('php/etc/php5/mods-available/intl.ini.erb'),
        require => Package["php${version}-intl"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::intl::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL intl',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-intl.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/intl.ini'],
        notify   => Exec['php::restart'],
    }

}
