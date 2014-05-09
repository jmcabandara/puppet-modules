class zabbix::javagateway {

    if !defined(Package['zabbix-java-gateway']) { package { 'zabbix-java-gateway': } }

    service { 'zabbix-java-gateway':
        ensure  => running,
        enable  => true,
        require => Package['zabbix-java-gateway'],
    }

}
