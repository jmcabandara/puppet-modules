class apache (
    $http_port = 80,
    $https_port = 443,
    $mod_authnz_ldap = false,
    $mod_headers = false,
    $mod_passenger = false,
    $mod_php5 = false,
    $mod_proxy = false,
    $mod_rewrite = false,
    $mod_ssl = false,
    $mod_status = false,
    $servertokens = 'OS',
    $serversignature = 'On',
    $traceenable = 'Off',
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

    file { ['/etc/apache2/sites-available', '/etc/apache2/sites-enabled']:
        ensure => directory,
    }

    file { '/etc/apache2/ports.conf':
        content => template('apache/etc/apache2/ports.conf.erb'),
    }

    file { '/etc/apache2/conf.d/logformat':
        source => 'puppet:///modules/apache/etc/apache2/conf.d/logformat',
    }

    file { '/etc/apache2/conf.d/security':
        content => template('apache/etc/apache2/conf.d/security.erb'),
    }

    # Disable the default site
    file { '/etc/apache2/sites-enabled/000-default':
        ensure => absent,
    }

    # Log Rotation
    file { '/etc/logrotate.d/apache2':
        ensure => present,
        source => 'puppet:///modules/apache/etc/logrotate.d/apache2',
    }

    # Modules
    class { 'apache::mod::authnz_ldap': enabled => $mod_authnz_ldap }
    class { 'apache::mod::headers': enabled => $mod_headers }
    class { 'apache::mod::passenger': enabled => $mod_passenger }
    class { 'apache::mod::php5': enabled => $mod_php5 }
    class { 'apache::mod::proxy': enabled => $mod_proxy }
    class { 'apache::mod::rewrite': enabled => $mod_rewrite }
    class { 'apache::mod::ssl': enabled => $mod_ssl }
    class { 'apache::mod::status': enabled => $mod_status }
}
