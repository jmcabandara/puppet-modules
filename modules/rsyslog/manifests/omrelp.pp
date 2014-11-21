class rsyslog::omrelp (
    $preservefqdn = 'on',
    $port = 514,
    $host,
) {

    if !defined(Package['rsyslog-relp']) {
        package { 'rsyslog-relp': }
    }

    file { '/etc/rsyslog.d/00-omrelp.conf':
        content => template('rsyslog/etc/rsyslog.d/omrelp.conf.erb'),
        require => Package['rsyslog'],
        notify  => Service['rsyslog'],
    }
}
