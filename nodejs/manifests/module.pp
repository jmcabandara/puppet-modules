define nodejs::module ($module = $title) {

    require ::nodejs

    if !defined(Exec["nodejs::module::${module}"]) {
        exec { "nodejs::module::${module}":
            command => "npm install -g ${module}",
            creates => "/usr/local/lib/node_modules/${module}",
        }
    }

}
