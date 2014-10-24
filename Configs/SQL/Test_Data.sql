-- MySQL dump 10.13  Distrib 5.5.40, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: Sudoers
-- ------------------------------------------------------
-- Server version	5.1.71

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
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_groups`
--

LOCK TABLES `command_groups` WRITE;
/*!40000 ALTER TABLE `command_groups` DISABLE KEYS */;
INSERT INTO `command_groups` VALUES (1,'ApacheServiceControl','0000-00-00',1,'2014-10-24 09:28:10','Ben Schofield'),(2,'MySQLServiceControl','0000-00-00',1,'2014-10-24 09:29:13','Ben Schofield');
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
INSERT INTO `commands` VALUES (1,'ApacheStart','/etc/init.d/httpd start','0000-00-00',1,'2014-10-24 09:25:48','Ben Schofield'),(2,'ApacheRestart','/etc/init.d/httpd restart','0000-00-00',1,'2014-10-24 09:26:04','Ben Schofield'),(3,'ApacheStop','/etc/init.d/httpd stop','0000-00-00',1,'2014-10-24 09:26:17','Ben Schofield'),(4,'MySQLStart','/etc/init.d/mysqld start','0000-00-00',1,'2014-10-24 09:27:00','Ben Schofield'),(5,'MySQLRestart','/etc/init.d/mysqld restart','0000-00-00',1,'2014-10-24 09:27:14','Ben Schofield'),(6,'MySQLStop','/etc/init.d/mysqld stop','0000-00-00',1,'2014-10-24 09:27:29','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_groups`
--

LOCK TABLES `host_groups` WRITE;
/*!40000 ALTER TABLE `host_groups` DISABLE KEYS */;
INSERT INTO `host_groups` VALUES (1,'WellingtonHosts','0000-00-00',1,'2014-10-24 09:10:52','admin'),(2,'AucklandHosts','0000-00-00',1,'2014-10-24 09:11:16','admin'),(3,'ApplicationServers','0000-00-00',1,'2014-10-24 09:11:44','admin'),(4,'DatabaseServers','0000-00-00',1,'2014-10-24 09:12:17','admin');
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
INSERT INTO `hosts` VALUES (1,'wlgprdapp01','127.0.0.1','0000-00-00',1,'2014-10-24 09:07:53','admin'),(2,'wlgprdapp02','127.0.0.2','0000-00-00',1,'2014-10-24 09:08:04','admin'),(3,'wlgprddb01','127.0.1.1','0000-00-00',1,'2014-10-24 09:08:27','admin'),(4,'wlgprddb02','127.0.1.2','0000-00-00',1,'2014-10-24 09:08:39','admin'),(5,'aklprdapp01','127.1.0.1','0000-00-00',1,'2014-10-24 09:09:11','admin'),(6,'aklprdapp02','127.1.0.2','0000-00-00',1,'2014-10-24 09:09:24','admin'),(7,'aklprddb01','127.1.1.1','0000-00-00',1,'2014-10-24 09:09:45','admin'),(8,'aklprddb02','127.1.1.2','0000-00-00',1,'2014-10-24 09:10:07','admin');
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
INSERT INTO `lnk_command_groups_to_commands` VALUES (1,1,2),(2,1,1),(3,1,3),(4,2,5),(5,2,4),(6,2,6);
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
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_host_groups_to_hosts`
--

LOCK TABLES `lnk_host_groups_to_hosts` WRITE;
/*!40000 ALTER TABLE `lnk_host_groups_to_hosts` DISABLE KEYS */;
INSERT INTO `lnk_host_groups_to_hosts` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,2,5),(6,2,6),(7,2,7),(8,2,8),(9,3,5),(10,3,6),(11,3,1),(12,3,2),(13,4,7),(14,4,8),(15,4,3),(16,4,4);
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
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lnk_rules_to_host_groups`
--

