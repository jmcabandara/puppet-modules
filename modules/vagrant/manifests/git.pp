define vagrant::git (
    $source = '/vhome',
    $destination = $title,
    $user = 'vagrant',
) {

    exec { "vagrant::${destination}/.gitconfig":
        command => "cp ${source}/.gitconfig ${destination}/.gitconfig || true",
    }

    exec { "vagrant::${destination}/.gitconfig::chown":
        command => "chown ${user}: ${destination}/.gitconfig || true",
        require => Exec["vagrant::${destination}/.gitconfig"],
    }

}
