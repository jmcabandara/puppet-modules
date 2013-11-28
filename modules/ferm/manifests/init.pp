class ferm (
    $input      = 'DROP',
    $output     = 'DROP',
    $forward    = 'DROP',
    $admin      = false,
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

    # Create the administration firewall rule
    if ($admin) {
        ferm::rule { '00-admin':
           dport => $admin,
        }
    }

    # Ensure ferm rules are refreshed after the main stage
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

    file { '/etc/ferm/ossec.ferm': }

    file { '/etc/ferm/ossec.exempt.d':
        ensure => directory,
        recurse => true,
        purge   => true,
    }

    file { '/etc/ferm/ferm.d':
        ensure  => directory,
        recurse => true,
        purge   => true,
    }

    file { '/etc/ferm/ferm.d/README':
        content => "# This directory is managed by puppet. Anything added here manually will be deleted\n",
        require => File['/etc/ferm/ferm.d'],
    }

}