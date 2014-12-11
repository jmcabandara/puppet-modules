define ferm::rule(
    $priority   = 20,
    $domain     = 'ip ip6',
    $table      = 'filter',
    $chain      = 'INPUT',
    $interface  = undef,
    $outerface  = undef,
    $proto      = 'tcp',
    $sport      = undef,
    $dport      = undef,
    $saddr      = undef,
    $daddr      = undef,
    $action     = 'ACCEPT',
    $comment    = undef,
    ) {

    file { "/etc/ferm/ferm.d/${priority}-${title}.ferm":
        ensure  => present,
        content => template('ferm/etc/ferm/rule.ferm.erb'),
        require => File['/etc/ferm/ferm.d'],
    }

}
