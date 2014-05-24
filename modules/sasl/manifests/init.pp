class sasl (
    $start = 'yes',
    $mechanisms = 'pam',
    $mech_options = undef,
    $threads = 5,
    $options = '-c -m /var/run/saslauthd',
) {

    if !defined(Package['sasl2-bin']) { package { 'sasl2-bin': } }

    file { '/etc/default/saslauthd':
        content => template('sasl/etc/default/saslauthd.erb'),
        require => Package['sasl2-bin'],
        notify  => Service['saslauthd'],
    }
    
    service { 'saslauthd':
        ensure  => running,
        enable  => true,
        require => [Package['sasl2-bin'], File['/etc/default/saslauthd']],
    }
}
