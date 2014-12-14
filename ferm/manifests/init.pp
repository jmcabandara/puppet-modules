class ferm (
    $input = 'DROP',
    $output = 'DROP',
    $forward = 'DROP',
    $fast = 'yes',
    $cache = 'no',
    $options = undef,
    $enabled = 'yes',
    ) {

    # Defaults
    File {
        require => [Package['ferm'], File['/etc/ferm']],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    package { 'ufw': ensure  => purged }

    if !defined(Package['iptables']) { package { 'iptables': } }
    if !defined(Package['ferm']) { package { 'ferm': } }

    # Ensure the firewall rules are loaded at boot
    service { 'ferm':
        enable  => true,
        require => Package['ferm'],
    }

    # Ensure ferm rules are refreshed after the main stage, so other manifests
    # have an opportunity to add their own ferm rules.
    stage { ferm: require => Stage[main] }
    class { 'ferm::enforce': stage => ferm }

    # Config Files
    file { '/etc/ferm':
        ensure  => directory,
        require => undef,
    }

    file { '/etc/ferm/ferm.conf':
        content => template('ferm/etc/ferm/ferm.conf.erb'),
    }

    file { '/etc/ferm/ferm.d':
        ensure  => directory,
        recurse => true,
        purge   => true,
    }

    file { '/etc/default/ferm':
        content => template('ferm/etc/default/ferm.erb'),
    }
}
