define awstats::config (
    $ensure = 'present',
    $logfile = '/var/log/apache2/access.log',
    $logtype = 'W',
    $logformat = 4,
    $logseparator = ' ',
    $sitedomain = $title,
    $hostaliases = 'localhost 127.0.0.1',
    $dnslookup = 1,
    $dirdata = '/var/lib/awstats',
    $dircgi = '/cgi-bin',
    $diricons = '/awstats-icon',
    $allowtoupdatestatsfrombrowser = 0,
    $allowfullyearview = 2,
    $enablelockforupdate = 0,
    $dnsstaticcachefile = 'dnscache.txt',
    $dnslastupdatecachefile = 'dnscachelastupdate.txt',
    $skipdnslookupfor = '',
    $allowaccessfromwebtoauthenticatedusersonly = 0,
    $allowaccessfromwebtofollowingauthenticatedusers = '',
    $allowaccessfromwebtofollowingipaddresses = '',
    $createdirdataifnotexists = 0,
    $buildhistoryformat = 'text',
    $buildreportformat = 'html',
    $savedatabasefileswithpermissionsforeveryone = 0,
    $purgelogfile = 0,
    $archivelogrecords = 0,
    $keepbackupofhistoricfiles = 0,
    $defaultfile = 'index.php index.html',
    $skiphosts = '',
    $skipuseragents = '',
    $skipfiles = '',
    $skipreferrersblacklist = '',
    $onlyhosts = '',
    $onlyuseragents = '',
    $onlyusers = '',
    $onlyfiles = '',
    $notpagelist = 'css js class gif jpg jpeg png bmp ico rss xml swf',
    $validhttpcodes = '200 304',
    $validsmtpcodes = '1 250',
    $authenticatedusersnotcasesensitive = 0,
    $urlnotcasesensitive = 0,
    $urlwithanchor = 0,
    $urlqueryseparators = '?;',
    $urlwithquery = 0,
    $urlwithquerywithonlyfollowingparameters = '',
    $urlwithquerywithoutfollowingparameters = '',
    $urlreferrerwithquery = 0,
    $warningmessages = 1,
    $errormessages = '',
    $debugmessages = 0,
    $nboflinesforcorruptedlog = 50,
    $wrapperscript = '',
    $decodeua = 0,
    $misctrackerurl = '/js/awstats_misc_tracker.js',
    $addlinktoexternalcgiwrapper = undef,
    $levelforbrowsersdetection = 2,
    $levelforosdetection = 2,
    $levelforrefereranalyze = 2,
    $levelforrobotsdetection = 2,
    $levelforsearchenginesdetection = 2,
    $levelforkeywordsdetection = 2,
    $levelforfiletypesdetection = 2,
    $levelforwormsdetection = 0,
    $useframeswhencgi = 1,
    $detailedreportsonnewwindows = 1,
    $expires = 0,
    $maxrowsinhtmloutput = 1000,
    $lang = 'auto',
    $dirlang = '/usr/share/awstats/lang',
    $showmenu = 1,
    $showsummary = 'UVPHB',
    $showmonthstats = 'UVPHB',
    $showdaysofmonthstats = 'VPHB',
    $showdaysofweekstats = 'PHB',
    $showhoursstats = 'PHB',
    $showdomainsstats = 'PHB',
    $showhostsstats = 'PHBL',
    $showauthenticatedusers = 0,
    $showrobotsstats = 'HBL',
    $showwormsstats = 0,
    $showemailsenders = 0,
    $showemailreceivers = 0,
    $showsessionsstats = 1,
    $showpagesstats = 'PBEX',
    $showfiletypesstats = 'HB',
    $showfilesizesstats = 0,
    $showdownloadsstats = 'HB',
    $showosstats = 1,
    $showbrowsersstats = 1,
    $showscreensizestats = 0,
    $showoriginstats = 'PH',
    $showkeyphrasesstats = 1,
    $showkeywordsstats = 1,
    $showmiscstats = 'a',
    $showhttperrorsstats = 1,
    $showsmtperrorsstats = 0,
    $showclusterstats = 0,
    $adddataarraymonthstats = 1,
    $adddataarrayshowdaysofmonthstats = 1,
    $adddataarrayshowdaysofweekstats = 1,
    $adddataarrayshowhoursstats = 1,
    $includeinternallinksinoriginsection = 0,
    $maxnbofdomain = 10,
    $minhitdomain = 1,
    $maxnbofhostsshown = 10,
    $minhithost = 1,
    $maxnbofloginshown = 10,
    $minhitlogin = 1,
    $maxnbofrobotshown = 10,
    $minhitrobot = 1,
    $maxnbofdownloadsshown = 10,
    $minhitdownloads = 1,
    $maxnbofpageshown = 10,
    $minhitfile = 1,
    $maxnbofosshown = 10,
    $minhitos = 1,
    $maxnbofbrowsersshown = 10,
    $minhitbrowser = 1,
    $maxnbofscreensizesshown = 5,
    $minhitscreensize = 1,
    $maxnbofwindowsizesshown = 5,
    $minhitwindowsize = 1,
    $maxnbofreferershown = 10,
    $minhitreferer = 1,
    $maxnbofkeyphrasesshown = 10,
    $minhitkeyphrase = 1,
    $maxnbofkeywordsshown = 10,
    $minhitkeyword = 1,
    $maxnbofemailsshown = 20,
    $minhitemail = 1,
    $firstdayofweek = 1,
    $showflaglinks = '',
    $showlinksonurl = 1,
    $usehttpslinkforurl = '',
    $maxlengthofshownurl = 64,
    $htmlheadsection = '',
    $htmlendsection = '',
    $metarobot = 0,
    $logo = 'awstats_logo6.png',
    $logolink = 'http://www.awstats.org',
    $barwidth = 260,
    $barheight = 90,
    $stylesheet = '',
    $color_background = 'FFFFFF',
    $color_tablebgtitle = 'CCCCDD',
    $color_tabletitle = '000000',
    $color_tablebg = 'CCCCDD',
    $color_tablerowtitle = 'FFFFFF',
    $color_tablebgrowtitle = 'ECECEC',
    $color_tableborder = 'ECECEC',
    $color_text = '000000',
    $color_textpercent = '606060',
    $color_titletext = '000000',
    $color_weekend = 'EAEAEA',
    $color_link = '0011BB',
    $color_hover = '605040',
    $color_u = 'FFAA66',
    $color_v = 'F4F090',
    $color_p = '4477DD',
    $color_h = '66DDEE',
    $color_k = '2EA495',
    $color_s = '8888DD',
    $color_e = 'CEC2E8',
    $color_x = 'C1B2E2',
    $loadplugin = ['hashfiles'],
    $extratrackedrowslimit = 500,
) {

    require ::awstats

    if !defined(File['/etc/awstats']) {
        file { '/etc/awstats':
            ensure  => directory,
            recurse => true,
            purge   => true,
        }
    }

    file { "/etc/awstats/awstats.${sitedomain}.conf":
        ensure  => $ensure,
        content => template('awstats/etc/awstats/awstats.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => 0644,
        require => File['/etc/awstats'],
    }

}