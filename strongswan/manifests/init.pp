class strongswan {

    if !defined(Package['strongswan']) {
        package { 'strongswan': }
    }

    if !defined(Package['strongswan-plugin-unity']) {
        package { 'strongswan-plugin-unity':
            require => Package['strongswan'],
        }
    }
}
