#!/usr/bin/ksh
# --------------------------------------------------------------------------------
# Nom         : /expl/scripts/cft/CFT_RECV_OK_SFTP.ksh
# Auteur      : CCOVTOM - Hervé Kouamo
# Date        : 08/02/2016
# Version     : 1.0
#
# Application : Exploitation Serveur CFT
#
# Resume      : Script generique de rebond vers WS-FTP
#
#
# Description : - Chargement du Profile d'exploitation pour chargement
#		  des variables globales.
#
#               - Definition des Variables locales.
#
#				  - Initialisation de la trace.
#
#				  - Controle de la presence du fichier de configuration.
#
#				  - Transfert WinSCP vers WS-FTP
#
#
# Entrées     : /expl/conf/profile.env.ksh
#               Fichier de definition de l'environnement d'exploitation. Il défini 
#               les variables globales EXP_F_CNFPRG, EXP_D_TMP et EXP_D_LOG.
#               /expl/conf/CFT/&idf_SFTP_CONF.ksh
#                   
# Sorties     : /logs/expl/cft/CFT_RECV_OK_SFTP_&part_&idf_&idt_${HEURE}.log
#               Trace d'exécution
#				
#
# Codes Retour: 0			- Success
#               10		- Erreur  - Problème lors de l'envoi du fichier
#               20		- Erreur  - Erreur lors du deplacement du fichier
#               100		- Fatal   - Fichier non trouve
#               110		- Fatal   - Profile d'exploitation inexistant
#               120		- Fatal   - Fichier de config. inexistant
#
# --------------------------------------------------------------------------------


# ################################################################################
#                                  INITIALISATION
# ################################################################################
    
# --------------------------------------------------------------------
# Chargement du profile d'exploitation
# --------------------------------------------------------------------

export Profile=/expl/conf/profile.env.ksh

if [[ ! -n ${Profile} ]];then
	NO_PROFILE
fi

. ${Profile}
   
# --------------------------------------------------------------------
# Definition de variables locales
# --------------------------------------------------------------------

export JOUR=$(date +%Y%m%d)
export HEURE=$(date +%H:%M:%S)

export  REP_LOG=${EXP_D_LOG}/CFT
export  LOG=${REP_LOG}/CFT_RECV_OK_SFTP_&part_&idf_&idt_${HEURE}.log
#export  FIC_MAIL=${EXP_D_TMP}/CFT_MAIL_&idf_&idt_OK_${HEURE}.tmp
#export  FIC_MAIL_ERR=${EXP_D_TMP}/CFT_MAIL_&idf_&idt_KO_${HEURE}.tmp

#export  MAIL_FROM=$(hostname)@rff.fr


#if [[ ${ENV} == "P" ]];then
#	export ENVIR=PRODUCTION
#fi

#if [[ ${ENV} == "I" ]];then 
#	export ENVIR=INTEGRATION
#fi

for file in $(echo "&fname");do 
   FICHIER=$(basename $file)
done

export  PART=&part
export	IDF=&idf
export  REP_SOURCE=/data/cft/in
export  REP_ARCH=/data/cft/in/archives

export  RetJob=0


# --------------------------------------------------------------------------------
# Initialisation de la Trace
# --------------------------------------------------------------------------------

echo "--------------------------------------------------------------------------------"  | tee -a ${LOG}
echo "$(date +%H:%M:%S) - Debut de traitement -" | tee -a ${LOG}
echo "--------------------------------------------------------------------------------"  | tee -a ${LOG}
echo "Parametres du transfert CFT d origine :" | tee -a ${LOG}
echo "PART = &part" | tee -a ${LOG}
echo "IDF = &idf" | tee -a ${LOG}
echo "FNAME = &fname" | tee -a ${LOG}
echo "NFNAME = &nfname" | tee -a ${LOG}
echo "xFICHIER = ${FICHIER}" | tee -a ${LOG}
echo "PARM = &parm" | tee -a ${LOG}
echo "IDT = &idt" | tee -a ${LOG}
echo "." | tee -a ${LOG}


