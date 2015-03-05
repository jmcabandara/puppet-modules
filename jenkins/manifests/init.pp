class jenkins (
    $http_port = 8080,
    $ajp_port = '-1',
    $prefix = undef,
    $java_args = '-Djava.awt.headless=true',
) {

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
        restart => 'curl -X POST http://localhost:8080/safeRestart',
        require => Package['jenkins'],
    }

    # the jenkins::plugin definition expects this directory to be present
    file { '/var/lib/jenkins/plugins':
        ensure  => directory,
        require => Package['jenkins'],
        owner   => 'jenkins',
        group   => 'nogroup',
    }

    file { '/etc/default/jenkins':
        content => template('jenkins/etc/default/jenkins.erb'),
        require => Package['jenkins'],
        notify  => Service['jenkins'],
    }

}
