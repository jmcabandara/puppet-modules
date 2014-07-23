class awstats {
    if !defined(Package['awstats']) { package { 'awstats': } }

    file { '/etc/awstats':
        ensure  => directory,
        recurse => true,
        purge   => true,
        require => Package['awstats'],
    }
}
