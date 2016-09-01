****************************************************************************************
# Red Hat Entreprise Linux
###Install package 

<pre class='sortie_standard'>yum install</pre>

### Install package
<pre class='sortie_standard'> rpm -i package </pre>

### Uninstall package
<pre class='sortie_standard'>  -e package </pre>

###Check if package installed
<pre class='sortie_standard'> rpm -q package </pre>

##Apache Service : httpd

### installation
<pre class='sortie_standard'> yum install httpd </pre>

### Start Service
<pre class='sortie_standard'> systemctl start httpd.service </pre>

### Restart Service
<pre class='sortie_standard'> systemctl restart httpd.service </pre>

###Stop Service
<pre class='sortie_standard'> systemctl stop httpd.service </pre>

### Reload Service
<pre class='sortie_standard'> systemctl reload httpd.service
apachectl graceful (Reload config without affect request) </pre>

###Check apache status
<pre class='sortie_standard'> systemctl is-active httpd.service </pre>

### Editing configuration files
<pre class='sortie_standard'>/etc/httpd/conf/httpd.conf : Main configuraiton file
/etc/httpd/conf.d/ : Auxiliary directory </pre>

### Check config
<pre class='sortie_standard'> apachectl configtest </pre>

### Comment pouvez-vous calculer la mémoire totale utilisée par un serveur web ?
<pre class='sortie_standard'> ps auxf | grep apache2 | grep -v grep | awk '{s+=$6} END {print s}' </pre>

### Sticky bit:
<pre class='sortie_standard'> chmod +t /home/vinita/data
chmod 1755 /home/vinita/data </pre>

******************************************************************************************
## Firewall
### Configure Firewall for http an https
firewall-cmd --add-service http
firewall-cmd --add-service https

### Check all service of Firewall
firewall-cm --list-all

*****************************************************************************************
## SMTP server Red Hat (POP3 et IMAP)
yum install dovecot

### Send Mail
yum install sendmail
systemctl start sendmail

### File and print server
yum install samba

***************************************************************************************

