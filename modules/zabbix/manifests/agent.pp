class zabbix::agent (
    $server = '127.0.0.1',
    $serveractive = '127.0.0.1',
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

    user { 'zabbix':
        groups  => 'adm',
        require => Package['zabbix-agent'],
    }

    # UserParameter Files

    file { '/etc/zabbix/zabbix_agentd.conf.d':
        ensure  => directory,
        recurse => true,
        purge   => true,
        require => Package['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/README':
        content => "## THIS DIRECTORY IS MANAGED BY PUPPET\n## Anything added here manually will automatically be deleted\n",
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/apache.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/apache.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/asterisk.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/asterisk.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/memcached.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/memcached.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/mysql.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/mysql.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/opcache.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/opcache.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/openvpn.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/openvpn.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/postfix.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/postfix.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.conf.d/puppet.conf':
        content => template('zabbix//etc/zabbix/zabbix_agentd.conf.d/puppet.conf.erb'),
        require => File['/etc/zabbix/zabbix_agentd.conf.d'],
        notify  => Service['zabbix-agent'],
    }

}
