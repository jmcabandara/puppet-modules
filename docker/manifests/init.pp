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

    if !defined(Package['lvm2']) {
        package { 'lvm2': }
    }

    if !defined(Package['xfsprogs']) {
        package { 'xfsprogs': }
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

    # Recompile lxc-docker from source to enable udev sync
    if ($package == 'lxc-docker') {
        require ::btrfs

        if !defined(Package['build-essential']) {
            package { 'build-essential': }
        }

        if !defined(Package['golang']) {
            package { 'golang': }
        }

        if !defined(Package['golang-gosqlite-dev']) {
            package { 'golang-gosqlite-dev': }
        }

        if !defined(Package['libdevmapper-dev']) {
            package { 'libdevmapper-dev': }
        }

        exec { 'docker::download':
            command => 'git clone https://git@github.com/docker/docker',
            cwd     => '/usr/local/src',
            creates => '/usr/local/src/docker',
            require => Package['build-essential', 'golang', 'golang-gosqlite-dev', 'libdevmapper-dev', 'lxc-docker'],
        }

        exec { 'docker::version':
            command  => 'git checkout v$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\')',
            cwd      => '/usr/local/src/docker',
            require  => Exec['docker::download'],
            unless  => 'git status | grep "HEAD detached at v$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\')"',
        }

        exec { 'docker::compile':
            command     => '/usr/local/src/docker/hack/make.sh dynbinary',
            cwd         => '/usr/local/src/docker',
            environment => ['AUTO_GOPATH=1'],
            require     => Exec['docker::version'],
            unless      => 'test -d /usr/local/src/docker/bundles/$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\')',
        }

        exec { 'docker::install::docker':
            command     => 'install -m 755 -o root -g root /usr/local/src/docker/bundles/$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\')/dynbinary/docker-$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\') /usr/bin/docker',
            subscribe   => Exec['docker::compile'],
            notify      => Service['docker'],
            refreshonly => true,
        }

        exec { 'docker::install::dockerinit-version':
            command     => 'install -m 755 -o root -g root /usr/local/src/docker/bundles/$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\')/dynbinary/dockerinit-$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\') /var/lib/docker/init/dockerinit-$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\')',
            subscribe   => Exec['docker::compile'],
            notify      => Service['docker'],
            refreshonly => true,
        }

        exec { 'docker::install::dockerinit':
            command     => 'install -m 755 -o root -g root /usr/local/src/docker/bundles/$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\')/dynbinary/dockerinit-$(dpkg -s lxc-docker | grep Version | awk \'{print $2}\') /usr/bin/dockerinit',
            subscribe   => Exec['docker::compile'],
            notify      => Service['docker'],
            refreshonly => true,
        }
    }
}
