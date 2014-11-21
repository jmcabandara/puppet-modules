class rsyslog {
    if !defined(Package['rsyslog']) {
        package { 'rsyslog': }
    }

    service { 'rsyslog':
        ensure  => running,
        enable  => true,
        require => Package['rsyslog'],
    }
}
