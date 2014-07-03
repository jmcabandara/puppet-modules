class ruby {
    if !defined(Package['ruby']) { package { 'ruby': } }
    if !defined(Package['ruby-dev']) { package { 'ruby-dev': } }
    if !defined(Package['rbenv']) { package { 'rbenv': } }
    if !defined(Package['ruby-build']) { package { 'ruby-build': } }
}
