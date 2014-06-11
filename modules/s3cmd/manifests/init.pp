class s3cmd {
    if !defined(Package['python-magic']) { package { 'python-magic': } }
    if !defined(Package['s3cmd']) { package { 's3cmd': } }
}
