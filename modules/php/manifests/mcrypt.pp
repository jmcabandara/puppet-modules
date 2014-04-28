class php::mcrypt (
    $algorithms_dir = undef,
    $modes_dir = undef,
) {
    if !defined(Package['php5-mcrypt']) { package { 'php5-mcrypt': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/mcrypt.ini':
        content => template('php/etc/php5/mods-available/mcrypt.ini.erb'),
        require => Package['php5-mcrypt'],
        notify  => Exec['php::restart'],
    }
}
