#! /bin/bash
#
# Please dont modify this file without checking with Jason.
# If you need to tweak something, make your own copy and edit.
#
# Writted by Sojan 3/29/2010
# Modified by Jason 8/10/16:
# - updated Step 22 for ITM 6.3.5
# Modified by Jason 5/9/16:
# - updated Step 35 Qradar logic to just use the ver4 VA file for all
# Modified by Jason 4/5/16:
# - changed rhel to rhel
# - updated TSM to 7.1.13
# - set the allid.sh script to all userids
# Modified by Jason 3/10/16:
# - updated Step 35 Qradar logic and version
# Modified by Jason 12/12/15:
# - updated Step 35 Qradar install logic
# Modified by Jason 08/17/15:
# - updated Step 13 for new BES client steps
# - TSM client
# - TAD4D agent
# Modified by Jason 06/16/15:
# - updated Step 22 ITM for vg to rhel and fs to ext4
# Modified by Jason 05/12/15:
# - added Step 38 for TPC SRA Agent install
# Modified by Jason 05/06/2015:
# - updated Step 22 for latest ITM package
# Modified by Jason 12/15/14:
# - added env determination from hostname
# - updated Step 36 to add ext4 support and 1777 /tmp
# - updated Step 22 ITM to install based on env
# Modified by Jason 7/28/14:
# - updated Step 20 TSM client
# Modified by Jason 7/17/14:
# - added input and output file listing
# - updated Step 6 control-alt-delete
# - updated Step 7 logrotate
# - updated Step 10 umask and secondary logging
# Modified by Jason 7/16/14:
# - commented out Step 19 lcfd
# - commented out Step 24 tonic
# - commented out Step 28 bladelogic
# - commented out Step 29 AOC userids
# - commented out Step 34 middleware userid 
# - commented out adduser function 
# - updated Step 13 BES client
# - updated Step 20 TSM client
# - updated Step 21 srmdata owner to Barry Buchek
# - updated Step 22 ITM install
# - updated Step 23 IBM userids to use allid.sh script
# - updated Step 25 to comment out syslog.conf stuff
# - added Step 35 Qradar install
# - added Step 36 EP2 scan
# - added Step 37 Yum and Mutt

### Input files for post_install.ksh under $NFS ###
# post_control.txt - control file for steps in the script
# hosts.tmp - standard hosts file
# secondary_logging.txt - code for secondary logging added to /etc/profile
# log.profile - script for secondary logging
# system-auth4/5/6 - standard system-auth file
# password-auth - standard password-auth file
# BES/BESAgent-9.0.787.0-rhe5.x86_64.rpm - BES client install package
# BES/actionsite.afxm - standard BES client file
# sudoers.rhel4/5/6 - standard sudoers file
# motd - standard motd file
# ntp.conf - standard ntp.conf file
# resolv.conf - standard resolv.conf file
# tsm63 - TSM client 6.3 packages
# tsmd - standard init.d script for TSM client
# srmdata_keys - standard srmdata ssh key
# srmLINUX-7.1.0.0.tar - SRM install tarball
# ITM/itm_os_agent - ITM agent install files
# allid.sh - script to install IBM userids - also /root/was,ihs,mq files
# rsyslog.conf - standard rsyslog.conf file
# vsaclient-Linux - Fusion install files
# TAD4D-Install-Script-NewBuilds.sh - TAD4D install script
# ScanScripts_linux-x86.tar.gz - TAD4D scan scripts tarball
# multipath.conf/.6 - standard multipath.conf file
# toolschk.sh - script to check tools status
# gep.ksh - script to ???
# sudo_copy.sh - script to copy sudoers file from /opt/admin
# qrd71000_us_3.csplin.install_iplno.tar - Qradar install tarball
# EP2 - EP2 scan files
# Muttrc - standard mutt config file
# LINUX_SRA - TPC SRA Agent installer dir

