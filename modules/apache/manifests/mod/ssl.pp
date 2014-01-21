class apache::mod::ssl {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/ssl.conf':
        ensure => '/etc/apache2/mods-available/ssl.conf',
    }

    file { '/etc/apache2/mods-enabled/ssl.load':
        ensure  => '/etc/apache2/mods-available/ssl.load',
        require => File['/etc/apache2/mods-enabled/socache_shmcb.load'],
    }
}
