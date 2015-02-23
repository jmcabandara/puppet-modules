define duply::profile (
    $profile = $title,
    $gpg_key = undef,
    $gpg_pw = undef,
    $target,
    $target_user = undef,
    $target_pass = undef,
    $source,
    $verbosity = 4,
    $max_fullbkp_age = undef,
    $volsize = 25,
) {

    require ::duply

    file { "/etc/duply/$profile":
        ensure => directory,
        mode   => 0700,
    }

    file { "/etc/duply/$profile/conf":
        content => template('duply/etc/duply/conf.erb'),
        mode    => 0644,
    }

}
