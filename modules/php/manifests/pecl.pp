define php::pecl (
    $package = $title,
) {

    exec { "php::pecl::${package}":
        command => "pecl install ${package}",
        require => Package['php-pear'],
        unless  => "pecl list ${package}",
    }

}
