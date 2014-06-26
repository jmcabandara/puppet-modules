class php::uploadprogress {

    if !defined(Package['php-pear']) { package { 'php-pear': } }

    exec { 'php::uploadprogress':
        command => 'pecl install uploadprogress',
        require => Package['php-pear'],
        unless  => 'pecl list uploadprogress',
    }

    file { '/etc/php5/mods-available/uploadprogress.ini':
        content => template('php/etc/php5/mods-available/uploadprogress.ini.erb'),
        require => Exec['php::uploadprogress'],
        notify  => Exec['php::restart'],
    }

    exec { 'php::uploadprogress:enable':
        command  => 'php5enmod -s ALL uploadprogress',
        require  => File['/etc/php5/mods-available/uploadprogress.ini'],
        onlyif   => [ 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-uploadprogress.ini ]; then echo "onlyif"; fi; done | grep onlyif'],
        provider => 'shell',
        notify   => Exec['php::restart'],
    }
}
