class openvpn {

    if !defined(Package['easy-rsa']) { package { 'easy-rsa': } }
    if !defined(Package['openvpn']) { package { 'openvpn': } }
    if !defined(Package['openvpn-auth-ldap']) { package { 'openvpn-auth-ldap': } }
    if !defined(Package['openvpn-auth-radius']) { package { 'openvpn-auth-radius': } }

    openvpn::dh { '1024': }
    openvpn::dh { '2048': }

    service { 'openvpn':
        ensure  => running,
        enable  => true,
        require => Package['openvpn'],
    }

}
