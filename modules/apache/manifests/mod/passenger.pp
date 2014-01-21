class apache::mod::passenger {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2', 'libapache2-mod-passenger', 'rails', 'librack-ruby', 'libmysql-ruby'],
        notify  => Service['apache2'],
    }

    if !defined(Package['libapache2-mod-passenger']) { package { 'libapache2-mod-passenger': } }
    if !defined(Package['rails']) { package { 'rails': } }
    if !defined(Package['librack-ruby']) { package { 'librack-ruby': } }
    if !defined(Package['libmysql-ruby']) { package { 'libmysql-ruby': } }

    file { '/etc/apache2/mods-enabled/passenger.conf':
        ensure => '/etc/apache2/mods-available/passenger.conf',
    }

    file { '/etc/apache2/mods-enabled/passenger.load':
        ensure => '/etc/apache2/mods-available/passenger.load',
    }

}
