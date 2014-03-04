define openvpn::dh ($size = $title) {

    exec { "openvpn::dh${size}.pem":
        command => "openssl dhparam -out /etc/openvpn/dh${size}.pem ${size}",
        creates => "/etc/openvpn/dh${size}.pem",
        require => Package['openvpn'],
        notify  => Service['openvpn'],
        timeout => 0, # This can take a while, but it only needs to be done once
    }

}
