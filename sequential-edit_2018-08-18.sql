# ************************************************************
# Sequel Pro SQL dump
# Version 4499
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: localhost (MySQL 5.6.38)
# Database: sequential-edit
# Generation Time: 2018-08-18 10:39:52 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table assetindexdata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assetindexdata`;

CREATE TABLE `assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) NOT NULL DEFAULT '',
  `volumeId` int(11) NOT NULL,
  `uri` text,
  `size` bigint(20) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `recordId` int(11) DEFAULT NULL,
  `inProgress` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assetindexdata_sessionId_volumeId_idx` (`sessionId`,`volumeId`),
  KEY `assetindexdata_volumeId_idx` (`volumeId`),
  CONSTRAINT `assetindexdata_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table assets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assets`;

CREATE TABLE `assets` (
  `id` int(11) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `kind` varchar(50) NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `focalPoint` varchar(13) DEFAULT NULL,
  `dateModified` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assets_filename_folderId_unq_idx` (`filename`,`folderId`),
  KEY `assets_folderId_idx` (`folderId`),
  KEY `assets_volumeId_idx` (`volumeId`),
  CONSTRAINT `assets_folderId_fk` FOREIGN KEY (`folderId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table assettransformindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assettransformindex`;

CREATE TABLE `assettransformindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assetId` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `fileExists` tinyint(1) NOT NULL DEFAULT '0',
  `inProgress` tinyint(1) NOT NULL DEFAULT '0',
  `dateIndexed` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `assettransformindex_volumeId_assetId_location_idx` (`volumeId`,`assetId`,`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table assettransforms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assettransforms`;

CREATE TABLE `assettransforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `mode` enum('stretch','fit','crop') NOT NULL DEFAULT 'crop',
  `position` enum('top-left','top-center','top-right','center-left','center-center','center-right','bottom-left','bottom-center','bottom-right') NOT NULL DEFAULT 'center-center',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `quality` int(11) DEFAULT NULL,
  `interlace` enum('none','line','plane','partition') NOT NULL DEFAULT 'none',
  `dimensionChangeTime` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `assettransforms_name_unq_idx` (`name`),
  UNIQUE KEY `assettransforms_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `categories_groupId_idx` (`groupId`),
  CONSTRAINT `categories_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categories_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table categorygroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `categorygroups`;

CREATE TABLE `categorygroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_name_unq_idx` (`name`),
  UNIQUE KEY `categorygroups_handle_unq_idx` (`handle`),
  KEY `categorygroups_structureId_idx` (`structureId`),
  KEY `categorygroups_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `categorygroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `categorygroups_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table categorygroups_sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `categorygroups_sites`;

CREATE TABLE `categorygroups_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorygroups_sites_groupId_siteId_unq_idx` (`groupId`,`siteId`),
  KEY `categorygroups_sites_siteId_idx` (`siteId`),
  CONSTRAINT `categorygroups_sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `categorygroups_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table content
# ------------------------------------------------------------

DROP TABLE IF EXISTS `content`;

CREATE TABLE `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `content_siteId_idx` (`siteId`),
  KEY `content_title_idx` (`title`),
  CONSTRAINT `content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `content` WRITE;
/*!40000 ALTER TABLE `content` DISABLE KEYS */;

INSERT INTO `content` (`id`, `elementId`, `siteId`, `title`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,NULL,'2018-08-18 10:27:56','2018-08-18 10:27:56','c2f6193f-f754-4874-9989-4ef8f67abd7f'),
	(2,2,1,'Test Entry 1','2018-08-18 10:35:17','2018-08-18 10:38:10','867ffd74-2a98-4698-b0b2-79f48fb81640'),
	(3,3,1,'Test Child 1','2018-08-18 10:35:30','2018-08-18 10:38:10','265912df-ba51-4f5f-94bd-67fc93b61065'),
	(4,4,1,'Test Child 2','2018-08-18 10:35:39','2018-08-18 10:38:10','ea794fcf-5466-47bc-915c-1274ddd62c79'),
	(5,5,1,'Test Entry 2','2018-08-18 10:35:49','2018-08-18 10:38:10','aae59cc5-537b-4664-995e-6ee057a84b00'),
	(6,6,1,'Test Entry 3','2018-08-18 10:36:00','2018-08-18 10:38:10','e03960b0-b5bd-4757-8769-075433834215'),
	(8,8,1,'Test Entry 5','2018-08-18 10:36:41','2018-08-18 10:38:10','e580a040-49c9-4843-be36-76fa42a2c0a9'),
	(9,9,1,'Test Entry 4','2018-08-18 10:36:52','2018-08-18 10:38:10','926e59ba-3ebc-4a5b-8191-a81784944020'),
	(10,10,1,'Test Entry 6','2018-08-18 10:37:05','2018-08-18 10:38:10','397daa09-ea4f-4659-9f56-615ccb6ffbd5'),
	(11,11,1,'Test Entry 7','2018-08-18 10:37:11','2018-08-18 10:38:10','718f9920-66cf-4b66-8ddf-36f6a91c5ec8'),
	(12,12,1,'Test Entry 8','2018-08-18 10:37:17','2018-08-18 10:38:10','a76054b0-b8bf-4256-8303-18e001666c15'),
	(13,13,1,'Test Entry 9','2018-08-18 10:37:25','2018-08-18 10:38:10','dfdf7643-856e-4457-9a33-854650900614'),
	(14,14,1,'Test Entry 11','2018-08-18 10:37:34','2018-08-18 10:38:10','3485bc1c-0c04-418a-bd55-b8470311910b');

/*!40000 ALTER TABLE `content` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craftidtokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craftidtokens`;

CREATE TABLE `craftidtokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `accessToken` text NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craftidtokens_userId_fk` (`userId`),
  CONSTRAINT `craftidtokens_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table deprecationerrors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `deprecationerrors`;

CREATE TABLE `deprecationerrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `fingerprint` varchar(255) NOT NULL,
  `lastOccurrence` datetime NOT NULL,
  `file` varchar(255) NOT NULL,
  `line` smallint(6) unsigned DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `traces` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `deprecationerrors_key_fingerprint_unq_idx` (`key`,`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table elementindexsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `elementindexsettings`;

CREATE TABLE `elementindexsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elementindexsettings_type_unq_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `elements`;

CREATE TABLE `elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `elements_fieldLayoutId_idx` (`fieldLayoutId`),
  KEY `elements_type_idx` (`type`),
  KEY `elements_enabled_idx` (`enabled`),
  KEY `elements_archived_dateCreated_idx` (`archived`,`dateCreated`),
  CONSTRAINT `elements_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `elements` WRITE;
/*!40000 ALTER TABLE `elements` DISABLE KEYS */;

INSERT INTO `elements` (`id`, `fieldLayoutId`, `type`, `enabled`, `archived`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'craft\\elements\\User',1,0,'2018-08-18 10:27:56','2018-08-18 10:27:56','c908714f-c9fe-4e3d-89c8-4114bdb8c8ce'),
	(2,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:35:17','2018-08-18 10:38:10','4718fdbe-6d1c-420f-9ce0-9287f7a90a6a'),
	(3,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:35:30','2018-08-18 10:38:10','66e01134-ba54-4298-be40-707c0e8d0df2'),
	(4,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:35:39','2018-08-18 10:38:10','65f673fa-3530-46ff-a751-47c4ca0a843e'),
	(5,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:35:49','2018-08-18 10:38:10','b193be56-730b-45bf-b783-203efefcaaf8'),
	(6,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:36:00','2018-08-18 10:38:10','07abe2c0-ad7c-495c-8ea7-47bb3f630d51'),
	(8,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:36:41','2018-08-18 10:38:10','3daba5b9-5b7a-4677-9e04-2d41b9c292d3'),
	(9,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:36:52','2018-08-18 10:38:10','8866d66b-8de0-449a-9932-e6df2561ef86'),
	(10,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:37:05','2018-08-18 10:38:10','037062db-f7c9-44b2-8ae1-83335e847ce7'),
	(11,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:37:11','2018-08-18 10:38:10','3aad6c62-6c85-4b6b-9179-28e6ae55ff45'),
	(12,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:37:17','2018-08-18 10:38:10','e287079e-b33f-4fab-a501-9f194b0628e4'),
	(13,2,'craft\\elements\\Entry',1,0,'2018-08-18 10:37:25','2018-08-18 10:38:10','4bbe127b-255f-4199-8238-107f8e448939'),
	(14,1,'craft\\elements\\Entry',1,0,'2018-08-18 10:37:34','2018-08-18 10:38:10','4e7024da-4f35-437c-8419-4b3297d9b5c0');

/*!40000 ALTER TABLE `elements` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table elements_sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `elements_sites`;

CREATE TABLE `elements_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `elements_sites_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  UNIQUE KEY `elements_sites_uri_siteId_unq_idx` (`uri`,`siteId`),
  KEY `elements_sites_siteId_idx` (`siteId`),
  KEY `elements_sites_slug_siteId_idx` (`slug`,`siteId`),
  KEY `elements_sites_enabled_idx` (`enabled`),
  CONSTRAINT `elements_sites_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `elements_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `elements_sites` WRITE;
/*!40000 ALTER TABLE `elements_sites` DISABLE KEYS */;

INSERT INTO `elements_sites` (`id`, `elementId`, `siteId`, `slug`, `uri`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,NULL,NULL,1,'2018-08-18 10:27:56','2018-08-18 10:27:56','0722f870-ace5-4618-b53d-38ff98d593e9'),
	(2,2,1,'test-entry-1','test/test-entry-1',1,'2018-08-18 10:35:17','2018-08-18 10:38:10','98af1965-091f-49d9-bec1-53330e44e9cf'),
	(3,3,1,'test-child-1','test/test-child-1',1,'2018-08-18 10:35:30','2018-08-18 10:38:10','645247c1-6b37-4d3d-8750-6bacbf695989'),
	(4,4,1,'test-child-2','test/test-child-2',1,'2018-08-18 10:35:39','2018-08-18 10:38:10','b41bc94b-c432-46c3-944d-596e572e3b63'),
	(5,5,1,'test-entry-2','test/test-entry-2',1,'2018-08-18 10:35:49','2018-08-18 10:38:10','dfc3fbd1-795d-4280-aeca-a8ec086c5488'),
	(6,6,1,'test-entry-3','test/test-entry-3',1,'2018-08-18 10:36:00','2018-08-18 10:38:10','1c8c9802-2de6-43a1-935d-e3adeac2b86f'),
	(8,8,1,'test-entry-5','test/test-entry-5',1,'2018-08-18 10:36:41','2018-08-18 10:38:10','0a2cbc2a-506a-4719-abf6-8534c02c335a'),
	(9,9,1,'test-entry-4','test/test-entry-4',1,'2018-08-18 10:36:52','2018-08-18 10:38:10','f9789687-4990-42e2-8bfb-cb471aff6fbe'),
	(10,10,1,'test-entry-6','test/test-entry-6',1,'2018-08-18 10:37:05','2018-08-18 10:38:10','05215ffe-0177-43cb-9db1-175311cda51f'),
	(11,11,1,'test-entry-7','test/test-entry-7',1,'2018-08-18 10:37:11','2018-08-18 10:38:10','e45c874d-c164-4ade-92fe-baf185c6ef1d'),
	(12,12,1,'test-entry-8','test/test-entry-8',1,'2018-08-18 10:37:17','2018-08-18 10:38:10','66b33027-d7e4-4c75-8911-5c5835ecf83c'),
	(13,13,1,'test-entry-9','test/test-entry-9',1,'2018-08-18 10:37:25','2018-08-18 10:38:10','076058df-629b-494d-801f-043a49bd4d1e'),
	(14,14,1,'test-entry-11','test/test-entry-11',1,'2018-08-18 10:37:34','2018-08-18 10:38:10','c726dd99-e230-46d0-a359-43e2d261f201');

/*!40000 ALTER TABLE `elements_sites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table entries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entries`;

CREATE TABLE `entries` (
  `id` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entries_postDate_idx` (`postDate`),
  KEY `entries_expiryDate_idx` (`expiryDate`),
  KEY `entries_authorId_idx` (`authorId`),
  KEY `entries_sectionId_idx` (`sectionId`),
  KEY `entries_typeId_idx` (`typeId`),
  CONSTRAINT `entries_authorId_fk` FOREIGN KEY (`authorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entries_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `entrytypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `entries` WRITE;
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;

INSERT INTO `entries` (`id`, `sectionId`, `typeId`, `authorId`, `postDate`, `expiryDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(2,1,1,1,'2018-08-18 10:35:00',NULL,'2018-08-18 10:35:17','2018-08-18 10:38:10','a147abef-b6fc-4ad1-9840-13a99a2649ae'),
	(3,1,1,1,'2018-08-18 10:35:00',NULL,'2018-08-18 10:35:30','2018-08-18 10:38:10','e5f8f2ea-9e05-4388-aa82-efbfb836eb66'),
	(4,1,1,1,'2018-08-18 10:35:00',NULL,'2018-08-18 10:35:39','2018-08-18 10:38:10','ac623e4c-9a83-4b60-9ae1-34498474d863'),
	(5,1,1,1,'2018-08-18 10:35:00',NULL,'2018-08-18 10:35:49','2018-08-18 10:38:10','9918e604-6fe6-4f84-aa29-b5dd71478fca'),
	(6,1,1,1,'2018-08-18 10:36:00',NULL,'2018-08-18 10:36:00','2018-08-18 10:38:10','b6243a7c-cbd3-45bb-8f17-ac7ebcfbcee2'),
	(8,1,1,1,'2018-08-18 10:36:00',NULL,'2018-08-18 10:36:41','2018-08-18 10:38:10','7e4e3135-ddd7-4682-a7f1-8fe3e81578ac'),
	(9,1,1,1,'2018-08-18 10:36:00',NULL,'2018-08-18 10:36:52','2018-08-18 10:38:10','8b7fdb9a-4bfe-4e9d-bcf3-fadd681b0cd7'),
	(10,1,1,1,'2018-08-18 10:37:00',NULL,'2018-08-18 10:37:05','2018-08-18 10:38:10','d3ae22dc-0e8c-4a55-bad8-a95ba7ed64c0'),
	(11,1,1,1,'2018-08-18 10:37:00',NULL,'2018-08-18 10:37:11','2018-08-18 10:38:10','d40c7840-75ed-477e-85e2-47cca484884c'),
	(12,1,1,1,'2018-08-18 10:37:00',NULL,'2018-08-18 10:37:17','2018-08-18 10:38:10','c5e6c4c8-2910-4c5a-952c-eba31412e8db'),
	(13,1,2,1,'2018-08-18 10:37:00',NULL,'2018-08-18 10:37:25','2018-08-18 10:38:10','d98a8ddf-b09b-4c92-ad29-8e40df26054e'),
	(14,1,1,1,'2018-08-18 10:37:00',NULL,'2018-08-18 10:37:34','2018-08-18 10:38:10','dddbc2b4-55eb-4bff-9613-79f4f2a79b66');

/*!40000 ALTER TABLE `entries` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table entrydrafts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entrydrafts`;

CREATE TABLE `entrydrafts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entrydrafts_sectionId_idx` (`sectionId`),
  KEY `entrydrafts_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entrydrafts_siteId_idx` (`siteId`),
  KEY `entrydrafts_creatorId_idx` (`creatorId`),
  CONSTRAINT `entrydrafts_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entrydrafts_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table entrytypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entrytypes`;

CREATE TABLE `entrytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `hasTitleField` tinyint(1) NOT NULL DEFAULT '1',
  `titleLabel` varchar(255) DEFAULT 'Title',
  `titleFormat` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `entrytypes_name_sectionId_unq_idx` (`name`,`sectionId`),
  UNIQUE KEY `entrytypes_handle_sectionId_unq_idx` (`handle`,`sectionId`),
  KEY `entrytypes_sectionId_idx` (`sectionId`),
  KEY `entrytypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `entrytypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entrytypes_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `entrytypes` WRITE;
/*!40000 ALTER TABLE `entrytypes` DISABLE KEYS */;

INSERT INTO `entrytypes` (`id`, `sectionId`, `fieldLayoutId`, `name`, `handle`, `hasTitleField`, `titleLabel`, `titleFormat`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,'Type 1','type1',1,'Title',NULL,1,'2018-08-18 10:34:00','2018-08-18 10:34:17','d9c5cfc4-fe68-4beb-864e-c0ed1a154124'),
	(2,1,2,'Type 2','type2',1,'Title',NULL,2,'2018-08-18 10:34:24','2018-08-18 10:34:24','7882a316-9d25-4ad2-9c62-2de048ce0d34');

/*!40000 ALTER TABLE `entrytypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table entryversions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `entryversions`;

CREATE TABLE `entryversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `siteId` int(11) NOT NULL,
  `num` smallint(6) unsigned NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `entryversions_sectionId_idx` (`sectionId`),
  KEY `entryversions_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `entryversions_siteId_idx` (`siteId`),
  KEY `entryversions_creatorId_idx` (`creatorId`),
  CONSTRAINT `entryversions_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `entryversions_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `entryversions_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `entryversions` WRITE;
/*!40000 ALTER TABLE `entryversions` DISABLE KEYS */;

INSERT INTO `entryversions` (`id`, `entryId`, `sectionId`, `creatorId`, `siteId`, `num`, `notes`, `data`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,2,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 1\",\"slug\":\"test-entry-1\",\"postDate\":1534588500,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:35:17','2018-08-18 10:35:17','403a053e-b132-4978-8960-72ab7357f0d7'),
	(2,3,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Child 1\",\"slug\":\"test-child-1\",\"postDate\":1534588500,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"2\",\"fields\":[]}','2018-08-18 10:35:31','2018-08-18 10:35:31','35c20ac6-b7f2-425c-9f0f-57e29085caa8'),
	(3,4,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Child 2\",\"slug\":\"test-child-2\",\"postDate\":1534588500,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"2\",\"fields\":[]}','2018-08-18 10:35:39','2018-08-18 10:35:39','08db4e4e-7489-4192-ac98-69ee05ab736f'),
	(4,5,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 2\",\"slug\":\"test-entry-2\",\"postDate\":1534588500,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:35:49','2018-08-18 10:35:49','3d374255-ac90-4661-af43-cff4ee65bc5f'),
	(5,6,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 3\",\"slug\":\"test-entry-3\",\"postDate\":1534588560,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:36:01','2018-08-18 10:36:01','b7808a92-df34-4e2b-a4c6-addd1882217a'),
	(7,8,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 5\",\"slug\":\"test-entry-5\",\"postDate\":1534588560,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:36:41','2018-08-18 10:36:41','0b1c986d-41b4-4bac-b138-21e8da6032b5'),
	(8,9,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 4\",\"slug\":\"test-entry-4\",\"postDate\":1534588560,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:36:52','2018-08-18 10:36:52','2975c66c-8377-4eea-af74-4d97013a12c4'),
	(9,10,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 6\",\"slug\":\"test-entry-6\",\"postDate\":1534588620,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:37:05','2018-08-18 10:37:05','98229833-7b2e-4235-9ba3-3ddc3eebd4cf'),
	(10,11,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 7\",\"slug\":\"test-entry-7\",\"postDate\":1534588620,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:37:11','2018-08-18 10:37:11','9a65887f-7c45-4e7d-a1cb-a1706691783d'),
	(11,12,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 8\",\"slug\":\"test-entry-8\",\"postDate\":1534588620,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:37:17','2018-08-18 10:37:17','73089bbd-a1ec-46dd-9222-e57d74b2ee52'),
	(12,13,1,1,1,1,'','{\"typeId\":\"2\",\"authorId\":\"1\",\"title\":\"Test Entry 9\",\"slug\":\"test-entry-9\",\"postDate\":1534588620,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:37:25','2018-08-18 10:37:25','5bb1e6b0-fead-4066-a256-3dc934959bb0'),
	(13,14,1,1,1,1,'','{\"typeId\":\"1\",\"authorId\":\"1\",\"title\":\"Test Entry 11\",\"slug\":\"test-entry-11\",\"postDate\":1534588620,\"expiryDate\":null,\"enabled\":true,\"newParentId\":\"\",\"fields\":[]}','2018-08-18 10:37:34','2018-08-18 10:37:34','b2f30342-f60c-44a2-a06a-9a42f477e8fb');

/*!40000 ALTER TABLE `entryversions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table fieldgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldgroups`;

CREATE TABLE `fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `fieldgroups` WRITE;
/*!40000 ALTER TABLE `fieldgroups` DISABLE KEYS */;

INSERT INTO `fieldgroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Common','2018-08-18 10:27:56','2018-08-18 10:27:56','9f7581d0-6c52-4dcc-94b7-1d47a89f3f12');

/*!40000 ALTER TABLE `fieldgroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table fieldlayoutfields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldlayoutfields`;

CREATE TABLE `fieldlayoutfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `tabId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fieldlayoutfields_layoutId_fieldId_unq_idx` (`layoutId`,`fieldId`),
  KEY `fieldlayoutfields_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayoutfields_tabId_idx` (`tabId`),
  KEY `fieldlayoutfields_fieldId_idx` (`fieldId`),
  CONSTRAINT `fieldlayoutfields_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fieldlayoutfields_tabId_fk` FOREIGN KEY (`tabId`) REFERENCES `fieldlayouttabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table fieldlayouts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldlayouts`;

CREATE TABLE `fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `fieldlayouts` WRITE;
/*!40000 ALTER TABLE `fieldlayouts` DISABLE KEYS */;

INSERT INTO `fieldlayouts` (`id`, `type`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'craft\\elements\\Entry','2018-08-18 10:34:00','2018-08-18 10:34:17','88d4923f-45ab-418a-b9f0-052c8a250f47'),
	(2,'craft\\elements\\Entry','2018-08-18 10:34:24','2018-08-18 10:34:24','7ff70a75-3b1c-49a0-87b1-d74b7ede6fc9');

/*!40000 ALTER TABLE `fieldlayouts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table fieldlayouttabs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fieldlayouttabs`;

CREATE TABLE `fieldlayouttabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fieldlayouttabs_sortOrder_idx` (`sortOrder`),
  KEY `fieldlayouttabs_layoutId_idx` (`layoutId`),
  CONSTRAINT `fieldlayouttabs_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table fields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fields`;

CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(64) NOT NULL,
  `context` varchar(255) NOT NULL DEFAULT 'global',
  `instructions` text,
  `translationMethod` varchar(255) NOT NULL DEFAULT 'none',
  `translationKeyFormat` text,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fields_handle_context_unq_idx` (`handle`,`context`),
  KEY `fields_groupId_idx` (`groupId`),
  KEY `fields_context_idx` (`context`),
  CONSTRAINT `fields_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `fieldgroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table globalsets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `globalsets`;

CREATE TABLE `globalsets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `globalsets_name_unq_idx` (`name`),
  UNIQUE KEY `globalsets_handle_unq_idx` (`handle`),
  KEY `globalsets_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `globalsets_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `globalsets_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table info
# ------------------------------------------------------------

DROP TABLE IF EXISTS `info`;

CREATE TABLE `info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(50) NOT NULL,
  `schemaVersion` varchar(15) NOT NULL,
  `edition` tinyint(3) unsigned NOT NULL,
  `timezone` varchar(30) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `on` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `fieldVersion` char(12) NOT NULL DEFAULT '000000000000',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `info` WRITE;
/*!40000 ALTER TABLE `info` DISABLE KEYS */;

INSERT INTO `info` (`id`, `version`, `schemaVersion`, `edition`, `timezone`, `name`, `on`, `maintenance`, `fieldVersion`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'3.0.20','3.0.91',0,'America/Los_Angeles','Sequential Edit',1,0,'nfFXcLLKwP0g','2018-08-18 10:27:56','2018-08-18 10:27:56','403dedb3-20f2-4e8b-82ca-0c9c15f091bf');

/*!40000 ALTER TABLE `info` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table matrixblocks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `matrixblocks`;

CREATE TABLE `matrixblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `ownerSiteId` int(11) DEFAULT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `matrixblocks_ownerId_idx` (`ownerId`),
  KEY `matrixblocks_fieldId_idx` (`fieldId`),
  KEY `matrixblocks_typeId_idx` (`typeId`),
  KEY `matrixblocks_sortOrder_idx` (`sortOrder`),
  KEY `matrixblocks_ownerSiteId_idx` (`ownerSiteId`),
  CONSTRAINT `matrixblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocks_ownerSiteId_fk` FOREIGN KEY (`ownerSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `matrixblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `matrixblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table matrixblocktypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `matrixblocktypes`;

CREATE TABLE `matrixblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `matrixblocktypes_name_fieldId_unq_idx` (`name`,`fieldId`),
  UNIQUE KEY `matrixblocktypes_handle_fieldId_unq_idx` (`handle`,`fieldId`),
  KEY `matrixblocktypes_fieldId_idx` (`fieldId`),
  KEY `matrixblocktypes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `matrixblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `matrixblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pluginId` int(11) DEFAULT NULL,
  `type` enum('app','plugin','content') NOT NULL DEFAULT 'app',
  `name` varchar(255) NOT NULL,
  `applyTime` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `migrations_pluginId_idx` (`pluginId`),
  KEY `migrations_type_pluginId_idx` (`type`,`pluginId`),
  CONSTRAINT `migrations_pluginId_fk` FOREIGN KEY (`pluginId`) REFERENCES `plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;

INSERT INTO `migrations` (`id`, `pluginId`, `type`, `name`, `applyTime`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'app','Install','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','7821ef30-8c06-40e1-80ce-4e9f17bda83d'),
	(2,NULL,'app','m150403_183908_migrations_table_changes','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','515b950f-ffb6-4af8-9c0d-462d448b4fb9'),
	(3,NULL,'app','m150403_184247_plugins_table_changes','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','dd130edb-ea8d-4adf-984e-cefbd972bda2'),
	(4,NULL,'app','m150403_184533_field_version','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','ecd2b985-8007-43ba-98db-d5a79cbad584'),
	(5,NULL,'app','m150403_184729_type_columns','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','9f900291-ba85-4579-9d52-d55c5ff679e5'),
	(6,NULL,'app','m150403_185142_volumes','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','96ccd629-2b3e-4a6c-b85d-f18a7335931b'),
	(7,NULL,'app','m150428_231346_userpreferences','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','12e62d23-1c13-484d-9475-30006edd56f1'),
	(8,NULL,'app','m150519_150900_fieldversion_conversion','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','0f4e7539-6d60-4fc8-a2d0-2c01dd90d9c6'),
	(9,NULL,'app','m150617_213829_update_email_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','3ccd1e88-be8d-48c1-ade5-13340e6e03ac'),
	(10,NULL,'app','m150721_124739_templatecachequeries','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','818d2646-63b3-4ad7-b651-59ce4672f8bb'),
	(11,NULL,'app','m150724_140822_adjust_quality_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','857d6b28-c850-47aa-ab74-b17152cbcfab'),
	(12,NULL,'app','m150815_133521_last_login_attempt_ip','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','c098b3d6-eb4f-4e4c-ae97-8f4d99168ce0'),
	(13,NULL,'app','m151002_095935_volume_cache_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','772f62f5-6d7f-4caf-a214-a235160fa07e'),
	(14,NULL,'app','m151005_142750_volume_s3_storage_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','49a103ad-94bb-4998-af2a-f8f925e331a1'),
	(15,NULL,'app','m151016_133600_delete_asset_thumbnails','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','5b83f0e7-736a-45a0-bcbf-4c20894d074d'),
	(16,NULL,'app','m151209_000000_move_logo','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','9de2a124-7ad6-4cb1-b234-e8d405492e29'),
	(17,NULL,'app','m151211_000000_rename_fileId_to_assetId','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','fdbf0bf2-cea6-4f56-8720-2e6aeaf86ea7'),
	(18,NULL,'app','m151215_000000_rename_asset_permissions','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','87b71c2e-a0f9-4fe4-89d9-c2a0154960ad'),
	(19,NULL,'app','m160707_000001_rename_richtext_assetsource_setting','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','7e333db5-8aa9-4166-b22f-76ee81910d9b'),
	(20,NULL,'app','m160708_185142_volume_hasUrls_setting','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','bee39982-9d9a-4593-8c16-60285c4ccd8c'),
	(21,NULL,'app','m160714_000000_increase_max_asset_filesize','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','5978f18e-f862-4d32-abfe-69d18c56d17a'),
	(22,NULL,'app','m160727_194637_column_cleanup','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','1cbec14d-4d4c-46c8-a97f-1dd6136f0ce9'),
	(23,NULL,'app','m160804_110002_userphotos_to_assets','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','a41abe61-67d3-435a-a36e-11c6f3936e98'),
	(24,NULL,'app','m160807_144858_sites','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','40cd3fa4-7001-49c4-b29f-3524711763c0'),
	(25,NULL,'app','m160829_000000_pending_user_content_cleanup','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','ae325714-e68c-4c9d-870c-b75f8b868e68'),
	(26,NULL,'app','m160830_000000_asset_index_uri_increase','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','00a50234-3b3d-456d-876c-b20e3114a077'),
	(27,NULL,'app','m160912_230520_require_entry_type_id','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','8623a6f9-c66a-4d11-96e2-11587cc44f62'),
	(28,NULL,'app','m160913_134730_require_matrix_block_type_id','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','f7ed725d-84f8-4da7-841a-a6a4d23b6904'),
	(29,NULL,'app','m160920_174553_matrixblocks_owner_site_id_nullable','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','daf11410-9cae-4fe3-aa63-4b970b81adcf'),
	(30,NULL,'app','m160920_231045_usergroup_handle_title_unique','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','8439765b-64e9-4986-8e9d-96e05f69640e'),
	(31,NULL,'app','m160925_113941_route_uri_parts','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','2f72b5e8-4608-4f8a-9b67-9828cff40853'),
	(32,NULL,'app','m161006_205918_schemaVersion_not_null','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','bc61ea5c-0950-4269-bba7-5857c37f96fa'),
	(33,NULL,'app','m161007_130653_update_email_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','2487b97e-e432-4da6-9c5c-4906f59a66b9'),
	(34,NULL,'app','m161013_175052_newParentId','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','89d58bfc-31ae-4ab2-a339-ce26f7b2b112'),
	(35,NULL,'app','m161021_102916_fix_recent_entries_widgets','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','2c984cb0-caff-4e2e-a40f-a0b3b1472eab'),
	(36,NULL,'app','m161021_182140_rename_get_help_widget','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','5a6be7e0-d654-474d-bb77-7f2a99e6fa73'),
	(37,NULL,'app','m161025_000000_fix_char_columns','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','25d0df52-45d3-4697-b2f4-2c0c2ffe3d64'),
	(38,NULL,'app','m161029_124145_email_message_languages','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','66a141a2-b164-4565-9f96-22c78215058c'),
	(39,NULL,'app','m161108_000000_new_version_format','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','3d0fd362-3cb8-4238-9e53-7d481aa58bf8'),
	(40,NULL,'app','m161109_000000_index_shuffle','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','119870a9-0791-4482-9178-40fdfb9b9cac'),
	(41,NULL,'app','m161122_185500_no_craft_app','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','fa66973c-713f-460a-9674-b2c87029e717'),
	(42,NULL,'app','m161125_150752_clear_urlmanager_cache','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','e47a0c17-947c-49b6-bd9b-83c13f97ee03'),
	(43,NULL,'app','m161220_000000_volumes_hasurl_notnull','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','617f1111-225c-4a4f-8aad-c60f9a8fc337'),
	(44,NULL,'app','m170114_161144_udates_permission','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','011b30e5-27b0-44bf-873c-14bb70c565ac'),
	(45,NULL,'app','m170120_000000_schema_cleanup','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','721bd296-204d-4279-9cb9-21c70b945a33'),
	(46,NULL,'app','m170126_000000_assets_focal_point','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','850fa1f6-0cf4-4542-9e19-514fb764e51d'),
	(47,NULL,'app','m170206_142126_system_name','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','1faf2679-fa3a-4ee7-9f70-5f3d35e16e94'),
	(48,NULL,'app','m170217_044740_category_branch_limits','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','fd15ec62-65b3-4864-849a-4d6ee419e9b9'),
	(49,NULL,'app','m170217_120224_asset_indexing_columns','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','f2491dd0-fbed-442c-8c7a-472ad45fb8d7'),
	(50,NULL,'app','m170223_224012_plain_text_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','e0f6e3c4-a9c3-4937-87e2-52da11c74b31'),
	(51,NULL,'app','m170227_120814_focal_point_percentage','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','2ed800be-6a6f-4591-869f-5ed7b78b69ca'),
	(52,NULL,'app','m170228_171113_system_messages','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','21100100-edff-4a2e-a14f-0cbdc7bc454d'),
	(53,NULL,'app','m170303_140500_asset_field_source_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','dc468626-06dc-4726-b501-ecea0ad4a340'),
	(54,NULL,'app','m170306_150500_asset_temporary_uploads','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','aae3d16a-fe38-4141-8f14-f7d2970d8c13'),
	(55,NULL,'app','m170414_162429_rich_text_config_setting','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','4469651d-ea61-4e7f-8960-9ef0847b08ba'),
	(56,NULL,'app','m170523_190652_element_field_layout_ids','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','3156c39e-735f-48f1-a217-441baef473b9'),
	(57,NULL,'app','m170612_000000_route_index_shuffle','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','7a1d84e7-aeda-43b8-b8ce-d12a71f859fc'),
	(58,NULL,'app','m170621_195237_format_plugin_handles','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','5de247cd-3b9f-4772-bb9c-c21cc22a8add'),
	(59,NULL,'app','m170630_161028_deprecation_changes','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','dace3f53-9f38-41a3-a2e4-6785dae1419b'),
	(60,NULL,'app','m170703_181539_plugins_table_tweaks','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','92b36225-d856-408f-b653-aea3ae3d6a2e'),
	(61,NULL,'app','m170704_134916_sites_tables','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','c1036d00-6d14-4d45-9d26-6de83e043b23'),
	(62,NULL,'app','m170706_183216_rename_sequences','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','3247eab5-f718-4732-b8b3-79599459c663'),
	(63,NULL,'app','m170707_094758_delete_compiled_traits','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','5f7c6fa8-ddeb-4044-8ffd-c7ed7097bfe7'),
	(64,NULL,'app','m170731_190138_drop_asset_packagist','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','b36b710f-d7c5-46b3-b6aa-27790964d857'),
	(65,NULL,'app','m170810_201318_create_queue_table','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','79f4fd19-7e3f-4a47-a4e8-394f9dcd5df6'),
	(66,NULL,'app','m170816_133741_delete_compiled_behaviors','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','0ea482f6-a832-481f-8f36-ba4df203c347'),
	(67,NULL,'app','m170821_180624_deprecation_line_nullable','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','f465a266-1878-4c44-8812-0ec257318e14'),
	(68,NULL,'app','m170903_192801_longblob_for_queue_jobs','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','9c0cc22d-4170-4f9b-9736-acca020a0a24'),
	(69,NULL,'app','m170914_204621_asset_cache_shuffle','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','a03eb1d2-afb9-4a01-b4cf-4ee56a4d0d7a'),
	(70,NULL,'app','m171011_214115_site_groups','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','c6badc18-6be6-4b08-961e-14c2edda1b93'),
	(71,NULL,'app','m171012_151440_primary_site','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','ab72f092-c9a4-4f1c-aec4-89995080c7a8'),
	(72,NULL,'app','m171013_142500_transform_interlace','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','b1112ef5-e432-44ac-9850-cb7541e91d59'),
	(73,NULL,'app','m171016_092553_drop_position_select','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','842d3297-c15b-4e49-9b92-4de6e95f9212'),
	(74,NULL,'app','m171016_221244_less_strict_translation_method','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','2c7725e8-e215-4cd1-83c9-48aae692f0d7'),
	(75,NULL,'app','m171107_000000_assign_group_permissions','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','d76b09f7-8f82-452e-9b97-b21d75ee8374'),
	(76,NULL,'app','m171117_000001_templatecache_index_tune','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','5912ffe4-f580-4e28-915e-bd27723f5441'),
	(77,NULL,'app','m171126_105927_disabled_plugins','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','cd88af1f-9f05-4c51-942e-db25937c5340'),
	(78,NULL,'app','m171130_214407_craftidtokens_table','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','09292444-3410-4ce6-a07a-95cf2f321953'),
	(79,NULL,'app','m171202_004225_update_email_settings','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','aac576a6-2ef2-476f-9569-f278e3c01ca2'),
	(80,NULL,'app','m171204_000001_templatecache_index_tune_deux','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','3114b1a3-b688-4c6f-b458-f5f3bda4aa25'),
	(81,NULL,'app','m171205_130908_remove_craftidtokens_refreshtoken_column','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','28bbca50-51a1-4aa5-90f3-dd992add5d69'),
	(82,NULL,'app','m171218_143135_longtext_query_column','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','8cee274a-5ab6-46ca-b769-d16e5afa2325'),
	(83,NULL,'app','m171231_055546_environment_variables_to_aliases','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','f9887782-4a72-4310-9a49-c4787f93f4ca'),
	(84,NULL,'app','m180113_153740_drop_users_archived_column','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','d17560ca-4e8f-4235-85d1-fc74b050ff25'),
	(85,NULL,'app','m180122_213433_propagate_entries_setting','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','3dbf7869-a1ad-413c-9ded-35ecfad865f8'),
	(86,NULL,'app','m180124_230459_fix_propagate_entries_values','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','0a3962ef-2387-4583-9788-ec6e0085080a'),
	(87,NULL,'app','m180128_235202_set_tag_slugs','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','6867f176-433e-4fed-b00a-db244e54e139'),
	(88,NULL,'app','m180202_185551_fix_focal_points','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','2dc37791-cdf5-4323-a224-9c02f367146e'),
	(89,NULL,'app','m180217_172123_tiny_ints','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','3e859869-294f-4ccf-9db5-12ceeccbb144'),
	(90,NULL,'app','m180321_233505_small_ints','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','c3a6291b-a65a-459d-8a9e-35db6ffe9dee'),
	(91,NULL,'app','m180328_115523_new_license_key_statuses','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','f6f3dd3e-c05f-4b0c-ba1b-6208315374a4'),
	(92,NULL,'app','m180404_182320_edition_changes','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','7ceaca72-4e7f-4869-9365-cb2409c41aaa'),
	(93,NULL,'app','m180411_102218_fix_db_routes','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','22a920fa-cf62-4be0-b597-2b92e549b8ac'),
	(94,NULL,'app','m180416_205628_resourcepaths_table','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','ef6ffeca-2793-4c76-bd0a-d4b3359d6f42'),
	(95,NULL,'app','m180418_205713_widget_cleanup','2018-08-18 10:27:59','2018-08-18 10:27:59','2018-08-18 10:27:59','d18ab99d-a2a2-44a7-9b1e-7fa27a8ae129'),
	(96,1,'plugin','Install','2018-08-18 10:32:40','2018-08-18 10:32:40','2018-08-18 10:32:40','e862071f-957a-46db-b386-1d08df0a66e2');

/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table plugins
# ------------------------------------------------------------

DROP TABLE IF EXISTS `plugins`;

CREATE TABLE `plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `handle` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `schemaVersion` varchar(255) NOT NULL,
  `licenseKey` char(24) DEFAULT NULL,
  `licenseKeyStatus` enum('valid','invalid','mismatched','astray','unknown') NOT NULL DEFAULT 'unknown',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `installDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `plugins_handle_unq_idx` (`handle`),
  KEY `plugins_enabled_idx` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;

INSERT INTO `plugins` (`id`, `handle`, `version`, `schemaVersion`, `licenseKey`, `licenseKeyStatus`, `enabled`, `settings`, `installDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'sequential-edit','1.0.0','1.0.0',NULL,'invalid',1,NULL,'2018-08-18 10:32:40','2018-08-18 10:32:40','2018-08-18 10:32:49','51742066-ed50-4119-8c6e-b4d0bf1d6d4d');

/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table queue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `queue`;

CREATE TABLE `queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` longblob NOT NULL,
  `description` text,
  `timePushed` int(11) NOT NULL,
  `ttr` int(11) NOT NULL,
  `delay` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) unsigned NOT NULL DEFAULT '1024',
  `dateReserved` datetime DEFAULT NULL,
  `timeUpdated` int(11) DEFAULT NULL,
  `progress` smallint(6) NOT NULL DEFAULT '0',
  `attempt` int(11) DEFAULT NULL,
  `fail` tinyint(1) DEFAULT '0',
  `dateFailed` datetime DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`id`),
  KEY `queue_fail_timeUpdated_timePushed_idx` (`fail`,`timeUpdated`,`timePushed`),
  KEY `queue_fail_timeUpdated_delay_idx` (`fail`,`timeUpdated`,`delay`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table relations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `relations`;

CREATE TABLE `relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `sourceSiteId` int(11) DEFAULT NULL,
  `targetId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `relations_fieldId_sourceId_sourceSiteId_targetId_unq_idx` (`fieldId`,`sourceId`,`sourceSiteId`,`targetId`),
  KEY `relations_sourceId_idx` (`sourceId`),
  KEY `relations_targetId_idx` (`targetId`),
  KEY `relations_sourceSiteId_idx` (`sourceSiteId`),
  CONSTRAINT `relations_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_sourceSiteId_fk` FOREIGN KEY (`sourceSiteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `relations_targetId_fk` FOREIGN KEY (`targetId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table resourcepaths
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resourcepaths`;

CREATE TABLE `resourcepaths` (
  `hash` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  PRIMARY KEY (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `resourcepaths` WRITE;
/*!40000 ALTER TABLE `resourcepaths` DISABLE KEYS */;

INSERT INTO `resourcepaths` (`hash`, `path`)
VALUES
	('19feb954','@app/web/assets/recententries/dist'),
	('1f8bd3f2','@app/web/assets/pluginstore/dist'),
	('2744fb3a','@app/web/assets/updateswidget/dist'),
	('29d657fb','@app/web/assets/craftsupport/dist'),
	('3146bf54','@app/web/assets/installer/dist'),
	('3711a905','@app/web/assets/updater/dist'),
	('3f1e38e6','@lib/jquery-ui'),
	('4b39ed9','@app/web/assets/cp/dist'),
	('4fa8ffcb','@lib/element-resize-detector'),
	('581295c6','@lib'),
	('5a8db70f','@craft/web/assets/matrixsettings/dist'),
	('6038543e','@bower/jquery/dist'),
	('65e19663','@craft/web/assets/editentry/dist'),
	('6d900cab','@lib/jquery.payment'),
	('71b7a343','@lib/velocity'),
	('7da8d567','@app/web/assets/feed/dist'),
	('85759d86','@app/web/assets/plugins/dist'),
	('8d7f59c2','@lib/timepicker'),
	('a14fe221','@lib/datepicker-i18n'),
	('b28001b7','@lib/xregexp'),
	('b7b85009','@craft/web/assets/pluginstore/dist'),
	('b8ec453d','@lib/selectize'),
	('b9bcf7ec','@app/web/assets/pluginstoreoauth/dist'),
	('bec36074','@craft/web/assets/cp/dist'),
	('c40942bd','@craft/web/assets/fields/dist'),
	('c4cc8b50','@lib/fabric'),
	('c7bed095','@app/web/assets/dashboard/dist'),
	('d18a5f6e','@lib/garnishjs'),
	('e23748e8','@lib/d3'),
	('eb36547b','@lib/jquery-touch-events'),
	('ec1bf0c8','@craft/web/assets/tablesettings/dist'),
	('ec9268b9','@lib/picturefill'),
	('f47a6947','@lib/fileupload');

/*!40000 ALTER TABLE `resourcepaths` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table routes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `routes`;

CREATE TABLE `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) DEFAULT NULL,
  `uriParts` varchar(255) NOT NULL,
  `uriPattern` varchar(255) NOT NULL,
  `template` varchar(500) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `routes_uriPattern_idx` (`uriPattern`),
  KEY `routes_siteId_idx` (`siteId`),
  CONSTRAINT `routes_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table searchindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `searchindex`;

CREATE TABLE `searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `searchindex` WRITE;
/*!40000 ALTER TABLE `searchindex` DISABLE KEYS */;

INSERT INTO `searchindex` (`elementId`, `attribute`, `fieldId`, `siteId`, `keywords`)
VALUES
	(1,'username',0,1,' jai '),
	(1,'firstname',0,1,''),
	(1,'lastname',0,1,''),
	(1,'fullname',0,1,''),
	(1,'email',0,1,' studio jaisand hu '),
	(1,'slug',0,1,''),
	(2,'slug',0,1,' test entry 1 '),
	(2,'title',0,1,' test entry 1 '),
	(3,'slug',0,1,' test child 1 '),
	(3,'title',0,1,' test child 1 '),
	(4,'slug',0,1,' test child 2 '),
	(4,'title',0,1,' test child 2 '),
	(5,'slug',0,1,' test entry 2 '),
	(5,'title',0,1,' test entry 2 '),
	(6,'slug',0,1,' test entry 3 '),
	(6,'title',0,1,' test entry 3 '),
	(8,'slug',0,1,' test entry 5 '),
	(8,'title',0,1,' test entry 5 '),
	(9,'slug',0,1,' test entry 4 '),
	(9,'title',0,1,' test entry 4 '),
	(10,'slug',0,1,' test entry 6 '),
	(10,'title',0,1,' test entry 6 '),
	(11,'slug',0,1,' test entry 7 '),
	(11,'title',0,1,' test entry 7 '),
	(12,'slug',0,1,' test entry 8 '),
	(12,'title',0,1,' test entry 8 '),
	(13,'slug',0,1,' test entry 9 '),
	(13,'title',0,1,' test entry 9 '),
	(14,'slug',0,1,' test entry 11 '),
	(14,'title',0,1,' test entry 11 ');

/*!40000 ALTER TABLE `searchindex` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sections
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sections`;

CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` enum('single','channel','structure') NOT NULL DEFAULT 'channel',
  `enableVersioning` tinyint(1) NOT NULL DEFAULT '0',
  `propagateEntries` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_handle_unq_idx` (`handle`),
  UNIQUE KEY `sections_name_unq_idx` (`name`),
  KEY `sections_structureId_idx` (`structureId`),
  CONSTRAINT `sections_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;

INSERT INTO `sections` (`id`, `structureId`, `name`, `handle`, `type`, `enableVersioning`, `propagateEntries`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'Test','test','structure',1,1,'2018-08-18 10:34:00','2018-08-18 10:38:09','d1bf9b4f-9f39-4442-9a44-044cac9c4bf9');

/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sections_sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sections_sites`;

CREATE TABLE `sections_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `enabledByDefault` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sections_sites_sectionId_siteId_unq_idx` (`sectionId`,`siteId`),
  KEY `sections_sites_siteId_idx` (`siteId`),
  CONSTRAINT `sections_sites_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sections_sites_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sections_sites` WRITE;
/*!40000 ALTER TABLE `sections_sites` DISABLE KEYS */;

INSERT INTO `sections_sites` (`id`, `sectionId`, `siteId`, `hasUrls`, `uriFormat`, `template`, `enabledByDefault`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,1,'test/{slug}','test/_entry',1,'2018-08-18 10:34:00','2018-08-18 10:38:09','448824f3-cdb0-4c6e-a97d-23c42bd9cf29');

/*!40000 ALTER TABLE `sections_sites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sequentialedit_queueditems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sequentialedit_queueditems`;

CREATE TABLE `sequentialedit_queueditems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(64) NOT NULL,
  `elementType` varchar(64) NOT NULL,
  `elementId` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sequentialedit_queueditems_sessionId_elementId_unq_idx` (`sessionId`,`elementId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `token` char(100) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sessions_uid_idx` (`uid`),
  KEY `sessions_token_idx` (`token`),
  KEY `sessions_dateUpdated_idx` (`dateUpdated`),
  KEY `sessions_userId_idx` (`userId`),
  CONSTRAINT `sessions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table shunnedmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shunnedmessages`;

CREATE TABLE `shunnedmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shunnedmessages_userId_message_unq_idx` (`userId`,`message`),
  CONSTRAINT `shunnedmessages_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table sitegroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sitegroups`;

CREATE TABLE `sitegroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sitegroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sitegroups` WRITE;
/*!40000 ALTER TABLE `sitegroups` DISABLE KEYS */;

INSERT INTO `sitegroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Sequential Edit','2018-08-18 10:27:56','2018-08-18 10:27:56','0739060b-7f93-4ebd-a553-facd1f576e17');

/*!40000 ALTER TABLE `sitegroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sites`;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `language` varchar(12) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '0',
  `baseUrl` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sites_handle_unq_idx` (`handle`),
  KEY `sites_sortOrder_idx` (`sortOrder`),
  KEY `sites_groupId_fk` (`groupId`),
  CONSTRAINT `sites_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `sitegroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;

INSERT INTO `sites` (`id`, `groupId`, `primary`, `name`, `handle`, `language`, `hasUrls`, `baseUrl`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,'Sequential Edit','default','en-GB',1,'@web/',1,'2018-08-18 10:27:56','2018-08-18 10:27:56','9d93f456-0dc8-4dca-9701-56c70ceb3a35');

/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table structureelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `structureelements`;

CREATE TABLE `structureelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `elementId` int(11) DEFAULT NULL,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `structureelements_structureId_elementId_unq_idx` (`structureId`,`elementId`),
  KEY `structureelements_root_idx` (`root`),
  KEY `structureelements_lft_idx` (`lft`),
  KEY `structureelements_rgt_idx` (`rgt`),
  KEY `structureelements_level_idx` (`level`),
  KEY `structureelements_elementId_idx` (`elementId`),
  CONSTRAINT `structureelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `structureelements_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `structureelements` WRITE;
/*!40000 ALTER TABLE `structureelements` DISABLE KEYS */;

INSERT INTO `structureelements` (`id`, `structureId`, `elementId`, `root`, `lft`, `rgt`, `level`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,NULL,1,1,26,0,'2018-08-18 10:35:17','2018-08-18 10:37:34','274a1b58-25c0-4700-b010-f08be8adee3a'),
	(2,1,2,1,2,7,1,'2018-08-18 10:35:17','2018-08-18 10:35:39','b79fe9d7-214c-4f4f-8ed0-707974dab01e'),
	(3,1,3,1,3,4,2,'2018-08-18 10:35:30','2018-08-18 10:35:30','342582a2-bac2-40ce-b746-5d63428af322'),
	(4,1,4,1,5,6,2,'2018-08-18 10:35:39','2018-08-18 10:35:39','eb236252-ef06-4912-9082-6888641f770b'),
	(5,1,5,1,8,9,1,'2018-08-18 10:35:49','2018-08-18 10:35:49','d50a0c04-387d-4edb-ac13-74ce3c716c4c'),
	(6,1,6,1,10,11,1,'2018-08-18 10:36:00','2018-08-18 10:36:00','77e6fb2f-a2db-4e7f-8f30-4f0b9744773e'),
	(7,1,8,1,14,15,1,'2018-08-18 10:36:41','2018-08-18 10:36:56','58db4407-967d-4a6a-bb27-5f0cd0a9a43e'),
	(8,1,9,1,12,13,1,'2018-08-18 10:36:52','2018-08-18 10:36:56','c6362eb9-1df9-4bad-9c44-f50fb7583d07'),
	(9,1,10,1,16,17,1,'2018-08-18 10:37:05','2018-08-18 10:37:05','9354b02c-f2e9-4763-8711-d85112d0436d'),
	(10,1,11,1,18,19,1,'2018-08-18 10:37:11','2018-08-18 10:37:11','8f137264-2bd4-4b21-9720-43fce2a38cc3'),
	(11,1,12,1,20,21,1,'2018-08-18 10:37:17','2018-08-18 10:37:17','8a11205d-c565-44c1-b7a0-f6e47f55c91e'),
	(12,1,13,1,22,23,1,'2018-08-18 10:37:25','2018-08-18 10:37:25','e950d08a-c412-45be-befe-5e059ca73559'),
	(13,1,14,1,24,25,1,'2018-08-18 10:37:34','2018-08-18 10:37:34','9cb02d3e-8692-436a-9173-3fa1983ef814');

/*!40000 ALTER TABLE `structureelements` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table structures
# ------------------------------------------------------------

DROP TABLE IF EXISTS `structures`;

CREATE TABLE `structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `structures` WRITE;
/*!40000 ALTER TABLE `structures` DISABLE KEYS */;

INSERT INTO `structures` (`id`, `maxLevels`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,2,'2018-08-18 10:34:00','2018-08-18 10:38:09','f87ad9bd-881f-4e72-8baf-eb71a069c4a4');

/*!40000 ALTER TABLE `structures` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table systemmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `systemmessages`;

CREATE TABLE `systemmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemmessages_key_language_unq_idx` (`key`,`language`),
  KEY `systemmessages_language_idx` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table systemsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `systemsettings`;

CREATE TABLE `systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `systemsettings` WRITE;
/*!40000 ALTER TABLE `systemsettings` DISABLE KEYS */;

INSERT INTO `systemsettings` (`id`, `category`, `settings`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'email','{\"fromEmail\":\"studio@jaisand.hu\",\"fromName\":\"Sequential Edit\",\"transportType\":\"craft\\\\mail\\\\transportadapters\\\\Sendmail\"}','2018-08-18 10:27:59','2018-08-18 10:27:59','9a29f109-025a-464c-b8ce-5a999af2f84f');

/*!40000 ALTER TABLE `systemsettings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table taggroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `taggroups`;

CREATE TABLE `taggroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggroups_name_unq_idx` (`name`),
  UNIQUE KEY `taggroups_handle_unq_idx` (`handle`),
  KEY `taggroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `taggroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tags`;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tags_groupId_idx` (`groupId`),
  CONSTRAINT `tags_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `taggroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tags_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table templatecacheelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templatecacheelements`;

CREATE TABLE `templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `templatecacheelements_cacheId_idx` (`cacheId`),
  KEY `templatecacheelements_elementId_idx` (`elementId`),
  CONSTRAINT `templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table templatecachequeries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templatecachequeries`;

CREATE TABLE `templatecachequeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `query` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecachequeries_cacheId_idx` (`cacheId`),
  KEY `templatecachequeries_type_idx` (`type`),
  CONSTRAINT `templatecachequeries_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `templatecaches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table templatecaches
# ------------------------------------------------------------

DROP TABLE IF EXISTS `templatecaches`;

CREATE TABLE `templatecaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) NOT NULL,
  `cacheKey` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `body` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_path_idx` (`cacheKey`,`siteId`,`expiryDate`,`path`),
  KEY `templatecaches_cacheKey_siteId_expiryDate_idx` (`cacheKey`,`siteId`,`expiryDate`),
  KEY `templatecaches_siteId_idx` (`siteId`),
  CONSTRAINT `templatecaches_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tokens`;

CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` char(32) NOT NULL,
  `route` text,
  `usageLimit` tinyint(3) unsigned DEFAULT NULL,
  `usageCount` tinyint(3) unsigned DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokens_token_unq_idx` (`token`),
  KEY `tokens_expiryDate_idx` (`expiryDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `usergroups`;

CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_handle_unq_idx` (`handle`),
  UNIQUE KEY `usergroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table usergroups_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `usergroups_users`;

CREATE TABLE `usergroups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `usergroups_users_groupId_userId_unq_idx` (`groupId`,`userId`),
  KEY `usergroups_users_userId_idx` (`userId`),
  CONSTRAINT `usergroups_users_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usergroups_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpermissions`;

CREATE TABLE `userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpermissions_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpermissions_usergroups`;

CREATE TABLE `userpermissions_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_usergroups_permissionId_groupId_unq_idx` (`permissionId`,`groupId`),
  KEY `userpermissions_usergroups_groupId_idx` (`groupId`),
  CONSTRAINT `userpermissions_usergroups_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_usergroups_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpermissions_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpermissions_users`;

CREATE TABLE `userpermissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userpermissions_users_permissionId_userId_unq_idx` (`permissionId`,`userId`),
  KEY `userpermissions_users_userId_idx` (`userId`),
  CONSTRAINT `userpermissions_users_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `userpermissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `userpermissions_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table userpreferences
# ------------------------------------------------------------

DROP TABLE IF EXISTS `userpreferences`;

CREATE TABLE `userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `userpreferences` WRITE;
/*!40000 ALTER TABLE `userpreferences` DISABLE KEYS */;

INSERT INTO `userpreferences` (`userId`, `preferences`)
VALUES
	(1,'{\"language\":\"en-GB\"}');

/*!40000 ALTER TABLE `userpreferences` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `photoId` int(11) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `pending` tinyint(1) NOT NULL DEFAULT '0',
  `lastLoginDate` datetime DEFAULT NULL,
  `lastLoginAttemptIp` varchar(45) DEFAULT NULL,
  `invalidLoginWindowStart` datetime DEFAULT NULL,
  `invalidLoginCount` tinyint(3) unsigned DEFAULT NULL,
  `lastInvalidLoginDate` datetime DEFAULT NULL,
  `lockoutDate` datetime DEFAULT NULL,
  `hasDashboard` tinyint(1) NOT NULL DEFAULT '0',
  `verificationCode` varchar(255) DEFAULT NULL,
  `verificationCodeIssuedDate` datetime DEFAULT NULL,
  `unverifiedEmail` varchar(255) DEFAULT NULL,
  `passwordResetRequired` tinyint(1) NOT NULL DEFAULT '0',
  `lastPasswordChangeDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unq_idx` (`username`),
  UNIQUE KEY `users_email_unq_idx` (`email`),
  KEY `users_uid_idx` (`uid`),
  KEY `users_verificationCode_idx` (`verificationCode`),
  KEY `users_photoId_fk` (`photoId`),
  CONSTRAINT `users_id_fk` FOREIGN KEY (`id`) REFERENCES `elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_photoId_fk` FOREIGN KEY (`photoId`) REFERENCES `assets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `username`, `photoId`, `firstName`, `lastName`, `email`, `password`, `admin`, `locked`, `suspended`, `pending`, `lastLoginDate`, `lastLoginAttemptIp`, `invalidLoginWindowStart`, `invalidLoginCount`, `lastInvalidLoginDate`, `lockoutDate`, `hasDashboard`, `verificationCode`, `verificationCodeIssuedDate`, `unverifiedEmail`, `passwordResetRequired`, `lastPasswordChangeDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'jai',NULL,NULL,NULL,'studio@jaisand.hu','$2y$13$s6ErRpiiEi9R57Db3a/WUOj4RRGLZPI6gJCTbI6er/mzJh9b0XqPS',1,0,0,0,'2018-08-18 10:27:58','::1',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,0,'2018-08-18 10:27:58','2018-08-18 10:27:58','2018-08-18 10:30:56','09c71671-5a77-4519-be4c-ac475adb3372');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table volumefolders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `volumefolders`;

CREATE TABLE `volumefolders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumefolders_name_parentId_volumeId_unq_idx` (`name`,`parentId`,`volumeId`),
  KEY `volumefolders_parentId_idx` (`parentId`),
  KEY `volumefolders_volumeId_idx` (`volumeId`),
  CONSTRAINT `volumefolders_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `volumefolders_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table volumes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `volumes`;

CREATE TABLE `volumes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `url` varchar(255) DEFAULT NULL,
  `settings` text,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volumes_name_unq_idx` (`name`),
  UNIQUE KEY `volumes_handle_unq_idx` (`handle`),
  KEY `volumes_fieldLayoutId_idx` (`fieldLayoutId`),
  CONSTRAINT `volumes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table widgets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `widgets`;

CREATE TABLE `widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `colspan` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `widgets_userId_idx` (`userId`),
  CONSTRAINT `widgets_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `widgets` WRITE;
/*!40000 ALTER TABLE `widgets` DISABLE KEYS */;

INSERT INTO `widgets` (`id`, `userId`, `type`, `sortOrder`, `colspan`, `settings`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'craft\\widgets\\RecentEntries',1,0,'{\"section\":\"*\",\"siteId\":\"1\",\"limit\":10}',1,'2018-08-18 10:30:56','2018-08-18 10:30:56','87e85265-96be-48cc-a13c-5ddf7eed4690'),
	(2,1,'craft\\widgets\\CraftSupport',2,0,'[]',1,'2018-08-18 10:30:56','2018-08-18 10:30:56','ea96dee3-a96f-4840-82fb-fa93094b7bea'),
	(3,1,'craft\\widgets\\Updates',3,0,'[]',1,'2018-08-18 10:30:56','2018-08-18 10:30:56','1088436d-1e49-4f02-a644-291200134569'),
	(4,1,'craft\\widgets\\Feed',4,0,'{\"url\":\"https://craftcms.com/news.rss\",\"title\":\"Craft News\",\"limit\":5}',1,'2018-08-18 10:30:56','2018-08-18 10:30:56','981a15c5-03e8-4b1d-a188-7db17e0cabf5');

/*!40000 ALTER TABLE `widgets` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
