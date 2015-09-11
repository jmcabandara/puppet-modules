class zabbix::agent (
    $listenip = undef,
    $server = '127.0.0.1',
    $serveractive = '127.0.0.1',
    $timeout = 3,
    $hostmetadata = undef,
    $hostmetadataitem = undef,
) {

    include ::jq

    if !defined(Package['zabbix-agent']) {
        package { 'zabbix-agent': }
    }

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

    user { 'zabbix':
        groups  => 'adm',
        require => Package['zabbix-agent'],
    }

    # UserParameter Files
    file { '/etc/zabbix/zabbix_agentd.conf.d':
        ensure  => directory,
        source  => 'puppet:///modules/zabbix/etc/zabbix/zabbix_agentd.conf.d',
        recurse => true,
        purge   => true,
        require => Package['zabbix-agent'],
        notify  => Service['zabbix-agent'],
    }

}