### Output files for post_install.ksh
# /root/post_$HOSTNAME.log - output file on target server
# /etc/sysconfig/network - HOSTNAME file on target server
# passd/$HOSTNAME - file for random generated pw
# /etc/ssh/sshd_config - security settings for sshd on target server
# /etc/login.defs - default password settings on target server
# /etc/pam.d/login - add pam.lastlog.so to login file on target server
# /etc/sysconfig/ntpd - set no to yes for ??? on target server
# /etc/hosts - configure standard hosts on target server
# /etc/init/control-alt-delete.override - disable ctrl-alt-del on target server
# /etc/logrotate.conf - set retention values on target server
# /etc/default/useradd - change home to local_home on target server
# /etc/fstab - change home to local_home on target server
# /root/.bashrc - add umask 027 for root on target server
# /etc/bashrc - add umask 027 for root on target server
# /etc/profile - add umask 027 for root and add secondary logging on target server
# /usr/local/support/log.profile - secondary logging script on target server
# /etc/ftpusers - add root on target server
# /etc/cron.allow - add root on target server
# /etc/cron.deny - remove from target server
# /etc/pam.d/system-auth - standard system-auth file on target server
# /etc/opt/BESClient/actionsite.axfm - standard BES client file on target server
# /etc/fstab - add /var/history_logs on target server
# /etc/sudoers - standard sudoers file on target server
# /etc/ntp.conf - standard ntp.conf file on target server
# /etc/resolv.conf - standard resolv.conf file on target server
# /etc/inid.d/tsmd - standard tsm client init script on target server 
# /var/adm/perfmgr - SRM tool on target server
# /opt/IBM/ITM - ITM tool on target server
# /etc/rsyslog.conf - standard rsyslog.conf file on target server
# /root/.bash_profile - add TMOUT setting on target server
# /opt/IBM/fusion - Fusion tool on target server
# /opt/IBM/stdas_scanner - TAD4D scan tool on target server
# /mnt/$HOSTNAME/upload*.zip - TAD4D scan output file
# /var/spool/crontabs/root - add entries to root's crontab
# /etc/multipath.conf - standard multipath.conf file 
# /opt/admin - directory for SA scripts
# /opt/tail2syslog - Qradar tool 
# va10p40055:/pub/EP2Scan_results/$HOSTNAME - EP2 scan output file
# /etc/Muttrc - standard Mutt config file

# 
# Version history: Sojan 7/23/2010,1/4/2011,2/18/2011,5/26/2011,10/26/2011,1/11/2012 3/19/2012 6/12/2012 7/5/2012
# 7/9/2012 11/7/2012 04/15/2013

PATH=/mnt/post_install/new_build:/sbin:$PATH
export PATH

LOGFILE=/root/"post_${HOSTNAME}.log"
REL=$(cat /etc/redhat-release |sed -e 's#[^0-9]##g')
NFS=/mnt/post_install/new_build
PWD=/mnt/post_install/new_build/passd
CT_FILE=$1
SERVERIP=`/sbin/ifconfig|grep "inet addr" | awk -F: '{print $2}'| awk '{print $1}' | head -1`

if [ $(id -u) -ne 0 ] ; then
	echo " Only root can run this script"
	exit 1
fi

if [ ! -d $NFS ] ; then
	echo " NFS mount missing"
	exit 1
fi

if [ -f "${LOGFILE}" ] ; then
        echo " ${LOGFILE} already exists - copying to ${LOGFILE}.old..."
        cp -f "${LOGFILE}" "${LOGFILE}.old"
fi

RONPASS() {
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c 8 | xargs
	  }

# commented out adduser function because we are using allid.sh script
#adduser() {
## Function to add users to Linux system
#file=$1

#lines=`grep -v '^#' $file|wc -l`
#cont=1
#while [ $cont -le $lines ]
#do
   #i=`cat $file |grep -v '^#'| head -$cont | tail -1`
   #A=`echo $i|awk -F, '{print $1}'`
   #B=`echo $i|awk -F, '{print $2}'`
   #C=`echo $i|awk -F, '{print $3}'`
#
        #egrep "^$A" /etc/passwd >/dev/null
        #if [ $? -eq 0 ]; then
                #echo "$A exists!"
        #else
                #useradd  -c "$B" -g staff -G $C -m -p pamZQJzCqTFyU $A
##                usermod -L $A
##                chage -d 0 $A
##                usermod -U $A
                #[ $? -eq 0 ] && echo "User $A has been added to system!" || echo "Failed to add a user $A !"
        #fi
   #cont=`expr $cont + 1`
#
#done
#}

HOST_CHK=$(hostname|grep wellpoint.com|wc -l)
if [ $HOST_CHK = 1 ] ; then
HOST=$(grep -w ^HOSTNAME /etc/sysconfig/network|awk -F= '{print $2}'|sed 's/\.wellpoint\.com//')
cp -p /etc/sysconfig/network /etc/sysconfig/network.orig
sed '
/^HOSTNAME/ { c\
HOSTNAME='"$HOST"'
}'< /etc/sysconfig/network.orig > /etc/sysconfig/network
hostname $HOST
fi

if [ -f $PWD/$(hostname) ] ; then
        PASSWD=$(cat $PWD/$(hostname))
else
        if [ -d $PWD ] ; then
        	RONPASS > $PWD/$(hostname)
        else
                mkdir -p $PWD
        	RONPASS > $PWD/$(hostname)
        fi
fi

if [ -z "$CT_FILE" ] ; then
	echo "Using default control file"
	CT_FILE=$NFS/post_control_rh8-phys.txt
fi

. $CT_FILE


if [ $(uname -m) = i686 ] ; then
BIT=32
elif [ $(uname -m) = x86_64 ] ; then
BIT=64
fi

SITE=`echo $(hostname) | cut -c 1-4`

