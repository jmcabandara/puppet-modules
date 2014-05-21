class openvpn {
    if !defined(Package['openvpn']) { package { 'openvpn': } }

    service { 'openvpn':
        ensure  => running,
        enable  => true,
        require => Package['openvpn'],
    }
}
