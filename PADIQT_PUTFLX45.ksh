#!/usr/bin/ksh
# --------------------------------------------------------------------------------
# Nom         : /expl/scripts/PADI/PADIQT_MOVFLX45.ksh
# Auteur      : BV - BTA
# Date        : 20/05/2014
# Version     : 1.0
#
# Application : Application PADI 
#
# Resume      : Ventilation CFT/ADI - Flux 45
#
# Description : - Chargement du Profile d'exploitation pour chargement
#                 des variables globales.
#
#               - Initialisation de la trace.
#
#               - Definition des Variables locales.
#
#               - Controle de la definition des variables globales.
#                
#               - Transfert de fichiers pdf via SFTP
#
#
# Entrées     : /expl/conf/profile.env.ksh
#               Fichier de définition de l'environnement d'exploitation. Il définit
#               les variables globales :
#
#      
#
# Codes Retour: 0   - Success
#               10  - Erreur  - Aucun fichier a traiter
#               20  - Erreur  - Erreur commande move
#               100 - Fatal   - Profile d'exploitation inexistant.
#               120 - Fatal   - Variable globale non definie
#
# --------------------------------------------------------------------------------

# ################################################################################
#                                  INITIALISATION
# ################################################################################


  # --------------------------------------------------------------------
  # Récupération des informations dans le fichier de configuration des flux
  # --------------------------------------------------------------------
  
  export Profile=/expl/conf/pad/profile.env.ksh # Profil spécifique au flux

  FLAG_FLUX=""
  SEP=";"
  CONF_DIR=/expl/conf/CFT
  CONF_FLUX=${CONF_DIR}/CFT_FLUX.conf

  if [[ ! -e ${CONF_FLUX} ]];then
    NO_CONF_FLUX
  fi

  xIDENTIFIANT=${IDF}
  echo "Extraction des infos du fichier de config des flux" | tee -a "${EXP_F_LOG}"

  xFNAME=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f11 -d"${SEP}")
  xDATA_DIR=$(dirname "${xFNAME}")

  xCIBLE_HOST=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f20 -d"${SEP}")
  xCIBLE_USER=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f22 -d"${SEP}")
  xCIBLE_PWD=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f23 -d"${SEP}")
  xCIBLE_DIR=$(grep "${SEP}${xIDENTIFIANT}${SEP}" ${CONF_FLUX} | grep -v "#" | cut -f24 -d"${SEP}")
 


