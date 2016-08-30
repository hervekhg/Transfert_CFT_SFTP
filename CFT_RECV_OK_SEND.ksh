#!/usr/bin/ksh
# --------------------------------------------------------------------------------
# Nom         : /expl/scripts/CFT/CFT_RECV_OK_SEND.ksh
# Auteur      : CCO - Hervé KOUAMO
# Date        : 09/02/2016
# Version     : 1.0
#
# Application : Exploitation Serveur CFT
#
# Resume      : Script generique de rebond vers CFT LAN ou partenaire exterieur (post traitement)
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
#
#
#
# Entrées     : /expl/conf/profile.env.ksh
#               Fichier de definition de l'environnement d'exploitation. Il défini 
#               les variables globales EXP_F_CNFPRG, EXP_D_TMP et EXP_D_LOG.
#                   
# Sorties     : /logs/expl/CFT/CFT_RECV_OK_GEN_&part_&idf_&idt_${HEURE}.log
#               Trace d'exécution
#				
#				  #
# Codes Retour: 0			- Success
#               10		- Erreur  - Problème lors de l'envoi du fichier
#               20		- Erreur  - Erreur lors du deplacement du fichier
#               100		- Fatal   - Fichier non trouve
#               110		- Fatal   - Profile d'exploitation inexistant
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

${Profile}
   
# --------------------------------------------------------------------
# Definition de variables locales
# --------------------------------------------------------------------
   
export JOUR=$(date +%Y%m%d)
export HEURE=$(date +%H:%M:%S)

export REP_LOG=${EXP_D_LOG}CFT
export LOG=${REP_LOG}/CFT_RECV_OK_GEN_&part_&idf_&idt_${HEURE}.log
export FIC_MAIL=${EXP_D_TMP}/CFT_RECV_OK_GEN_&part_&idf_&idt_${HEURE}.tmp
export FIC_MAIL_ERR=${EXP_D_TMP}/CFT_RECV_KO_GEN_&part_&idf_&idt_${HEURE}.tmp



# export MAIL_FROM=%COMPUTERNAME%@rff.fr
# export MAIL_TO=bta@rff.fr


# --------------------------------------------------------------------
# Controle des fichiers de config. liés au transfert
# --------------------------------------------------------------------

#export  CONF_IDF=${EXP_D_CNF}/cft/&idf_CONF.ksh

#if [ ! -e ${CONF_IDF} ];then
#  NO_CONF
#else
#  ${CONF_IDF} &idf
#fi


if [[ ${ENV} == "P" ]];then
	export ENVIR=PRODUCTION
fi

if [[ ${ENV} == "I" ]];then 
	export ENVIR=INTEGRATION
fi


for file in $(echo "&fname");do 
   FICHIER=$(basename $file)
done

export PART=&part
export REP_SOURCE=/data/cft/in


export RETJOB=0

# --------------------------------------------------------------------------------
# Initialisation de la Trace
# --------------------------------------------------------------------------------

echo "-------------------------------------------------------------------------" | tee -a ${LOG}
echo "$(date +%H:%M:%S) - Debut de traitement -" | tee -a ${LOG}
echo "-------------------------------------------------------------------------" | tee -a ${LOG}
echo "Parametres du transfert CFT d'origine :" | tee -a ${LOG}
echo "PART = &part" | tee -a ${LOG}
echo "IDF = &idf" | tee -a ${LOG}
echo "IDT = &idt" | tee -a ${LOG}
echo "FNAME = &fname" | tee -a ${LOG}
echo "NFNAME = &nfname" | tee -a ${LOG}
#echo "PARM = &parm" | tee -a ${LOG}
echo "FICHIER = ${FICHIER}" | tee -a ${LOG}
echo "." | tee -a ${LOG}

# ################################################################################
#                               PROGRAMME PRINCIPAL
# ################################################################################


