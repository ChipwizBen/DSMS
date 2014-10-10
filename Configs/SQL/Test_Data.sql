-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: Sudoers
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
-- Current Database: `Sudoers`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `Sudoers` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `Sudoers`;

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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_groups`
--

LOCK TABLES `command_groups` WRITE;
/*!40000 ALTER TABLE `command_groups` DISABLE KEYS */;
INSERT INTO `command_groups` VALUES (1,'ApacheCommands','0000-00-00',1,'2014-10-09 03:43:21','Ben Schofield');
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
INSERT INTO `commands` VALUES (1,'ApacheStart','/etc/init.d/httpd start','0000-00-00',1,'2014-10-09 03:38:40','Ben Schofield'),(2,'ApacheStop','/etc/init.d/httpd stop','0000-00-00',0,'2014-10-09 03:39:03','Ben Schofield'),(3,'ApacheRestart','/etc/init.d/httpd restart','0000-00-00',1,'2014-10-09 03:39:24','Ben Schofield'),(4,'MySQLStart','/etc/init.d/mysqld start','0000-00-00',1,'2014-10-09 03:39:46','Ben Schofield'),(5,'MySQLStop','/etc/init.d/mysqld stop','0000-00-00',1,'2014-10-09 03:40:02','Ben Schofield'),(6,'Wildcard','/sbin/service * restart','0000-00-00',1,'2014-10-09 20:59:51','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_groups`
--

