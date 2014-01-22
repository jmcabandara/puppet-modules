class php::oauth {
    if !defined(Package['php5-oauth']) { package { 'php5-oauth': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/oauth.ini':
        content => template('php/etc/php5/mods-available/oauth.ini.erb'),
        require => Package['php5-oauth'],
        notify  => Exec['php::restart'],
    }
}
