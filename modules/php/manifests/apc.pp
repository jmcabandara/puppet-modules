class php::apc (
    $enabled = undef,
    $shm_segments = undef,
    $shm_size = undef,
    $shm_strings_buffer = undef,
    $optimization = undef,
    $num_files_hint = undef,
    $user_entries_hint = undef,
    $ttl = undef,
    $user_ttl = undef,
    $gc_ttl = undef,
    $cache_by_default = undef,
    $filters = undef,
    $mmap_file_mask = undef,
    $slam_defense = undef,
    $file_update_protection = undef,
    $enable_cli = undef,
    $max_file_size = undef,
    $use_request_time = undef,
    $stat = undef,
    $write_lock = undef,
    $report_autofilter = undef,
    $serializer = undef,
    $include_once_override = undef,
    $rfc1867 = undef,
    $rfc1867_prefix = undef,
    $rfc1867_name = undef,
    $rfc1867_freq = undef,
    $rfc1867_ttl = undef,
    $localcache = undef,
    $localcache_size = undef,
    $coredump_unmap = undef,
    $stat_ctime = undef,
    $preload_path = undef,
    $file_md5 = undef,
    $canonicalize = undef,
    $lazy_functions = undef,
    $lazy_classes = undef,
) {
    if !defined(Package['php-apc']) { package { 'php-apc': require => Package['php5-cli'] } }

    file { '/etc/php5/conf.d/apc.ini':
        content => template('php/etc/php5/conf.d/apc.ini.erb'),
        require => Package['php-apc'],
        notify  => Exec['php::restart'],
    }

    file { '/usr/local/share/php/apc.php':
        source  => 'puppet:///modules/php/usr/local/share/php/apc.php',
        require => File['/usr/local/share/php'],
        mode    => '0755',
    }
}