LOCK TABLES `host_groups` WRITE;
/*!40000 ALTER TABLE `host_groups` DISABLE KEYS */;
INSERT INTO `host_groups` VALUES (1,'ApplicationServers','0000-00-00',1,'2014-10-09 03:40:55','Ben Schofield');
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
INSERT INTO `hosts` VALUES (1,'wlgprdapp01','127.0.0.1','0000-00-00',1,'2014-10-09 03:41:20','Ben Schofield'),(2,'wlgprdapp02','127.0.0.2','0000-00-00',1,'2014-10-09 03:41:27','Ben Schofield'),(3,'wlgprdapp03','127.0.0.3','0000-00-00',1,'2014-10-09 03:41:33','Ben Schofield'),(4,'wlgprdapp04','127.0.0.4','2014-10-09',1,'2014-10-09 03:41:43','Ben Schofield'),(5,'wlgprddb01','127.0.1.1','0000-00-00',1,'2014-10-09 03:36:15','Ben Schofield'),(6,'wlgprddb02','127.0.1.2','0000-00-00',1,'2014-10-09 03:36:26','Ben Schofield'),(7,'wlgprddb03','127.0.1.3','0000-00-00',0,'2014-10-09 03:36:38','Ben Schofield'),(8,'wlgprddb04','127.0.1.4','0000-00-00',1,'2014-10-09 03:36:49','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_command_groups_to_commands`
--

LOCK TABLES `lnk_command_groups_to_commands` WRITE;
/*!40000 ALTER TABLE `lnk_command_groups_to_commands` DISABLE KEYS */;
INSERT INTO `lnk_command_groups_to_commands` VALUES (1,1,3),(2,1,1),(3,1,2);
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
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_host_groups_to_hosts`
--

LOCK TABLES `lnk_host_groups_to_hosts` WRITE;
/*!40000 ALTER TABLE `lnk_host_groups_to_hosts` DISABLE KEYS */;
INSERT INTO `lnk_host_groups_to_hosts` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4);
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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_command_groups`
--

LOCK TABLES `lnk_rules_to_command_groups` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_command_groups` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_command_groups` VALUES (1,1,1);
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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_host_groups`
--

LOCK TABLES `lnk_rules_to_host_groups` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_host_groups` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_host_groups` VALUES (1,1,1);
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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_user_groups`
--

LOCK TABLES `lnk_rules_to_user_groups` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_user_groups` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_user_groups` VALUES (1,1,2);
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
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_users`
--

LOCK TABLES `lnk_rules_to_users` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_users` DISABLE KEYS */;
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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_user_groups_to_users`
--

LOCK TABLES `lnk_user_groups_to_users` WRITE;
/*!40000 ALTER TABLE `lnk_user_groups_to_users` DISABLE KEYS */;
INSERT INTO `lnk_user_groups_to_users` VALUES (1,1,4),(2,1,5),(3,1,6),(4,2,1),(5,2,2),(6,2,3);
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
  `all_hosts` int(1) NOT NULL DEFAULT '0',
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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rules`
--

LOCK TABLES `rules` WRITE;
/*!40000 ALTER TABLE `rules` DISABLE KEYS */;
INSERT INTO `rules` VALUES (1,'ApacheControl',0,'root',0,0,'0000-00-00',1,1,'2014-10-09 16:46:29','Rodney Apple','2014-10-09 03:44:24','Ben Schofield');
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
  `system_group` int(1) NOT NULL DEFAULT '0',
  `expires` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `groupname_UNIQUE` (`groupname`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_groups`
--

LOCK TABLES `user_groups` WRITE;
/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
INSERT INTO `user_groups` VALUES (1,'DatabaseAdministrators',0,'0000-00-00',1,'2014-10-09 03:42:19','Ben Schofield'),(2,'UnixAdministrators',0,'0000-00-00',1,'2014-10-09 03:42:45','Ben Schofield'),(3,'dslunix',1,'0000-00-00',1,'2014-10-09 21:12:46','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'UnixUser1','0000-00-00',1,'2014-10-09 03:37:09','Ben Schofield'),(2,'UnixUser2','2015-01-01',1,'2014-10-09 03:37:39','Ben Schofield'),(3,'UnixUser3','0000-00-00',1,'2014-10-09 03:37:46','Ben Schofield'),(4,'DBAUser1','0000-00-00',1,'2014-10-09 03:37:56','Ben Schofield'),(5,'DBAUser2','0000-00-00',1,'2014-10-09 03:38:03','Ben Schofield'),(6,'DBAUser3','0000-00-00',0,'2014-10-09 03:38:11','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=137 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log`
--

LOCK TABLES `access_log` WRITE;
/*!40000 ALTER TABLE `access_log` DISABLE KEYS */;
INSERT INTO `access_log` VALUES (1,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/login.cgi','','GET','on','10.0.2.4','443','admin','2014-10-09 16:26:24'),(2,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/login.cgi','','GET','on','10.0.2.4','443','admin','2014-10-09 16:31:09'),(3,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','admin','2014-10-09 16:31:29'),(4,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/account-management.cgi','','POST','on','10.0.2.4','443','admin','2014-10-09 16:33:16'),(5,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/account-management.cgi','','GET','on','10.0.2.4','443','admin','2014-10-09 16:33:39'),(6,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/account-management.cgi','','POST','on','10.0.2.4','443','admin','2014-10-09 16:33:43'),(7,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/account-management.cgi','','GET','on','10.0.2.4','443','admin','2014-10-09 16:34:01'),(8,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/login.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:34:15'),(9,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/changelog.cgi','https://10.0.2.4/account-management.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:34:36'),(10,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/changelog.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:34:43'),(11,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:34:46'),(12,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:06'),(13,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:07'),(14,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:16'),(15,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:17'),(16,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:25'),(17,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:27'),(18,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:44'),(19,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:35:48'),(20,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:15'),(21,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:17'),(22,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:27'),(23,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:28'),(24,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:39'),(25,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:40'),(26,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:49'),(27,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:56'),(28,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:36:58'),(29,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:09'),(30,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:11'),(31,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:39'),(32,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:41'),(33,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:46'),(34,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:48'),(35,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:56'),(36,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:37:58'),(37,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:38:03'),(38,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:38:04'),(39,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-users.cgi','https://10.0.2.4/sudoers-users.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:38:12'),(40,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-users.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:38:15'),(41,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:38:18'),(42,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:38:40'),(43,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:38:42'),(44,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:39:03'),(45,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:39:06'),(46,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:39:24'),(47,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:39:26'),(48,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:39:46'),(49,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:39:47'),(50,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:02'),(51,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:08'),(52,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:10'),(53,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:39'),(54,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:42'),(55,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:46'),(56,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:53'),(57,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:40:55'),(58,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:07'),(59,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','Edit_Host=1','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:10'),(60,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi?Edit_Host=1','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:20'),(61,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','Edit_Host=2','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:23'),(62,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi?Edit_Host=2','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:27'),(63,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','Edit_Host=3','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:29'),(64,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi?Edit_Host=3','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:33'),(65,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi','Edit_Host=4','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:39'),(66,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-hosts.cgi','https://10.0.2.4/sudoers-hosts.cgi?Edit_Host=4','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:43'),(67,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-hosts.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:49'),(68,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:51'),(69,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:41:53'),(70,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:11'),(71,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:14'),(72,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:17'),(73,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:20'),(74,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:21'),(75,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:34'),(76,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:37'),(77,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:41'),(78,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:45'),(79,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-command-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:52'),(80,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-command-groups.cgi','https://10.0.2.4/sudoers-command-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:42:54'),(81,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-command-groups.cgi','https://10.0.2.4/sudoers-command-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:43:11'),(82,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-command-groups.cgi','https://10.0.2.4/sudoers-command-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:43:14'),(83,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-command-groups.cgi','https://10.0.2.4/sudoers-command-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:43:18'),(84,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-command-groups.cgi','https://10.0.2.4/sudoers-command-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:43:21'),(85,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/sudoers-command-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:43:27'),(86,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:43:53'),(87,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/sudoers-rules.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:43:55'),(88,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/sudoers-rules.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:44:04'),(89,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/sudoers-rules.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:44:08'),(90,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/sudoers-rules.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:44:12'),(91,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/sudoers-rules.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:44:24'),(92,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/login.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:45:00'),(93,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/sudoers-rules.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:45:04'),(94,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/account-management.cgi','Edit_User=3','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:45:07'),(95,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/account-management.cgi','https://10.0.2.4/account-management.cgi?Edit_User=3','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:45:12'),(96,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/login.cgi','','GET','on','10.0.2.4','443','Rodney Apple','2014-10-09 16:45:21'),(97,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Rodney Apple','2014-10-09 16:46:07'),(98,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Rodney Apple','2014-10-09 16:46:24'),(99,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Rodney Apple','2014-10-09 16:46:27'),(100,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/sudoers-rules.cgi','','GET','on','10.0.2.4','443','Rodney Apple','2014-10-09 16:46:29'),(101,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-rules.cgi','https://10.0.2.4/login.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:46:36'),(102,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/audit-log.cgi','https://10.0.2.4/sudoers-rules.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:46:39'),(103,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/audit-log.cgi','https://10.0.2.4/sudoers-rules.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:49:11'),(104,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/audit-log.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:49:19'),(105,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:49:27'),(106,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/index.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:50:33'),(107,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/audit-log.cgi','https://10.0.2.4/distribution-status.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:50:39'),(108,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/audit-log.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:51:07'),(109,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/audit-log.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:52:20'),(110,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi','Edit_Host_Parameters=1','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:53:22'),(111,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=1','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:53:31'),(112,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=1','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 16:54:53'),(113,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=1','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:24:18'),(114,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi','Edit_Host_Parameters=6','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:24:36'),(115,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=6','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:24:56'),(116,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=6','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:27:37'),(117,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=6','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:30:55'),(118,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=6','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:33:18'),(119,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi','Edit_Host_Parameters=3','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:36:44'),(120,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=3','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:36:55'),(121,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=3','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:42:54'),(122,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi','Edit_Host_Parameters=7','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:43:54'),(123,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=7','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:44:02'),(124,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/distribution-status.cgi?Edit_Host_Parameters=7','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:44:52'),(125,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/index.cgi','https://10.0.2.4/distribution-status.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-09 17:56:53'),(126,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/login.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 09:58:18'),(127,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/audit-log.cgi','https://10.0.2.4/distribution-status.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 09:58:30'),(128,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/audit-log.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 09:59:16'),(129,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-10 09:59:18'),(130,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-commands.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 09:59:52'),(131,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-host-groups.cgi','https://10.0.2.4/sudoers-commands.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 10:00:04'),(132,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-host-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 10:00:06'),(133,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','POST','on','10.0.2.4','443','Ben Schofield','2014-10-10 10:00:08'),(134,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/sudoers-user-groups.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 10:12:46'),(135,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/audit-log.cgi','https://10.0.2.4/sudoers-user-groups.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 10:15:10'),(136,'10.0.2.8','','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0','/distribution-status.cgi','https://10.0.2.4/audit-log.cgi','','GET','on','10.0.2.4','443','Ben Schofield','2014-10-10 10:15:23');
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
) ENGINE=MyISAM AUTO_INCREMENT=90 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: MD5: f9a484aa783b1858853780a2f463ac40, SHA1: f5399f408f9d9d82416680d470941aed65c66c3e. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_f9a484aa783b1858853780a2f463ac40\' for future reference.','2014-10-09 03:27:20','System'),(2,'Account Management','View','admin accessed Account Management.','2014-10-09 03:31:29','admin'),(3,'Account Management','View','admin accessed Account Management.','2014-10-09 03:33:16','admin'),(4,'Account Management','Add','admin added a new system account as Account ID 2: Ben Schofield (ben@nwk1.com). Ben Schofield has Admin Privileges, Ben Schofield can Approve the Rules created by others, Ben Schofield\'s Rules require approval and Ben Schofield is not locked out.','2014-10-09 03:33:39','admin'),(5,'Account Management','View','admin accessed Account Management.','2014-10-09 03:33:39','admin'),(6,'Account Management','View','admin accessed Account Management.','2014-10-09 03:33:43','admin'),(7,'Account Management','Add','admin added a new system account as Account ID 3: Rodney Apple (devnull@). Rodney Apple has no Admin Privileges, Rodney Apple can Approve the Rules created by others, Rodney Apple\'s Rules require approval and Rodney Apple is not locked out.','2014-10-09 03:34:01','admin'),(8,'Account Management','View','admin accessed Account Management.','2014-10-09 03:34:01','admin'),(9,'Account Management','View','Ben Schofield accessed Account Management.','2014-10-09 03:34:15','Ben Schofield'),(10,'Hosts','Add','Ben Schofield added wlgprdbla01 (127.0.0.1), set it Active and to not expire. The system assigned it Host ID 1.','2014-10-09 03:35:06','Ben Schofield'),(11,'Distribution','Add','Ben Schofield added wlgprdbla01 (127.0.0.1) [Host ID 1] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:35:06','Ben Schofield'),(12,'Hosts','Add','Ben Schofield added wlgprdbla02 (127.0.0.2), set it Active and to not expire. The system assigned it Host ID 2.','2014-10-09 03:35:15','Ben Schofield'),(13,'Distribution','Add','Ben Schofield added wlgprdbla02 (127.0.0.2) [Host ID 2] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:35:15','Ben Schofield'),(14,'Hosts','Add','Ben Schofield added wlgprdbla03 (127.0.0.3), set it Active and to not expire. The system assigned it Host ID 3.','2014-10-09 03:35:25','Ben Schofield'),(15,'Distribution','Add','Ben Schofield added wlgprdbla03 (127.0.0.3) [Host ID 3] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:35:25','Ben Schofield'),(16,'Hosts','Add','Ben Schofield added wlgprdbla04 (127.0.0.4), set it Active and to expire on 2014-10-09. The system assigned it Host ID 4.','2014-10-09 03:35:44','Ben Schofield'),(17,'Distribution','Add','Ben Schofield added wlgprdbla04 (127.0.0.4) [Host ID 4] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:35:44','Ben Schofield'),(18,'Hosts','Add','Ben Schofield added wlgprddb01 (127.0.1.1), set it Active and to not expire. The system assigned it Host ID 5.','2014-10-09 03:36:15','Ben Schofield'),(19,'Distribution','Add','Ben Schofield added wlgprddb01 (127.0.1.1) [Host ID 5] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:36:15','Ben Schofield'),(20,'Hosts','Add','Ben Schofield added wlgprddb02 (127.0.1.2), set it Active and to not expire. The system assigned it Host ID 6.','2014-10-09 03:36:26','Ben Schofield'),(21,'Distribution','Add','Ben Schofield added wlgprddb02 (127.0.1.2) [Host ID 6] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:36:26','Ben Schofield'),(22,'Hosts','Add','Ben Schofield added wlgprddb03 (127.0.1.3), set it Inactive and to not expire. The system assigned it Host ID 7.','2014-10-09 03:36:38','Ben Schofield'),(23,'Distribution','Add','Ben Schofield added wlgprddb03 (127.0.1.3) [Host ID 7] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:36:38','Ben Schofield'),(24,'Hosts','Add','Ben Schofield added wlgprddb04 (127.0.1.4), set it Active and to not expire. The system assigned it Host ID 8.','2014-10-09 03:36:49','Ben Schofield'),(25,'Distribution','Add','Ben Schofield added wlgprddb04 (127.0.1.4) [Host ID 8] to the sudoers distribution system and assigned it default parameters.','2014-10-09 03:36:49','Ben Schofield'),(26,'Users','Add','Ben Schofield added UnixUser1, set it Active and to not expire. The system assigned it User ID 1.','2014-10-09 03:37:09','Ben Schofield'),(27,'Users','Add','Ben Schofield added UnixUser2, set it Active and to expire on 2015-01-01. The system assigned it User ID 2.','2014-10-09 03:37:39','Ben Schofield'),(28,'Users','Add','Ben Schofield added UnixUser3, set it Active and to not expire. The system assigned it User ID 3.','2014-10-09 03:37:46','Ben Schofield'),(29,'Users','Add','Ben Schofield added DBAUser1, set it Active and to not expire. The system assigned it User ID 4.','2014-10-09 03:37:56','Ben Schofield'),(30,'Users','Add','Ben Schofield added DBAUser2, set it Active and to not expire. The system assigned it User ID 5.','2014-10-09 03:38:03','Ben Schofield'),(31,'Users','Add','Ben Schofield added DBAUser3, set it Inactive and to not expire. The system assigned it User ID 6.','2014-10-09 03:38:11','Ben Schofield'),(32,'Commands','Add','Ben Schofield added ApacheStart (/etc/init.d/httpd start), set it Active and to not expire. The system assigned it Command ID 1.','2014-10-09 03:38:40','Ben Schofield'),(33,'Commands','Add','Ben Schofield added ApacheStop (/etc/init.d/httpd stop), set it Inactive and to not expire. The system assigned it Command ID 2.','2014-10-09 03:39:03','Ben Schofield'),(34,'Commands','Add','Ben Schofield added ApacheRestart (/etc/init.d/httpd restart), set it Active and to not expire. The system assigned it Command ID 3.','2014-10-09 03:39:24','Ben Schofield'),(35,'Commands','Add','Ben Schofield added MySQLStart (/etc/init.d/mysqld start), set it Active and to not expire. The system assigned it Command ID 4.','2014-10-09 03:39:46','Ben Schofield'),(36,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: MD5: 823462cd8e5ee0e163698714f3d9a3c8, SHA1: f55b2ef60abb42c3991d077bad3f85b064f6976d. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_823462cd8e5ee0e163698714f3d9a3c8\' for future reference.','2014-10-09 03:40:01','System'),(37,'Commands','Add','Ben Schofield added MySQLStop (/etc/init.d/mysqld stop), set it Active and to not expire. The system assigned it Command ID 5.','2014-10-09 03:40:02','Ben Schofield'),(38,'Host Groups','Add','Ben Schofield added ApplicationServers, set it Active and to not expire. 4 hosts were attached: wlgprdbla04, wlgprdbla03, wlgprdbla02, wlgprdbla01. The system assigned it Host Group ID 1.','2014-10-09 03:40:55','Ben Schofield'),(39,'Hosts','Modify','Ben Schofield modified Host ID 1. The new entry is recorded as wlgprdapp01 (127.0.0.1), set Active and does not expire.','2014-10-09 03:41:20','Ben Schofield'),(40,'Hosts','Modify','Ben Schofield modified Host ID 2. The new entry is recorded as wlgprdapp02 (127.0.0.2), set Active and does not expire.','2014-10-09 03:41:27','Ben Schofield'),(41,'Hosts','Modify','Ben Schofield modified Host ID 3. The new entry is recorded as wlgprdapp03 (127.0.0.3), set Active and does not expire.','2014-10-09 03:41:33','Ben Schofield'),(42,'Hosts','Modify','Ben Schofield modified Host ID 4. The new entry is recorded as wlgprdapp04 (127.0.0.4), set Active and expires on 2014-10-09.','2014-10-09 03:41:43','Ben Schofield'),(43,'User Groups','Add','Ben Schofield added DatabaseAdministrators as a Sudoers Group, set it Active and to not expire. 3 users were attached: DBAUser3, DBAUser2, DBAUser1. The system assigned it User Group ID 1.','2014-10-09 03:42:19','Ben Schofield'),(44,'User Groups','Add','Ben Schofield added UnixAdministrators as a Sudoers Group, set it Active and to not expire. 3 users were attached: UnixUser3, UnixUser2, UnixUser1. The system assigned it User Group ID 2.','2014-10-09 03:42:45','Ben Schofield'),(45,'Command Groups','Add','Ben Schofield added ApacheCommands, set it Active and to not expire. 3 commands were attached: ApacheStop, ApacheStart, ApacheRestart. The system assigned it Command Group ID 1.','2014-10-09 03:43:21','Ben Schofield'),(46,'Rules','Add','Ben Schofield added ApacheControl (to be run as root, with the PASSWD and EXEC flags), set it Active and to not expire. The system assigned it Rule ID 1.','2014-10-09 03:44:24','Ben Schofield'),(47,'Rules','Modify','Ben Schofield added Host Group ApplicationServers [Host Group ID 1] to Rule ApacheControl [Rule ID 1]','2014-10-09 03:44:24','Ben Schofield'),(48,'Rules','Modify','Ben Schofield added User Group UnixAdministrators [User Group ID 2] to Rule ApacheControl [Rule ID 1]','2014-10-09 03:44:24','Ben Schofield'),(49,'Rules','Modify','Ben Schofield added Command Group ApacheCommands [Command Group ID 1] to Rule ApacheControl [Rule ID 1]','2014-10-09 03:44:24','Ben Schofield'),(50,'Account Management','View','Ben Schofield accessed Account Management.','2014-10-09 03:45:04','Ben Schofield'),(51,'Account Management','View','Ben Schofield accessed Account Management.','2014-10-09 03:45:07','Ben Schofield'),(52,'Account Management','Modify','Ben Schofield edited a system account with Account ID 3: Rodney Apple (devnull@). Rodney Apple has no Admin Privileges, Rodney Apple can Approve the Rules created by others, Rodney Apple\'s Rules require approval and Rodney Apple is not locked out. Ben Schofield also changed Rodney Apple\'s password.','2014-10-09 03:45:11','Ben Schofield'),(53,'Account Management','View','Ben Schofield accessed Account Management.','2014-10-09 03:45:12','Ben Schofield'),(54,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: MD5: 92efa217876e7083dd99d14d8b75f418, SHA1: 2609a1b71c72acc455c32c460e7760419597adbd. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_92efa217876e7083dd99d14d8b75f418\' for future reference.','2014-10-09 03:46:02','System'),(55,'Rules','Approve','Rodney Apple Approved ApacheControl [Rule ID 1].','2014-10-09 03:46:29','Rodney Apple'),(56,'Audit Log','View','Ben Schofield accessed the Audit Log.','2014-10-09 03:46:39','Ben Schofield'),(57,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: MD5: dc17025ea8b7d7a32e9f7cfb45ce537d, SHA1: 12d018c998cf073505a459a15fd1a4637cc7e3d2. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_dc17025ea8b7d7a32e9f7cfb45ce537d\' for future reference.','2014-10-09 03:47:01','System'),(58,'Audit Log','View','Ben Schofield accessed the Audit Log.','2014-10-09 03:49:11','Ben Schofield'),(59,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 03:49:27','Ben Schofield'),(60,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 03:50:33','Ben Schofield'),(61,'Audit Log','View','Ben Schofield accessed the Audit Log.','2014-10-09 03:50:39','Ben Schofield'),(62,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 03:51:07','Ben Schofield'),(63,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 03:52:20','Ben Schofield'),(64,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 03:53:22','Ben Schofield'),(65,'Distribution','Modify','Ben Schofield modified Host ID 1. The new entry is recorded as User: transport, Key Path: /home/transport/.ssh/id_rsa, Timeout: 15 seconds and Remote Sudoers Path: sudoers/sudoers.','2014-10-09 03:53:31','Ben Schofield'),(66,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 03:53:31','Ben Schofield'),(67,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 03:54:53','Ben Schofield'),(68,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:24:18','Ben Schofield'),(69,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:24:36','Ben Schofield'),(70,'Distribution','Modify','Ben Schofield modified Host ID 6. The new entry is recorded as User: transport, Key Path: /root/.ssh/id_rsa, Timeout: 15 seconds and Remote Sudoers Path: /bla/sudoers.','2014-10-09 04:24:56','Ben Schofield'),(71,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:24:56','Ben Schofield'),(72,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:27:37','Ben Schofield'),(73,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:30:55','Ben Schofield'),(74,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:33:18','Ben Schofield'),(75,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:36:44','Ben Schofield'),(76,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:36:55','Ben Schofield'),(77,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:42:54','Ben Schofield'),(78,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:43:54','Ben Schofield'),(79,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:44:02','Ben Schofield'),(80,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 04:44:52','Ben Schofield'),(81,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: MD5: 5cbcc7389167d0c729076d6f4860204e, SHA1: e7d05f65a066cc67e8714edfa3bdfeaf2a74951b. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_5cbcc7389167d0c729076d6f4860204e\' for future reference.','2014-10-09 19:59:24','System'),(82,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 20:58:18','Ben Schofield'),(83,'Audit Log','View','Ben Schofield accessed the Audit Log.','2014-10-09 20:58:30','Ben Schofield'),(84,'Commands','Add','Ben Schofield added Wildcard (/sbin/service * restart), set it Active and to not expire. The system assigned it Command ID 6.','2014-10-09 20:59:51','Ben Schofield'),(85,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: MD5: ab183c3065e1721e6d2e35c379c4595d, SHA1: b9377d7859918e6bc869e2af2562dd62738b54ae. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_ab183c3065e1721e6d2e35c379c4595d\' for future reference.','2014-10-09 21:00:01','System'),(86,'User Groups','Add','Ben Schofield added dslunix as a System Group, set it Active and to not expire. 0 users were attached. The system assigned it User Group ID 3.','2014-10-09 21:12:46','Ben Schofield'),(87,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: MD5: fd9ead46159f75f33f4ce93b40574f5c, SHA1: b42a3fa73964fc325fd1afdef66db745ccec4cb1. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_fd9ead46159f75f33f4ce93b40574f5c\' for future reference.','2014-10-09 21:13:01','System'),(88,'Audit Log','View','Ben Schofield accessed the Audit Log.','2014-10-09 21:15:10','Ben Schofield'),(89,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-09 21:15:23','Ben Schofield');
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
INSERT INTO `credentials` VALUES (1,'admin','ebc21cd4ad20daa929cdfd65446c662d1454f08552c546d495eed15f3f0edcd39400565ccbebc489542ba1f528a7963e9bd2425ba0dd35370e81e92e0dd708de',';2eiR=|VyBcv0VWVi0gd=9&B,h<*;SpE.JAv)pik>g-6C!|5W#;tfsu(@0L&u@0u','noreply@','2014-10-09 16:26:24','2014-10-09 16:34:01',1,0,1,0,0,'','2014-10-09 03:34:01','Ben Schofield'),(2,'Ben Schofield','73808dc63c6000b7a01d90edc09042aee677985b2905926665fb54d1dc3ab9cc9bc799bec8f241b1aa9b96529d01e339c5d1e09469d009102ba34923f87f96f2','xu>T00jF4H3)_a6se?dZ7I7->B9;CEM<P;iUc?O#.gfeBv0XyD,U&#i^M_8wH0','ben@nwk1.com','2014-10-10 09:58:18','2014-10-10 10:15:23',1,1,1,0,0,'0','2014-10-09 21:15:23','admin'),(3,'Rodney Apple','2d432f861eeb7b6ca6a0eba8790724debbff829cc710acc55f4cd2ed470975b70b13fc8e1ff5ed05cd30dddfa2fcbdb1b9b78359e7212a211b07b612f5cec4fd','qSt4u-0qpV31:&ogNrwz+_tSVacv5o!&yP{*mKOGvL,PW;o>I68w|-H_QnC4C{_K','devnull@','2014-10-09 16:45:21','2014-10-09 16:46:29',0,1,1,0,0,'0','2014-10-09 03:46:29','Ben Schofield');
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
INSERT INTO `distribution` VALUES (1,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprdapp01 (127.0.0.1). Sudoers MD5: fd9ead46159f75f33f4ce93b40574f5c\n','2014-10-10 10:38:02','2014-10-09 16:53:31','Ben Schofield'),(2,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprdapp02 (127.0.0.2). Sudoers MD5: fd9ead46159f75f33f4ce93b40574f5c\n','2014-10-10 10:38:02','2014-10-09 16:35:15','Ben Schofield'),(3,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprdapp03 (127.0.0.3). Sudoers MD5: fd9ead46159f75f33f4ce93b40574f5c\n','2014-10-10 10:38:02','2014-10-09 16:35:25','Ben Schofield'),(4,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','Connection Failed: Connection to remote server is broken \n    Hints: \n    1) Badly formatted IP address\n    2) Identity file not found\n    3) Not enough permissions to read identity file','2014-10-10 10:38:02','2014-10-09 16:35:44','Ben Schofield'),(5,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprddb01 (127.0.1.1). Sudoers MD5: fd9ead46159f75f33f4ce93b40574f5c\n','2014-10-10 10:38:03','2014-10-09 16:36:15','Ben Schofield'),(6,'transport','/root/.ssh/id_rsa',15,'bla/sudoers','Push Failed: Couldn\'t open remote file \'bla/sudoers(9298).tmp\': No such file \n	Hints: \n    1) Check that the remote path is correct\n    2) If the Remote Server uses chroot, try making the path relative (i.e. path/sudoers instead of /path/sudoers)','2014-10-10 10:38:03','2014-10-09 17:24:56','Ben Schofield'),(7,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprddb03 (127.0.1.3). Sudoers MD5: fd9ead46159f75f33f4ce93b40574f5c\n','2014-10-10 10:38:03','2014-10-09 16:36:38','Ben Schofield'),(8,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprddb04 (127.0.1.4). Sudoers MD5: fd9ead46159f75f33f4ce93b40574f5c\n','2014-10-10 10:38:04','2014-10-09 16:36:49','Ben Schofield');
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

-- Dump completed on 2014-10-10 10:38:19
