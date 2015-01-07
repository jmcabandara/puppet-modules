define openvpn::client (
    $proto = 'udp',
    $remote = [],
    $inline = true,
    $ca = undef,
    $tls_auth = undef,
    $key = undef,
    $cert = undef,
    $script_security = 1,
    $up = undef,
    $down = undef,
) {

    include ::openvpn

    file { "/etc/openvpn/${title}.conf":
        content => template('openvpn/etc/openvpn/client.conf.erb'),
        require => Package['openvpn'],
        notify  => Service['openvpn'],
    }

}
