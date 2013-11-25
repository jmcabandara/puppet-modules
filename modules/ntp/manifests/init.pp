class ntp {

    if !defined(Package['ntp']) { package { 'ntp': } }

    service { 'ntp':
        ensure => running,
        enable => true,
        require => Package['ntp'],
    }

}
