class apache (
    $http_port = 80,
    $https_port = 443,
    $admin_port = 61709,
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
    if !defined(Package['apache2-utils']) { package { 'apache2-utils': } }

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

    # Security Settings
    file { '/etc/apache2/conf-available/security.conf':
        content => template('apache/etc/apache2/conf-available/security.conf.erb'),
    }
    file { '/etc/apache2/conf-enabled/security.conf':
        ensure  => '/etc/apache2/conf-available/security.conf',
    }

    # Admin virtualhost
    file { '/etc/apache2/conf-available/admin.conf':
        content => template('apache/etc/apache2/conf-available/admin.conf.erb'),
    }
    file { '/etc/apache2/conf-enabled/admin.conf':
        ensure => '/etc/apache2/conf-available/admin.conf',
    }

    # Disable the default site
    file { '/etc/apache2/sites-enabled/000-default.conf':
        ensure => $default_vhost ? {
            true    => '/etc/apache2/sites-available/000-default.conf',
            default => absent,
        }
    }

    # Force vhost configuration through puppet
    file { ['/etc/apache2/sites-available', '/etc/apache2/sites-enabled']:
        ensure  => directory,
        recurse => true,
        purge   => true,
        require => Package['apache2'],
    }
}
