define elasticsearch::plugin (
    $org = 'elasticsearch',
    $user = 'elasticsearch-',
    $plugin = $title,
    $version = undef,
) {
    require ::elasticsearch

    exec { "elasticsearch::plugin::${plugin}::install":
        command => "/usr/share/elasticsearch/bin/plugin install ${org}/${user}${plugin}/${version}",
        unless  => "/usr/share/elasticsearch/bin/plugin --list | grep ${plugin}"
    }
}
