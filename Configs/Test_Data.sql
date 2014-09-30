-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sudoers
-- ------------------------------------------------------
-- Server version	5.1.73

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
-- Current Database: `sudoers`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sudoers` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `sudoers`;

--
-- Table structure for table `command_groups`
--

DROP TABLE IF EXISTS `command_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `command_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupname` varchar(128) NOT NULL,
  `expires` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `groupname_UNIQUE` (`groupname`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_groups`
--

LOCK TABLES `command_groups` WRITE;
/*!40000 ALTER TABLE `command_groups` DISABLE KEYS */;
INSERT INTO `command_groups` VALUES (1,'HTTPServiceControl','0000-00-00',1,'2014-09-23 05:15:06','Ben Schofield'),(2,'MySQLServiceControl','0000-00-00',1,'2014-09-23 05:15:19','Ben Schofield');
/*!40000 ALTER TABLE `command_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commands`
--

DROP TABLE IF EXISTS `commands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command_alias` varchar(128) NOT NULL,
  `command` varchar(1000) NOT NULL,
  `expires` date NOT NULL,
  `active` int(1) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `command_alias_UNIQUE` (`command_alias`),
  UNIQUE KEY `command_UNIQUE` (`command`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commands`
--

LOCK TABLES `commands` WRITE;
/*!40000 ALTER TABLE `commands` DISABLE KEYS */;
INSERT INTO `commands` VALUES (1,'HTTPStart','/sbin/service httpd start','0000-00-00',1,'2014-09-23 05:12:00','Ben Schofield'),(2,'HTTPStop','/sbin/service httpd stop','0000-00-00',1,'2014-09-23 05:12:11','Ben Schofield'),(3,'HTTPRestart','/sbin/service httpd restart','0000-00-00',1,'2014-09-23 05:12:31','Ben Schofield'),(4,'MySQLStart','/sbin/service mysqld start','2014-09-23',1,'2014-09-23 05:13:02','Ben Schofield'),(5,'MySQLStop','/sbin/service mysqld stop','0000-00-00',1,'2014-09-23 05:13:14','Ben Schofield'),(6,'MySQLRestart','/sbin/service mysqld restart','0000-00-00',0,'2014-09-23 05:13:27','Ben Schofield');
/*!40000 ALTER TABLE `commands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_groups`
--

DROP TABLE IF EXISTS `host_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupname` varchar(128) NOT NULL,
  `expires` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `groupname_UNIQUE` (`groupname`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_groups`
--

LOCK TABLES `host_groups` WRITE;
/*!40000 ALTER TABLE `host_groups` DISABLE KEYS */;
INSERT INTO `host_groups` VALUES (1,'ProdTestHosts','0000-00-00',1,'2014-09-23 05:13:54','Ben Schofield'),(2,'ProdAppHosts','0000-00-00',1,'2014-09-23 05:14:11','Ben Schofield');
/*!40000 ALTER TABLE `host_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hosts`
--

DROP TABLE IF EXISTS `hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(128) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `expires` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `ip_UNIQUE` (`ip`),
  UNIQUE KEY `hostname_UNIQUE` (`hostname`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosts`
--

LOCK TABLES `hosts` WRITE;
/*!40000 ALTER TABLE `hosts` DISABLE KEYS */;
INSERT INTO `hosts` VALUES (1,'wlgprdtst01','127.0.0.1','0000-00-00',1,'2014-09-30 02:12:45','Ben Schofield'),(2,'wlgprdtst02','127.0.0.2','0000-00-00',1,'2014-09-30 02:12:45','Ben Schofield'),(3,'wlgprdtst03','127.0.0.3','0000-00-00',0,'2014-09-30 02:12:45','Ben Schofield'),(4,'wlgprdtst04','127.0.0.4','2014-09-23',1,'2014-09-30 02:12:45','Ben Schofield'),(5,'wlgprdapp01','127.0.1.1','0000-00-00',1,'2014-09-30 02:12:45','Ben Schofield'),(6,'wlgprdapp02','127.0.1.2','0000-00-00',1,'2014-09-30 02:12:45','Ben Schofield'),(7,'wlgprdapp03','127.0.1.3','0000-00-00',1,'2014-09-30 02:12:45','Ben Schofield'),(8,'wlgprdapp04','127.0.1.4','0000-00-00',1,'2014-09-30 02:12:45','Ben Schofield');
/*!40000 ALTER TABLE `hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_command_groups_to_commands`
--

DROP TABLE IF EXISTS `lnk_command_groups_to_commands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_command_groups_to_commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` int(11) NOT NULL,
  `command` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_command_groups_to_commands`
--

LOCK TABLES `lnk_command_groups_to_commands` WRITE;
/*!40000 ALTER TABLE `lnk_command_groups_to_commands` DISABLE KEYS */;
INSERT INTO `lnk_command_groups_to_commands` VALUES (1,1,3),(2,1,1),(3,1,2),(4,2,6),(5,2,4),(6,2,5);
/*!40000 ALTER TABLE `lnk_command_groups_to_commands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_host_groups_to_hosts`
--

DROP TABLE IF EXISTS `lnk_host_groups_to_hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_host_groups_to_hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` int(11) NOT NULL,
  `host` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_host_groups_to_hosts`
--

LOCK TABLES `lnk_host_groups_to_hosts` WRITE;
/*!40000 ALTER TABLE `lnk_host_groups_to_hosts` DISABLE KEYS */;
INSERT INTO `lnk_host_groups_to_hosts` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,2,5),(6,2,6),(7,2,7),(8,2,8);
/*!40000 ALTER TABLE `lnk_host_groups_to_hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_rules_to_command_groups`
--

DROP TABLE IF EXISTS `lnk_rules_to_command_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_rules_to_command_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule` int(11) NOT NULL,
  `command_group` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_command_groups`
--

LOCK TABLES `lnk_rules_to_command_groups` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_command_groups` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_command_groups` VALUES (1,1,1),(2,2,2);
/*!40000 ALTER TABLE `lnk_rules_to_command_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_rules_to_commands`
--

DROP TABLE IF EXISTS `lnk_rules_to_commands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_rules_to_commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule` int(11) NOT NULL,
  `command` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_commands`
--

LOCK TABLES `lnk_rules_to_commands` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_commands` DISABLE KEYS */;
/*!40000 ALTER TABLE `lnk_rules_to_commands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_rules_to_host_groups`
--

DROP TABLE IF EXISTS `lnk_rules_to_host_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_rules_to_host_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule` int(11) NOT NULL,
  `host_group` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_host_groups`
--

LOCK TABLES `lnk_rules_to_host_groups` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_host_groups` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_host_groups` VALUES (1,1,1),(2,2,2),(3,2,1);
/*!40000 ALTER TABLE `lnk_rules_to_host_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_rules_to_hosts`
--

DROP TABLE IF EXISTS `lnk_rules_to_hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_rules_to_hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule` int(11) NOT NULL,
  `host` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_hosts`
--

LOCK TABLES `lnk_rules_to_hosts` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_hosts` DISABLE KEYS */;
/*!40000 ALTER TABLE `lnk_rules_to_hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_rules_to_user_groups`
--

DROP TABLE IF EXISTS `lnk_rules_to_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_rules_to_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule` int(11) NOT NULL,
  `user_group` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_user_groups`
--

LOCK TABLES `lnk_rules_to_user_groups` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_user_groups` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_user_groups` VALUES (1,1,1),(2,2,2);
/*!40000 ALTER TABLE `lnk_rules_to_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_rules_to_users`
--

DROP TABLE IF EXISTS `lnk_rules_to_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_rules_to_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_users`
--

LOCK TABLES `lnk_rules_to_users` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_users` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_users` VALUES (1,2,1),(2,2,3);
/*!40000 ALTER TABLE `lnk_rules_to_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lnk_user_groups_to_users`
--

DROP TABLE IF EXISTS `lnk_user_groups_to_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnk_user_groups_to_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_user_groups_to_users`
--

LOCK TABLES `lnk_user_groups_to_users` WRITE;
/*!40000 ALTER TABLE `lnk_user_groups_to_users` DISABLE KEYS */;
INSERT INTO `lnk_user_groups_to_users` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,2,5),(6,2,6),(7,2,7);
/*!40000 ALTER TABLE `lnk_user_groups_to_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rules`
--

DROP TABLE IF EXISTS `rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `run_as` varchar(128) NOT NULL,
  `nopasswd` int(1) NOT NULL DEFAULT '0',
  `noexec` int(1) NOT NULL DEFAULT '1',
  `expires` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `approved` int(1) NOT NULL DEFAULT '0',
  `last_approved` datetime NOT NULL,
  `approved_by` varchar(128) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rules`
--

LOCK TABLES `rules` WRITE;
/*!40000 ALTER TABLE `rules` DISABLE KEYS */;
INSERT INTO `rules` VALUES (1,'ApacheControl','root',0,1,'0000-00-00',1,1,'2014-09-23 17:18:31','Rodney Apple','2014-09-23 05:16:47','Ben Schofield'),(2,'MySQLControl','root',0,1,'0000-00-00',1,1,'2014-09-23 17:18:33','Rodney Apple','2014-09-23 05:17:27','Ben Schofield');
/*!40000 ALTER TABLE `rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupname` varchar(128) NOT NULL,
  `expires` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `groupname_UNIQUE` (`groupname`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_groups`
--

LOCK TABLES `user_groups` WRITE;
/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
INSERT INTO `user_groups` VALUES (1,'UnixGroup','0000-00-00',1,'2014-09-23 05:14:31','Ben Schofield'),(2,'DBAGroup','0000-00-00',1,'2014-09-23 05:14:42','Ben Schofield');
/*!40000 ALTER TABLE `user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `expires` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'UnixUser1','0000-00-00',1,'2014-09-23 05:10:48','Ben Schofield'),(2,'UnixUser2','0000-00-00',1,'2014-09-23 05:10:52','Ben Schofield'),(3,'UnixUser3','2014-09-23',1,'2014-09-23 05:11:00','Ben Schofield'),(4,'UnixUser4','0000-00-00',1,'2014-09-23 05:11:05','Ben Schofield'),(5,'DBAUser1','0000-00-00',1,'2014-09-23 05:11:12','Ben Schofield'),(6,'DBAUser2','0000-00-00',0,'2014-09-23 05:11:19','Ben Schofield'),(7,'DBAUser3','2014-09-23',1,'2014-09-23 05:11:27','Ben Schofield');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `Management`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `Management` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `Management`;

--
-- Table structure for table `access_log`
--

DROP TABLE IF EXISTS `access_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `access_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `ip` varchar(15) NOT NULL,
  `hostname` varchar(30) DEFAULT NULL,
  `user_agent` varchar(128) DEFAULT NULL,
  `script` varchar(128) DEFAULT NULL,
  `referer` varchar(128) DEFAULT NULL,
  `query` varchar(128) DEFAULT NULL,
  `request_method` varchar(128) DEFAULT NULL,
  `https` varchar(3) NOT NULL,
  `server_name` varchar(128) DEFAULT NULL,
  `server_port` varchar(128) DEFAULT NULL,
  `username` varchar(128) DEFAULT NULL,
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=129 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log`
--

LOCK TABLES `access_log` WRITE;
/*!40000 ALTER TABLE `access_log` DISABLE KEYS */;
INSERT INTO `access_log` VALUES (1,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/index.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:04:31'),(2,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/index.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:04:38'),(3,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./index.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:06:50'),(4,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/access-log.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:07:03'),(5,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/audit-log.cgi','https://udm-sudoers-01.alabs./access-log.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:07:05'),(6,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./audit-log.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:07:30'),(7,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:07:32'),(8,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-09-23 17:07:47'),(9,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:07:52'),(10,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:07:56'),(11,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:07:58'),(12,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:08:15'),(13,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:08:16'),(14,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:08:24'),(15,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:08:25'),(16,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:08:38'),(17,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:08:39'),(18,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:08:52'),(19,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:09:40'),(20,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:12'),(21,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:13'),(22,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:20'),(23,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:21'),(24,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:29'),(25,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:31'),(26,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:39'),(27,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:41'),(28,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:42'),(29,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:48'),(30,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:49'),(31,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:53'),(32,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:10:54'),(33,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:00'),(34,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:01'),(35,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:05'),(36,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:07'),(37,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:12'),(38,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:14'),(39,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:19'),(40,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:20'),(41,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:27'),(42,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:31'),(43,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:11:32'),(44,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:12:01'),(45,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:12:02'),(46,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:12:11'),(47,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:12:12'),(48,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:12:31'),(49,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:12:35'),(50,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:02'),(51,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:03'),(52,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:14'),(53,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:15'),(54,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:27'),(55,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:31'),(56,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:33'),(57,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:45'),(58,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:47'),(59,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:49'),(60,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:50'),(61,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:52'),(62,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:54'),(63,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:55'),(64,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:13:59'),(65,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:06'),(66,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:08'),(67,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:10'),(68,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:11'),(69,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:14'),(70,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:16'),(71,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:25'),(72,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:26'),(73,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:28'),(74,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:29'),(75,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:30'),(76,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:31'),(77,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:33'),(78,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:39'),(79,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:40'),(80,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:41'),(81,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:42'),(82,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:44'),(83,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:46'),(84,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:52'),(85,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:54'),(86,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:14:55'),(87,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:06'),(88,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:07'),(89,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:15'),(90,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:16'),(91,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:17'),(92,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:19'),(93,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:23'),(94,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:25'),(95,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:28'),(96,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:33'),(97,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:35'),(98,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:15:52'),(99,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:16:32'),(100,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:16:36'),(101,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:16:47'),(102,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:16:49'),(103,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:16:59'),(104,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:02'),(105,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:06'),(106,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:10'),(107,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:13'),(108,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:15'),(109,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:27'),(110,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:54'),(111,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:17:55'),(112,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-09-23 17:18:17'),(113,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/index.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-09-23 17:18:26'),(114,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./index.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-09-23 17:18:29'),(115,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-09-23 17:18:31'),(116,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-09-23 17:18:33'),(117,'172.17.152.137','','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36','/index.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-09-23 17:19:03'),(118,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/distribution-status.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:10:07'),(119,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:10:12'),(120,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:10:31'),(121,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:10:33'),(122,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:13:32'),(123,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/distribution-status.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:13:40'),(124,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:13:43'),(125,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/distribution-status.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:13:47'),(126,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:13:52'),(127,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:14:51'),(128,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-09-30 15:17:01');
/*!40000 ALTER TABLE `access_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `method` varchar(45) NOT NULL,
  `action` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `username` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=62 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,'Account Management','View','admin accessed Account Management.','2014-09-23 05:06:50','admin'),(2,'Access Log','View','admin accessed the Access Log.','2014-09-23 05:07:03','admin'),(3,'Audit Log','View','admin accessed the Audit Log.','2014-09-23 05:07:05','admin'),(4,'Account Management','View','admin accessed Account Management.','2014-09-23 05:07:30','admin'),(5,'Account Management','View','admin accessed Account Management.','2014-09-23 05:07:32','admin'),(6,'Account Management','Add','admin added a new system account as Account ID 2: Ben Schofield (ben@nwk1.com). Ben Schofield has Admin Privileges, Ben Schofield can Approve the Rules created by others, Ben Schofield\'s Rules require approval and Ben Schofield is not locked out.','2014-09-23 05:07:46','admin'),(7,'Account Management','View','admin accessed Account Management.','2014-09-23 05:07:47','admin'),(8,'Account Management','View','Ben Schofield accessed Account Management.','2014-09-23 05:07:52','Ben Schofield'),(9,'Hosts','Add','Ben Schofield added wlgprdtst01 (192.168.1.11), set it Active and to not expire. The system assigned it Host ID 1.','2014-09-23 05:08:15','Ben Schofield'),(10,'Hosts','Add','Ben Schofield added wlgprdtst02 (192.168.1.12), set it Active and to not expire. The system assigned it Host ID 2.','2014-09-23 05:08:24','Ben Schofield'),(11,'Hosts','Add','Ben Schofield added wlgprdtst03 (192.168.1.13), set it Inactive and to not expire. The system assigned it Host ID 3.','2014-09-23 05:08:38','Ben Schofield'),(12,'Hosts','Add','Ben Schofield added wlgprdtst04 (192.168.1.14), set it Active and to expire on 2014-09-23. The system assigned it Host ID 4.','2014-09-23 05:08:52','Ben Schofield'),(13,'Hosts','Add','Ben Schofield added wlgprdapp01 (192.168.2.11), set it Active and to not expire. The system assigned it Host ID 5.','2014-09-23 05:10:12','Ben Schofield'),(14,'Hosts','Add','Ben Schofield added wlgprdapp02 (192.168.2.12), set it Active and to not expire. The system assigned it Host ID 6.','2014-09-23 05:10:20','Ben Schofield'),(15,'Hosts','Add','Ben Schofield added wlgprdapp03 (192.168.2.13), set it Active and to not expire. The system assigned it Host ID 7.','2014-09-23 05:10:29','Ben Schofield'),(16,'Hosts','Add','Ben Schofield added wlgprdapp04 (192.168.2.14), set it Active and to not expire. The system assigned it Host ID 8.','2014-09-23 05:10:39','Ben Schofield'),(17,'Users','Add','Ben Schofield added UnixUser1, set it Active and to not expire. The system assigned it User ID 1.','2014-09-23 05:10:48','Ben Schofield'),(18,'Users','Add','Ben Schofield added UnixUser2, set it Active and to not expire. The system assigned it User ID 2.','2014-09-23 05:10:52','Ben Schofield'),(19,'Users','Add','Ben Schofield added UnixUser3, set it Active and to expire on 2014-09-23. The system assigned it User ID 3.','2014-09-23 05:11:00','Ben Schofield'),(20,'Users','Add','Ben Schofield added UnixUser4, set it Active and to not expire. The system assigned it User ID 4.','2014-09-23 05:11:05','Ben Schofield'),(21,'Users','Add','Ben Schofield added DBAUser1, set it Active and to not expire. The system assigned it User ID 5.','2014-09-23 05:11:12','Ben Schofield'),(22,'Users','Add','Ben Schofield added DBAUser2, set it Inactive and to not expire. The system assigned it User ID 6.','2014-09-23 05:11:19','Ben Schofield'),(23,'Users','Add','Ben Schofield added DBAUser3, set it Active and to expire on 2014-09-23. The system assigned it User ID 7.','2014-09-23 05:11:27','Ben Schofield'),(24,'Commands','Add','Ben Schofield added HTTPStart (/sbin/service httpd start), set it Active and to not expire. The system assigned it Command ID 1.','2014-09-23 05:12:00','Ben Schofield'),(25,'Commands','Add','Ben Schofield added HTTPStop (/sbin/service httpd stop), set it Active and to not expire. The system assigned it Command ID 2.','2014-09-23 05:12:11','Ben Schofield'),(26,'Commands','Add','Ben Schofield added HTTPRestart (/sbin/service httpd restart), set it Active and to not expire. The system assigned it Command ID 3.','2014-09-23 05:12:31','Ben Schofield'),(27,'Commands','Add','Ben Schofield added MySQLStart (/sbin/service mysqld start), set it Active and to expire on 2014-09-23. The system assigned it Command ID 4.','2014-09-23 05:13:02','Ben Schofield'),(28,'Commands','Add','Ben Schofield added MySQLStop (/sbin/service mysqld stop), set it Active and to not expire. The system assigned it Command ID 5.','2014-09-23 05:13:14','Ben Schofield'),(29,'Commands','Add','Ben Schofield added MySQLRestart (/sbin/service mysqld restart), set it Inactive and to not expire. The system assigned it Command ID 6.','2014-09-23 05:13:27','Ben Schofield'),(30,'Host Groups','Add','Ben Schofield added ProdTestHosts, set it Active and to not expire. 4 hosts were attached: wlgprdtst04, wlgprdtst03, wlgprdtst02, wlgprdtst01. The system assigned it Host Group ID 1.','2014-09-23 05:13:54','Ben Schofield'),(31,'Host Groups','Add','Ben Schofield added ProdAppHosts, set it Active and to not expire. 4 hosts were attached: wlgprdapp04, wlgprdapp03, wlgprdapp02, wlgprdapp01. The system assigned it Host Group ID 2.','2014-09-23 05:14:11','Ben Schofield'),(32,'User Groups','Add','Ben Schofield added UnixGroup, set it Active and to not expire. 4 users were attached: UnixUser4, UnixUser3, UnixUser2, UnixUser1. The system assigned it User Group ID 1.','2014-09-23 05:14:31','Ben Schofield'),(33,'User Groups','Add','Ben Schofield added DBAGroup, set it Active and to not expire. 3 users were attached: DBAUser3, DBAUser2, DBAUser1. The system assigned it User Group ID 2.','2014-09-23 05:14:42','Ben Schofield'),(34,'Command Groups','Add','Ben Schofield added HTTPServiceControl, set it Active and to not expire. 3 commands were attached: HTTPStop, HTTPStart, HTTPRestart. The system assigned it Command Group ID 1.','2014-09-23 05:15:06','Ben Schofield'),(35,'Command Groups','Add','Ben Schofield added MySQLServiceControl, set it Active and to not expire. 3 commands were attached: MySQLStop, MySQLStart, MySQLRestart. The system assigned it Command Group ID 2.','2014-09-23 05:15:19','Ben Schofield'),(36,'Rules','Add','Ben Schofield added ApacheControl (to be run as root, with the PASSWD and NOEXEC flags), set it Active and to not expire. The system assigned it Rule ID 1.','2014-09-23 05:16:47','Ben Schofield'),(37,'Rules','Modify','Ben Schofield added Host Group ProdTestHosts [Host Group ID 1] to Rule ApacheControl [Rule ID 1]','2014-09-23 05:16:47','Ben Schofield'),(38,'Rules','Modify','Ben Schofield added User Group UnixGroup [User Group ID 1] to Rule ApacheControl [Rule ID 1]','2014-09-23 05:16:47','Ben Schofield'),(39,'Rules','Modify','Ben Schofield added Command Group HTTPServiceControl [Command Group ID 1] to Rule ApacheControl [Rule ID 1]','2014-09-23 05:16:47','Ben Schofield'),(40,'Rules','Add','Ben Schofield added MySQLControl (to be run as root, with the PASSWD and NOEXEC flags), set it Active and to not expire. The system assigned it Rule ID 2.','2014-09-23 05:17:27','Ben Schofield'),(41,'Rules','Modify','Ben Schofield added Host Group ProdAppHosts [Host Group ID 2] to Rule MySQLControl [Rule ID 2]','2014-09-23 05:17:27','Ben Schofield'),(42,'Rules','Modify','Ben Schofield added Host Group ProdTestHosts [Host Group ID 1] to Rule MySQLControl [Rule ID 2]','2014-09-23 05:17:27','Ben Schofield'),(43,'Rules','Modify','Ben Schofield added User Group DBAGroup [User Group ID 2] to Rule MySQLControl [Rule ID 2]','2014-09-23 05:17:27','Ben Schofield'),(44,'Rules','Modify','Ben Schofield added User UnixUser1 [User ID 1] to Rule MySQLControl [Rule ID 2]','2014-09-23 05:17:27','Ben Schofield'),(45,'Rules','Modify','Ben Schofield added User UnixUser3 [User ID 3] to Rule MySQLControl [Rule ID 2]','2014-09-23 05:17:27','Ben Schofield'),(46,'Rules','Modify','Ben Schofield added Command Group MySQLServiceControl [Command Group ID 2] to Rule MySQLControl [Rule ID 2]','2014-09-23 05:17:27','Ben Schofield'),(47,'Account Management','View','Ben Schofield accessed Account Management.','2014-09-23 05:17:54','Ben Schofield'),(48,'Account Management','View','Ben Schofield accessed Account Management.','2014-09-23 05:17:55','Ben Schofield'),(49,'Account Management','Add','Ben Schofield added a new system account as Account ID 3: Rodney Apple (devnull@). Rodney Apple has no Admin Privileges, Rodney Apple can Approve the Rules created by others, Rodney Apple\'s Rules require approval and Rodney Apple is not locked out.','2014-09-23 05:18:17','Ben Schofield'),(50,'Account Management','View','Ben Schofield accessed Account Management.','2014-09-23 05:18:17','Ben Schofield'),(51,'Rules','Approve','Rodney Apple Approved ApacheControl [Rule ID 1].','2014-09-23 05:18:31','Rodney Apple'),(52,'Rules','Approve','Rodney Apple Approved MySQLControl [Rule ID 2].','2014-09-23 05:18:33','Rodney Apple'),(53,'Sudoers','Deployment Succeeded','The sudoers file was built, passed visudo validation, and checksums as follows: MD5:87e360ae1ea1b3836e7f84c91258c8e1, SHA1:cf9a5f887704d241318ddefab8555b3ba03a47cf.','2014-09-23 05:18:57','System'),(54,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:10:12','Ben Schofield'),(55,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:10:31','Ben Schofield'),(56,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:10:33','Ben Schofield'),(57,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:13:32','Ben Schofield'),(58,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:13:43','Ben Schofield'),(59,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:13:52','Ben Schofield'),(60,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:14:51','Ben Schofield'),(61,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-09-30 02:17:01','Ben Schofield');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credentials`
--

DROP TABLE IF EXISTS `credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credentials` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `salt` varchar(64) NOT NULL,
  `email` varchar(128) NOT NULL,
  `last_login` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_active` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `admin` int(1) NOT NULL DEFAULT '0',
  `approver` int(1) NOT NULL DEFAULT '0',
  `requires_approval` int(1) NOT NULL DEFAULT '1',
  `lockout` int(1) NOT NULL DEFAULT '0',
  `lockout_counter` int(1) NOT NULL DEFAULT '0',
  `lockout_reset` varchar(128) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credentials`
--

LOCK TABLES `credentials` WRITE;
/*!40000 ALTER TABLE `credentials` DISABLE KEYS */;
INSERT INTO `credentials` VALUES (1,'admin','ebc21cd4ad20daa929cdfd65446c662d1454f08552c546d495eed15f3f0edcd39400565ccbebc489542ba1f528a7963e9bd2425ba0dd35370e81e92e0dd708de',';2eiR=|VyBcv0VWVi0gd=9&B,h<*;SpE.JAv)pik>g-6C!|5W#;tfsu(@0L&u@0u','noreply@','2014-09-23 17:04:38','2014-09-23 17:07:47',1,0,1,0,0,'','2014-09-23 05:07:47','Ben Schofield'),(2,'Ben Schofield','ef16e3286dab3fb718e3633fb38d4c519d0b744fb4fe61faf9e7373d203ee1ff8e98067fa399fb00409caf298ead4530ce1fc45114c923b08f5e2f496ca8f3f7','8z_LN}_}S0@L^sF_,_xF7-+=-_Jr:L!?@1P0>K/?-tN<fk7LGX0?I}jnjOk@a<5?','ben@nwk1.com','2014-09-23 17:07:52','2014-09-30 15:17:01',1,1,1,0,0,'0','2014-09-30 02:17:01','admin'),(3,'Rodney Apple','bd2139be01f0fc6fb66eaba4abcb9ba45776e99d3517e958aeeb951f3e4bd981ffb2eb4c7570ea26f16dbbbefd893f93b59ca6fc7e3e7c2a851c94452dd48e34','afr_<qBcS|p!.S/Cwdc_n0VB*8I1=c3.E+G:F<J+^0jfWOu08CM9f}jF14dR','devnull@','2014-09-23 17:18:26','2014-09-23 17:19:03',0,1,1,0,0,'0','2014-09-23 05:19:03','Ben Schofield');
/*!40000 ALTER TABLE `credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distribution`
--

DROP TABLE IF EXISTS `distribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `distribution` (
  `host_id` int(11) NOT NULL,
  `user` varchar(128) NOT NULL DEFAULT 'transport',
  `key_path` varchar(255) NOT NULL DEFAULT '/home/transport/.ssh/id_rsa',
  `timeout` int(3) NOT NULL DEFAULT '5',
  `remote_sudoers_path` varchar(255) NOT NULL DEFAULT '/tmp/sudoers',
  `status` varchar(1024) NOT NULL DEFAULT 'Not yet attempted connection.',
  `last_updated` datetime NOT NULL,
  `last_modified` datetime NOT NULL,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`host_id`),
  UNIQUE KEY `host_id_UNIQUE` (`host_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distribution`
--

LOCK TABLES `distribution` WRITE;
/*!40000 ALTER TABLE `distribution` DISABLE KEYS */;
INSERT INTO `distribution` VALUES (1,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host1','OK: /tmp/host1 written successfully to wlgprdtst01 (127.0.0.1). Sudoers MD5: f71c1ec96611487856d90f14ddf72749\n','2014-09-30 15:16:59','2014-09-30 15:02:31','Ben Schofield'),(2,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host2','OK: /tmp/host2 written successfully to wlgprdtst02 (127.0.0.2). Sudoers MD5: f71c1ec96611487856d90f14ddf72749\n','2014-09-30 15:16:59','2014-09-30 15:02:31','Ben Schofield'),(3,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host3','Not yet attempted connection.','0000-00-00 00:00:00','2014-09-30 15:02:31','Ben Schofield'),(4,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host4','Not yet attempted connection.','0000-00-00 00:00:00','2014-09-30 15:02:31','Ben Schofield'),(5,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host5','OK: /tmp/host5 written successfully to wlgprdapp01 (127.0.1.1). Sudoers MD5: f71c1ec96611487856d90f14ddf72749\n','2014-09-30 15:16:55','2014-09-30 15:02:31','Ben Schofield'),(6,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host6','Push Failed: Couldn\'t rename remote file \'/tmp/host6(1814).tmp\' to \'/tmp/host6\': Permission denied \n    Hints: \n    1) Check that transport can write to /tmp/host6','2014-09-30 15:16:56','2014-09-30 15:02:31','Ben Schofield'),(7,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host7','Connection Failed: Connection to remote server is broken \n    Hints: \n    1) Badly formatted IP address\n    2) Identity file not found\n    3) Not enough permissions to read identity file','2014-09-30 15:16:58','2014-09-30 15:02:31','Ben Schofield'),(8,'transport','/home/transport/.ssh/id_rsa',15,'/tmp/host8','OK: /tmp/host8 written successfully to wlgprdapp04 (127.0.1.4). Sudoers MD5: f71c1ec96611487856d90f14ddf72749\n','2014-09-30 15:16:59','2014-09-30 15:02:31','Ben Schofield');
/*!40000 ALTER TABLE `distribution` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-09-30 15:17:43
