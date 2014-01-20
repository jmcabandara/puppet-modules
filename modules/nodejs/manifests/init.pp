class nodejs {

    if !defined(Package['nodejs']) { package { 'nodejs': } }
    if !defined(Package['npm']) { package { 'npm': } }

}
