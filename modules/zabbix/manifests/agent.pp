class zabbix::agent (
    $server = 'localhost',
    $serveractive = '127.0.0.1',
    $listenport = undef,
    $startagents = undef,
) {

    if !defined(Package['zabbix-agent']) { package { 'zabbix-agent': } }

    service { 'zabbix-agent':
        ensure  => running,
        enable  => true,
        require => Package['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf':
        content => template('zabbix/etc/zabbix/zabbix_agentd.conf.erb'),
        require => Package['zabbix-agent'],
        notify  => Service['zabbix-agent'],
    }
}
