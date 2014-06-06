class php::opcache (
    $enable = undef,
    $enable_cli = undef,
    $memory_consumption = undef,
    $interned_strings_buffer = undef,
    $max_accelerated_files = undef,
    $max_wasted_percentage = undef,
    $use_cwd = undef,
    $validate_timestamps = undef,
    $revalidate_freq = undef,
    $revalidate_path = undef,
    $save_comments = undef,
    $load_comments = undef,
    $fast_shutdown = undef,
    $enable_file_override = undef,
    $optimization_level = undef,
    $inherited_hack = undef,
    $dups_fix = undef,
    $blacklist_filename = undef,
    $max_file_size = undef,
    $consistency_checks = undef,
    $force_restart_timeout = undef,
    $error_log = undef,
    $log_verbosity_level = undef,
    $preferred_memory_model = undef,
    $protect_memory = undef,
    $mmap_base = undef,
) {

    file { '/etc/php5/mods-available/opcache.ini':
        content => template('php/etc/php5/mods-available/opcache.ini.erb'),
        require => Package['php5-cli'],
        notify  => Exec['php::restart'],
    }

    file { '/usr/local/share/php':
        ensure => directory,
    }

    file { '/usr/local/share/php/opcache.php':
        content => template('php/usr/local/share/php/opcache.php.erb'),
        require => File['/usr/local/share/php'],
        mode    => 0755,
    }
}
