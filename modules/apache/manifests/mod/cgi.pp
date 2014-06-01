class apache::mod::cgi {

    exec { 'a2enmod cgi':
        creates => '/etc/apache2/mods-enabled/cgi.load',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

}
