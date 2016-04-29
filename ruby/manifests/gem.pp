define ruby::gem (
    $gem = $title,
    $version = 'present',
) {

    if !defined(Package['build-essential']) { package { 'build-essential': } }
    if !defined(Package['ruby']) { package { 'ruby': } }
    if !defined(Package['ruby-dev']) { package { 'ruby-dev': } }

    if !defined(Package["ruby::gem::${gem}"]) {
        package { "ruby::gem::${gem}":
            name     => $gem,
            provider => gem,
            ensure   => $version,
            require  => Package['ruby', 'ruby-dev', 'build-essential'],
        }
    }
}
