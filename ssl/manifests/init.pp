class ssl {

    if !defined(Package['ssl-cert']) {
        package { 'ssl-cert': }
    }

    # Directory to store CA certificates
    file { '/usr/local/share/ca-certificates':
        ensure => directory,
        owner  => 'root',
        group  => 'staff',
        mode   => '2775',
    }

    # Update CA certificates
    exec { 'ssl::reload':
        command     => '/usr/sbin/update-ca-certificates',
        require     => Package['ssl-cert'],
        refreshonly => true,
    }
}
