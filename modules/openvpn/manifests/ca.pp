class openvpn::ca ( 
    $key_size = 2048,
    $ca_expire = 3650,
    $key_expire = 3650,
    $key_country = 'US',
    $key_province = 'CA',
    $key_city = 'SanFrancisco',
    $key_org = 'Fort-Funston',
    $key_email = 'me@myhost.mydomain',
    $key_ou = 'MyOrganizationalUnit',
) {

    if !defined(Package['easy-rsa']) { package { 'easy-rsa': } }

    exec { 'openvpn::ca::make-cadir':
        command => 'make-cadir /etc/openvpn/easy-rsa',
        creates => '/etc/openvpn/easy-rsa',
        require => Package['easy-rsa'],
        notify  => Service['openvpn'],
    }

    file { '/etc/openvpn/easy-rsa/vars':
        content => template('openvpn/etc/openvpn/easy-rsa/vars.erb'),
        require => Exec['openvpn::ca::make-cadir'],
    }

    exec { 'openvpn::ca::clean-all':
        command  => '. ./vars && ./clean-all',
        cwd      => '/etc/openvpn/easy-rsa',
        provider => 'shell',
        creates  => '/etc/openvpn/easy-rsa/keys',
        require  => File['/etc/openvpn/easy-rsa/vars'],
        notify   => Service['openvpn'],
    }

    exec { 'openvpn::ca::build-ca':
        command  => '. ./vars && ./pkitool --initca',
        cwd      => '/etc/openvpn/easy-rsa',
        provider => 'shell',
        creates => [
            '/etc/openvpn/easy-rsa/keys/ca.key',
            '/etc/openvpn/easy-rsa/keys/ca.crt',
        ],
        require => File['/etc/openvpn/easy-rsa/vars'],
        notify  => Service['openvpn'],
    }

    exec { 'openvpn::ca::build-dh':
        command  => '. ./vars && ./build-dh',
        cwd      => '/etc/openvpn/easy-rsa',
        provider => 'shell',
        timeout  => 0, # This can take a while, but it only needs to be done once
        creates  => "/etc/openvpn/easy-rsa/keys/dh${key_size}.pem",
        require  => File['/etc/openvpn/easy-rsa/vars'],
        notify   => Service['openvpn'],
    }

}
