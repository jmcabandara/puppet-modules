define nodejs::module ($module = $title) {
    if !defined(Package['npm']) { package { 'npm': } }

    if !defined(Exec["nodejs::module::${module}"]) {
        exec { "nodejs::module::${module}":
            command => "npm install -g ${module}",
            require => Package['npm'],
            creates => "/usr/local/lib/node_modules/${module}",
        }
    }

}
