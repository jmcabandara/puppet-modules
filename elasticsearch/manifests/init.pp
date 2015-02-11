class elasticsearch {

    require ::java::jdk

    apt::source { 'elasticsearch':
        location    => 'http://packages.elasticsearch.org/elasticsearch/1.4/debian',
        release     => 'stable',
        key         => 'D88E42B4',
        key_source  => 'http://pgp.mit.edu/pks/lookup?op=get&search=0xD27D666CD88E42B4',
        include_src => false,
        before     => Package['elasticsearch'],
    }

    if !defined(Package['elasticsearch']) {
        package { 'elasticsearch': }
    }

    file { '/etc/default/elasticsearch':
        content => template('elasticsearch/etc/default/elasticsearch.erb'),
        require => Package['elasticsearch'],
        notify  => Service['elasticsearch'],
    }
        
    file { '/etc/elasticsearch/elasticsearch.yml':
        content => template('elasticsearch/etc/elasticsearch/elasticsearch.yml.erb'),
        require => Package['elasticsearch'],
        notify  => Service['elasticsearch'],
    }

    service { 'elasticsearch':
        ensure  => running,
        enable  => true,
        require => Package['elasticsearch'],
    }

}
