define supervisor::program (
    $program = $title,
    $user = undef,
    $redirect_stderr = false,
    $stdout_logfile = 'AUTO',
    $directory = undef,
    $environment = undef,
    $autorestert = undef,
    $command
) {

    file { "/etc/supervisor/conf.d/${program}.conf":
        content => template('supervisor/etc/supervisor/conf.d/program.conf.erb'),
        require => [Package['supervisor'], Service['supervisor']],
        notify  => Exec['supervisor::reload'],
    }

    exec { "supervisor::restart::${program}":
        command     => "supervisorctl restart ${program}",
        refreshonly => true,
    }
}
