class drush (
    $version = '6.1.0',
    $installdir = '/usr/local/share',
) {


    if !defined(Package['php5-cli']) { package { 'php5-cli': } }
    if !defined(Package['php5-gd']) { package { 'php5-gd': require => Package['php5-cli'] } }
    if !defined(Package['php5-mysql']) { package { 'php5-mysql': require => Package['php5-cli'] } }
    if !defined(Package['unzip']) { package { 'unzip': } }
    if !defined(Package['wget']) { package { 'wget': } }

    file { "${installdir}/drush":
        ensure => directory,
    }

    exec { 'drush::download':
        command => 'wget -q -O drush-$VERSION.zip https://github.com/drush-ops/drush/archive/$VERSION.zip',
        creates => "/usr/local/src/drush-${version}.zip",
    }

    exec { 'drush::unpack':
        command => "unzip drush-${version}.zip",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/drush-${version}",
        require => [Exec['drush::download'], Package['unzip']],
    }

    exec { 'drush::install':
        command => "rsync -a drush-${version}/ ${installdir}/drush/",
        cwd     => '/usr/local/src',
        unless  => "grep drush_version=${version} ${installdir}/drush/drush.info",
        require => [Exec['drush::unpack'], File["${installdir}/drush"]],
    }

    file { '/usr/local/bin/drush':
        ensure  => "${installdir}/drush/drush",
        require => Exec['drush::install'],
    }

}
