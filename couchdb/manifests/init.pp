class couchdb (
    $httpd_port = 5984,
    $httpd_bind_address = '127.0.0.1',
    $httpd_enable_cors = false,
    $cors_credentials = undef,
    $cors_origins = undef,
    $cors_methods = undef,
    $cors_headers = undef,

    $ensure = 'running',
) {

    if !defined(Package['couchdb']) {
        package { 'couchdb': }
    }

    service { 'couchdb':
        enable => $ensure ? {
            'running' => true,
            default   => false,
        },
        ensure => $ensure,
    }

    file { '/etc/couchdb/default.d/httpd.ini':
        content => template('couchdb/etc/couchdb/default.d/httpd.ini.erb'),
        require => Package['couchdb'],
        notify  => Service['couchdb'],
    }


    file { '/etc/couchdb/default.d/cors.ini':
        content => template('couchdb/etc/couchdb/default.d/cors.ini.erb'),
        require => Package['couchdb'],
        notify  => Service['couchdb'],
    }
}
