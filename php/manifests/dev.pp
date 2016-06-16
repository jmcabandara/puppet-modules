class php::dev (
    $version = '5',
) {

    include ::php

    if !defined(Package["php${version}-dev"]) {
        package { "php${version}-dev": }
    }

}
