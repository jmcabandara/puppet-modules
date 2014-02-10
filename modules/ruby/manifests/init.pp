class ruby {
    if !defined(Package['ruby']) { package { 'ruby': } }
    if !defined(Package['rubygems']) { package { 'rubygems': } }
}
