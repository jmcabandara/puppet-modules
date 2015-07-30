define nodejs::module (
    $module = $title,
    $version = undef,
) {

    require ::nodejs

    if !defined(Exec["nodejs::module::${module}"]) {
        exec { "nodejs::module::${module}":
            command => $version ? {
                undef   => "npm install -g ${module}",
                default => "npm install -g ${module}@${version}",
            },
            unless  => $version ? {
                undef   => "npm -g ls ${module}",
                default => "npm -g ls ${module}@${version}",
            },
        }
    }

}
