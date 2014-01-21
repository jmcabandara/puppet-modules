class apache::mod::proxy {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/proxy.load':
        ensure => '/etc/apache2/mods-available/proxy.load',
    }

    file { '/etc/apache2/mods-enabled/proxy.conf':
        ensure => '/etc/apache2/mods-available/proxy.conf',
    }

}
