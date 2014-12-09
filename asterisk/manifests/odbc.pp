class asterisk::odbc {
    if !defined(Package['unixodbc']) { package { 'unixodbc': } }
    if !defined(Package['unixodbc-dev']) { package { 'unixodbc-dev': } }
    if !defined(Package['libmyodbc']) { package { 'libmyodbc': } }

    $arch = $::architecture ? {
        'amd64' => 'x86_64',
        default => 'i386',
    }

    file { '/etc/odbcinst.ini':
        content => template('asterisk/etc/odbcinst.ini.erb'),
        owner   => 'root',
        group   => 'root',
        require => Package['unixodbc'],
        before  => Service['asterisk'],
    }

    file { '/etc/odbc.ini':
        content => template('asterisk/etc/odbc.ini.erb'),
        owner   => 'root',
        group   => 'root',
        require => Package['unixodbc'],
        before  => Service['asterisk'],
    }
}
