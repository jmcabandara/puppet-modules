class sphinx (
    $version = '1.3.1',
) {
    require pip

    package { 'Sphinx':
        ensure   => $version,
        provider => 'pip',
    }
}