env=`echo $(hostname) | cut -c 5`
case $env in
        p)      ENV=prod;;
        d|t|n)  ENV=nonprod;;
        *)      ENV=unknown;;
esac

exec > ${LOGFILE}

#ROSE=RED
#if [ $ROSE = GREEN ] ; then
#echo SLEEEEEEEEEEEEEEEEPING
#sleep 60
# Step 0 Update resolv.conf
if [ $STEP0 = Y ] ; then
cat $NFS/resolv.conf > /etc/resolv.conf
echo " Anthem resolv.conf copied"
echo " Step 0 done"
else
echo " Anthem resolv.conf not copied"
echo " Step 0 not done"
fi

# Step 1 SSHD config
if [ -f /etc/ssh/sshd_config -a $STEP1 = Y ] ; then
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
sed -e 's/#MaxAuthTries 6/MaxAuthTries 5/g'  \
-e 's/#PermitRootLogin yes/PermitRootLogin no/g' -e 's/#MaxStartups 10/MaxStartups 100/g' \
-e 's/AcceptEnv/#AcceptEnv/g' -e 's/#PrintMotd/PrintMotd/g' </etc/ssh/sshd_config.orig >/etc/ssh/sshd_config
echo 'DenyUsers wsadmin' >> /etc/ssh/sshd_config
echo 'DenyGroups sshdeny' >> /etc/ssh/sshd_config
sed -i 's/#Protocol\ 2/Protocol\ 2/g' /etc/ssh/sshd_config
echo " Step 1 done"
else
echo " Step 1 not done"
fi

# Step 2 login.defs
if [ -f /etc/login.defs -a $STEP2 = Y ] ; then
cp -p /etc/login.defs /etc/login.defs.orig
sed -e 's/99999/45/g' -e 's/PASS_MIN_LEN\t5/PASS_MIN_LEN\t8/g' \
-e 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t7/'</etc/login.defs.orig >/etc/login.defs
echo " Step 2 done"
else
echo " Step 2 not done"
fi

# Step 3 pam.d/login
if [ -f /etc/pam.d/login -a $STEP3 = Y ] ; then
cp -p /etc/pam.d/login /etc/pam.d/login.orig
sed '
/pam_selinux.so open/ i\
session    optional     pam_lastlog.so
' </etc/pam.d/login.orig >/etc/pam.d/login
echo " Step 3 done"
else
echo " Step 3 not done"
fi

# Step 4 NTP
if [ -f /etc/sysconfig/ntpd -a $STEP4 = Y ] ; then
cp -p /etc/sysconfig/ntpd /etc/sysconfig/ntpd.orig
sed 's/no/yes/g' </etc/sysconfig/ntpd.orig  >/etc/sysconfig/ntpd
echo " Step 4 done"
else
echo " Step 4 not done"
fi

# Step 5 hosts
if [ ! -f /etc/hosts.orig  -a $STEP5 = Y ] ; then
cp -p /etc/hosts /etc/hosts.orig
cat $NFS/hosts.tmp > /etc/hosts
a=$(ifconfig -a |grep -w inet |egrep -v '127.0.0.1|169.|192.'|awk '{print $2}'|tr -d '  Bcast')
b=`echo ${HOSTNAME}|awk -F. '{print $1}'`
echo "$a    $b     $b.wellpoint.com" >>/etc/hosts
echo " Step 5 done"
else
echo " Step 5 not done"
fi

# Step 6 disable control-alt-delete
if [ $STEP6 = Y ] ; then
/bin/systemctl mask ctrl-alt-del.target
echo " Step 6 done"
else
echo " Step 6 not done"
fi

# Step 7 logrotate
if [ -f /etc/logrotate.conf -a $STEP7 = Y ] ; then
cp -p /etc/logrotate.conf /etc/logrotate.conf.orig
sed -e '6,10s/rotate 4/rotate 13/' -e 's/rotate 1$/rotate 4/g' </etc/logrotate.conf.orig >/etc/logrotate.conf
echo " Step 7 done"
else
echo " Step 7 not done"
fi

# Step 8 useradd default home to /local_home
if [ -f /etc/default/useradd -a $STEP8 = Y -a $STEP9 = Y ] ; then
cp -p /etc/default/useradd /etc/default/useradd.orig
sed 's/\/home/\/local_home/g' </etc/default/useradd.orig >/etc/default/useradd
echo " Step 8 done"
else
echo " Step 8 not done"
fi

# Step 9 change home to /local_home
if [ $STEP9 = Y ] ; then 
mkdir /local_home 2>/dev/null;/bin/umount /home
cp -p /etc/fstab /etc/fstab.orig 
sed 's/ \/home/ \/local_home/g' </etc/fstab.orig >/etc/fstab
/bin/mount /local_home
echo " Step 9 done"
else
echo " Step 9 not done"
fi

