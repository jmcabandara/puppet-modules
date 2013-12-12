class php::curl (
    $cainfo = undef,
) {
    if !defined(Package['php5-curl']) { package { 'php5-curl': require => Package['php5-cli'] } }

    file { '/etc/php5/conf.d/curl.ini':
        content => template('php/etc/php5/conf.d/curl.ini.erb'),
        require => Package['php5-curl'],
        notify  => Exec['php::restart'],
    }
}
