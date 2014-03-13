class apache (
    $http_port = 80,
    $https_port = 443,
    $default_vhost = false,
    $servertokens = 'OS',
    $serversignature = 'On',
    $traceenable = 'Off',
    $umask = '0022',
) {

    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    if !defined(Package['apache2']) { package { 'apache2': } }

    service { 'apache2':
        ensure  => running,
        enable  => true,
        require => Package['apache2'],
    }

    file { '/etc/apache2/ports.conf':
        content => template('apache/etc/apache2/ports.conf.erb'),
    }

    file { '/etc/apache2/envvars':
        content => template('apache/etc/apache2/envvars.erb'),
    }

    file { '/etc/apache2/conf-available/logformat.conf':
        source => 'puppet:///modules/apache/etc/apache2/conf-available/logformat.conf',
    }
    file { '/etc/apache2/conf-enabled/logformat.conf':
        ensure  => '/etc/apache2/conf-available/logformat.conf',
        require => File['/etc/apache2/conf-available/logformat.conf'],
    }

    file { '/etc/apache2/conf-available/security.conf':
        content => template('apache/etc/apache2/conf-available/security.conf.erb'),
    }
    file { '/etc/apache2/conf-enabled/security.conf':
        ensure  => '/etc/apache2/conf-available/security.conf',
        require => File['/etc/apache2/conf-available/security.conf'],
    }

    # Disable the default site
    file { '/etc/apache2/sites-enabled/000-default.conf':
        ensure => $default_vhost ? {
            true    => '/etc/apache2/sites-available/000-default.conf',
            default => absent,
        }
    }

}
