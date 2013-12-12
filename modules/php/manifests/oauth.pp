class php::oauth {
    if !defined(Package['build-essential']) { package { 'build-essential': } }
    if !defined(Package['libpcre3-dev']) { package { 'libpcre3-dev': } }

    exec { 'php::oauth::install':
        command => 'pecl install oauth',
        unless  => 'pecl list | grep oauth',
        require => Package['php-pear', 'php5-dev', 'libpcre3-dev', 'build-essential'],
        notify  => Exec['php::restart'],
    }

    file { '/etc/php5/conf.d/oauth.ini':
        content => template('php/etc/php5/conf.d/oauth.ini.erb'),
        require => Exec['php::oauth::install'],
        notify  => Exec['php::restart'],
    }
}
