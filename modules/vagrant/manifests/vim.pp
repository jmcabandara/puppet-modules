define vagrant::vim (
    $source = '/vhome',
    $destination = $title,
    $user = 'vagrant',
) {

    if !defined(Package['rsync']) { package { 'rsync': } }
    if !defined(Package['vim']) { package { 'vim': } }

    exec { "vagrant::${destination}/.vimrc":
        command => "cp ${source}/.vimrc ${destination}/.vimrc || true",
    }

    exec { "vagrant::${destination}/.vimrc::chown":
        command => "chown ${user}: ${destination}/.vimrc || true",
        require => Exec["vagrant::${destination}/.vimrc"],
    }

    exec { "vagrant::${destination}/.vim":
        command => "rsync -a --delete ${source}/.vim/ ${destination}/.vim/ || true",
    }

    exec { "vagrant::${destination}/.vim::chown":
        command => "chown -R ${user}: ${destination}/.vim || true",
        require => Exec["vagrant::${destination}/.vim"],
    }

}