FLAG_FLUX=""
SEP=";"
CONF_DIR=/expl/conf/CFT
CONF_FLUX=${CONF_DIR}/CFT_FLUX.conf

xIDENTIFIANT=${IDF}
echo "Extraction des infos du fichier de config des flux" | tee -a "${LOG}"

#xFNAME=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f11 -d"${SEP}")
#xDATA_DIR=$(dirname "${xFNAME}")
xDATA_DIR=${REP_SOURCE}


xCIBLE_HOST=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f20 -d"${SEP}")
xCIBLE_USER=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f22 -d"${SEP}")
xCIBLE_PWD=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f23 -d"${SEP}")

xCIBLE_DIR=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f24 -d"${SEP}")

# --------------------------------------------------------------------
# Controle des fichiers de config. liés au transfert
# --------------------------------------------------------------------

#export  CONF_IDF=${EXP_D_CNF}/cft/&idf_CONF.ksh

#if [ ! -e ${CONF_IDF} ];then
#  NO_CONF
#else
#  ${CONF_IDF} &idf
#fi


TRANSFERT()
{
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	echo "$(date +%H:%M:%S) Envoi SFTP du fichier ${FICHIER} vers le serveur ${xCIBLE_HOST} "| tee -a ${LOG}
	echo "." | tee -a ${LOG}

	#  Copie du fichier vers le serveur
	export Msg=OK
    export Svr=S
    (echo progress; echo put "${xDATA_DIR}/${FICHIER} ${xCIBLE_DIR}"; echo quit) | sshpass -p "${xCIBLE_PWD}" sftp -v ${xCIBLE_USER}@${xCIBLE_HOST} 2>&1| tee -a ${LOG}
     RetJob=$?

	if [ $RetJob != 0 ];then
	  export RetJob=60
	  echo "\n${EXP_J_CTEC}-E-${EXP_J_TYTR}, Erreur liee a la commande d envoi sftp put" | tee -a  ${LOG} 
	  FIN_JOB 
	else
	  grep "No such file or directory" ${LOG} >/dev/null
	  RetJob=$?
	  if [ $RetJob != 0 ];then
	    export RetJob=0
	    echo "pas d erreur de type No such" | tee -a ${LOG}
	  else
	    export RetJob=15
	    export Msg=ERREUR
	    export Svr=E
	    echo "\n${EXP_J_CTEC}-E-${EXP_J_TYTR}, Erreur liee au fichier source ou repertoire cible" | tee -a  ${LOG} 
	  fi
	fi

	echo "."  | tee -a ${LOG}
	echo "------------------------------------------------------------------------- "| tee -a ${LOG}
	echo "$(date +%H:%M:%S) Fin du transfert" | tee -a ${LOG}
	echo "." | tee -a ${LOG}

#	if [ ${ENVOI_MAIL} == "Y" ];then
#		MAIL_OK
#	else
#		echo "Pas denvoi de mail." | tee -a ${LOG}
#	fi

	ARCH_FILE
	FIN_JOB
}


# --------------------------------------------------------------------
# Archivage du fichier recu
# --------------------------------------------------------------------
ARCH_FILE()
{
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	echo "$(date +%H:%M:%S) Archivage du fichier : " | tee -a ${LOG}
	mv ${REP_SOURCE}/${FICHIER} ${REP_ARCH}/${FICHIER}_${JOUR}_${HEURE}.recv | tee -a ${LOG}

	if [ $? -ne 0 ];then
		echo "ERREUR LORS DE L ARCHIVAGE DU FICHIER RECU !" | tee -a ${LOG}
		echo "DEPLACER MANUELLEMENT LE FICHIER !" | tee -a ${LOG}
		export RetJob=90
		FIN_JOB
	else
		echo "Archivage OK"  | tee -a ${LOG}
		echo "."  | tee -a ${LOG}
	fi

	echo "." | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
}
# --------------------------------------------------------------------
# Absence du fichier de chargement de l environnement d'exploitation
# --------------------------------------------------------------------