# Step 10 umask and secondary logging
if [ $STEP10 = Y ] ; then
cp -p /root/.bashrc /root/.bashrc.orig
cp -p /etc/bashrc /etc/bashrc.orig
cp -p /etc/profile /etc/profile.orig
if [ `grep -E 'umask 027' /root/.bashrc|wc -l ` -eq 0 ] ; then
echo "umask 027" >> /root/.bashrc
#echo "UMASK 027" >> /root/.bashrc ### this needs to be fixed in the HC scan
fi
if [ `grep -E 'umask 027' /etc/bashrc|wc -l ` -eq 0 ] ; then
echo "if [ \`id -u\` = 0 ]; then umask 027; fi" >> /etc/bashrc
#cat $NFS/umaskbashrc.txt >> /etc/bashrc
fi
if [ `grep -E 'umask 027' /etc/profile|wc -l` -eq 0 ] ; then
echo "if [ \`id -u\` = 0 ]; then umask 027; fi" >> /etc/profile
#cat $NFS/umaskprofile.txt >> /etc/profile
fi
sed 's/ulimit -S/#ulimit -S/g' </etc/profile.orig >/etc/profile
cat $NFS/secondary_logging.txt >> /etc/profile
mkdir -m 755 -p /usr/local/support ;cp $NFS/log.profile /usr/local/support/.
echo " Step 10 done"
else
echo " Step 10 not done"
fi

# Step 11 security settings
if [ $STEP11 = Y ] ; then
#chmod 1777 /var/spool
mkdir /etc/.profile
mkdir /etc/.ssh
chmod 750 /var/log
chmod 700 /root
chmod 700 /etc/security
chmod 700 /etc/default
echo "root" >/etc/ftpusers
if [ ! -f /etc/cron.allow ] ; then
echo "root" > /etc/cron.allow
#echo oracle >> /etc/cron.allow
fi
if [ -f /etc/cron.deny ] ; then
rm -f /etc/cron.deny
fi
if [ ! -f /etc/at.allow ] ; then
echo "root" > /etc/at.allow
else
echo "root" >> /etc/at.allow
fi
cp -p /etc/securetty /etc/securetty.orig
cp -p $NFS/securetty /etc/securetty
echo " Step 11 done"
else 
echo " Step 11 not done"
fi

# Step 12 system-auth and password-auth
if [ $STEP12 = Y ] ; then
cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth.orig
cp -p /etc/pam.d/password-auth /etc/pam.d/password-auth.orig
cat $NFS/password-auth8 > /etc/pam.d/password-auth
if [ $REL -ge 40 -a $REL -le 49 ] ; then
        cat $NFS/system-auth4 > /etc/pam.d/system-auth
elif [ $REL -ge 50 -a $REL -le 59 ] ; then
        cat $NFS/system-auth5 > /etc/pam.d/system-auth
elif [ $REL -ge 60 -a $REL -le 69 ] ; then
	cat $NFS/system-auth6 > /etc/pam.d/system-auth
elif [ $REL -ge 70 -a $REL -le 79 ] ; then
	cat $NFS/system-auth7 > /etc/pam.d/system-auth
elif [ $REL -ge 80 -a $REL -le 89 ] ; then
	cat $NFS/system-auth8 > /etc/pam.d/system-auth
fi
echo " Step 12 done"
else
echo " Step 12 not done"
fi

