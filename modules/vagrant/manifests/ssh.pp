define vagrant::ssh (
    $source = '/vhome',
    $destination = $title,
    $user = 'vagrant',
) {

    if !defined(Package['rsync']) { package { 'rsync': } }

    exec { "vagrant::${destination}/.ssh":
        command => "rsync -a --delete --exclude=authorized_keys ${source}/.ssh/ ${destination}/.ssh/ || true",
    }

    exec { "vagrant::${destination}/.ssh::chown":
        command => "chown -R ${user}: ${destination}/.ssh || true",
        require => Exec["vagrant::${destination}/.ssh"],
    }

}
