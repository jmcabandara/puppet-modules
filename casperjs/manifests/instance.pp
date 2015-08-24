define casperjs::instance (
    $version = $title,
    $installdir = '/usr/local/share',
) {

    require phantomjs
    require wget

    if !defined(Exec["casperjs::install::${version}"]) {
        exec { "casperjs::install::${version}":
            command => "wget -q -O - https://github.com/n1k0/casperjs/archive/${version}.tar.gz | tar -C ${installdir} -zxf -",
            creates => "${installdir}/casperjs-${version}",
            require => Package['wget'],
        }
    }

}