# Step 13 BUILD REPO
if [ $STEP13 = Y ] ; then
# need line to copy standard repo file to setup repos, otherwise assumes that has already been done
#cp -p $NFS/repo /etc/yum.repos.d
rm -rf /etc/yum.repos.d/*
cp $NFS/rhel8build.repo /etc/yum.repos.d/local.repo
echo "sslverify=false" >> /etc/yum.conf
/bin/yum install -y net-tools
/bin/yum install -y libstdc++.so.5
/bin/yum install -y ksh
/bin/yum install -y bind-utils
/bin/yum install -y lsof
/bin/yum install -y system-storage-manager
/bin/yum install -y ntp
/bin/yum install -y bc
/bin/yum install -y unzip
/bin/yum install -y nc
/bin/yum install -y perl-5*
/bin/yum install -y mksh
/bin/yum install -y python3*
yum -y update 
#yum repolist
echo " Standard repos added, updated to latest patches "
else
echo " Standard repos NOT added, NOT updated to latest patches"
fi

# Step 14 history_logs filesystem
if [ ! -d /var/history_logs -a $STEP14 = Y ] ; then
/sbin/lvcreate -L 2G -n history_logs_lv vg_sda
/sbin/mkfs.xfs /dev/vg_sda/history_logs_lv
cp -p /etc/fstab /etc/fstab.orig
echo "/dev/vg_sda/history_logs_lv  /var/history_logs       xfs     defaults        1 2" >> /etc/fstab
mkdir -p /var/history_logs ; /bin/mount /var/history_logs
chmod 1777 /var/history_logs
echo " /var/history_log fs created"
echo " Step 14 done"
else
echo " /var/history_log fs/dir exists"
echo " Step 14 not done"
fi


# Step 15 sudoers
if [ $STEP15 = Y ] ; then
cp -p /etc/sudoers /etc/sudoers.orig
cp $NFS/sudoers.current/sudoers.rhel.current /etc/sudoers
cp -r $NFS/sudoers.current/sudoers.d/* /etc/sudoers.d
chmod 440 /etc/sudoers.d/*
chown -R root:root /etc/sudoers.d 
echo " Anthem sudoers file copied"
echo " Step 15 done"
else
echo " Anthem sudoers file not copied"
echo " Step 15 not done"
fi

# Step 16 motd
if [ $STEP16 = Y ] ; then
cat $NFS/motd > /etc/motd
cat $NFS/motd > /etc/issue
echo " Anthem motd copied"
echo " Step 16 done"
else
echo " Anthem motd not copied"
echo " Step 16 not done"
fi


# Step 17 register with Satellite
#if [ $STEP17 = N ] ; then
#echo "Registering with Satellite"
#  if [ $REL -ge 70 -a $REL -le 79 ] ; then
#     cd /tmp
#     if [ $ENV = prod ] ; then
#        wget -O ael-7-ibm-prod_ak.va10plvbas300.runOnNode.sh http://va10plvbas300.wellpoint.com/pub/antm-IT-Blessed-scripts/ak/ael-7-ibm-prod_ak.va10plvbas300.runOnNode.sh
 #       chmod +x /tmp/ael-7-ibm-prod_ak.va10plvbas300.runOnNode.sh
  #      . /tmp/ael-7-ibm-prod_ak.va10plvbas300.runOnNode.sh
   #  else
    #    wget -O ael-7-ibm-test_ak.va10plvbas300.runOnNode.sh http://va10plvbas300.wellpoint.com/pub/antm-IT-Blessed-scripts/ak/ael-7-ibm-test_ak.va10plvbas300.runOnNode.sh
     #   chmod +x /tmp/ael-7-ibm-test_ak.va10plvbas300.runOnNode.sh
      #  . /tmp/ael-7-ibm-test_ak.va10plvbas300.runOnNode.sh
     #fi
     /bin/yum install ksh -y
     #echo "Registered with Satellite"
     #echo " Step 17 done"
  #else
  #   echo "Failed to register with Satellite"
   #  echo " Step 17 not done"
  #fi
#fi

# Step 18 chrony.conf
if [ $STEP18 = Y ] ; then
if [ ! -f /usr/sbin/chronyd ] ; then
/bin/yum install chrony -y
fi
cp -p /etc/chrony.conf /etc/chrony.conf.orig
cp -p $NFS/chrony.conf /etc/chrony.conf
/bin/systemctl enable chronyd
/bin/systemctl start chronyd
echo " Anthem chrony.conf copied and chrony setup complete"
else
echo " chrony setup not done"
fi


# Step 19 lcfd - Not Required 
#if [ $STEP19 = Y ] ; then
#pkill lcfd
#cp $NFS/tivlcfd.tar /
#cd /;tar -xvf  /tivlcfd.tar;rm -f tivlcfd.tar
#chmod -R 755 /opt/Tivoli
#cp -p /opt/Tivoli/lcf/generic/lcfd_start.sh /opt/Tivoli/lcf/generic/lcfd_start.sh.orig
#sed 's/\#\!\/bin\/sh/\#\!\/bin\/ksh/g' </opt/Tivoli/lcf/generic/lcfd_start.sh.orig >/opt/Tivoli/lcf/generic/lcfd_start.sh
#/opt/Tivoli/lcf/generic/setupinit.sh
#/opt/Tivoli/lcf/generic/lcfd_start.sh $HOSTNAME 30.130.18.17
#echo " LCFD installed"
#else
#echo " LCFD not installed"
#fi

# Step 20 TSM client
if [ $STEP20 = Y ] ; then
cd $NFS
./install-tsm.sh
echo " TSM agent installed"
else
echo " TSM agent not installed"
fi

# Step 21 SRM
#if [ $STEP21 = N ] ; then
#groupadd srmcoll
#if [ ! -d /var/adm ] ; then
	#mkdir -p /var/adm
#fi
#useradd -g srmcoll -c "897/I/669765//Barry Buchek" -m -d /var/adm/perfmgr srmdata
#/usr/sbin/usermod -s /usr/libexec/openssh/sftp-server srmdata
#/usr/bin/passwd -l srmdata
#mkdir -p /var/adm/perfmgr/.ssh
#cat $NFS/srmdata_keys > /var/adm/perfmgr/.ssh/authorized_keys
#chown -R srmdata:srmcoll /var/adm/perfmgr
#cp $NFS/srmLINUX-7.1.0.0.tar /var/adm/perfmgr
#cd /var/adm/perfmgr
#tar -xvf  srmLINUX-7.1.0.0.tar
#rm -f srmLINUX-7.1.0.0.tar
#bin/install.srm
#echo " SRM agent installed"
#else
#echo " SRM agent not installed"
#fi

# Step 22 install BIND-UTILS 
if [ $STEP22 = Y ] ; then
   /bin/yum install -y bind-utils  
   /bin/yum install -y lsof 
   /bin/yum install -y system-storage-manager 
   systemctl stop firewalld
   systemctl disable firewalld
   systemctl mask firewalld
   systemctl mask iptables 
   cp  $NFS/resolv.conf /etc/resolv.conf
   echo " Step 42 done"
fi

# Step 23 IBM userids
if [ $STEP23 = Y ] ; then
/bin/chage -m 7 root;/bin/chage -M 45 root
#chage -M 45 avahi-autoipd;chage -M 45 uidadmin
cd $NFS
#./allid-usonly.sh
./allid.sh
echo " Users added"
else
echo " Users not added"
fi

# Step 24 tonic - Not Required
#if [ $STEP24 = N ] ; then
#/bin/rpm -i $NFS/Tonic-1.09-1.noarch.rpm
#echo " Tonic installed"
#else
#echo " Tonic not installed"
#fi

# Step 25 rsyslog.conf
# commenting out syslog.conf file updates
#if [ -f /etc/syslog.conf -a $STEP25 = Y ] ; then
#cp -p /etc/syslog.conf /etc/syslog.conf.orig
#sed -e '
#/\*.info\;mail/ i\
#*.info;mail.none;authpriv.none;cron.none                @in02plviif001.wellpoint.com' \
#-e '
#/authpriv\.\*/ i\
#authpriv.*                                              @in02plviif001.wellpoint.com' \
#-e '
#/cron\.\*/ i\
#cron.*                                                  @in02plviif001.wellpoint.com' \
#</etc/syslog.conf.orig >/etc/syslog.conf
#/sbin/service syslog reload
#echo " Step 25 done"
#else
#echo " Step 25 not done"
#fi

