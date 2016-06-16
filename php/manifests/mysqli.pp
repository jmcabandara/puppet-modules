class php::mysqli (
    $allow_local_infile = undef,
    $allow_persistent = undef,
    $max_persistent = undef,
    $max_links = undef,
    $default_port = undef,
    $default_socket = undef,
    $default_host = undef,
    $default_user = undef,
    $default_pw = undef,
    $reconnect = undef,
    $cache_size = undef,
    $version = '5',
) {

    if !defined(Package["php${version}-mysql"]) {
        package { "php${version}-mysql":
            require => Package["php${version}-cli"],
        }
    }

    file { '/etc/php5/mods-available/mysqli.ini':
        content => template('php/etc/php5/mods-available/mysqli.ini.erb'),
        require => Package["php${version}-mysql"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::mysqli::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL mysqli',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-mysqli.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/mysqli.ini'],
        notify   => Exec['php::restart'],
    }

}
