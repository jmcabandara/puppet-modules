class apache::mod::proxy (
    $enabled = true,
    $http = true,
    $wstunnel = true,
) {
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    file { '/etc/apache2/mods-enabled/proxy.load':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/proxy.load',
            default => 'absent',
        },
    }

    file { '/etc/apache2/mods-enabled/proxy.conf':
        ensure  => $enabled ? {
            true    => '/etc/apache2/mods-available/proxy.conf',
            default => 'absent',
        },
    }

    file { '/etc/apache2/mods-enabled/proxy_http.load':
        ensure  => $enabled ? {
            true    => $http ? {
                true    => '/etc/apache2/mods-available/proxy_http.load',
                default => 'absent',
            },
            default => 'absent',
        },
    }

    file { '/etc/apache2/mods-enabled/proxy_wstunnel.load':
        ensure  => $enabled ? {
            true    => $wstunnel ? {
                true    => '/etc/apache2/mods-available/proxy_wstunnel.load',
                default => 'absent',
            },
            default => 'absent',
        },
    }

}
