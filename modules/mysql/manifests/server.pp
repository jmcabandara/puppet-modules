class mysql::server (
    $max_allowed_packet             = '64M',
    $skip_name_resolve              = true,
    $max_connections                = 100,
    $table_open_cache               = 400,
    $query_cache_size               = '16M',
    $join_buffer_size               = 131072,
    $default_storage_engine         = 'innodb',
    $innodb_flush_method            = undef,
    $innodb_flush_log_at_trx_commit = 2,
    $innodb_log_buffer_size         = '8M',
    $innodb_log_file_size           = '256M',
    $innodb_file_per_table          = true,
    $innodb_buffer_pool_size        = undef,
) {

    if !$::memorysize_mb {
        $memorysize_mb = $::memorysize
    }

    class { 'mysql::client': }

    if !defined(Package['mysql-server']) { package { 'mysql-server': } }

    service { 'mysql':
        ensure  => running,
        enable  => true,
        require => Package['mysql-server'],
    }

    file { '/etc/mysql/my.cnf':
        content => template('mysql/etc/mysql/my.cnf.erb'),
        require => Package['mysql-server'],
        notify  => Exec['mysql::ib_logfile'],
    }

    exec { 'mysql::ib_logfile':
        command     => 'rm -f /var/lib/mysql/ib_logfile*',
        refreshonly => true,
        notify      => Service['mysql'],
    }

    # TODO run or simulate mysql_secure_installation
}
