class couchdb (
    $httpd_port = 5984,
    $httpd_bind_address = '127.0.0.1',
    $httpd_enable_cors = false,
    $cors_origins = undef,
    $cors_methods = undef,
    $cors_headers = undef,
) {

    if !defined(Package['couchdb']) {
        package { 'couchdb': }
    }

    service { 'couchdb':
        enable => true,
        ensure => running,
    }

    file { '/etc/couchdb/local.d/httpd.ini':
        content => template('couchdb/etc/couchdb/local.d/httpd.ini.erb'),
        require => Package['couchdb'],
        notify  => Service['couchdb'],
        owner   => 'couchdb',
        group   => 'couchdb',
    }

    file { '/etc/couchdb/local.d/cors.ini':
        content => template('couchdb/etc/couchdb/local.d/cors.ini.erb'),
        require => Package['couchdb'],
        notify  => Service['couchdb'],
        owner   => 'couchdb',
        group   => 'couchdb',
    }

}
