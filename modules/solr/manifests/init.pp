class solr {

    if !defined(Package['solr-tomcat']) { package { 'solr-tomcat': } }

    if !defined(Service['tomcat6']) {
        service { 'tomcat6':
            ensure => running,
            enable => true,
        }
    }

    exec { 'solr::multicore':
        command => 'sed -i \'s/ defaultCoreName="collection1"//;/core name="collection1"/d\' /etc/solr/solr.xml',
        onlyif  => 'grep defaultCoreName="collection1" /etc/solr/solr.xml || grep core\ name="collection1" /etc/solr/solr.xml',
        require => Package['solr-tomcat'],
        notify  => Service['tomcat6'],
    }

    exec { 'solr::solrconfig':
        command => "sed -i '/<dataDir>.*<\\/dataDir>/d' /etc/solr/conf/solrconfig.xml",
        onlyif  => "grep '<dataDir>.*</dataDir>' /etc/solr/conf/solrconfig.xml",
        require => Package['solr-tomcat'],
    }

    file { '/usr/local/share/solr':
        ensure => directory,
    }
}
