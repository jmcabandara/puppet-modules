define solr::index::drupal (
    $index = $title,
    $version = '7.x-1.6',
) {

    solr::index { $index: }

    exec { "solr::index::drupal::${index}":
        command => "wget -q -O- http://ftp.drupal.org/files/projects/apachesolr-${version}.tar.gz | tar --strip 3 -zxf - --no-same-owner --wildcards \"apachesolr/solr-conf/solr-3.x/*\" && echo ${version} > version.txt",
        unless  => "grep ${version} version.txt",
        cwd     => "/usr/local/share/solr/${index}/conf",
        require => File["/usr/local/share/solr/${index}/conf"],
        notify  => Service['tomcat6'],
    }
}
