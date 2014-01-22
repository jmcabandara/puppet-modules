class php::xsl {
    if !defined(Package['php5-xsl']) { package { 'php5-xsl': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/xsl.ini':
        content => template('php/etc/php5/mods-available/xsl.ini.erb'),
        require => Package['php5-xsl'],
        notify  => Exec['php::restart'],
    }
}
