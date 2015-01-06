class unbound (
    $unbound_enable = true,
    $root_trust_anchor_update = true,
    $root_trust_anchor_file = '/var/lib/unbound/root.key',
    $resolvconf = true,
    $resolvconf_forwarders = true,
    $daemon_opts = undef,
) {

    if !defined(Package['unbound']) { package { 'unbound': } }

    file { '/etc/default/unbound':
        content => template('unbound/etc/default/unbound.erb'),
        require => Package['unbound'],
        notify  => Service['unbound'],
    }

    file { '/etc/unbound/unbound.conf':
        content => template('unbound/etc/unbound/unbound.conf.erb'),
        require => Package['unbound'],
        notify  => Service['unbound'],
    }

    file { '/etc/unbound/unbound.conf.d':
        ensure  => directory,
        purge   => true,
        recurse => true,
        require => Package['unbound'],
        notify  => Service['unbound'],
    }

    service { 'unbound':
        ensure  => running,
        enable  => true,
        require => Package['unbound'],
    }

}
