class dovecot (
    $imapd = true,
    $pop3d = false,
    $mail_location = 'mbox:~/mail:INBOX=/var/mail/%u',
    $ssl_cert = '/etc/dovecot/dovecot.pem',
    $ssl_key = '/etc/dovecot/private/dovecot.pem',
    $auth = 'system',
    $passwdfile_passdb_args = 'scheme=CRYPT username_format=%u /etc/dovecot/users',
    $passwdfile_userdb_args = 'username_format=%u /etc/dovecot/users',
    $passwdfile_userdb_default_fields = undef,
    $passwdfile_userdb_override_fields = undef,
) {

    if !defined(Package['dovecot-core']) {
        package { 'dovecot-core': }
    }

    if $imapd {
        if !defined(Package['dovecot-imapd']) {
            package { 'dovecot-imapd':
                require => Package['dovecot-core'],
                notify  => Service['dovecot'],
            }
        }
    }

    if $pop {
        if !defined(Package['dovecot-pop3d']) {
            package { 'dovecot-pop3d':
                require => Package['dovecot-core'],
                notify  => Service['dovecot'],
            }
        }
    }

    File {
        require => Package['dovecot-core'],
        notify  => Service['dovecot'],
    }

    file { '/etc/dovecot/conf.d/10-auth.conf':
        content => template('dovecot/etc/dovecot/conf.d/10-auth.conf.erb'),
    }

    file { '/etc/dovecot/conf.d/10-mail.conf':
        content => template('dovecot/etc/dovecot/conf.d/10-mail.conf.erb'),
    }

    file { '/etc/dovecot/conf.d/10-ssl.conf':
        content => template('dovecot/etc/dovecot/conf.d/10-ssl.conf.erb'),
    }

    if $auth == 'passwdfile' {
        file { '/etc/dovecot/conf.d/auth-passwdfile.conf.ext':
            content => template('dovecot/etc/dovecot/conf.d/auth-passwdfile.conf.ext.erb'),
        }
    }

    service { 'dovecot':
        ensure  => running,
        enable  => true,
        require => Package['dovecot-core'],
    }

}