if [ -f /etc/rsyslog.conf -a $STEP25 = Y ] ; then
cp -p /etc/rsyslog.conf /etc/rsyslog.conf.orig
cp $NFS/rsyslog.conf /etc/rsyslog.conf
#/sbin/service rsyslog reload
/bin/systemctl restart rsyslog
echo " Step 25 done"
else
echo " Step 25 not done"
fi

# Step 26 TMOUT setting
if [ $STEP26 = Y ] ; then
if [ `grep -E TMOUT /root/.bash_profile|wc -l` -eq 0 ] ; then
echo "TMOUT=21600" >> /root/.bash_profile
fi
if [ `grep -E TMOUT /etc/profile|wc -l` -eq 0 ] ; then
echo "TMOUT=1800" >> /etc/profile
fi
#sed -i 's/TMOUT=1800/TMOUT=21600/g' /etc/profile
echo " Step 26 done "
else
echo " Step 26 not done"
fi

# Step 27 Fusion
#if [ $STEP27 = N ] ; then
#if [ -d /opt/IBM/fusion ] ; then
#pkill vsacommd;pkill vsaoutd;pkill vsaclientd
#rm -rf /opt/IBM/fusion/*
#else
#mkdir -p -m 755 /opt/IBM/fusion
#fi
#cp -p $NFS/vsaclient-Linux/* /opt/IBM/fusion/.
#cd /opt/IBM/fusion;./client_setup
#/opt/IBM/fusion/vsaclient start
#echo " Step 27 done"
#else
#echo " Step 27 not done"
#fi

# Step 28 bladelogic - Not Required
#if [ $STEP28 = N ] ; then
#$NFS/NSH750-264-RHAS4X86_64.SH -silent
#/sbin/service rscd start
#echo " Step 28 done,not required"
#else
#echo " Step 28 not done"
#fi

# Step 29 AOC userids
# commented out all user stuff
if [ $STEP29 = Y ] ; then
cd $NFS
./aocid.sh
cd user;./syncpw-aocteam.sh; grep -i src /etc/shadow
echo " Step 29 done"
else
echo " Step 29 not done"
fi

# Step 30 TAD4D 
#TAD4D replease with Flexera


# Step 31 crontab
if [ $STEP31 = Y ] ; then
TMPCRON=/tmp/rootcrontab
touch /var/spool/cron/root
/bin/crontab -u root -l > $TMPCRON
#CRON1=$(grep vsaclientwd $TMPCRON |wc -l)
#if [ $CRON1 -eq 0 ] ; then
#echo "# VSA Client Watchdog (added 20101223144623)" >> $TMPCRON
#echo "22 * * * * /bin/su - root -c "cd /opt/IBM/fusion\;/opt/IBM/fusion/vsaclientwd" >> /dev/null 2>&1 " >> $TMPCRON
#fi
CRON2=$(grep sudo_copy.sh $TMPCRON |wc -l)
if [ $CRON2 -eq 0 ] ; then
echo "# overwrite sudoers every hour" >> $TMPCRON
echo "01 * * * * /bin/sh /opt/admin/sudo_copy.sh" >> $TMPCRON
fi
if [ $CRON2 -eq 0 ] ; then
/bin/crontab $TMPCRON
fi
rm $TMPCRON
echo " Step 31 done"
else
echo " Step 31 not done"
fi

