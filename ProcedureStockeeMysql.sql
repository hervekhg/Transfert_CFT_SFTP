DROP PROCEDURE IF EXISTS ESPACE_PRETRAIT.CHARGT_PT_OAT_SEBAC_PRAC;
CREATE PROCEDURE ESPACE_PRETRAIT.`CHARGT_PT_OAT_SEBAC_PRAC`()
BEGIN

DROP TABLE IF EXISTS `ESPACE_PRETRAIT`.`SEBAC_PRAC`;
CREATE TABLE `ESPACE_PRETRAIT`.`SEBAC_PRAC` (
  `SEBAC_PTINDEX` VARCHAR(15) NOT NULL,
  `SEBAC_PRAC` VARCHAR(20) NOT NULL,
  `SEBAC_EXTREM` VARCHAR(20),
/*  PRIMARY KEY (`SEBAC_PTINDEX`),*/
  INDEX `IDX_PRAC` (`SEBAC_PRAC` ASC)
) ENGINE = MYISAM;
INSERT INTO `ESPACE_PRETRAIT`.`SEBAC_PRAC`
SELECT PTINDEX,
       CONCAT(SUBSTRING_INDEX(LOCATION,': ',-1),'/',REPLACE(DESCRIPTION,'-','.')) AS SEBAC_PRAC,
       M_EXTREMITYTYPE 
FROM `ESPACE_CHARGT`.`SEBAC_PORTTABLEIMP`,`ESPACE_CHARGT`.`SEBAC_PORTMAPPINGIMP` 
WHERE PTINDEX=M_PORTINDEX 
GROUP BY SEBAC_PRAC ORDER BY PTINDEX ;

DROP TABLE IF EXISTS `ESPACE_PRETRAIT`.`OAT_PRAC`;
CREATE TABLE `ESPACE_PRETRAIT`.`OAT_PRAC` (
  `OAT_PORT_INDEX` VARCHAR(15) NOT NULL,
  `OAT_PRAC` VARCHAR(20) NOT NULL,
  INDEX `IDX_PRAC` (`OAT_PRAC` ASC)
) ENGINE = MYISAM;
INSERT INTO `ESPACE_PRETRAIT`.`OAT_PRAC`
SELECT PORT_INDEX,PORT_NOM FROM `ESPACE_CHARGT`.`OAT_PRAC` WHERE PORT_DATE_SUPP IS NULL OR PORT_DATE_SUPP = '' ORDER BY PORT_INDEX;
END;