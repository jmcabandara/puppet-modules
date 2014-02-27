define nodejs::module ($module = $title) {
    if !defined(Package['npm']) { package { 'npm': } }

    exec { "node.js::module::${module}":
        command => "npm install -g ${module}",
        require => Package['npm'],
        creates => "/usr/lib/node_modules/${module}",
    }

}
