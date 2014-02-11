define ruby::gem ($gem = $title) {

    if !defined(Package['rubygems']) { package { 'rubygems': } }

    package { "ruby::gem::$gem":
        name     => $gem,
        provider => gem,
        require  => Package['rubygems'],
    }
}
