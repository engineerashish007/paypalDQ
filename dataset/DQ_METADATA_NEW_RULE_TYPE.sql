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
-- Table structure for table `RULE_TYPE`
--

DROP TABLE IF EXISTS `RULE_TYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RULE_TYPE` (
  `ID` int(50) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `TEMPLATE_QUERY` varchar(6000) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `IMPLEMENTATION_NAME` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `DESCRIPTION` varchar(5000) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `CREATE_TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UPDATE_TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `UK_RULE_TYPE` (`NAME`(255))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RULE_TYPE`
--

LOCK TABLES `RULE_TYPE` WRITE;
/*!40000 ALTER TABLE `RULE_TYPE` DISABLE KEYS */;
INSERT INTO `RULE_TYPE` VALUES (1,'QC_FILE_CHECK',NULL,'QCFileValidation','This rule will kick off the QC File Validation based on the table on which the rule is applied.','2018-09-07 13:46:16','2018-09-07 13:46:16'),(2,'ORPHAN_RECORDS_CHECK_HQL_FILE','$$HQL_FILE_PATH$$','HQLFileLogicBasedValidation','This rule will read the Query from the HQL file configured and substitute the required placeholders before executing it. ','2018-09-07 13:46:16','2018-09-07 13:46:16'),(3,'ORPHAN_RECORDS_CHECK','SELECT COUNT(T.$$TARGET_COLUMN_NAME$$) FROM $$TARGET_DB_NAME$$.$$TARGET_TABLE_NAME$$ T WHERE NOT EXISTS ( SELECT S.$$SOURCE_COLUMN_NAME$$ FROM $$SOURCE_DB_NAME$$.$$SOURCE_TABLE_NAME$$ S   WHERE S.$$SOURCE_COLUMN_NAME$$ = T.$$TARGET_COLUMN_NAME$$ ) $$CONDITIONS$$','TargetSourceQueryValidation','This query will be executed on the database by substituting the TARGET details and SOURCE details. For Orphan records check rule, both the target and source tables must be available in the same Cluster/Database server.','2018-09-07 13:46:16','2018-09-07 13:46:16'),(4,'DUPLICATE_VALUE_CHECK','SELECT COUNT(1) FROM ( SELECT $$TARGET_COLUMN_NAME$$ , COUNT(1) FROM $$TARGET_DB_NAME$$.$$TARGET_TABLE_NAME$$ $$CONDITIONS$$ GROUP BY $$TARGET_COLUMN_NAME$$ HAVING COUNT(1)>1) TEMP ','TargetSourceQueryValidation','This rule primarily focuses on the DUPLICATE condition on a TARGET_FIELD. The query in the templateQuery field will be executed on the target table and validated for 0 result. If the result is non-zero, the validation will fail.','2018-09-07 13:46:16','2018-09-07 13:46:16'),(5,'NULL_VALUE_CHECK','SELECT COUNT(1) FROM $$TARGET_DB_NAME$$.$$TARGET_TABLE_NAME$$ WHERE $$TARGET_COLUMN_NAME$$ IS NULL $$CONDITIONS$$','TargetSourceQueryValidation','This rule primarily focuses on the NULL condition on a TARGET_FIELD. The query in the templateQuery field will be executed on the target table and validated for 0 result. If the result is non-zero, the validation will fail.','2018-09-07 13:46:16','2018-09-07 13:46:16'),(6,'NEW_VALUE_CHECK','SELECT COUNT(T.$$TARGET_COLUMN_NAME$$) FROM $$TARGET_DB_NAME$$.$$TARGET_TABLE_NAME$$ T LEFT JOIN $$REFERENCE_DB_NAME$$.$$REFERENCE_TABLE_NAME$$ R ON T.$$TARGET_COLUMN_NAME$$=R.$$REFERENCE_FIELD_NAME$$ WHERE $$REFERENCE_FIELD_NAME$$ IS NULL $$CONDITIONS$$','TargetSourceQueryValidation','This rule is for verifying if there are any new values in the target column. For this, a reference table is created to hold all the unique values of the target table column and the same is used to check if there are any new values. The query in the templateQuery has references to TARGET table and the REFERENCE table. Hence, the details of the REFERENCE table needs to be configured in the RULE_ASSIGNMENT_PARAMETER table correctly.','2018-09-07 13:46:16','2018-09-07 13:46:16'),(7,'DATA_CORRECTNESS_CHECK','SELECT COUNT($$TARGET_COLUMN_NAME$$) FROM $$TARGET_DB_NAME$$.$$TARGET_TABLE_NAME$$ $$CONDITIONS$$','TargetSourceQueryValidation','The query in the templateQuery field will be executed on the target table and validated for 0 result. If the result is non-zero, the validation will fail.','2018-09-07 13:46:16','2018-09-07 13:46:16'),(8,'CUSTOM_QUERY_CHECK','$$CUSTOM_QUERY$$','CustomQueryValidation','Given a custom query, the engine will execute the custom query and compares the result with the provided threshold in the RULE_TYPE_PARAMETER or RULE_ASSIGNMENT_PARAMETER','2018-09-07 13:46:16','2018-09-07 13:46:16'),(9,'TARGET_SOURCE_RESULT_COMPARISON','SELECT DISTINCT $$TARGET_COLUMN_NAME$$ FROM $$TARGET_DB_NAME$$.$$TARGET_TABLE_NAME$$ $$CONDITIONS$$','TargetSourceResultComparisonValidation','The source query and the target queries will be executed on respective databases and the results of both queries will be compared. If the results match, the validation will succeed. Else it fails. The rule expects 2 queries to be provided in the template_query separated by semi-colon. If the queries are not provided, the rule would try to look at the TARGET_SOURCE_QUERY_FILE_PATH parameter value and tries to execute the queries in the file. The file is expected to have 2 queries (TARGET, SOURCE)','2018-09-07 13:46:16','2018-09-07 13:46:16');
/*!40000 ALTER TABLE `RULE_TYPE` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-07 19:18:27