# Step 32 multipath.conf
if [ $STEP32 = Y ] ; then
if [ -f /etc/multipath.conf ] ; then
cp /etc/multipath.conf /etc/multipath.conf.orig
fi
if [ $REL -ge 60 -a $REL -le 69 ] ; then
cp $NFS/multipath.conf.6 /etc/multipath.conf
else
cp $NFS/multipath.conf /etc/multipath.conf
fi
/bin/systemctl enable multipathd
/bin/systemctl restart multipathd
echo " Step 32 done"
else
echo " Step 32 not done"
fi

# Step 33 /opt/admin scripts
if [ $STEP33 = Y ] ; then
mkdir /opt/admin 
#cp -p $NFS/toolschk.sh /opt/admin/.
#cp -p $NFS/gep.ksh /opt/admin/.
cp -p $NFS/sudo_copy.sh /opt/admin/.;chmod 775 /opt/admin/sudo_copy.sh
chown -R satuser:unixadm /opt/admin
echo " Step 33 done"
else
echo " Step 33 not done"
fi


# Step 34 VENAFI FileSystem
if [ ! -d /venafi -a $STEP34 = Y ] ; then
lvcreate -L1G -n venafi vg_sda
mkfs.xfs /dev/mapper/vg_sda-venafi
mkdir -p /venafi
echo "/dev/mapper/vg_sda-venafi /venafi xfs     defaults        0 0" >>/etc/fstab
mount -a
echo " Step 34 done"
else
echo " Step 34 not done"
fi

# Step 35 Qradar
if [ ! -f /opt/tail2syslog/tail2syslog.pl -a $STEP35 = Y ] ; then
cd /mnt/post_install/new_build/Qradar2021
cp qrd73000_us_0.csplin.install_iplno_Anthem_va10p30207_2021-09-10.tar /
cd /
tar -xovf qrd73000_us_0.csplin.install_iplno_Anthem_va10p30207_2021-09-10.tar 
cd /esd/sdwork
./qrd73000_standalone.sh
echo " Step 35 done"
else
echo " Step 35 not done"
fi

# Step 36 EP2 scan
if [ $STEP36 = Y ] ; then
echo "Starting find command to remove world writable files..."
#find / \( -fstype ext3 -o -fstype ext4 -o -fstype xfs \) \( -type d -o -type f \) -perm -002 -ls  -exec chmod 755 {} \;
#e#cho "find complete"
chmod 1777 /tmp
chmod 700 /etc/security
chmod 700 /etc/default
chmod 1777 /var/history_logs
chmod 1777 /var/tmp
cd $NFS/EP2
echo "Starting EP2 scan..."
./EP2_Driver_V2.0.8.sh
echo "EP2 scan complete"
mkdir /pub
/bin/mount 30.128.116.40:/pub /pub
cd /pub/EP2Scan_results
mkdir $HOSTNAME
cd /pub/EP2Scan_results/$HOSTNAME
cp -R /tmp/EP2_Driver_V2.0.8.sh.files .
cd /
/bin/umount /pub 
echo " Step 36 done"
else
echo " Step 36 not done"
fi

# Step 37 Setup Yum and Mutt
if [ $STEP37 = Y ] ; then
   #rhnreg_ks --username=ac01371 --password=ac01371 --force
   /bin/yum -y update
   /bin/rpm -e nano
   /bin/yum -y install mutt
   mv /etc/Muttrc /etc/Muttrc.orig
   cp $NFS/Muttrc /etc/Muttrc
   echo " Step 37 done"
else
   echo " Step 37 not done"
fi

# Step 38 TPC SRA Agent
if [ $STEP38 = Y ] ; then
cd $NFS/LINUX_SRA/linux_ix86/bin
./Agent -install -force -serverPort 9549 -serverIp 30.132.129.73  -installLoc "/opt/IBM/TPC" -agentPort 49101 -commType daemon
echo " Step 38 done"
else
echo " Step 38 not done"
fi

# Step 39 Tanium Install
if [ ! -f /opt/Tanium/TaniumClient/TaniumClient -a $STEP39 = Y ] ; then
cd $NFS/tanium
echo "Installing Tanium agent..."
./install-tanium.sh
#if [ $ENV = prod ] ; then
  #./install-prod.sh
  #/etc/init.d/TaniumClient start
#else
  #./install-dev.sh
  #/etc/init.d/TaniumClient start
#fi
echo " Step 39 done"
else
echo " Step 39 not done"
fi

