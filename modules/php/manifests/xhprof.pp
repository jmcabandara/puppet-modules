class php::xhprof (
    $output_dir = undef,
) {
    if !defined(Package['php5-xhprof']) { package { 'php5-xhprof': require => Package['php5-cli'] } }

    file { '/etc/php5/mods-available/xhprof.ini':
        content => template('php/etc/php5/mods-available/xhprof.ini.erb'),
        require => Package['php5-xhprof'],
        notify  => Exec['php::restart'],
    }
}
