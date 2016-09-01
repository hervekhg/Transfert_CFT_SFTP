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

# Système Linux
Date de dernier reboot
<pre class='sortie_standard'> who –b </pre>

Duree de fonctionnement du serveur
<pre class='sortie_standard'> uptime </pre>

Liste des connectées au serveur
<pre class='sortie_standard'> who </pre>

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

# Commande find
|Commande|Description| 
|find -name *monfichier*.ogg |Recherche dans le dossier courant |
|find /home/ -name monfichier |Recherche le fichier monfichier dans toute la descendance de /home|
|find . -mtime -5 |Recherche les fichiers du répertoire courant qui ont été modifiés entre maintenant et il y a 5 jours|
|find /home/ -mtime -1 \! -type d |Recherche uniquement les fichiers (! -type d signifie n'était pas un répertoire) ayant été modifiés ces dernières 24h|
|find . ! -user root |find . ! -user root |
|find . \( -name '*.wmv' -o -name '*.wma' \) -exec rm {} \;|Recherche et supprime tous les fichiers WMA et WMV trouvés|
|find . \( -type f -exec sudo chmod 664 "{}" \; \) , \( -type d -exec sudo chmod 775 "{}" \; \)|Modifie récursivement les droits en 664 sur les fichiers et en 775 sur les répertoires en une seule instruction|

## Commande ps

|Option|Description| 
|-a|Affiche tous les jobs exécutés par l'utilisateur et le système|
|-x|Affiche jobs et process confondus|
|-A|Affiche tous les process exécutés par l'utilisateur et le système (équivalent à ps -ax)|
|-j|Affiche plus de caractéristiques sur le processus, comme l'état (colonne STAT), ou l'utilisateur qui exécute le processus
|-m|Affiche les processus par ordre d'utilisation de la mémoire, à la place du PID
|-r|Affiche les processus par ordre d'utilisation du processeur
|-u|Donne la liste des processus associés à un utilisateur.
|ps -jax |affiche tous les processus en activité et le nom de leur utilisateur
|ps -ef |lister tous les processus
|ps -ax |lister tous les processus (BSD syntax)
|ps -u |lister les processus lancé par un utilisateur
|ps -ejH |lister les processus en arbres
|ps -C apache2 |lister les processus associer à apache
|ps aux --sort=-pcpu,+pmem |lister les processus par la consommation de CPU et Memoire
|}

## Commande awk
|Option|Description 
|
awk -F ":" '{ $2 = "" ; print $0 }' /etc/passwd|imprime chaque ligne du fichier /etc/passwd après avoir effacé le deuxième champs|
|awk 'END {print NR}' fichier|imprime le nombre total de lignes du fichiers|
|awk '{print $NF}' fichier|imprime le dernier champs de chaque ligne|
|who \| awk '{print $1,$5}'|imprime le login et le temps de connexion|
|awk 'length($0)>75 {print}' fichier'|	imprime les lignes de plus de 75 caractères. (print équivaur à print $0)|

## Commande grep
|Option|Description 
|grep "oracle" * | Recherche tous les fichiers du répertoire courant contenant oracle|
|grep -lR "oracle" * | Recherche récursivement et affiche la liste des fichiers contenant oracle|
|grep -n "null" dump.txt| Retourne toutes les lignes et les numéros ou apparaissent null dans dump.txt|

## Commande sed

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

