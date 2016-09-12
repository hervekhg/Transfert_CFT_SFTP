****************************************************************************************
## Gestion des package RHEL
|Commande|Description| 
| ----------- | ------ |
|yum install package|Installation d'un pacakge|
|rpm -i package| Installation d'un package avec les sources|
|rpm -e package| Désinstaller un package|
|rpm -q package| Vérifier si un package est installé|

## Apache (httpd) pour RHEL
|Commande|Description| 
| ----------- | ------ |
|yum install httpd |installation d'apache|
|systemctl start httpd.service| Démarrage d'apache|
|systemctl restart httpd.service| Redémarrage d'apache|
|systemctl stop httpd.servic|Arrêt d'apache|
|systemctl reload httpd.service ou apachectl graceful  | Recharge d'apache|
|systemctl is-active httpd.service| Obtenir le statut d'apache|
|apachectl configtest|Test de la configuration apache|
|/etc/httpd/conf/httpd.conf; /etc/httpd/conf.d/ | Fichier de configuration|

## Firewall RHEL
|Commande|Description| 
| ----------- | ------ |
|firewall-cmd --add-service http| configure le firewall pour le flux http|
|firewall-cmd --add-service https |configure le firewall pour le flux https|
|firewall-cm --list-all| lister tous les services du firewall|

## Autres Service RHEL
|Commande|Description| 
| ----------- | ------ | 
|yum install sendmail| package pour les mail|
|yum install samb| package pour serveur de fichier et d'impiramnte|

## Commandes importantes
|Commande|Description| 
| ----------- | ------ | 
|who –b |Date de dernier reboot|
|grep -v '#' fichier | Affiche toutes les lignes ne contenant pas "#"|
|uptime|Duree de fonctionnement du serveur|
|who|Liste des utilisateurs connectés au serveur|
|lsof|Liste des fichiers ouvert et les processus associés|
|uname -a|Affiche toutes les informations sur le système|
|cat fic1 && cat fic2 > fic3 | concatener deux fichiers|
|file -i fichier| obtenir les informations sur le type de fichier|
|sed -i 's/Unix/UNIX/g' unix.txt | remplace Unix par UNIX dans le fichier unix.txt|
|ps auxf | grep apache2 | grep -v grep | awk '{s+=$6} END {print s}' | Memoire totale utilisée par un processus|
|chmod +t /home/vinita/data| ajout du sticky bit sur data|
|ipcs| NOmbre de segment mémoire d'oracle/postgrel |
|echo "This is the body" \| mail -s "Sujett" -aFrom:Harry\<harry@gmail.com\>someone@example.com|Commande d'envoi de mail|
|cat fichier \| while read ligne
do print $ligne done| Lire chaque ligne d'un fichier|

