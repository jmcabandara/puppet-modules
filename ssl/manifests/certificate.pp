define ssl::certificate (
    $commonName = $title,
    $subjectAltName = undef,

    $countryName = undef,
    $stateOrProvinceName = undef,
    $localityName = undef,
    $organizationName = undef,
    $organizationalUnitName = undef,
    $emailAddress = undef,
) {

    require ::ssl

    file { "/etc/ssl/$commonName.cnf":
        content => template('ssl/etc/ssl/openssl.cnf.erb'),
    }

    exec { "openssl::req::$commonName":
        command => "openssl req -x509 -newkey rsa:2048 -keyout /etc/ssl/private/$commonName.key -out /etc/ssl/certs/$commonName.crt -days 365 -nodes -extensions v3_req -config /etc/ssl/$commonName.cnf",
        creates => ["/etc/ssl/private/$commonName.key", "/etc/ssl/certs/$commonName.crt"],
        require => File["/etc/ssl/$commonName.cnf"],
    }

}
