-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: 127.0.0.1    Database: DQ_METADATA_NEW
-- ------------------------------------------------------
-- Server version	5.7.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `RULE_ASSIGNMENT_PARAMETER`
--

DROP TABLE IF EXISTS `RULE_ASSIGNMENT_PARAMETER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RULE_ASSIGNMENT_PARAMETER` (
  `ID` int(50) NOT NULL AUTO_INCREMENT,
  `RULE_ASSIGNMENT_ID` int(50) NOT NULL,
  `RULE_TYPE_PARAMETER_ID` int(50) DEFAULT NULL,
  `VALUE` varchar(1000) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `CREATE_TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UPDATE_TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_RULE_PARAMETER` (`RULE_ASSIGNMENT_ID`,`RULE_TYPE_PARAMETER_ID`),
  KEY `RULE_TYPE_PARAMETER_ID` (`RULE_TYPE_PARAMETER_ID`),
  CONSTRAINT `rule_assignment_parameter_ibfk_1` FOREIGN KEY (`RULE_ASSIGNMENT_ID`) REFERENCES `RULE_ASSIGNMENT` (`ID`),
  CONSTRAINT `rule_assignment_parameter_ibfk_2` FOREIGN KEY (`RULE_TYPE_PARAMETER_ID`) REFERENCES `RULE_TYPE_PARAMETER` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RULE_ASSIGNMENT_PARAMETER`
--

LOCK TABLES `RULE_ASSIGNMENT_PARAMETER` WRITE;
/*!40000 ALTER TABLE `RULE_ASSIGNMENT_PARAMETER` DISABLE KEYS */;
INSERT INTO `RULE_ASSIGNMENT_PARAMETER` VALUES (1,1,1,'QC_$$SUBSIDIARY_NAME$$_$$DOMAIN_NAME$$_$$DATABASE_NAME$$_$$ENTITY_NAME$$_D_WHERE_$$DATA_DATE$$_*_dly*','2018-09-07 13:46:16','2018-09-07 13:46:16'),(2,2,14,'ID','2018-09-07 13:46:16','2018-09-07 13:46:16'),(3,3,18,'ID','2018-09-07 13:46:16','2018-09-07 13:46:16'),(4,4,2,'/Users/vijaydatla/Downloads/DQFramework/qc/qc_queries.hql','2018-09-07 13:46:16','2018-09-07 13:46:16'),(5,5,26,'SELECT COUNT(1) FROM ( SELECT $$TARGET_COLUMN_NAME$$ , COUNT(1) FROM $$TARGET_DB_NAME$$.$$TARGET_TABLE_NAME$$ WHERE $$TARGET_COLUMN_NAME$$ = 100 GROUP BY $$TARGET_COLUMN_NAME$$ HAVING COUNT(1)>1) TEMP','2018-09-07 13:46:16','2018-09-07 13:46:16'),(6,6,28,'SELECT DISTINCT $$SOURCE_COLUMN_NAME$$ FROM $$SOURCE_DB_NAME$$.$$SOURCE_TABLE_NAME$$ $$CONDITIONS$$','2018-09-07 13:46:16','2018-09-07 13:46:16');
/*!40000 ALTER TABLE `RULE_ASSIGNMENT_PARAMETER` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-07 19:18:28
