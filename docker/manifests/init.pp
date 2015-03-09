class docker (
    $package = 'docker.io',
    $docker_opts = undef,
) {

    apt::source { 'docker':
        location    => 'https://get.docker.com/ubuntu/',
        release     => 'docker',
        repos       => 'main',
        key         => 'A88D21E9',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false,
        before      => Package['docker'],
    }

    package { 'docker':
        name => $package,
    }

    file { '/etc/default/docker':
        path    => $package ? {
            'docker.io'  => '/etc/default/docker.io',
            'lxc-docker' => '/etc/default/docker',
            default      => '/etc/default/docker',
        },
        content => template('docker/etc/default/docker.erb'),
        require => Package['docker'],
        notify  => Service['docker']
    }

    service { 'docker':
        name    => $package ? {
            'lxc-docker' => 'docker',
            default      => $package,
        },
        ensure  => running,
        enable  => true,
        require => Package['docker'],
    }

}
