define jenkins::plugin (
    $plugin = $title,
    $type = 'hpi',
    $version = 'latest',
) {

    if !defined(Package['wget']) {
        package { 'wget': }
    }

    exec { "jenkins::plugin::${plugin}::${version}::download":
        command => $version ? {
            latest  => "wget -O ${plugin}-${version}.${type} http://updates.jenkins-ci.org/latest/${plugin}.${type}",
            default => "wget -O ${plugin}-${version}.${type} http://updates.jenkins-ci.org/download/plugins/${plugin}/${version}/${plugin}.${type}",
        },
        cwd     => '/tmp',
        creates => "/tmp/${plugin}-${version}.${type}",
        require => Package['wget'],
    }

    file { "/var/lib/jenkins/plugins/${plugin}.jpi":
        source  => "/tmp/${plugin}-${version}.${type}",
        owner   => 'jenkins',
        require => [
            Package['jenkins'],
            Exec["jenkins::plugin::${plugin}::${version}::download"],
        ],
        notify  => Service['jenkins'],
    }

    file { "/var/lib/jenkins/plugins/${plugin}.jpi.pinned":
        ensure => $version ? {
            'latest' => absent,
            default  => present,
        },
    }

}