# Step 40 Flexera Install
if [ ! -f /opt/managesoft/libexec/ndtask -a $STEP40 = Y ] ; then
cd $NFS/Flexera/
./flexera.sh
echo " Step 40 done"
else
echo " Step 40 not done"
fi

# Step 41 TCS compliance steps
if [ $STEP41 = Y ] ; then
echo "" >> /etc/profile
#echo "TMOUT=1800" >> /etc/profile
#echo "readonly TMOUT" >> /etc/profile
#echo "export TMOUT" >> /etc/profile
cp /etc/security/pwquality.conf /etc/security/pwquality.conf.orig
cp $NFS/pwquality.conf /etc/security/pwquality.conf
cp /etc/pam.d/su /etc/pam.d/su.orig
sed -i '/required/s/^#//g' /etc/pam.d/su
sed -i '/sufficient\tpam_wheel/s/^/#/g' /etc/pam.d/su
sed -i 's/pam_wheel.so use_uid$/pam_wheel.so use_uid root_only/g' /etc/pam.d/su
sed -e '/^#/! {/pam_pwquality/ s/^/#/}' -i /etc/pam.d/passwd
echo " Step 41 done"
fi

# Step 42 Install Splunk Forwarder
if [ ! -f /opt/splunkforwarder/bin/splunk -a $STEP42 = Y ] ; then
   echo "Step 42 Installing Splunk Forwarder..."
   cd $NFS/Splunk/
   tar xvf splunkforwarder-6.4.4-b53a5c14bb5e-Linux-x86_64.tar.gz -C /opt/
   /opt/splunkforwarder/bin/splunk start --accept-license
   /opt/splunkforwarder/bin/splunk edit user admin -password temporary -roles admin -auth admin:changeme
   /opt/splunkforwarder/bin/splunk enable boot-start
   /opt/splunkforwarder/bin/splunk restart
else
   echo "Step 42 Install Splunk Forwarder not done"
fi

# Step 43 ITM
if [ ! -f /opt/IBM/ITM/lx8266/lz/bin/klzagent -a $STEP43 = Y ] ; then
ITMLVEXISTS=`lvs | grep itm_lv`
if [ X$ITMLVEXISTS == X ] ; then
echo "Creating itm_lv..."
/sbin/lvcreate -L3G -n itm_lv vg_sda
/sbin/mkfs.xfs /dev/vg_sda/itm_lv
echo "done"
fi
mkdir -p /opt/IBM/ITM
ITMFSTAB=`grep itm_lv /etc/fstab`
if [ X$ITMFSTAB == X ] ; then
echo "Adding itm_lv to /etc/fstab..."
echo "/dev/vg_sda/itm_lv /opt/IBM/ITM   xfs    defaults        1 2" >> /etc/fstab
echo "done"
fi
/bin/mount -a
echo "Installing ITM..."
cd $NFS/FP5/lz_063005000_LINUX
if [ $ENV = nonprod ] ; then 
	./itmInstall.ksh -f /mnt/post_install/new_build/lx8266/itm_install_ITMP1_nonprod.txt
else
	./itmInstall.ksh -f /mnt/post_install/new_build/lx8266/itm_install_ITMP1_prod.txt
fi
/opt/IBM/ITM/bin/itmcmd agent start lz
echo " ITM agent installed"
else
echo " ITM agent not installed"
fi
# Step 44 BES
if [ ! -f /opt/BESClient/bin/BESClient -a $STEP44 = Y ] ; then
cd $NFS/BES; ./teminstall
echo " Step 13 done "
else
echo " Step 13 not done"
fi

# Step 45 install Centrify Packages
if [ $STEP45 = Y ] ; then
cd  $NFS/centrify/CURRENT-BUNDLE
echo "Installing Centrify..."
./install-centrify.sh 
echo " Step 45 Centrify Install  done"
else
echo " Step 45 Centrify Install not done"
fi

# Dnsmasq 
echo "Installing dnsmasq..."
cd $NFS/dnsmasq
./install-dnsmasq-rh8.sh
echo "Dnsmasq install done"

# Install Ilumio
echo "Installing Illumio agent..."
cd $NFS
./install-illumio.sh
echo "Illumio install done"

# Install Qualys Agent
echo "Installing Qualys Agent..."
cd $NFS/Qualys
./install-qualys-agent.sh
echo "Qualys Agent install done"

# Tuning settings
echo "Running Linux tuning script..."
cd $NFS
./Redhat_linux_May2021v2.sh
echo "Linux tuning script done"

# Cleanup khaja userid
echo "Removing khaja id..."
/usr/sbin/userdel -r khaja

# Stop/disable cockpit service and socket
echo "Disabling cockpit service and socket..."
systemctl stop cockpit.service
systemctl disable cockpit.service
systemctl stop cockpit.socket
systemctl disable cockpit.socket

echo " POST INSTALL COMPLETED,PLEASE REBOOT THE SERVER" > $(tty)
exit 0
