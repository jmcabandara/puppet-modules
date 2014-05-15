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
        require => [Package['solr-tomcat'], File["/usr/local/share/solr/${index}"]],
        before  => Exec["solr::index::drupal::core::${index}"],
    }

    file { "/usr/local/share/solr/${index}/data":
        source  => '/var/lib/solr/data',
        recurse => true,
        replace => false,
        owner   => 'tomcat6',
        group   => 'tomcat6',
        links   => follow,
        require => [Package['solr-tomcat'], File["/usr/local/share/solr/${index}"]],
        before  => Exec["solr::index::drupal::core::${index}"],
    }

    exec { "solr::index::drupal::${index}::solrconfig":
        command => "sed -i 's/<dataDir>.*<\\/dataDir>/<dataDir>\\/usr\\/local\\/share\\/solr\\/${index}\\/data<\\/dataDir>/g' /usr/local/share/solr/${index}/conf/solrconfig.xml",
        unless  => "grep '<dataDir>/usr/local/share/solr/${index}/data</dataDir>' /usr/local/share/solr/${index}/conf/solrconfig.xml",
        require => File["/usr/local/share/solr/${index}/conf"],
        before  => Exec["solr::index::drupal::core::${index}"],
        notify  => Service['tomcat6'],
    }

    exec { "solr::index::drupal::core::${index}":
        command => "sed -i '/<\\/cores>/i \\ \\ \\ \\ <core name=\"${index}\" instanceDir=\"/usr/local/share/solr/${index}\" />' /etc/solr/solr.xml",
        unless  => "grep core\\ name=\\\"${index}\\\" /etc/solr/solr.xml",
        require => Package['solr-tomcat'],
        notify  => Service['tomcat6'],
    }
}
