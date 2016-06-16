class php::xsl (
    $version = '5',
) {

    if !defined(Package["php${version}-xsl"]) {
        package { "php${version}-xsl":
            require => Package["php${version}-cli"],
        }
    }

    file { '/etc/php5/mods-available/xsl.ini':
        content => template('php/etc/php5/mods-available/xsl.ini.erb'),
        require => Package["php${version}-xsl"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::xsl::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL xsl',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-xsl.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/xsl.ini'],
        notify   => Exec['php::restart'],
    }

}
