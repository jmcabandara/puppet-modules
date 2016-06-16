class php (
    $version = '5',
) {

    if !defined(Package["php${version}-cli"]) {
        package { "php${version}-cli": }
    }

    if !defined(Package['php-pear']) {
        package { 'php-pear':
            ensure => latest,
        }
    }

    # Changes to PHP configs will notify this Exec. Any other classes can then
    # subscribe to this in order restart their appropriate services.
    exec { 'php::restart':
        command     => '/bin/true',
        refreshonly => true,
    }

}
