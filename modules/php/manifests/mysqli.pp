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
) {
    if !defined(Package['php5-mysql']) { package { 'php5-mysql': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/mysqli.ini':
        content => template('php/etc/php5/mods-available/mysqli.ini.erb'),
        require => Package['php5-mysql'],
        notify  => Exec['php::restart'],
    }

}
