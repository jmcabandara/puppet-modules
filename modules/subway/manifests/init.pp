class subway (
    $repo = 'https://github.com/thedjpetersen/subway.git',
    $branch = undef,
    $release = undef,
    $path = '/opt',
) {

    if !defined(Package['git']) { package { 'git': } }

    user { 'subway':
        home  => "${path}/subway",
        shell => '/bin/false',
    }

    exec { 'subway::download':
        command => "git clone ${repo} ${path}/subway && chown -R subway:subway ${path}/subway",
        creates => "${path}/subway",
        require => [User['subway'], Package['git']],
        notify  => Exec['subway::npm'],
        before  => Service['subway'],
    }

    if $branch {
        exec { 'subway::branch':
            command => "git checkout ${branch}",
            unless  => "git branch --no-color | grep ^\\* | awk '{$1=\"\";$0=substr($0,2)}1' | grep ^${branch}$",
            cwd     => "${path}/subway",
            user    => 'subway',
            require => Exec['subway::download'],
            notify  => [Exec['subway::npm'], Service['subway']],
        }
    }

    if $release {
        exec { 'subway::tag':
            command => "git checkout ${release}",
            unless  => "test \"${release}\" = \"$(git describe --tags)\"",
            cwd     => "${path}/subway",
            user    => 'subway',
            require => Exec['subway::download'],
            notify  => [Exec['subway::npm'], Service['subway']],
        }
    }

    file { "${path}/subway/node_modules":
        ensure  => directory,
        owner   => 'subway',
        group   => 'subway',
        require => Exec['subway::download'],
        notify  => Exec['subway::npm'],
    }

    exec { 'subway::npm':
        command     => 'npm install',
        cwd         => "${path}/subway",
        user        => 'subway',
        environment => "HOME=${path}/subway",
        require     => Package['npm'],
        notify      => Service['subway'],
        refreshonly => true,
    }

    file { '/var/log/subway':
        ensure  => directory,
        owner   => 'subway',
        require => User['subway'],
        before  => Service['subway'],
    }

    file { '/etc/init/subway.conf':
        content => template('subway/etc/init/subway.conf.erb'),
        notify  => Service['subway'],
    }

    service { 'subway':
        ensure  => running,
        enable  => true,
        require => [Package['nodejs'], User['subway']],
    }
}
