define openvpn::client (
    $proto = 'udp',
    $remote = [],
    $cipher = undef,
    $auth = undef,
    $inline = true,
    $ca = undef,
    $tls_auth = undef,
    $tls_version_min = undef,
    $key = undef,
    $cert = undef,
    $script_security = undef,
    $up = undef,
    $down = undef,
) {

    require ::openvpn

    file { "/etc/openvpn/${title}.conf":
        content => template('openvpn/etc/openvpn/client.conf.erb'),
        notify  => Service["openvpn::client::${title}"],
    }

    service { "openvpn::client::${title}":
        provider => 'base',
        start    => "/usr/sbin/service openvpn start ${title}",
        stop     => "/usr/sbin/service openvpn stop ${title}",
        restart  => "/usr/sbin/service openvpn restart ${title}",
        status   => "/usr/sbin/service openvpn status ${title}",
        ensure   => running,
    }

}
