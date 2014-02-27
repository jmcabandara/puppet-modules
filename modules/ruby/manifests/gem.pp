define ruby::gem ($gem = $title) {

    if !defined(Package['rubygems']) { package { 'rubygems': } }

    if !defined(Package["ruby::gem::${gem}"]) {
        package { "ruby::gem::${gem}":
            name     => $gem,
            provider => gem,
            require  => Package['rubygems'],
        }
    }
}
