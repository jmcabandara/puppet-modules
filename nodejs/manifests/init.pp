class nodejs (
    $version = '0.10',
) {

    apt::source { 'nodesource':
        location   => "https://deb.nodesource.com/node_${version}",
        repos      => 'main',
        key        => 'AA01DA2C',
        key_source => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
        before     => Package['nodejs'],
    }

    if !defined(Package['nodejs']) {
        package { 'nodejs':
            ensure => "$version*",
        }
    }

}
