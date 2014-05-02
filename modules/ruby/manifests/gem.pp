define ruby::gem ($gem = $title) {

    if !defined(Package['ruby']) { package { 'ruby': } }

    if !defined(Package["ruby::gem::${gem}"]) {
        package { "ruby::gem::${gem}":
            name     => $gem,
            provider => gem,
            require  => Package['ruby'],
        }
    }
}
