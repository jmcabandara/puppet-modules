define openvpn::server (
    $local = undef,
    $port = 1194,
    $proto = 'udp',
    $dev = 'tun',
    $dh = '/etc/openvpn/easy-rsa/keys/dh2048.pem',
    $server = '10.8.0.0 255.255.255.0',
    $redirect_gateway = false,
    $dhcp_option = [],
    $client_to_client = false,
    $duplicate_cn = false,
    $tls_auth = true,
    $cipher = 'BF-CBC',
    $comp_lzo = true,
    $user = 'nobody',
    $group = 'nogroup',
    $verb = 3,
    $server_ipv6 = undef,
    $route_ipv6 = [],
    $client_cert_not_required = false,
    $username_as_common_name = false,
    $topology = 'subnet',
    $plugin = [],
    $management = undef,
    $management_client_user = undef,
    $management_client_group = undef,
) {

    if !defined(Package['openvpn']) { package { 'openvpn': } }
    if !defined(Package['openvpn-auth-ldap']) { package { 'openvpn-auth-ldap': } }
    if !defined(Package['openvpn-auth-radius']) { package { 'openvpn-auth-radius': } }

    file { "/etc/openvpn/${title}.conf":
        content => template('openvpn/etc/openvpn/server.conf.erb'),
        require => Package['openvpn', 'openvpn-auth-ldap', 'openvpn-auth-radius'],
        notify  => Service['openvpn'],
    }

    exec { "openvpn::server::${title}::build-key-server":
        command  => ". ./vars && ./pkitool --server ${title}",
        cwd      => '/etc/openvpn/easy-rsa',
        provider => 'shell',
        creates  => [
            "/etc/openvpn/easy-rsa/keys/${title}.key",
            "/etc/openvpn/easy-rsa/keys/${title}.csr",
            "/etc/openvpn/easy-rsa/keys/${title}.crt",
        ],
        require => [
            File['/etc/openvpn/easy-rsa/vars'],
            Exec['openvpn::ca::build-ca'],
        ],
        notify  => Service['openvpn'],
    }

    if $tls_auth {
        exec { "openvpn::server::${title}::ta.key":
            command => "openvpn --genkey --secret /etc/openvpn/${title}.ta.key",
            creates => "/etc/openvpn/${title}.ta.key",
            require => Package['openvpn'],
            notify  => Service['openvpn'],
        }
    }

}
