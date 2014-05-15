define solr::index (
    $index = $title,
) {

    file { "/usr/local/share/solr/${index}":
        ensure => directory,
    }

    file { "/usr/local/share/solr/${index}/conf":
        source  => '/etc/solr/conf',
        recurse => true,
        replace => false,
        links   => follow,
        require => [Package['solr-tomcat'], File["/usr/local/share/solr/${index}"], Exec['solr::solrconfig']],
        before  => Exec["solr::index::${index}"],
    }

    file { "/usr/local/share/solr/${index}/data":
        source  => '/var/lib/solr/data',
        recurse => true,
        replace => false,
        owner   => 'tomcat6',
        group   => 'tomcat6',
        links   => follow,
        require => [Package['solr-tomcat'], File["/usr/local/share/solr/${index}"]],
        before  => Exec["solr::index::${index}"],
    }

    exec { "solr::index::${index}":
        command => "sed -i '/<\\/cores>/i \\ \\ \\ \\ <core name=\"${index}\" instanceDir=\"/usr/local/share/solr/${index}\" />' /etc/solr/solr.xml",
        unless  => "grep core\\ name=\\\"${index}\\\" /etc/solr/solr.xml",
        require => Package['solr-tomcat'],
        notify  => Service['tomcat6'],
    }
}
