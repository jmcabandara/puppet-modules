class php::memcached (
    $sess_locking = undef,
    $sess_consistent_hash = undef,
    $sess_binary = undef,
    $sess_lock_wait = undef,
    $sess_prefix = undef,
    $sess_number_of_replicas = undef,
    $sess_randomize_replica_read = undef,
    $sess_remove_failed = undef,
    $compression_type = undef,
    $compression_factor = undef,
    $compression_threshold = undef,
    $serializer = undef,
    $use_sasl = undef,
    $version = '5',
) {

    if !defined(Package["php${version}-memcached"]) {
        package { "php${version}-memcached":
            require => Package["php${version}-cli"],
        }
    }

    file { '/etc/php5/mods-available/memcached.ini':
        content => template('php/etc/php5/mods-available/memcached.ini.erb'),
        require => Package["php${version}-memcached"],
        notify  => Exec['php::restart'],
    }

    exec { 'php::memcached::enable':
        provider => 'shell',
        command  => 'php5enmod -s ALL memcached',
        onlyif   => 'for x in `php5query -S`; do if [ ! -f /etc/php5/$x/conf.d/20-memcached.ini ]; then echo "onlyif"; fi; done | grep onlyif',
        require  => File['/etc/php5/mods-available/memcached.ini'],
        notify   => Exec['php::restart'],
    }

}
