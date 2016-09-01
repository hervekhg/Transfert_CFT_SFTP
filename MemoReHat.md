****************************************************************************************
# Red Hat Entreprise Linux

Install package 
<pre class='sortie_standard'>yum install package</pre>

Install package
<pre class='sortie_standard'> rpm -i package </pre>

Uninstall package
<pre class='sortie_standard'> rpm -e package </pre>

Check if package installed
<pre class='sortie_standard'> rpm -q package </pre>

##Apache Service : httpd

installation
<pre class='sortie_standard'> yum install httpd </pre>

Start Service
<pre class='sortie_standard'> systemctl start httpd.service </pre>

Restart Service
<pre class='sortie_standard'> systemctl restart httpd.service </pre>

Stop Service
<pre class='sortie_standard'> systemctl stop httpd.service </pre>

Reload Service
<pre class='sortie_standard'> systemctl reload httpd.service
apachectl graceful (Reload config without affect request) </pre>

Check apache status
<pre class='sortie_standard'> systemctl is-active httpd.service </pre>

Editing configuration files
<pre class='sortie_standard'>/etc/httpd/conf/httpd.conf : Main configuraiton file
/etc/httpd/conf.d/ : Auxiliary directory </pre>

Check config
<pre class='sortie_standard'> apachectl configtest </pre>

## Système Linux
Check last reboo
<pre class='sortie_standard'> who –b </pre>

Concat two file in one
<pre class='sortie_standard'> cat fic1 && cat fic2 > fic3 </pre>

Get info about type of file
<pre class='sortie_standard'> file -i fichier </pre>

replace string in file
<pre class='sortie_standard'> sed -i 's/Unix/UNIX/g' unix.txt </pre>

Memoire totale utilisée par apache ?
<pre class='sortie_standard'> ps auxf | grep apache2 | grep -v grep | awk '{s+=$6} END {print s}' </pre>

Sticky bit:
<pre class='sortie_standard'> chmod +t /home/vinita/data
chmod 1755 /home/vinita/data </pre>

Nombre de segment memoire d'Oracle/Postgrel
<pre class='sortie_standard'> ipcs </pre>

******************************************************************************************
## Firewall
Configure Firewall for http an https
<pre class='sortie_standard'>firewall-cmd --add-service http
firewall-cmd --add-service https</pre>

check all service of Firewall
<pre class='sortie_standard'>firewall-cm --list-all </pre>

*****************************************************************************************
SMTP server Red Hat (POP3 et IMAP)
<pre class='sortie_standard'> yum install dovecot </pre>

Send Mail
<pre class='sortie_standard'> yum install sendmail
systemctl start sendmail </pre>

### File and print server
<pre class='sortie_standard'> yum install samba </pre>

***************************************************************************************

