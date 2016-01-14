define supervisor::program (
    $program = $title,
    $user = undef,
    $command
) {

    file { "/etc/supervisor/conf.d/${program}.conf":
        content => template('supervisor/etc/supervisor/conf.d/program.conf.erb'),
        require => [Package['supervisor'], Service['supervisor']],
        notify  => Exec['supervisor::reload'],
    }

}
