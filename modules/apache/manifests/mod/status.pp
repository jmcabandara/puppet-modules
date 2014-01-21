class apache::mod::status (
    $location = '/server-status',
    $require_ip = {},
    $require_host = {},
) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/status.load':
        ensure => '/etc/apache2/mods-available/status.load',
    }

    file { '/etc/apache2/mods-available/status.conf':
        content => template('apache/etc/apache2/mods-available/status.conf.erb'),
    }

    file { '/etc/apache2/mods-enabled/status.conf':
        ensure => '/etc/apache2/mods-available/status.conf',
    }

}
