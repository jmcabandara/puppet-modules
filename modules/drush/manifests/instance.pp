define drush::instance (
    $version = $title,
    $installdir = '/usr/local/share',
) {

    if !defined(Package['php5-cli']) { package { 'php5-cli': } }
    if !defined(Package['php5-dev']) { package { 'php5-dev': } }
    if !defined(Package['wget']) { package { 'wget': } }

    exec { "drush::install::$version":
        command => "wget -q -O - https://github.com/drush-ops/drush/archive/${version}.tar.gz | tar -C ${installdir} -zxf -",
        creates => "${installdir}/drush-${version}",
    }

}
