class openvpn {
    if !defined(Package['openvpn']) { package { 'openvpn': } }

    service { 'openvpn':
        ensure  => running,
        enable  => true,
        start   => 'service openvpn start || /bin/true',
        require => Package['openvpn'],
    }
}
