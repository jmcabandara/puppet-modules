class php::gd (
    $jpeg_ignore_warning = undef,
) {
    if !defined(Package['php5-gd']) { package { 'php5-gd': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/gd.ini':
        content => template('php/etc/php5/mods-available/gd.ini.erb'),
        require => Package['php5-gd'],
        notify  => Exec['php::restart'],
    }
}
