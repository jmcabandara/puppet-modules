class jenkins {

    apt::source { 'jenkins':
        location    => 'http://pkg.jenkins-ci.org/debian',
        release     => 'binary/',
        repos       => '',
        include_src => false,
        key         => '10AF40FE',
        key_source  => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
        before      => Package['jenkins'],
    }

    if !defined(Package['jenkins']) { package { 'jenkins': } }

    service { 'jenkins':
        ensure  => running,
        enable  => true,
        require => Package['jenkins'],
    }

    # the jenkins::plugin definition expects this directory to be present
    file { '/var/lib/jenkins/plugins':
        ensure  => directory,
        require => Package['jenkins'],
        owner   => 'jenkins',
        group   => 'nogroup',
    }

}
