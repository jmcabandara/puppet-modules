class php::imagick (
    $locale_fix = undef,
    $progress_monitor = undef,
) {
    if !defined(Package['php5-imagick']) { package { 'php5-imagick': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/imagick.ini':
        content => template('php/etc/php5/mods-available/imagick.ini.erb'),
        require => Package['php5-imagick'],
        notify  => Exec['php::restart'],
    }
}
