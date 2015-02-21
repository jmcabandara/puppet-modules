class rsyslog (
    $repeatedmsgreduction = 'on',
) {
    if !defined(Package['rsyslog']) {
        package { 'rsyslog': }
    }

    file { '/etc/rsyslog.conf':
        content => template('rsyslog/etc/rsyslog.conf.erb'),
        require => Package['rsyslog'],
        notify  => Service['rsyslog'],
    }

    service { 'rsyslog':
        ensure  => running,
        enable  => true,
        require => Package['rsyslog'],
    }
}
