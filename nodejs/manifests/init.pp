class nodejs (
    $version = '0.10',
    $ensure = 'present',
    $provider = undef,
    $source = undef,
) {

    apt::source { 'nodesource':
        location   => "https://deb.nodesource.com/node_${version}",
        repos      => 'main',
        key        => 'AA01DA2C',
        key_source => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
        before     => Package['nodejs'],
    }

    if !defined(Package['build-essential']) {
        package { 'build-essential': }
    }

    if !defined(Package['rlwrap']) {
        package { 'rlwrap': }
    }

    if !defined(Package['nodejs']) {
        package { 'nodejs':
            ensure   => $ensure,
            provider => $provider,
            source   => $source,
            require  => Package['build-essential', 'rlwrap'],
        }
    }

}
