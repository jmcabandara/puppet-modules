class casperjs {

    if !defined(Package['git']) { package { 'git': } }
    if !defined(Package['phantomjs']) { package { 'phantomjs': } }

    exec { 'casperjs::download':
        command => 'git clone git://github.com/n1k0/casperjs.git /usr/local/share/casperjs',
        creates => '/usr/local/share/casperjs',
        require => Package['git'],
    }

    file { '/usr/local/bin/casperjs':
        ensure  => '/usr/local/share/casperjs/bin/casperjs',
        require => Exec['casperjs::download'],
    }

}
