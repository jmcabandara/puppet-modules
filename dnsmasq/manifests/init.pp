class dnsmasq (
    $start = undef,
) {

    if !defined(Package['dnsmasq']) {
        package { 'dnsmasq': }
    }

    file { '/etc/default/dnsmasq':
        content => template('dnsmasq/etc/default/dnsmasq.erb'),
        require => Package['dnsmasq'],
        notify  => Service['dnsmasq'],
    }

    service { 'dnsmasq':
        ensure  => running,
        enable  => true,
        require => Package['dnsmasq'],
    }

}
