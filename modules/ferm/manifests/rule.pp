define ferm::rule(
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
    $ossec      = undef,
    ) {

    $dir = $ossec ? {
        exempt  => 'ossec.exempt.d',
        default => 'ferm.d',
    }

    $int = $interface ? {
        undef   => '',
        default => " interface ($interface)",
    }

    $out = $outerface ? {
        undef   => '',
        default => " outerface ($outerface)",
    }

    $spt = $sport ? {
        undef   => '',
        default => " sport ($sport)",
    }

    $dpt = $dport ? {
        undef   => '',
        default => " dport ($dport)",
    }

    $protocol = $proto ? {
        any   => '',
        default => " proto ($proto)",
    }

    $src = $saddr ? {
        undef => $domain ? {
            'ip'    => '0.0.0.0/0',
            'ip6'   => '::/0',
            default => '0.0.0.0/0 ::/0',
        },
        default => $saddr,
    }

    $dst = $daddr ? {
        undef => $domain ? {
            'ip'    => '0.0.0.0/0',
            'ip6'   => '::/0',
            default => '0.0.0.0/0 ::/0',
        },
        default => $daddr,
    }

    file { "/etc/ferm/${dir}/${title}.ferm":
        ensure  => present,
        #content => "domain ($domain) table $table chain $chain$int$out$protocol saddr ($src)$spt daddr ($dst)$dpt $action;\n",
        content => template('ferm/etc/ferm/rule.ferm.erb'),
        require => File['/etc/ferm/ferm.d'],
    }

}