SEP=";"
CONF_DIR=/expl/conf/CFT
CONF_FLUX=${CONF_DIR}/CFT_FLUX.conf
xIDENTIFIANT=&idf
echo "Extraction des infos du fichier de config des flux" | tee -a "${LOG}"
export NEWPART=$(grep "${SEP}${xIDENTIFIANT}" ${CONF_FLUX} | grep -v "#" | cut -f2 -d"${SEP}")
xFNAME=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f11 -d"${SEP}")
export REP_SEND=$(dirname "${xFNAME}")


VERIF_FLAG()
{
# --------------------------------------------------------------------
# Test présence du FLAG bloquant envoi des fichiers chez SNCF
# --------------------------------------------------------------------
	export FLAG_OFF=/data/cft/flags/${NEWPART}/&idf_OFF

	echo "CFT-I-TST $(date +%H:%M:%S) Test Présence du Flag ${FLAG_OFF}"  | tee -a ${LOG}
	echo "---------------------------------------------------------------------------" | tee -a ${LOG}

	if [ -e ${FLAG_OFF} ];then
		FLAG_OFF
	else
		echo "le fichier ${FLAG_OFF} n'est pas présent, on continue ....." | tee -a ${LOG}
		echo "." | tee -a ${LOG}
		TRANSFERT
		echo "." | tee -a ${LOG}
    fi
}

TRANSFERT()
{
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	echo "$(date +%H:%M:%S) Envoi du fichier ${FICHIER} vers le partenaire CFT ${NEWPART}" | tee -a ${LOG}
	echo "." | tee -a ${LOG}


	/appli/cft/Transfer_CFT/runtime/profile.ksh
	echo "CFTUTIL send part=${NEWPART},idf=&idf,fname=${REP_SEND}/${FICHIER},parm=&nfname,nfname=&nfname" | tee -a ${LOG}
	CFTUTIL send part=${NEWPART},idf=&idf,fname=${REP_SEND}/${FICHIER},parm=&nfname,nfname=&nfname | tee -a ${LOG} 2>&1

	if [ $? -ne 0 ];then
		echo "ERREUR LORS DE LA SOUMISSION DU TRANSFERT CFT !" | tee -a ${LOG}
		export RETJOB=10
	else
		echo "Transfert CFT soumis correctement." | tee -a ${LOG}
		TST_ENVOI_MAIL
	fi

	echo "."  | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}

	FIN_JOB
}

# --------------------------------------------------------------------
# Absence du fichier de chargement de l'environnement d'exploitation
# --------------------------------------------------------------------

NO_PROFILE()
{
	echo "." | tee -a ${LOG}
	echo "[ERREUR] Fichier d'environnement non trouve dans le repertoire /expl/conf/" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
	export RETJOB=110
	FIN_JOB
}

# --------------------------------------------------------------------
# Aucun fichier trouve
# --------------------------------------------------------------------

NO_FILE()
{
	echo "." | tee -a ${LOG}
	echo "[ERREUR] Aucun fichier trouve dans le repertoire ${REP_SOURCE}" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
	export RETJOB=100
	FIN_JOB
}


# --------------------------------------------------------------------
# Envoi de mail si transfert OK
# --------------------------------------------------------------------

MAIL_OK()
{
	echo "$(date +%H:%M:%S) Envoi de mail" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	echo "Bonjour" > ${FIC_MAIL}
	echo "."| tee -a ${FIC_MAIL}
	echo "Le fichier ${FICHIER} vient d'être reçu par CFT du partenaire ${PART} ." | tee -a ${FIC_MAIL}
	echo "." | tee -a ${FIC_MAIL}
	echo "Cordialement"| tee -a ${FIC_MAIL}
	echo "BTO" | tee -a ${FIC_MAIL}
	echo "E-mail : LDBTO@rff.fr" | tee -a ${FIC_MAIL}
	echo "Tel. : 01 53 94 10 70" | tee -a ${FIC_MAIL}
	echo "."| tee -a ${FIC_MAIL}

	echo "CFT-I-MAILOK $(date +%H:%M:%S) Envoi de mail" | tee -a ${LOG}
	echo "." | tee -a ${LOG}

	cat ${FIC_MAIL} | mail -r ${MAIL_FROM} -c ${MAIL_CC} -s "[CFT - ${ENVIR}] : Reception via l'IDF &idf du fichier ${FICHIER}${SUBJECT}" ${MAIL_TO}  | tee -a ${LOG} 2>&1
	
	if [ $? -ne 0 ];then
		echo "ERREUR LORS DE L ENVOI DE MAIL !" | tee -a ${LOG}
	else
		echo "Mail envoye." | tee -a ${LOG}
		echo "."  | tee -a ${LOG}
	fi
	rm -f ${FIC_MAIL}
}
# --------------------------------------------------------------------
# Envoi de mail si transfert en erreur
# --------------------------------------------------------------------

