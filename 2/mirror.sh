#!/bin/bash
#########################################################################
# File Name: epelMirrors.sh
# Author: LookBack
# Email: admin#dwhd.org
# Version:
# Created Time: Fri 17 Jul 2015 02:29:53 AM CST
#########################################################################
 
if ! which rsync >/dev/null 2>&1;then exit 1;fi
 
rsyncUrl=(
        rsync://epel.mirrors.ovh.net/fedora-epel
        rsync.osuosl.org::mariadb
        rsync://rsync.percona.com/rsync/
        rsync://ftp5.gwdg.de/pub/linux/mysql/
        rsync://apt.puppetlabs.com/packages/
        rsync://cpan.mirrors.ovh.net/CPAN/
        rsync://mirror1.hs-esslingen.de/repoforge/
        rsync://mirror.wdc1.us.leaseweb.net/gentoo
        rsync://mirror.wdc1.us.leaseweb.net/slackware
)
 
localDir=(
        /u01/EPEL
        /u01/SQL/MariaDB
        /u01/SQL/Percona
        /u01/SQL/MySQL
        /u01/Puppet
        /u01/CPAN
        /u01/RepoForge
        /u01/Gentoo
        /u01/Slackware
)
 
rsync_Mirrors() {
        rsync -vai4CH --safe-links --numeric-ids --delete --delete-delay --delay-updates $1 $2
}
 
#https://mariadb.com/kb/en/mariadb/mirroring-mariadb/
#https://www.percona.com/blog/2014/02/14/using-percona-rsync-repositories-set-local-centos-mirror/
#http://dev.mysql.com/downloads/how-to-mirror.html
 
for i in `seq 0 ${#localDir[@]}`;do
        [ ! -d ${localDir[$i]} ] && mkdir -p ${localDir[$i]}
        rsync_Mirrors ${rsyncUrl[$i]} ${localDir[$i]}
        #[ "$i" = "0" ] && cp -a `dirname ${localDir[7]}`/fancyindex ${localDir[0]}
        #[ "$i" = "1" ] && mv ${localDir[1]}/index.html ${localDir[1]}/index.html_backup
        #[ "$i" = "3" ] && mv ${localDir[3]}/index.html ${localDir[3]}/index.html_backup
        #[ "$i" = "6" ] &&cp -a `dirname ${localDir[7]}`/fancyindex ${localDir[6]}/ && mv ${localDir[6]}/index.html ${localDir[6]}/index.html_backup
done

