class apache::mod::socache_shmcb {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/socache_shmcb.load':
        ensure => '/etc/apache2/mods-available/socache_shmcb.load',
    }
}
