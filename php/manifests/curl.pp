class php::curl (
    $cainfo = undef,
    $version = '5',
) {

    if !defined(Package["php${version}-curl"]) {
        package { "php${version}-curl":
            require => Package["php${version}-cli"]
        }
    }

    file { '/etc/php5/mods-available/curl.ini':
        content => template('php/etc/php5/mods-available/curl.ini.erb'),
        require => Package["php${version}-curl"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::curl::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL curl',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-curl.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/curl.ini'],
        notify   => Exec['php::restart'],
    }

}