## Commande find
|Commande|Description| 
| ----------- | ------ | 
|find -name *monfichier*.ogg |Recherche dans le dossier courant |
|find /home/ -name monfichier |Recherche le fichier monfichier dans toute la descendance de /home|
|find . -mtime -5 |Recherche les fichiers du répertoire courant qui ont été modifiés entre maintenant et il y a 5 jours|
|find /home/ -mtime -1 \! -type d |Recherche uniquement les fichiers (! -type d signifie n'était pas un répertoire) ayant été modifiés ces dernières 24h|
|find . ! -user root |find . ! -user root |
|find . \( -name '*.wmv' -o -name '*.wma' \) -exec rm {} \;|Recherche et supprime tous les fichiers WMA et WMV trouvés|
|find . \( -type f -exec sudo chmod 664 "{}" \; \) , \( -type d -exec sudo chmod 775 "{}" \; \)|Modifie récursivement les droits en 664 sur les fichiers et en 775 sur les répertoires en une seule instruction|

## Commande ps
|Option|Description|
| ----------- | ------ | 
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

## Commande Chroot
|Option|Description|
| ----------- | ------ | 

## Commande awk
|Option|Description|
| ----------- | ------ | 
|awk -F ":" '{ $2 = "" ; print $0 }' /etc/passwd|imprime chaque ligne du fichier /etc/passwd après avoir effacé le deuxième champs|
|awk 'END {print NR}' fichier|imprime le nombre total de lignes du fichiers|
|awk '{print $NF}' fichier|imprime le dernier champs de chaque ligne|
|who \| awk '{print $1,$5}'|imprime le login et le temps de connexion|
|awk 'length($0)>75 {print}' fichier'|	imprime les lignes de plus de 75 caractères. (print équivaur à print $0)|

## Commande grep
|Option|Description 
| ----------- | ------ | 
|grep "oracle" * | Recherche tous les fichiers du répertoire courant contenant oracle|
|grep -lR "oracle" * | Recherche récursivement et affiche la liste des fichiers contenant oracle|
|grep -n "null" dump.txt| Retourne toutes les lignes et les numéros ou apparaissent null dans dump.txt|

## mount
|Option|Description 
| ----------- | ------ |
|mount|Liste tous les systèmes de fichiers actuellement montés|
|mount -a |Monte tous les systèmes de fichiers déclarés dans le fichier /etc/fstab|
|mount /mnt/maPartion |Monte le système de fichiers ad-hoc déclarés dans le fichier /etc/fstab|
|mount -t proc /proc /aa/proc|Monte le dossier /proc dans la partition /aa/proc|
|mount --bind /proc_old proc_new |Monte l'ancien système de fichier /proc_old dans le nouveau proc_new|
|mount -t vfat -o defaults,rw,user,umask=022,uid=1000 /dev/sda1 /mnt/Mondisk/ |Monte un disque dur USB (/dev/sda1) formaté en FAT32 (-t vfat) en lecture écriture (rw) dans le répertoire /mnt/Mondisk/ ; tous les utilisateurs peuvent le démonter (user), les droits d'exécution (uid=1000) sont fixés à l'utilisateur ayant l'UID 1000 (sous Ubuntu, l'uid 1000 correspond au premier utilisateur créé) et la création d'un fichier s'effectuera avec les permissions 644 (rw-r---r--) et pour un répertoire 755 (rwxr-xr-x) (umask 022)|

## umount
|Option|Description 
| ----------- | ------ |
| umount /mnt/Mondisk  |umount /mnt/Mondisk |
|umount -f /dev/cdrom |umount -f /dev/cdrom |
|umount -d /mnt/monIso |Démonte et libère le périphérique loop|
|umount -a |Démonte tous les systèmes de fichiers montés (à l'exception de /proc) ; ne sert que lorsque l'on veut redémarrer ou éteindre sa machine manuellement et proprement.|

## adduser
|Option|Description 
| ----------- | ------ |
|adduser MonUtilisateur | Crée l'utilisateur MonUtilisateur. |
|adduser –disabled-password –no-create-home UtilisateurSSH |Crée un utilisateur UtilisateurSSH sans mot de passe qui ne pourra pas se connecter directement sur la machine et sans lui créer de répertoire home|
|adduser –disabled-password –home /home/UtilisateurSSH UtilisateurSSH |Même chose qu'au-dessus sauf qu'on lui donne le même répertoire HOME qu'à l'utilisateur UtilisateurSSH créé en premier|
|adduser UtilisateurSSH fuse | Ajoute l'utilisateur UtilisateurSSH (crée préalablement) dans le groupe "fuse", on peut faire aussi un: gpasswd -a $USER fuse|
|adduser NouvelUtilisateur ––ingroup users|Crée l'utilisateur NouvelUtilisateur et l'ajoute au groupe "users"|

## adduser
|Option|Description 
| ----------- | ------ |
|deluser UtilisateurSSH |Supprime l'utilisateur UtilisateurSSH|
|deluser –remove-home NouvelUtilisateur|Supprime l'utilisateur NouvelUtilisateur ainsi que le répertoire /home/NouvelUtilisateur|
|deluser NouvelUtilisateur users |Supprime l'utilisateur NouvelUtilisateur du groupe "users"|

## du
|Option|Description 
| ----------- | ------ |
|du -hs dir |Affiche la taille du répertoire dir ou du répertoire courant si dir est omis |
|du -ch /home/MonUtilisateur |Affiche la taille du répertoire dir ou du répertoire courant si dir est omis|
|du -sm ~/Images/*.jpg |Affiche la taille totale des fichiers JPEG contenus dans le répertoire ~/Images|

## Information sur le système:uname
|Commande|Description| 
| ----------- | ------ | 
|uname -s| nom du noyau|
|uname -n|Affiche le nom de la machine (hostname)|
|uname -r|Affiche la révision du noyau|
|uname -v|Affiche la version du noyau|
|uname -o|Affiche le nom du système d'exploitation|
|uname -a|Affiche tout|

## Commande sed





