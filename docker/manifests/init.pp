class docker (
    $docker_opts = undef,
    $ensure = 'present',
) {

    apt::source { 'docker':
        location    => 'https://apt.dockerproject.org/repo',
        release     => 'ubuntu-trusty',
        repos       => 'main',
        key         => '58118E89F3A912897C070ADBF76221572C52609D',
        key_server  => 'pgp.mit.edu',
        include_src => false,
        before      => Package['docker-engine'],
    }

    if !defined(Package['lvm2']) {
        package { 'lvm2': }
    }

    if !defined(Package['xfsprogs']) {
        package { 'xfsprogs': }
    }

    package { 'lxc-docker':
        ensure => absent,
        before => Package['docker-engine'],
    }

    package { 'docker-engine':
        ensure => $ensure,
    }

    file { '/etc/default/docker':
        content => template('docker/etc/default/docker.erb'),
        require => Package['docker-engine'],
        notify  => Service['docker']
    }

    service { 'docker':
        ensure  => running,
        enable  => true,
        require => Package['docker-engine'],
    }

}