LOCK TABLES `lnk_rules_to_host_groups` WRITE;
/*!40000 ALTER TABLE `lnk_rules_to_host_groups` DISABLE KEYS */;
INSERT INTO `lnk_rules_to_host_groups` VALUES (1,1,3),(2,2,4);
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
INSERT INTO `lnk_user_groups_to_users` VALUES (1,1,1),(2,1,2),(3,1,3),(4,2,4),(5,2,5),(6,2,6);
/*!40000 ALTER TABLE `lnk_user_groups_to_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(2) NOT NULL DEFAULT '0',
  `item_id` int(11) NOT NULL,
  `note` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
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
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rules`
--

LOCK TABLES `rules` WRITE;
/*!40000 ALTER TABLE `rules` DISABLE KEYS */;
INSERT INTO `rules` VALUES (1,'ApacheServerControl',0,'root',0,0,'0000-00-00',1,1,'2014-10-24 22:31:35','Rodney Apple','2014-10-24 09:30:09','Ben Schofield'),(2,'MySQLServerControl',0,'root',0,0,'0000-00-00',1,1,'2014-10-24 22:31:37','Rodney Apple','2014-10-24 09:31:20','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_groups`
--

LOCK TABLES `user_groups` WRITE;
/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
INSERT INTO `user_groups` VALUES (1,'UnixUsers',0,'0000-00-00',1,'2014-10-24 09:23:04','Ben Schofield'),(2,'DatabaseUsers',0,'0000-00-00',1,'2014-10-24 09:23:29','Ben Schofield');
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
INSERT INTO `users` VALUES (1,'UnixUser1','0000-00-00',0,'2014-10-24 09:22:13','Ben Schofield'),(2,'UnixUser2','0000-00-00',1,'2014-10-24 09:17:46','Ben Schofield'),(3,'UnixUser3','0000-00-00',1,'2014-10-24 09:17:53','Ben Schofield'),(4,'DBAUser1','0000-00-00',1,'2014-10-24 09:21:05','Ben Schofield'),(5,'DBAUser2','2014-10-24',1,'2014-10-24 09:21:30','Ben Schofield'),(6,'DBAUser3','0000-00-00',1,'2014-10-24 09:21:19','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=132 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_log`
--

LOCK TABLES `access_log` WRITE;
/*!40000 ALTER TABLE `access_log` DISABLE KEYS */;
INSERT INTO `access_log` VALUES (1,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./index.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:07:19'),(2,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:07:21'),(3,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:07:54'),(4,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:07:56'),(5,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:08:05'),(6,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:08:07'),(7,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:08:28'),(8,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:08:30'),(9,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:08:39'),(10,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:08:43'),(11,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:09:12'),(12,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:09:14'),(13,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:09:24'),(14,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:09:27'),(15,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:09:45'),(16,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:09:47'),(17,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:07'),(18,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:25'),(19,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:29'),(20,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:40'),(21,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:43'),(22,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:46'),(23,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:48'),(24,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:53'),(25,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:10:55'),(26,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:04'),(27,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:07'),(28,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:10'),(29,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:13'),(30,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:17'),(31,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:21'),(32,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:29'),(33,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:33'),(34,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:36'),(35,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:40'),(36,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:44'),(37,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:11:47'),(38,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:12:02'),(39,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:12:06'),(40,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:12:09'),(41,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:12:13'),(42,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-host-groups.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:12:17'),(43,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./sudoers-host-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:12:49'),(44,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:13:59'),(45,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:14:18'),(46,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:14:20'),(47,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:14:48'),(48,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','POST','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:14:51'),(49,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:15:13'),(50,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:15:42'),(51,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi','Edit_User=3','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:15:48'),(52,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./account-management.cgi?Edit_User=3','','GET','on','udm-sudoers-01.alabs.','443','admin','2014-10-24 22:15:54'),(53,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/account-management.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:16:03'),(54,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/index.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-10-24 22:16:11'),(55,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/index.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:16:19'),(56,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-hosts.cgi','https://udm-sudoers-01.alabs./index.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:09'),(57,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-hosts.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:13'),(58,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:15'),(59,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:40'),(60,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:42'),(61,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:47'),(62,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:49'),(63,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:17:53'),(64,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:20:58'),(65,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:06'),(66,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:08'),(67,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:13'),(68,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:15'),(69,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:20'),(70,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','Edit_User=5','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:24'),(71,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi?Edit_User=5','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:30'),(72,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','Edit_User=1','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:21:39'),(73,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-users.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi?Edit_User=1','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:13'),(74,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-users.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:22'),(75,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:24'),(76,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:31'),(77,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:39'),(78,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:42'),(79,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:51'),(80,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:22:54'),(81,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:01'),(82,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:04'),(83,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:06'),(84,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:22'),(85,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:24'),(86,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:27'),(87,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:30'),(88,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:37'),(89,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:23:45'),(90,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:25:48'),(91,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:25:51'),(92,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:26:05'),(93,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:26:06'),(94,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:26:17'),(95,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:26:19'),(96,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:01'),(97,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:03'),(98,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:14'),(99,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:18'),(100,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-commands.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:30'),(101,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-user-groups.cgi','https://udm-sudoers-01.alabs./sudoers-commands.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:45'),(102,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-user-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:48'),(103,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:27:50'),(104,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:03'),(105,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:06'),(106,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:08'),(107,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:11'),(108,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:22'),(109,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:39'),(110,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:42'),(111,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:28:45'),(112,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-command-groups.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:29:13'),(113,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-command-groups.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:29:18'),(114,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:29:22'),(115,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:29:51'),(116,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:29:56'),(117,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:29:59'),(118,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:30:09'),(119,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:30:14'),(120,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:30:25'),(121,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:30:29'),(122,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','POST','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:30:32'),(123,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:31:21'),(124,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-10-24 22:31:32'),(125,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-10-24 22:31:35'),(126,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-10-24 22:31:38'),(127,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/sudoers-rules.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-10-24 22:31:51'),(128,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/index.cgi','https://udm-sudoers-01.alabs./sudoers-rules.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-10-24 22:32:13'),(129,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/index.cgi','https://udm-sudoers-01.alabs./index.cgi','','GET','on','udm-sudoers-01.alabs.','443','Rodney Apple','2014-10-24 22:32:57'),(130,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/index.cgi','https://udm-sudoers-01.alabs./login.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:33:07'),(131,'172.30.6.43','','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.120 Chrome/37.0.2062.120 Safari','/distribution-status.cgi','https://udm-sudoers-01.alabs./index.cgi','','GET','on','udm-sudoers-01.alabs.','443','Ben Schofield','2014-10-24 22:33:17');
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
) ENGINE=MyISAM AUTO_INCREMENT=67 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (2,'Hosts','Add','admin added wlgprdapp01 (127.0.0.1), set it Active and to not expire. The system assigned it Host ID 1.','2014-10-24 09:07:53','admin'),(3,'Distribution','Add','admin added wlgprdapp01 (127.0.0.1) [Host ID 1] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:07:53','admin'),(4,'Hosts','Add','admin added wlgprdapp02 (127.0.0.2), set it Active and to not expire. The system assigned it Host ID 2.','2014-10-24 09:08:04','admin'),(5,'Distribution','Add','admin added wlgprdapp02 (127.0.0.2) [Host ID 2] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:08:04','admin'),(6,'Hosts','Add','admin added wlgprddb01 (127.0.1.1), set it Active and to not expire. The system assigned it Host ID 3.','2014-10-24 09:08:27','admin'),(7,'Distribution','Add','admin added wlgprddb01 (127.0.1.1) [Host ID 3] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:08:27','admin'),(8,'Hosts','Add','admin added wlgprddb02 (127.0.1.2), set it Active and to not expire. The system assigned it Host ID 4.','2014-10-24 09:08:39','admin'),(9,'Distribution','Add','admin added wlgprddb02 (127.0.1.2) [Host ID 4] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:08:39','admin'),(10,'Hosts','Add','admin added aklprdapp01 (127.1.0.1), set it Active and to not expire. The system assigned it Host ID 5.','2014-10-24 09:09:11','admin'),(11,'Distribution','Add','admin added aklprdapp01 (127.1.0.1) [Host ID 5] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:09:11','admin'),(12,'Hosts','Add','admin added aklprdapp02 (127.1.0.2), set it Active and to not expire. The system assigned it Host ID 6.','2014-10-24 09:09:24','admin'),(13,'Distribution','Add','admin added aklprdapp02 (127.1.0.2) [Host ID 6] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:09:24','admin'),(14,'Hosts','Add','admin added aklprddb01 (127.1.1.1), set it Active and to not expire. The system assigned it Host ID 7.','2014-10-24 09:09:45','admin'),(15,'Distribution','Add','admin added aklprddb01 (127.1.1.1) [Host ID 7] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:09:45','admin'),(16,'Hosts','Add','admin added aklprddb02 (127.1.1.2), set it Active and to not expire. The system assigned it Host ID 8.','2014-10-24 09:10:07','admin'),(17,'Distribution','Add','admin added aklprddb02 (127.1.1.2) [Host ID 8] to the sudoers distribution system and assigned it default parameters.','2014-10-24 09:10:07','admin'),(18,'Host Groups','Add','admin added WellingtonHosts, set it Active and to not expire. 4 hosts were attached: wlgprddb02, wlgprddb01, wlgprdapp02, wlgprdapp01. The system assigned it Host Group ID 1.','2014-10-24 09:10:52','admin'),(19,'Host Groups','Add','admin added AucklandHosts, set it Active and to not expire. 4 hosts were attached: aklprddb02, aklprddb01, aklprdapp02, aklprdapp01. The system assigned it Host Group ID 2.','2014-10-24 09:11:16','admin'),(20,'Host Groups','Add','admin added ApplicationServers, set it Active and to not expire. 4 hosts were attached: wlgprdapp02, wlgprdapp01, aklprdapp02, aklprdapp01. The system assigned it Host Group ID 3.','2014-10-24 09:11:44','admin'),(21,'Host Groups','Add','admin added DatabaseServers, set it Active and to not expire. 4 hosts were attached: wlgprddb02, wlgprddb01, aklprddb02, aklprddb01. The system assigned it Host Group ID 4.','2014-10-24 09:12:17','admin'),(22,'Account Management','View','admin accessed Account Management.','2014-10-24 09:12:49','admin'),(23,'Account Management','View','admin accessed Account Management.','2014-10-24 09:13:59','admin'),(24,'Account Management','Add','admin added a new system account as Account ID 2: admin (devnull@). admin has Administrator Privileges, admin can not Approve the Rules created by others, admin\'s Rules require approval and admin is not locked out.','2014-10-24 09:14:18','admin'),(25,'Account Management','View','admin accessed Account Management.','2014-10-24 09:14:18','admin'),(26,'Account Management','View','admin accessed Account Management.','2014-10-24 09:14:20','admin'),(27,'Account Management','Add','admin added a new system account as Account ID 3: Ben Schofield (ben@nwk1.com). Ben Schofield has Administrator Privileges, Ben Schofield can Approve the Rules created by others, Ben Schofield\'s Rules require approval and Ben Schofield is not locked out.','2014-10-24 09:14:48','admin'),(28,'Account Management','View','admin accessed Account Management.','2014-10-24 09:14:48','admin'),(29,'Account Management','View','admin accessed Account Management.','2014-10-24 09:14:51','admin'),(30,'Account Management','Add','admin added a new system account as Account ID 4: Rodney Apple (blabla@). Rodney Apple has no Administrator Privileges, Rodney Apple can Approve the Rules created by others, Rodney Apple\'s Rules require approval and Rodney Apple is not locked out.','2014-10-24 09:15:13','admin'),(31,'Account Management','View','admin accessed Account Management.','2014-10-24 09:15:13','admin'),(32,'Account Management','View','admin accessed Account Management.','2014-10-24 09:15:42','admin'),(33,'Account Management','View','admin accessed Account Management.','2014-10-24 09:15:48','admin'),(34,'Account Management','Modify','admin edited a system account with Account ID 3: Ben Schofield (ben@nwk1.com). Ben Schofield has Administrator Privileges, Ben Schofield can Approve the Rules created by others, Ben Schofield\'s Rules require approval and Ben Schofield is not locked out. admin also changed Ben Schofield\'s password.','2014-10-24 09:15:53','admin'),(35,'Account Management','View','admin accessed Account Management.','2014-10-24 09:15:54','admin'),(36,'Account Management','View','Ben Schofield accessed Account Management.','2014-10-24 09:16:03','Ben Schofield'),(37,'Users','Add','Ben Schofield added UnixUser1, set it Active and to not expire. The system assigned it User ID 1.','2014-10-24 09:17:40','Ben Schofield'),(38,'Users','Add','Ben Schofield added UnixUser2, set it Active and to not expire. The system assigned it User ID 2.','2014-10-24 09:17:46','Ben Schofield'),(39,'Users','Add','Ben Schofield added UnixUser3, set it Active and to not expire. The system assigned it User ID 3.','2014-10-24 09:17:53','Ben Schofield'),(40,'Users','Add','Ben Schofield added DBAUser1, set it Active and to not expire. The system assigned it User ID 4.','2014-10-24 09:21:05','Ben Schofield'),(41,'Users','Add','Ben Schofield added DBAUser2, set it Active and to not expire. The system assigned it User ID 5.','2014-10-24 09:21:13','Ben Schofield'),(42,'Users','Add','Ben Schofield added DBAUser3, set it Active and to not expire. The system assigned it User ID 6.','2014-10-24 09:21:19','Ben Schofield'),(43,'Users','Modify','Ben Schofield modified User ID 5. The new entry is recorded as DBAUser2, set Active and expires on 2014-10-24.','2014-10-24 09:21:30','Ben Schofield'),(44,'Users','Modify','Ben Schofield modified User ID 1. The new entry is recorded as UnixUser1, set Inactive and does not expire.','2014-10-24 09:22:13','Ben Schofield'),(45,'User Groups','Add','Ben Schofield added UnixUsers as a Sudoers Group, set it Active and to not expire. 3 users were attached: UnixUser3, UnixUser2, UnixUser1. The system assigned it User Group ID 1.','2014-10-24 09:23:04','Ben Schofield'),(46,'User Groups','Add','Ben Schofield added DatabaseUsers as a Sudoers Group, set it Active and to not expire. 3 users were attached: DBAUser3, DBAUser2, DBAUser1. The system assigned it User Group ID 2.','2014-10-24 09:23:29','Ben Schofield'),(47,'Commands','Add','Ben Schofield added ApacheStart (/etc/init.d/httpd start), set it Active and to not expire. The system assigned it Command ID 1.','2014-10-24 09:25:48','Ben Schofield'),(48,'Commands','Add','Ben Schofield added ApacheRestart (/etc/init.d/httpd restart), set it Active and to not expire. The system assigned it Command ID 2.','2014-10-24 09:26:04','Ben Schofield'),(49,'Commands','Add','Ben Schofield added ApacheStop (/etc/init.d/httpd stop), set it Active and to not expire. The system assigned it Command ID 3.','2014-10-24 09:26:17','Ben Schofield'),(50,'Commands','Add','Ben Schofield added MySQLStart (/etc/init.d/mysqld start), set it Active and to not expire. The system assigned it Command ID 4.','2014-10-24 09:27:00','Ben Schofield'),(51,'Commands','Add','Ben Schofield added MySQLRestart (/etc/init.d/mysqld restart), set it Active and to not expire. The system assigned it Command ID 5.','2014-10-24 09:27:14','Ben Schofield'),(52,'Commands','Add','Ben Schofield added MySQLStop (/etc/init.d/mysqld stop), set it Active and to not expire. The system assigned it Command ID 6.','2014-10-24 09:27:29','Ben Schofield'),(53,'Command Groups','Add','Ben Schofield added ApacheServiceControl, set it Active and to not expire. 3 commands were attached: ApacheStop, ApacheStart, ApacheRestart. The system assigned it Command Group ID 1.','2014-10-24 09:28:10','Ben Schofield'),(54,'Command Groups','Add','Ben Schofield added MySQLServiceControl, set it Active and to not expire. 3 commands were attached: MySQLStop, MySQLStart, MySQLRestart. The system assigned it Command Group ID 2.','2014-10-24 09:29:13','Ben Schofield'),(55,'Rules','Add','Ben Schofield added ApacheServerControl (to be run as root, with the PASSWD and EXEC flags), set it Active and to not expire. The system assigned it Rule ID 1.','2014-10-24 09:30:09','Ben Schofield'),(56,'Rules','Modify','Ben Schofield added Host Group ApplicationServers [Host Group ID 3] to Rule ApacheServerControl [Rule ID 1]','2014-10-24 09:30:09','Ben Schofield'),(57,'Rules','Modify','Ben Schofield added User Group UnixUsers [User Group ID 1] to Rule ApacheServerControl [Rule ID 1]','2014-10-24 09:30:09','Ben Schofield'),(58,'Rules','Modify','Ben Schofield added Command Group ApacheServiceControl [Command Group ID 1] to Rule ApacheServerControl [Rule ID 1]','2014-10-24 09:30:09','Ben Schofield'),(59,'Rules','Add','Ben Schofield added MySQLServerControl (to be run as root, with the PASSWD and EXEC flags), set it Active and to not expire. The system assigned it Rule ID 2.','2014-10-24 09:31:20','Ben Schofield'),(60,'Rules','Modify','Ben Schofield added Host Group DatabaseServers [Host Group ID 4] to Rule MySQLServerControl [Rule ID 2]','2014-10-24 09:31:20','Ben Schofield'),(61,'Rules','Modify','Ben Schofield added User Group DatabaseUsers [User Group ID 2] to Rule MySQLServerControl [Rule ID 2]','2014-10-24 09:31:20','Ben Schofield'),(62,'Rules','Modify','Ben Schofield added Command Group MySQLServiceControl [Command Group ID 2] to Rule MySQLServerControl [Rule ID 2]','2014-10-24 09:31:20','Ben Schofield'),(63,'Rules','Approve','Rodney Apple Approved ApacheServerControl [Rule ID 1].','2014-10-24 09:31:35','Rodney Apple'),(64,'Rules','Approve','Rodney Apple Approved MySQLServerControl [Rule ID 2].','2014-10-24 09:31:37','Rodney Apple'),(65,'Sudoers','Deployment Succeeded','Configuration changes were detected and a new sudoers file was built, passed visudo validation, and MD5 checksums as follows: MD5: 3669b01d9773302cb89489d6302cf504. A copy of this sudoers has been stored at \'/var/www/html/sudoers-storage/sudoers_3669b01d9773302cb89489d6302cf504\' for future reference.','2014-10-24 09:32:39','System'),(66,'Access Log','View','Ben Schofield accessed Distribution Status.','2014-10-24 09:33:17','Ben Schofield');
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
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credentials`
--

LOCK TABLES `credentials` WRITE;
/*!40000 ALTER TABLE `credentials` DISABLE KEYS */;
INSERT INTO `credentials` VALUES (2,'admin','6a3f8b7f7685efe62ae6491d9d616fc6a0eb930a2d571cce840f28232e32ab4959371e6d1517318f1e9fb9bdae61b1b21342aa703c34248e436b8dd937e90626','Q920DIo}QtlxC37DsIZG46SY+l-Dz6d<Bp-Af;pttf!#0MqlOTsa:s<has1xwz/','devnull@','2014-10-24 22:15:42','2014-10-24 22:15:54',1,0,1,0,0,'0','2014-10-24 09:15:54','admin'),(3,'Ben Schofield','8f39112adb4011b05ba1bc9af5eb8e4a28e012f265df0594cc71dfdca3c90fccd39e31555844f0b6aed6baded5dec31950f49f523c55abe0733a94630904934a','l}:Wzr7Go;ahP_D1q/wZRmG23tTnQLOw9xvOgqTwb.M|psDYhkCMejZMqI5RFhaw','ben@nwk1.com','2014-10-24 22:33:07','2014-10-24 22:33:17',1,1,1,0,0,'0','2014-10-24 09:33:17','admin'),(4,'Rodney Apple','4ca516c3898bc0b0a8d635f60c2310e43f2d6c3861af6b2d145aa6f812ba82713e329f0785832665b243a07cc3e8e728fb76f760d2ccf22a26c94f64bf0bc526','HNrTTstU,c3-?BA36@!lVRfE&&H4&z&gZCsi:Z4.fZ?ku*B>dCQ{|}?uXSr1YPp0','blabla@','2014-10-24 22:31:51','2014-10-24 22:32:57',0,1,1,0,0,'0','2014-10-24 09:32:57','admin');
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
  `sftp_port` int(5) NOT NULL DEFAULT '22',
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
INSERT INTO `distribution` VALUES (1,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprdapp01 (127.0.0.1). Sudoers MD5: 3669b01d9773302cb89489d6302cf504\n','2014-10-24 22:32:50','2014-10-24 22:07:53','admin'),(2,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprdapp02 (127.0.0.2). Sudoers MD5: 3669b01d9773302cb89489d6302cf504\n','2014-10-24 22:32:50','2014-10-24 22:08:04','admin'),(3,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprddb01 (127.0.1.1). Sudoers MD5: 3669b01d9773302cb89489d6302cf504\n','2014-10-24 22:32:51','2014-10-24 22:08:27','admin'),(4,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to wlgprddb02 (127.0.1.2). Sudoers MD5: 3669b01d9773302cb89489d6302cf504\n','2014-10-24 22:32:51','2014-10-24 22:08:39','admin'),(5,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to aklprdapp01 (127.1.0.1). Sudoers MD5: 3669b01d9773302cb89489d6302cf504\n','2014-10-24 22:32:43','2014-10-24 22:09:11','admin'),(6,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','Connection Failed: Connection to remote server is broken \n    Hints: \n    1) Incorrect user name\n    2) Incorrect IP address or port\n    3) Key identity file not found\n    4) Insufficient permissions to read key identity file','2014-10-24 22:32:46','2014-10-24 22:09:24','admin'),(7,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to aklprddb01 (127.1.1.1). Sudoers MD5: 3669b01d9773302cb89489d6302cf504\n','2014-10-24 22:32:48','2014-10-24 22:09:45','admin'),(8,22,'transport','/root/.ssh/id_rsa',15,'upload/sudoers','OK: upload/sudoers written successfully to aklprddb02 (127.1.1.2). Sudoers MD5: 3669b01d9773302cb89489d6302cf504\n','2014-10-24 22:32:50','2014-10-24 22:10:07','admin');
/*!40000 ALTER TABLE `distribution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lock`
--

DROP TABLE IF EXISTS `lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lock` (
  `sudoers-build` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sudoers-build`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lock`
--

LOCK TABLES `lock` WRITE;
/*!40000 ALTER TABLE `lock` DISABLE KEYS */;
INSERT INTO `lock` VALUES (0);
/*!40000 ALTER TABLE `lock` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-10-24 22:36:00
