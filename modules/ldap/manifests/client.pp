class ldap::client (
        $base,
        $uri,
        $ldap_version = 3,
        $binddn = undef,
        $bindpw = undef,
        $rootbinddn = undef,
        $rootbindpw = undef,
        $pam_password = 'md5',
        $nss_base_passwd = undef,
        $nss_base_shadow = undef,
        $nss_base_group = undef,
        $nss_map_attribute = undef,
        $nss_map_objectclass = undef,
        $ssl = 'off',
        $tls_checkpeer = 'yes',
        $tls_cacertfile = '/etc/ssl/certs/ca-certificates.crt',
        $tls_cacertdir = undef,
        ) {

    # Defaults
    File {
        owner   => 'root',
        group   => 'root',
        require => Package['libnss-ldap', 'libpam-ldap'],
    }

    # Required packages
    if !defined(Package['libnss-ldap']) { package { 'libnss-ldap': } }
    if !defined(Package['libpam-ldap']) { package { 'libpam-ldap': } }
    if !defined(Package['unscd']) { package { 'unscd': } }

    # NSCD service
    service { 'unscd':
        ensure  => running,
        enable  => true,
        require => Package['unscd'],
    }

    # LDAP Configuration
    file { '/etc/ldap/ldap.conf':
        content => template('ldap/etc/ldap/ldap.conf.erb'),
    }

    # LDAP Authentication
    file { '/etc/ldap.conf':
        content => template('ldap/etc/ldap.conf.erb'),
    }

    if $rootbindpw {
        file { '/etc/ldap.secret':
            content => $rootbindpw,
            mode    => 0600,
        }
    }
    
    file { '/etc/nsswitch.conf':
        source => 'puppet:///modules/ldap/etc/nsswitch.conf',
    }

    file { '/etc/pam.d/common-password':
        source => 'puppet:///modules/ldap/etc/pam.d/common-password',
    }

    file { '/etc/pam.d/common-session':
        source => 'puppet:///modules/ldap/etc/pam.d/common-session',
    }

    file { '/etc/pam.d/common-session-noninteractive':
        source => 'puppet:///modules/ldap/etc/pam.d/common-session-noninteractive',
    }

}
