class docker {

    if !defined(Package['docker.io']) { package { 'docker.io': } }

    file { '/usr/bin/docker':
        source  => '/usr/bin/docker.io',
        require => Package['docker.io'],
    }

}
