#!/bin/ksh
#* ***********************************************************************
#* Nom :        
#* Version :    1.0
#* ***********************************************************************
#*
#* Description :
#*     
#*
#* Parametres : NEANT
#*
#* Exemples de lancement :
#*     
#*
#* ***********************************************************************
#* Creation :           01/08/16 par HGK
#*
#* ***********************************************************************
# 00 07 * * * /dossier_entree/Prod_test.ksh 2>&1 1>>/dossier_entree/Prod_test.log

# Positionnement dans repertoire courant
cd /dossier_entree

# Initialisation des variables
SUBJECT_MAIL="Sujet du Mail"
MESSAGE_DE_FIN_MAIL="Cordialement"
TIMESTAMP=`date '+%d/%m/%Y %T'`
DESTINATAIRE=destinataire@mail.fr

FOLDER_SCRIPT="/dossier_entree"

DUMP="dump.sql"
FILE_RESULTAT="Prod_test-$(date +'%Y-%m-%d').csv"
FILE_RESULTAT_TMP="tmp.csv"
FILE_MAIL="/dossier_entree/result/mail.txt"



GenereData()
{
        echo "Lancement de la requete de recuperation"
        #sqlplus -S SYSTEM/4oRr9-K3 \@sql/${DUMP}
        #cd ${FOLDER_SCRIPT}
        sqlplus -S SYSTEM/4oRr9-K3 \@sql/${DUMP}

        echo "Entête" > result/$FILE_RESULTAT
        cat ${FOLDER_SCRIPT}/result/${FILE_RESULTAT_TMP} >> ${FOLDER_SCRIPT}/result/$FILE_RESULTAT

        cd ${FOLDER_SCRIPT}/result
        gzip -f ${FOLDER_SCRIPT}/result/${FILE_RESULTAT}
        #rm ${FOLDER_SCRIPT}/result/${FILE_RESULTAT_TMP}
}

GenereMail()
{
    #cd ${FOLDER_SCRIPT}
        echo "${TIMESTAMP} Creation du mail"
        echo "Bonjour,
        Voici les resultats du $(date '+%d/%m/%Y'):
        " > ${FILE_MAIL}
        #cat ${FOLDER_SCRIPT}/result/${FILE_RESULTAT_TMP} >> ${FILE_MAIL}
        echo "
        Vous trouverez en pieces jointes, le fichier" >> ${FILE_MAIL}
        echo " $FILE_RESULTAT" >> ${FILE_MAIL}
        echo "$MESSAGE_DE_FIN_MAIL" >> ${FILE_MAIL}

        echo "encodage ${FILE_RESULTAT}"
        #gzip -f ${FOLDER_SCRIPT}/result/$FILE_RESULTAT

        if [ -f ${FILE_RESULTAT}.gz ];
        then
            echo "${TIMESTAMP} Creation du fichier .gz"
            uuencode ${FOLDER_SCRIPT}/result/${FILE_RESULTAT}.gz ${FILE_RESULTAT}.gz >> ${FILE_MAIL}
        else 
        	echo "${TIMESTAMP} Le fichier .gz ne peut pas être créé"
        	exit 1
        fi
}


EnvoiMail()
{
        # EnvoiMail $DESTINATAIRE $SUBJECT_MAIL $MAIL
        echo "${TIMESTAMP} envoi du mail a $1"
        cat $FILE_MAIL | mail -s "Resultat Prod " $DESTINATAIRE
        #cat mail.txt
        echo " ${TIMESTAMP} Fin d'envoi du mail.txt"
        exit 0
}

##### Programme Principal ################
set -x
echo "${TIMESTAMP} Début Récupération des données"
GenereData
echo "${TIMESTAMP} Fin Récupération des données"

echo "${TIMESTAMP} Genération du Mail"
GenereMail

echo "${TIMESTAMP} Envoi du Mail"
EnvoiMail
#EnvoiMail $DESTINATAIRE $SUBJECT_MAIL $FILE_MAIL
