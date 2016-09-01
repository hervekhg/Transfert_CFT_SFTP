****************************************************************************************
# Red Hat Entreprise Linux
##Apache Service : httpd

### installation
yum install httpd

### Start Service
systemctl start httpd.service

### Restart Service
systemctl restart httpd.service

###Stop Service
systemctl stop httpd.service

### Reload Service
systemctl reload httpd.service
apachectl graceful (Reload config without affect request)

###Check apache status
systemctl is-active httpd.service

### Editing configuration files
/etc/httpd/conf/httpd.conf : Main configuraiton file
/etc/httpd/conf.d/ : Auxiliary directory

### Check config
apachectl configtest

******************************************************************************************
## Firewall
### Configure Firewall for http an https
firewall-cmd --add-service http
firewall-cmd --add-service https

### Check all service of Firewall
firewall-cm --list-all

*****************************************************************************************
# SMTP server Red Hat (POP3 et IMAP)
yum install dovecot

### Send Mail
yum install sendmail
systemctl start sendmail

### File and print server
yum install samba

***************************************************************************************
###Install package 
yum install package
yum update

### Install package
rpm -i package

### Uninstall package
rpm -e package

###Check if package installed
rpm -q package
