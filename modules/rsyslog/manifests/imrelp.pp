class rsyslog::imrelp (
    $preservefqdn = 'on',
    $port = 514,
) {

    if !defined(Package['rsyslog-relp']) {
        package { 'rsyslog-relp': }
    }

    file { '/etc/rsyslog.d/00-imrelp.conf':
        content => template('rsyslog/etc/rsyslog.d/imrelp.conf.erb'),
        require => Package['rsyslog'],
        notify  => Service['rsyslog'],
    }
}