Fct_End_Job()
{
  export H_Fin=$(date +%H:%M:%S)
  export Sever=S

  if [[ $RetJob -ne 0 ]];then
      export Sever=E
  fi

  if [[ $RetJob -ge 99 ]];then
      export Sever=F
  fi

  if [[ $RetJob -lt 0 ]];then
      export Sever=F
  fi

  echo "." | tee -a ${EXP_F_LOG}
  echo "--------------------------------------------------------------------------------" | tee -a ${EXP_F_LOG}
  echo "${EXP_J_CTEC}-${Sever}-STP, ${H_Fin} - Fin Ventilation ${EXP_D_TMP}/*.pdf - ${RetJob}" | tee -a ${EXP_F_LOG}
  echo "--------------------------------------------------------------------------------" | tee -a ${EXP_F_LOG}

  FCT_LOGEXP {Sever} Fin Ventilation ${EXP_D_TMP}/*.pdf - ${RetJob}

  if [[ -e ${EXP_F_TMP} ]];then
     rm -f ${EXP_F_TMP}
  fi

  if [[ -e ${EXP_F_LOG} ]];then
     cat ${EXP_F_LOG}
  fi

  if [[ $Sever != "S" ]];then
    ${FCT_SNDMAIL} ${Sever} ${RetJob} Erreur Ventilation Flux 45 - ${APP_F_RCV_45}
  fi
  
  exit ${RetJob}
}

# --------------------------------------------------------------------
# Variable non définie dans le profile d'exploitation applicatif.
# --------------------------------------------------------------------

Fct_Bad_Var()
{
  
   echo "."  | tee -a ${EXP_F_LOG}
   echo "${EXP_J_CTEC}-F-${EXP_J_TYTR}, Variable globale non definie"  | tee -a ${EXP_F_LOG}
   echo "${EXP_J_CTEC}-I-${EXP_J_TYTR}, Controler le fichier ${EXP_D_CNF}/profile.env.ksh"  | tee -a ${EXP_F_LOG}
   echo "${EXP_J_CTEC}-I-${EXP_J_TYTR}, Variable EXP_D_TMP" | tee -a ${EXP_F_LOG}
   echo "."  | tee -a ${EXP_F_LOG}
   export  RetJob=120
   Fct_End_Job
}
  
# ################################################################################
#                                     ROUTINES
# ################################################################################

# --------------------------------------------------------------------
# Chargement de l'environnement d'exploitation
# --------------------------------------------------------------------

Fct_Load_Env()
{

  Job="$(basename $0)"
  export Job="${Job%.*}"

  export H_Deb=$(date +%H:%M:%S)
  export EXP_F_LOG=/logs/expl/${Job}.err
  export Profile=/expl/conf/profile.env.ksh

  if [ -n ${Profile} ];then
      ${Profile} ${Job}
  else
      echo "."  | tee -a ${EXP_F_LOG}
      echo "FIC-F-CNF, Fichier Environnement ${Profile} inexistant"  | tee -a ${EXP_F_LOG}
      echo "FIC-I-STR, Lancement impossible du traitement ${Job}" | tee -a ${EXP_F_LOG}
      echo "."  | tee -a ${EXP_F_LOG}

      export RetJob=100
      Fct_End_Job
  fi

  Fct_End_Job

}

# --------------------------------------------------------------------
# initialisation de la trace d'exploitation
# --------------------------------------------------------------------
Fct_Open_Log()
{
  echo "." | tee -a ${EXP_F_LOG}
  echo "--------------------------------------------------------------------------------" | tee -a ${EXP_F_LOG}
  echo "${EXP_J_CTEC}-I-STR, ${H_Deb} - Debut Ventilation ${EXP_D_TMP}/*.pdf" | tee -a ${EXP_F_LOG}
  echo "--------------------------------------------------------------------------------" | tee -a ${EXP_F_LOG}

  FCT_LOGEXP I Debut Ventilation ${EXP_D_TMP}/*.pdf
  
}


FCT_LOGEXP()
{
  Severity=$1
  shift
  Message=$*

  echo "$(hostname) - ${EXP_JOUR} - $(date +%H:%M:%S) - ${Severity} - ${UTGS} - ${EXP_J_CTEC} - ${EXP_J_NAME} - ${Message}" | tee -a ${EXP_F_LOGEXP}
}


Fct_File_Trf()
{  

  export Msg=OK
  export Svr=S

  echo "." | tee -a ${EXP_F_LOG}
  echo "${EXP_J_CTEC}-I-${EXP_J_TYTR}, Transfert ${xDATA_DIR}/${FilNam} vers ${xCIBLE_DIR}" | tee -a ${EXP_F_LOG} 

  #  Copie du fichier vers le serveur
  (echo progress; echo put "${xDATA_DIR}/${FilNam} ${xCIBLE_DIR}"; echo quit) | sshpass -p "${xCIBLE_PWD}" sftp -v ${xCIBLE_USER}@${xCIBLE_HOST} 2>&1| tee -a  ${EXP_F_LOG}

  RetJob=$?
  if [ $RetJob != 0 ];then
      export RetJob=60
      echo "\n${EXP_J_CTEC}-E-${EXP_J_TYTR}, Erreur liee a la commande d envoi sftp put" | tee -a  ${EXP_F_LOG} 
      Fct_End_Job 
  else
      grep "No such file or directory" ${EXP_F_LOG} >/dev/null
      RetJob=$?

      if [ $RetJob != 0 ];then
        echo "pas d erreur de type No such" | tee -a ${EXP_F_LOG}
      else
        export RetJob=15
        export Msg=ERREUR
        export Svr=E
        echo "\n${EXP_J_CTEC}-E-${EXP_J_TYTR}, Erreur liee au fichier source ou repertoire cible" | tee -a  ${EXP_F_LOG} 
      fi
  fi
}

NO_CONF_FLUX()
{
  echo "." | tee -a ${EXP_F_LOG}
  echo "[ERREUR] Fichier de configuration CFT_FLUX.conf non trouve dans le repertoire ${CONF_DIR}" | tee -a ${LOG}
  echo "." | tee -a ${EXP_F_LOG}
  export RetJob=120
  Fct_End_Job
}





# --------------------------------------------------------------------
  # Chargement du Profile d'exploitation
  # --------------------------------------------------------------------

  Fct_Load_Env

  # --------------------------------------------------------------------
  # Creation des traces d'exploitations
  # --------------------------------------------------------------------

  Fct_Open_Log

# ################################################################################
#                                    PROCEDURE
# ################################################################################

  # --------------------------------------------------------------------
  # Controle des variables globales
  # --------------------------------------------------------------------

  if [[ ! -n ${EXP_D_TMP} ]];then
    Fct_Bad_Var
  fi

  # --------------------------------------------------------------------
  # Definition de Variables
  # --------------------------------------------------------------------

  export RetJob=0
  
# ################################################################################
#                                    PROCEDURE
# ################################################################################

# --------------------------------------------------------------------
# Pour chaque fichier PDF trouvé dans le répertoire ${EXP_D_TMP} :
# 
#     . Détermination du répertoire Cible
#     . Déplacement du fichier vers répertoire cible
#
# --------------------------------------------------------------------

  echo "." | tee -a ${EXP_F_LOG}  
  
  for file in $(ls -1 ${EXP_D_TMP}/*.pdf);do

      export FilNam=file
      # # export SsRep=
      # export Svr=S
      # export Msg=OK

      # Prefixe=$(echo $FilNam | awk -F'_' '{echo $2}')
      # Type=$(echo $Prefixe | awk -F' ' '{echo $1}')
      # SsRep=$(echo $APP_D_45_$Type | awk -F'=,' '{echo $2}') # A Confirmer

      # if [[ ! -n $SsRep ]];then
      #   export SsRep=${APP_D_45_OTHER}
      # fi

      Fct_File_Trf

      # echo "${EXP_J_CTEC}-I-${EXP_J_TYTR}, Fichier ${FilNam}, Type ${Type}, Cible ${SsRep}" | tee -a ${EXP_F_LOG}
      # mv "${EXP_D_TMP}/${FilNam}" "${SsRep}/" | tee -a ${EXP_F_LOG} 

      # if [[ $? -ne 0 ]];then
      #   export Msg="ERREUR"
      #   export Svr="E"
      #   export RetJob=10
      # fi

      # echo "${EXP_J_CTEC}-${Svr}-${EXP_J_TYTR}, Deplacement ${Msg}" | tee -a ${EXP_F_LOG}
      # echo "." | tee -a ${EXP_F_LOG}

      # FCT_LOGEXP ${Svr} Ventilation ${FilNam} dans ${SsRep} - ${Msg}
    
  done
  
  
# --------------------------------------------------------------------
# Fin de Script 
# --------------------------------------------------------------------