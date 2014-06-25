class etherpad-lite (
    $version = '1.4.0',
    $path = '/opt',
) {

    if !defined(Package['git']) { package { 'git': } }

    user { 'etherpad-lite':
        home  => "${path}/etherpad-lite",
        shell => '/bin/false',
    }

    exec { 'etherpad::download':
        command => "git clone https://github.com/ether/etherpad-lite.git ${path}/etherpad-lite && chown -R etherpad-lite:etherpad-lite ${path}/etherpad-lite",
        creates => "${path}/etherpad-lite",
        require => [User['etherpad-lite'], Package['git']],
        before  => Service['etherpad-lite'],
    }

    exec { 'etherpad::version':
        command => $version ? {
            undef   => 'git checkout develop',
            default => "git checkout ${version}",
        },
        unless => $version ? {
            undef   => 'git branch --no-color | grep ^\* | awk \'{$1="";$0=substr($0,2)}1\' | grep ^develop$',
            default => "test \"${version}\" = \"$(git describe --tags)\"",
        },
        cwd    => "${path}/etherpad-lite",
        user   => 'etherpad-lite',
        notify => Service['etherpad-lite'],
    }

    file { '/var/log/etherpad-lite':
        ensure  => directory,
        owner   => 'etherpad-lite',
        require => User['etherpad-lite'],
        before  => Service['etherpad-lite'],
    }

    file { '/etc/init/etherpad-lite.conf':
        content => template('etherpad-lite/etc/init/etherpad-lite.conf.erb'),
        notify  => Service['etherpad-lite'],
    }

    service { 'etherpad-lite':
        ensure  => running,
        enable  => true,
        require => [Package['nodejs'], User['etherpad-lite']],
    }
}
