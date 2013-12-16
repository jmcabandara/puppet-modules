class drush (
    $version = '6.2.0',
    $installdir = '/usr/local/share',
) {

    drush::instance { "drush::${version}":
        version    => $version,
        installdir => $installdir,
    }

    file { "${installdir}/drush":
        ensure  => "${installdir}/drush-${version}",
        require => Drush::Instance["drush::${version}"],
    }

    file { '/usr/local/bin/drush':
        ensure  => "${installdir}/drush/drush",
        require => File["${installdir}/drush"],
    }

    # TODO: install Console_Table-1.1.3
    ##    Drush needs to download a library from                               [error]
    ##    http://download.pear.php.net/package/Console_Table-1.1.3.tgz in order
    ##    to function, and the attempt to download this file automatically
    ##    failed because you do not have permission to write to the library
    ##    directory /usr/local/share/drush-6.2.0/lib. To continue you will need
    ##    to manually download the package from
    ##    http://download.pear.php.net/package/Console_Table-1.1.3.tgz, extract
    ##    it, and copy the directory into your /usr/local/share/drush-6.2.0/lib
    ##    directory.

}
