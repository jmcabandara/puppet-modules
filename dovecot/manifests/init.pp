class dovecot (
    $imapd = true,
    $pop3d = false,
    $mail_location = 'mbox:~/mail:INBOX=/var/mail/%u',
    $ssl_cert = '/etc/dovecot/dovecot.pem',
    $ssl_key = '/etc/dovecot/private/dovecot.pem',
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

    file { '/etc/dovecot/conf.d/10-ssl.conf':
        content => template('dovecot/etc/dovecot/conf.d/10-ssl.conf.erb'),
        require => Package['dovecot-core'],
        notify  => Service['dovecot'],
    }

    file { '/etc/dovecot/conf.d/10-mail.conf':
        content => template('dovecot/etc/dovecot/conf.d/10-mail.conf.erb'),
        require => Package['dovecot-core'],
        notify  => Service['dovecot'],
    }

    service { 'dovecot':
        ensure  => running,
        enable  => true,
        require => Package['dovecot-core'],
    }

}
