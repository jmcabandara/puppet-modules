define solr::index::drupal::search_api_solr (
    $index = $title,
    $version = '7.x-1.5',
) {

    solr::index { $index: }

    exec { "solr::index::drupal::search_api_solr::${index}":
        command => "wget -q -O- http://ftp.drupal.org/files/projects/search_api_solr-${version}.tar.gz | tar --strip 3 -zxf - --no-same-owner --wildcards \"search_api_solr/solr-conf/3.x/*\" && echo ${version} > version.txt",
        unless  => "grep ${version} version.txt",
        cwd     => "/usr/local/share/solr/${index}/conf",
        require => File["/usr/local/share/solr/${index}/conf"],
        notify  => Service['tomcat6'],
    }
}
