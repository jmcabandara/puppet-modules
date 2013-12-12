class apache::mod::php5 ($enabled = true) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2', 'libapache2-mod-php5'],
        notify  => Service['apache2'],
    }

    if !defined(Package['libapache2-mod-php5']) { package { 'libapache2-mod-php5': } }

    file { '/etc/apache2/mods-enabled/php5.conf':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/php5.conf',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/php5.load':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/php5.load',
            default => 'absent',
        },
    }

    if $enabled {
        exec { 'apache::mod::php5::restart':
            command     => '/bin/true',
            subscribe   => Exec['php::restart'],
            notify      => Service['apache2'],
            refreshonly => true,
        }
    }
}
