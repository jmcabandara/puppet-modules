class opendkim (
    $domain = undef,
    $keyfile = undef,
    $selector = undef,
    $socket = undef,
) {

    if !defined(Package['opendkim']) {
        package { 'opendkim': }
    }

    if !defined(Package['opendkim-tools']) {
        package { 'opendkim-tools': }
    }

    service { 'opendkim':
        ensure  => running,
        enable  => true,
        require => Package['opendkim'],
    }

    file { '/etc/opendkim.conf':
        content => template('opendkim/etc/opendkim.conf.erb'),
        require => Package['opendkim'],
        notify  => Service['opendkim'],
    }
}
