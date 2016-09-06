#!/bin/sh
######################################
# Date :2016/05/09
# Auteur: Herve Kouamo
# Script de Mise a jour du Wiki BACKUP
#####################################

HOST="192.168.5.240"
LOGIN="user"
MDP="mdp"
REMOTE_FOLDER="/opt/folder"
FILE="*.gz"
LOCAL_FOLDER="/opt/local_folder"

UserBDD="user"
PwdBDD="pwd"
NomBDD="bddname"
BD_FILE="dump.sql"


#DÃ©finition du fichier log
FicLog=~/"Scripts/UpdateWIKIBACK$(date '+%Y%m%d').log"
touch $FicLog


GetFile(){
 echo "Recuperation de l'archive" >>$FicLog

 scp ${LOGIN}@${HOST}:${REMOTE_FOLDER}/${FILE} ${LOCAL_FOLDER}
 echo "Fin de copie" >>$FicLog

}

UnzipFile(){
 echo "Gunzip des fichiers" >>$FicLog
 gunzip ${LOCAL_FOLDER}/${FILE}
 echo "Fin Gunzip des fichiers et debut detar" >>$FicLog
 tar -xvf ${LOCAL_FOLDER}/*.tar
 echo "Fin detar des fichiers " >>$FicLog

}

UpdateImages(){
 echo "Mise a jour du dossier des images" >>$FicLog
 cp -r /opt/restaure/images/* /opt/mediawiki-1.21.3/images
 rm -rf  /opt/restaure/images
}

UpdateDataBase(){

 echo "Mise a jour de la base de donnees" >>$FicLog

 mysql -u $UserBDD --password=$PwdBDD $NomBDD < ${LOCAL_FOLDER}/${BD_FILE}
 CodeRet=$?
 echo "Fin de la mise a jour BDD: " + $CodeRet >>$FicLog

}
PurgeFile(){
 rm -f ${LOCAL_FOLDER}/*
}

#Programme principal
echo "Debut du programme $(date '+%Y-%m-%d:%H%M%S')"  >>$FicLog
GetFile
echo "Debut dezippage"
UnzipFile
echo "Fin dezippage"

echo "Mise a jour du dossier images"
UpdateImages
echo "Fin MAJ images"

echo "Debut Mise a jour de BDD"
UpdateDataBase
echo "Fin Mise a jour BDD"

echo "Purge des fichiers"
PurgeFile

echo "Fin du programme $(date '+%Y-%m-%d:%H%M%S')"  >>$FicLog