NO_PROFILE()
{
	echo "." | tee -a ${LOG}
	echo "[ERREUR] Fichier d environnement non trouve dans le repertoire ${EXP_D_CNF}" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
#	MAIL_EXPL
	export RetJob=110
	FIN_JOB
}

# --------------------------------------------------------------------
# Absence du fichier de config. pour le fichier recu
# --------------------------------------------------------------------
NO_CONF()
{
	echo "." | tee -a ${LOG}
	echo "[ERREUR] Fichier de configuration &idf_CONF.ksh non trouve dans le repertoire ${EXP_D_CNF}/CFT" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
#	MAIL_EXPL
	export RetJob=120
	FIN_JOB
}

#----------------------------------------
# Aucun fichier trouve
# --------------------------------------------------------------------

NO_FILE()
{
	echo "." | tee -a ${LOG}
	echo "[ERREUR] Aucun fichier trouve dans le repertoire ${REP_SOURCE}" | tee -a ${LOG}
	echo ". "| tee -a ${LOG}
#	MAIL_EXPL
	export RetJob=100
	FIN_JOB
}


# --------------------------------------------------------------------
# Envoi de mail si transfert OK
# --------------------------------------------------------------------

#MAIL_OK()
#{
#	echo "$(date +%H:%M:%S) Envoi de Mail" | tee -a ${LOG}
#	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
#	echo "." | tee -a ${LOG}
#	cat ${FIC_MAIL} | mail -r ${MAIL_FROM} -c ${MAIL_CC} -s "[CFT - ${ENVIR}] : Reception via l'IDF &idf du fichier ${FICHIER}" ${MAIL_TO}
#
#	if [ $? -ne 0];then
#		echo "ERREUR LORS DE L ENVOI DE MAIL !" | tee -a ${LOG}
#	else
#		echo "Mail envoye." | tee -a ${LOG}
#		echo "."  | tee -a ${LOG}
#	fi
#}
# --------------------------------------------------------------------
# Envoi de mail si transfert en erreur
# --------------------------------------------------------------------

#MAIL_ERR()
#{
#	echo "$(date +%H:%M:%S) Envoi de mail" | tee -a ${LOG}
#	echo "." | tee -a ${LOG}
#	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
#	if [[ ! -e ${FIC_MAIL_ERR} ]];then
#		cat ${LOG} | tee -a ${FIC_MAIL_ERR}
#
#	export  SUBJECT="[CFT - ${ENVIR}] : Probleme lors de la reception du fichier ${FICHIER} !"
#	cat ${FIC_MAIL_ERR} | mail -r ${MAIL_FROM} -s "[$SUBJECT" ${MAIL_CC}
#
#	if [ $? -ne 0];then
#		echo "ERREUR LORS DE L ENVOI DE MAIL !" | tee -a ${LOG}
#	else
#		echo "Mail envoye." | tee -a ${LOG}
#		echo "."  | tee -a ${LOG}
#	fi
#}

# --------------------------------------------------------------------
# --------------------------- FIN DU JOB -----------------------------
# --------------------------------------------------------------------

FIN_JOB()
{	
#    if [[ $RetJob -ne 0 ]];then
#    	MAIL_ERR
#    fi 

	rm -f ${FIC_MAIL}
	rm -f ${FIC_MAIL_ERR}
	echo "." | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	echo "$(date +%H:%M:%S) Fin de traitement ${Msg} - Code Retour  : ${RetJob}" | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	exit ${RetJob}
}



# ################################################################################
#                               PROGRAMME PRINCIPAL
# ################################################################################

if [[ ${PART} == "LOOP" ]];then
	echo "Test Boucle locale, pas d action." | tee -a ${LOG}
	ARCH_FILE
	FIN_JOB
fi

if [[ ${xCIBLE_DIR} == "NOP" ]];then
	echo "Pas d'action : archivage du fichier reçu." | tee -a ${LOG}
	ARCH_FILE
	FIN_JOB
fi

TRANSFERT
