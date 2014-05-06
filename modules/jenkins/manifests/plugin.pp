define jenkins::plugin (
    $plugin = $title,
    $type = 'hpi',
    $version = 'latest',
) {

    if !defined(Package['wget']) { package { 'wget': } }

    exec { "jenkins::plugin::${plugin}::download":
        command => $version ? {
            latest  => "wget http://updates.jenkins-ci.org/latest/${plugin}.${type}",
            default => "wget http://updates.jenkins-ci.org/download/plugins/${plugin}/${version}/${plugin}.${type}",
        },
        cwd     => '/var/lib/jenkins/plugins',
        user    => 'jenkins',
        creates => "/var/lib/jenkins/plugins/${plugin}.${type}",
        require => [Package['wget', 'jenkins'], File['/var/lib/jenkins/plugins']],
        notify  => Service['jenkins'],
    }

}
