class php::xmlrpc {
    if !defined(Package['php5-xmlrpc']) { package { 'php5-xmlrpc': require => Package['php5-cli'] } }

    file { '/etc/php5/conf.d/xmlrpc.ini':
        content => template('php/etc/php5/conf.d/xmlrpc.ini.erb'),
        require => Package['php5-xmlrpc'],
        notify  => Exec['php::restart'],
    }
}
