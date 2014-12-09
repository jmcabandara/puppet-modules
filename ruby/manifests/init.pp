class ruby {
    if !defined(Package['ruby']) { package { 'ruby': } }
    if !defined(Package['ruby-dev']) { package { 'ruby-dev': } }
}
