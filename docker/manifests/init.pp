class docker (
    $package = 'docker.io',
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

    service { 'docker':
        ensure  => running,
        enable  => true,
        require => Package['docker'],
    }

}
