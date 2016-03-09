class zabbix::server (
    $start = 'yes',
    $dbhost = 'localhost',
    $dbname = 'zabbix',
    $dbuser = 'zabbix',
    $dbpassword = undef,
    $javagateway = undef,
    $javagatewayport = undef,
    $startjavapollers = undef,
    $timeout = 3,
    $fpinglocation = '/usr/bin/fping',
    $fping6location = undef,
    $cachesize = '8M',
) {

    if !defined(Package['zabbix-frontend-php']) { package { 'zabbix-frontend-php': } }
    if !defined(Package['zabbix-server-mysql']) { package { 'zabbix-server-mysql': } }

    service { 'zabbix-server':
        ensure  => running,
        enable  => true,
        require => Package['zabbix-server-mysql'],
    }

    file { '/etc/zabbix/zabbix_server.conf':
        content => template('zabbix/etc/zabbix/zabbix_server.conf.erb'),
        require => Package['zabbix-server-mysql'],
        notify  => Service['zabbix-server'],
    }

    file { '/etc/default/zabbix-server':
        content => template('zabbix/etc/default/zabbix-server.erb'),
        require => Package['zabbix-server-mysql'],
        notify  => Service['zabbix-server'],
    }

    file { '/etc/sysctl.d/60-zabbix-server.conf':
        content => template('zabbix/etc/sysctl.d/60-zabbix-server.conf.erb'),
        notify  => Exec['zabbix::server::procps'],
    }

    exec { 'zabbix::server::procps':
        command     => 'service procps start',
        refreshonly => true,
    }
}
