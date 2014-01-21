class apache::mod::ssl {

    exec { 'a2enmod ssl':
        creates => ['/etc/apache2/mods-enabled/ssl.conf', '/etc/apache2/mods-enabled/ssl.load'],
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

}
