class jenkins {

    if !defined(Package['jenkins']) { package { 'jenkins': } }

    service { 'jenkins':
        ensure  => running,
        enable  => true,
        require => Package['jenkins'],
    }
}
