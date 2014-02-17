class vagrant (
    $source = '/vhome',
    $destination = '/home/vagrant',
    $user = 'vagrant',
) {

    vagrant::ssh { $destination:
        source => $source,
        user   => $user,
    }

    vagrant::git { $destination:
        source => $source,
        user   => $user,
    }

    vagrant::vim { $destination:
        source => $source,
        user   => $user,
    }

}
