class puppet {

    File {
        require => Package['puppet'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    apt::source { 'puppetlabs':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main dependencies',
        key        => '4BD6EC30',
        key_server => 'pgp.mit.edu',
        before     => Package['puppet'],
    }

    if !defined(Package['puppet']) { package { 'puppet': } }

    file { '/etc/puppet/puppet.conf':
        source => 'puppet:///modules/puppet/etc/puppet/puppet.conf',
    }
    
    file { '/etc/puppet/hiera.yaml':
        source => 'puppet:///modules/puppet/etc/puppet/hiera.yaml',
    }

    cron { 'puppet':
        ensure  => present,
        command => '/usr/bin/puppet agent --onetime --no-daemonize --logdest syslog > /dev/null 2>&1',
        user    => 'root',
        minute  => fqdn_rand(60),
    }

    service { 'puppet':
        ensure  => stopped,
        enable  => false,
        require => Package['puppet'],
    }

}
