class varnish (
    $address = ':80',
    $management = 'localhost:6082',
    $storage = 'malloc,256m',
    $user = 'varnish',
    $group = 'varnish',
    $nfiles = 131072,
    $memlock = 82000,
    $varnishncsa = true,
    $varnishncsa_logformat = '%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-agent}i"',
    $varnishlog  = false,
) {

    File {
        require => Package['varnish'],
    }

    Service {
        require => Package['varnish'],
        ensure  => running,
        enable  => true,
    }

    if !defined(Package['varnish']) { package { 'varnish': } }

    file { '/etc/default/varnish':
        content => template('varnish/etc/default/varnish.erb'),
        notify  => Service['varnish'],
    }

    file { '/etc/default/varnishlog':
        content => template('varnish/etc/default/varnishlog.erb'),
        notify  => Service['varnishlog'],
    }

    file { '/etc/default/varnishncsa':
        content => template('varnish/etc/default/varnishncsa.erb'),
        notify  => Service['varnishncsa'],
    }

    file { '/etc/init.d/varnishncsa':
        content => template('varnish/etc/init.d/varnishncsa.erb'),
        notify  => Service['varnishncsa'],
    }

    service { 'varnish': }
    service { 'varnishlog': }
    service { 'varnishncsa': }
}
