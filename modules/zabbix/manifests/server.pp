class zabbix::server (
    $dbhost = 'localhost',
    $dbname = 'zabbix',
    $dbuser = 'zabbix',
    $dbpassword = undef,
    $javagateway = undef,
    $javagatewayport = undef,
    $startjavapollers = undef,
    $timeout = 3,
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
}
