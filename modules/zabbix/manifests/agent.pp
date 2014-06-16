class zabbix::agent (
    $server = '127.0.0.1',
    $serveractive = '127.0.0.1',
) {

    if !defined(Package['zabbix-agent']) { package { 'zabbix-agent': } }

    service { 'zabbix-agent':
        ensure   => running,
        enable   => true,
        provider => 'init',
        require  => Package['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf':
        content => template('zabbix/etc/zabbix/zabbix_agentd.conf.erb'),
        require => Package['zabbix-agent'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d':
        ensure  => directory,
        source  => 'puppet:///modules/zabbix/etc/zabbix/zabbix_agentd.conf.d',
        recurse => true,
        require => Package['zabbix-agent'],
        notify  => Service['zabbix-agent'],
    }

    user { 'zabbix':
        groups  => 'adm',
        require => Package['zabbix-agent'],
    }
}
