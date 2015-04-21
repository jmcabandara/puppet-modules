class btrfs (
    $version = 'v3.18.2'
) {

    require ::git

    if !defined(Package['build-essential']) {
        package { 'build-essential': }
    }

    if !defined(Package['uuid-dev']) {
        package { 'uuid-dev': }
    }

    if !defined(Package['libattr1-dev']) {
        package { 'libattr1-dev': }
    }

    if !defined(Package['zlib1g-dev']) {
        package { 'zlib1g-dev': }
    }

    if !defined(Package['libacl1-dev']) {
        package { 'libacl1-dev': }
    }

    if !defined(Package['e2fslibs-dev']) {
        package { 'e2fslibs-dev': }
    }

    if !defined(Package['libblkid-dev']) {
        package { 'libblkid-dev': }
    }

    if !defined(Package['liblzo2-dev']) {
        package { 'liblzo2-dev': }
    }

    if !defined(Package['asciidoc']) {
        package { 'asciidoc': }
    }

    if !defined(Package['xmlto']) {
        package { 'xmlto': }
    }

    exec { 'btrfs::download':
        command => 'git clone https://kernel.googlesource.com/pub/scm/linux/kernel/git/mason/btrfs-progs',
        cwd     => '/usr/local/src',
        creates => '/usr/local/src/btrfs-progs',
        require => Package['build-essential', 'uuid-dev', 'libattr1-dev', 'zlib1g-dev', 'libacl1-dev', 'e2fslibs-dev', 'libblkid-dev', 'liblzo2-dev', 'asciidoc', 'xmlto'],
    }

    exec { 'btrfs::version':
        command => "git checkout $version",
        cwd     => '/usr/local/src/btrfs-progs',
        require => Exec['btrfs::download'],
        unless  => "git status | grep 'HEAD detached at $version'",
    }

    exec { 'btrfs::make':
        command     => 'make',
        cwd         => '/usr/local/src/btrfs-progs',
        subscribe   => Exec['btrfs::version'],
        refreshonly => true,
    }

    exec { 'btrfs::install':
        command     => 'make install',
        cwd         => '/usr/local/src/btrfs-progs',
        subscribe   => Exec['btrfs::make'],
        refreshonly => true,
    }

}