MAIL_ERR()
{
	echo "$(date +%H:%M:%S) Envoi de mail" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	echo "Bonjour" > ${FIC_MAIL_ERR}
	echo "."| tee -a${FIC_MAIL_ERR}
	echo "Le fichier ${FICHIER} vient d'être reçu par CFT du partenaire ${PART} et n'a pas été ré-émis ." | tee -a ${FIC_MAIL_ERR}
	echo "." | tee -a ${FIC_MAIL_ERR}
	echo "Cordialement," | tee -a ${FIC_MAIL_ERR}
	echo "BTO" | tee -a ${FIC_MAIL_ERR}
	echo "E-mail : LDBTO@rff.fr" | tee -a ${FIC_MAIL_ERR}
	echo "Tel. : 01 53 94 10 70" | tee -a ${FIC_MAIL_ERR}
	echo "." | tee -a ${FIC_MAIL_ERR}
	# cat ${LOG} > ${FIC_MAIL}

	export SUBJECT="[CFT - ${ENVIR}] : Probleme lors de l'envoi du fichier ${FICHIER} vers le partenaire CFT ${NEWPART}!"

	cat ${FIC_MAIL_ERR} | mail -r ${MAIL_FROM} -c ${MAIL_CC} -s "${SUBJECT}" ${MAIL_TO}  | tee -a ${LOG} 2>&1

	if [ $? -ne 0 ];then
		echo "ERREUR LORS DE L ENVOI DE MAIL !" | tee -a ${LOG}
	else
		echo "Mail envoye." | tee -a ${LOG}
		echo "."  | tee -a ${LOG}
	fi
	rm -f ${FIC_MAIL}
}


# --------------------------------------------------------------------
# --------------------------- FIN DU JOB -----------------------------
# --------------------------------------------------------------------

FIN_JOB()
{
	if [[ ${RETJOB} -ne 0 ]];then
		MAIL_ERR
	fi
	echo "." | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	echo "$(date +%H:%M:%S) Fin de traitement - Code Retour : ${RETJOB}" | tee -a ${LOG}
	echo "-------------------------------------------------------------------------" | tee -a ${LOG}
	exit ${RETJOB}
}

# --------------------------------------------------------------------
# Absence du fichier de config. pour le fichier recu
# --------------------------------------------------------------------
NO_CONF()
{
	echo "." | tee -a ${LOG}
	echo "[ERREUR] Fichier de configuration &idf_CONF.ksh non trouve dans le repertoire ${EXP_D_CNF}/CFT" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
	export RETJOB=120
	FIN_JOB
}

# --------------------------------------------------------------------
# Fichier FLAG trouve
# --------------------------------------------------------------------
FLAG_OFF()
{
	echo "." | tee -a ${LOG}
	echo "$(date +%H:%M:%S) [INFO] Le flag ${FLAG_OFF} est présent." | tee -a ${LOG}
	echo "Le fichier ${FICHIER}  est présent dans le répertoire ${REP_SEND}" | tee -a ${LOG}
	echo "." | tee -a ${LOG}
	export RETJOB=0
	FIN_JOB
}

# --------------------------------------------------------------------
# Vérification si envoi mail
# --------------------------------------------------------------------
TST_ENVOI_MAIL()
{
	if [ ${ENVOI_MAIL} == "Y" ];then
		MAIL_OK
	else
		echo "Pas d'envoi de mail." | tee -a ${LOG}
	fi
}