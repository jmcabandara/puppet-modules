class php::gd (
    $jpeg_ignore_warning = undef,
    $version = '5',
) {

    if !defined(Package["php${version}-gd"]) {
        package { "php${version}-gd":
            require => Package["php${version}-cli"],
        }
    }

    file { '/etc/php5/mods-available/gd.ini':
        content => template('php/etc/php5/mods-available/gd.ini.erb'),
        require => Package["php${version}-gd"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::gd::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL gd',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-gd.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/gd.ini'],
        notify   => Exec['php::restart'],
    }

}
