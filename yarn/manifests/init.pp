class yarn {

    apt::key { 'yarn':
        key_source  => 'https://dl.yarnpkg.com/debian/pubkey.gpg',
    }

    apt::source { 'yarn':
        location    =>  'https://dl.yarnpkg.com/debian/',
        release     => 'stable',
        repos       => 'main',
        include_src => false,
        require     => Apt::Key['yarn'],
        before      => Package['yarn'],
    }

    if !defined(Package['yarn']) {
        package { 'yarn': }
    }

}
