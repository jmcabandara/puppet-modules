class casperjs (
    $version = '1.1-beta3',
    $installdir = '/usr/local/share',
) {

    casperjs::instance { "casperjs::${version}":
        version    => $version,
        installdir => $installdir,
    }

    file { "${installdir}/casperjs":
        ensure  => "${installdir}/casperjs-${version}",
        require => Casperjs::Instance["casperjs::${version}"],
    }

    file { '/usr/local/bin/casperjs':
        ensure  => '/usr/local/share/casperjs/bin/casperjs',
        require => File["${installdir}/casperjs"],
    }

}
