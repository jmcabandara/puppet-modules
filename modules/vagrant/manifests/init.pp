class vagrant ( $source = '/vhome' ) {
    class { '::vagrant::ssh': source => $source }
    class { '::vagrant::git': source => $source }
    class { '::vagrant::vim': source => $source }
}
