class apache::mod::passenger ($enabled = true) {
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
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/passenger.conf',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/passenger.load':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/passenger.load',
            default => 'absent',
        },
    }

}
