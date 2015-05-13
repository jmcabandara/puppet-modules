class ssmtp (
    $root = 'postmaster',
    $mailhub = 'mail',
    $hostname = $::fqdn,
) {

    if !defined(Package['ssmtp']) {
        package { 'ssmtp': }
    }

    file { '/etc/ssmtp/ssmtp.conf':
        content => template('ssmtp/etc/ssmtp/ssmtp.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
