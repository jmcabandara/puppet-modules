class nodejs {

    if !defined(Package['nodejs']) { package { 'nodejs': } }
    if !defined(Package['nodejs-legacy']) { package { 'nodejs-legacy': } }
    if !defined(Package['npm']) { package { 'npm': } }

}
