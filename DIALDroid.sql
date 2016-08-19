-- --------------------------------------------------------
-- Host:                         131.230.166.229
-- Server version:               5.5.50-0ubuntu0.14.04.1 - (Ubuntu)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             9.2.0.4947
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table dialdroid_test.ActionStrings
CREATE TABLE IF NOT EXISTS `ActionStrings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `st` varchar(191) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `st` (`st`),
  KEY `st_idx` (`st`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.Aliases
CREATE TABLE IF NOT EXISTS `Aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_id` (`component_id`),
  KEY `target_id` (`target_id`),
  CONSTRAINT `Aliases_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `Components` (`id`),
  CONSTRAINT `Aliases_ibfk_2` FOREIGN KEY (`target_id`) REFERENCES `Components` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.AppAnalysisTime
CREATE TABLE IF NOT EXISTS `AppAnalysisTime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AppID` int(11) DEFAULT NULL,
  `ModelParse` int(11) DEFAULT NULL,
  `ClassLoad` int(11) DEFAULT NULL,
  `MainGeneration` int(11) DEFAULT NULL,
  `EntryPointMapping` int(11) DEFAULT NULL,
  `IC3TotalTime` int(11) DEFAULT NULL,
  `ExitPointPath` int(11) DEFAULT NULL,
  `EntryPointPath` int(11) DEFAULT NULL,
  `TotalTime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_AppAnalysisTime_1_idx` (`AppID`),
  CONSTRAINT `fk_AppAnalysisTime_1` FOREIGN KEY (`AppID`) REFERENCES `Applications` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.AppCategories
CREATE TABLE IF NOT EXISTS `AppCategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AppID` int(11) NOT NULL,
  `CategoryID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_AppCategories_1_idx` (`AppID`),
  KEY `fk_AppCategories_2_idx` (`CategoryID`),
  CONSTRAINT `fk_AppCategories_1` FOREIGN KEY (`AppID`) REFERENCES `Applications` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_AppCategories_2` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.Applications
CREATE TABLE IF NOT EXISTS `Applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  `version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.AppTimeout
CREATE TABLE IF NOT EXISTS `AppTimeout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AppID` int(11) NOT NULL,
  `Timeout` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_AppTimeout_1_idx` (`AppID`),
  CONSTRAINT `fk_AppTimeout_1` FOREIGN KEY (`AppID`) REFERENCES `Applications` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.Categories
CREATE TABLE IF NOT EXISTS `Categories` (
  `id` int(11) NOT NULL,
  `Categories` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.CategoryStrings
CREATE TABLE IF NOT EXISTS `CategoryStrings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `st` varchar(191) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `st` (`st`),
  KEY `st_idx` (`st`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.Classes
CREATE TABLE IF NOT EXISTS `Classes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `class` varchar(191) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `app_id_idx` (`app_id`) USING HASH,
  KEY `idx-class` (`class`) USING HASH,
  CONSTRAINT `Classes_ibfk_1` FOREIGN KEY (`app_id`) REFERENCES `Applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.ComponentExtras
CREATE TABLE IF NOT EXISTS `ComponentExtras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL,
  `extra` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `component_id` (`component_id`),
  CONSTRAINT `ComponentExtras_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `Components` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.Components
CREATE TABLE IF NOT EXISTS `Components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) NOT NULL,
  `kind` char(1) COLLATE utf8mb4_bin NOT NULL,
  `exported` tinyint(1) NOT NULL,
  `permission` int(11) DEFAULT NULL,
  `missing` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `permission` (`permission`),
  CONSTRAINT `Components_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `Classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Components_ibfk_2` FOREIGN KEY (`permission`) REFERENCES `PermissionStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.EntryPoints
CREATE TABLE IF NOT EXISTS `EntryPoints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) DEFAULT NULL,
  `method` varchar(512) DEFAULT NULL,
  `instruction` int(11) DEFAULT NULL,
  `statement` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_EntryPoints_class_idx` (`class_id`),
  CONSTRAINT `fk_EntryPoints_class` FOREIGN KEY (`class_id`) REFERENCES `Classes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.ExitPointComponents
CREATE TABLE IF NOT EXISTS `ExitPointComponents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exit_id` int(11) NOT NULL,
  `component_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `exit_id` (`exit_id`),
  KEY `component_id` (`component_id`),
  CONSTRAINT `ExitPointComponents_ibfk_1` FOREIGN KEY (`exit_id`) REFERENCES `ExitPoints` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ExitPointComponents_ibfk_2` FOREIGN KEY (`component_id`) REFERENCES `Components` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.ExitPoints
CREATE TABLE IF NOT EXISTS `ExitPoints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) NOT NULL,
  `method` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  `instruction` mediumint(9) NOT NULL,
  `statement` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL,
  `exit_kind` char(1) COLLATE utf8mb4_bin NOT NULL,
  `missing` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `ExitPoints_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `Classes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.ICCEntryLeaks
CREATE TABLE IF NOT EXISTS `ICCEntryLeaks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_point_id` int(11) DEFAULT NULL,
  `leak_source` varchar(512) NOT NULL,
  `leak_sink` varchar(512) DEFAULT NULL,
  `leak_path` mediumtext,
  `sink_method` varchar(127) DEFAULT NULL,
  `disabled` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_ICCEntryDataLeaks_entry_idx` (`entry_point_id`),
  CONSTRAINT `fk_ICCEntryDataLeaks_entry` FOREIGN KEY (`entry_point_id`) REFERENCES `EntryPoints` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.ICCExitLeaks
CREATE TABLE IF NOT EXISTS `ICCExitLeaks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exit_point_id` int(11) DEFAULT NULL,
  `leak_source` varchar(512) DEFAULT NULL,
  `leak_path` mediumtext,
  `leak_sink` varchar(512) DEFAULT NULL,
  `method` varchar(512) DEFAULT NULL,
  `disabled` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_ExitLeaks_exitpoint_idx` (`exit_point_id`),
  CONSTRAINT `fk_ExitLeaks_exitpoint` FOREIGN KEY (`exit_point_id`) REFERENCES `ExitPoints` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.IFilterActions
CREATE TABLE IF NOT EXISTS `IFilterActions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filter_id` int(11) NOT NULL,
  `action` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `filter_id` (`filter_id`),
  KEY `action_idx` (`action`) USING HASH,
  CONSTRAINT `IFilterActions_ibfk_1` FOREIGN KEY (`filter_id`) REFERENCES `IntentFilters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `IFilterActions_ibfk_2` FOREIGN KEY (`action`) REFERENCES `ActionStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IFilterCategories
CREATE TABLE IF NOT EXISTS `IFilterCategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filter_id` int(11) NOT NULL,
  `category` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `filter_id` (`filter_id`),
  KEY `category_idx` (`category`) USING HASH,
  CONSTRAINT `IFilterCategories_ibfk_1` FOREIGN KEY (`filter_id`) REFERENCES `IntentFilters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `IFilterCategories_ibfk_2` FOREIGN KEY (`category`) REFERENCES `CategoryStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IFilterData
CREATE TABLE IF NOT EXISTS `IFilterData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filter_id` int(11) DEFAULT NULL,
  `scheme` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `host` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `port` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `path` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `type` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `subtype` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `filter_id` (`filter_id`),
  CONSTRAINT `IFilterData_ibfk_1` FOREIGN KEY (`filter_id`) REFERENCES `IntentFilters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentActions
CREATE TABLE IF NOT EXISTS `IntentActions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intent_id` int(11) NOT NULL,
  `action` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intent_id` (`intent_id`),
  KEY `action` (`action`),
  CONSTRAINT `IntentActions_ibfk_1` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `IntentActions_ibfk_2` FOREIGN KEY (`action`) REFERENCES `ActionStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentCategories
CREATE TABLE IF NOT EXISTS `IntentCategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intent_id` int(11) NOT NULL,
  `category` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intent_id` (`intent_id`),
  KEY `category` (`category`),
  CONSTRAINT `IntentCategories_ibfk_1` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `IntentCategories_ibfk_2` FOREIGN KEY (`category`) REFERENCES `CategoryStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentClasses
CREATE TABLE IF NOT EXISTS `IntentClasses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intent_id` int(11) NOT NULL,
  `class` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intent_id` (`intent_id`),
  KEY `iclass-class-idx` (`class`(191)) USING HASH,
  CONSTRAINT `IntentClasses_ibfk_1` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentData
CREATE TABLE IF NOT EXISTS `IntentData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intent_id` int(11) NOT NULL,
  `data` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intent_id` (`intent_id`),
  KEY `IntentData_ibfk_2` (`data`),
  CONSTRAINT `IntentData_ibfk_1` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentExtras
CREATE TABLE IF NOT EXISTS `IntentExtras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intent_id` int(11) NOT NULL,
  `extra` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intent_id` (`intent_id`),
  CONSTRAINT `IntentExtras_ibfk_1` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentFilters
CREATE TABLE IF NOT EXISTS `IntentFilters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL,
  `alias` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `c_id_idx` (`component_id`) USING HASH,
  CONSTRAINT `IntentFilters_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `Components` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentMimeTypes
CREATE TABLE IF NOT EXISTS `IntentMimeTypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intent_id` int(11) NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_bin NOT NULL,
  `subtype` varchar(191) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intent_id` (`intent_id`),
  KEY `type_idx` (`type`),
  KEY `subtype_idx` (`subtype`),
  CONSTRAINT `IMimeTypes_ibfk_1` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentPackages
CREATE TABLE IF NOT EXISTS `IntentPackages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intent_id` int(11) NOT NULL,
  `package` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intent_id` (`intent_id`),
  KEY `idx-package` (`package`(191)) USING HASH,
  CONSTRAINT `IntentPackages_ibfk_1` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.IntentPermissions
CREATE TABLE IF NOT EXISTS `IntentPermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exit_id` int(11) NOT NULL,
  `i_permission` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `exit_id` (`exit_id`),
  KEY `i_permission` (`i_permission`),
  CONSTRAINT `IntentPermissions_ibfk_1` FOREIGN KEY (`exit_id`) REFERENCES `ExitPoints` (`id`) ON DELETE CASCADE,
  CONSTRAINT `IntentPermissions_ibfk_2` FOREIGN KEY (`i_permission`) REFERENCES `PermissionStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.Intents
CREATE TABLE IF NOT EXISTS `Intents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exit_id` int(11) NOT NULL,
  `implicit` tinyint(1) NOT NULL,
  `alias` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `exit_id` (`exit_id`),
  CONSTRAINT `Intents_ibfk_1` FOREIGN KEY (`exit_id`) REFERENCES `ExitPoints` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.ParsedURI
CREATE TABLE IF NOT EXISTS `ParsedURI` (
  `id` int(11) NOT NULL DEFAULT '0',
  `scheme` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `path` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `host` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `port` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `orig_uri` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`id`),
  KEY `idx-scheme-host` (`host`(10)),
  KEY `idx-path-uri` (`path`(10)),
  KEY `idx-scheme-pUri` (`scheme`(10)) USING BTREE,
  KEY `idx-orig-uri` (`orig_uri`(32))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.PermissionLeaks
CREATE TABLE IF NOT EXISTS `PermissionLeaks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ICCLeakID` int(11) NOT NULL,
  `PermissionID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1_leaks_permission` (`PermissionID`),
  KEY `FK2_ICC_permission` (`ICCLeakID`),
  CONSTRAINT `FK1_leaks_permission` FOREIGN KEY (`PermissionID`) REFERENCES `PermissionStrings` (`id`),
  CONSTRAINT `FK2_ICC_permission` FOREIGN KEY (`ICCLeakID`) REFERENCES `ICCExitLeaks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.Permissions
CREATE TABLE IF NOT EXISTS `Permissions` (
  `id` int(11) NOT NULL,
  `level` char(1) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`,`level`),
  CONSTRAINT `Permissions_ibfk_1` FOREIGN KEY (`id`) REFERENCES `PermissionStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.PermissionStrings
CREATE TABLE IF NOT EXISTS `PermissionStrings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `st` varchar(191) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `st` (`st`),
  KEY `st_idx` (`st`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.PrivilegeEscalations
CREATE TABLE IF NOT EXISTS `PrivilegeEscalations` (
  `fromapp` int(11) NOT NULL,
  `toapp` int(11) NOT NULL,
  `data_leak_id` int(11) NOT NULL DEFAULT '0',
  `PermissionID` int(11) NOT NULL,
  `icc_type` varchar(10) DEFAULT NULL,
  KEY `data_leak_id` (`data_leak_id`),
  KEY `PermissionID` (`PermissionID`),
  KEY `toapp` (`toapp`),
  KEY `fromapp` (`fromapp`),
  CONSTRAINT `FK_PrivilegeEscalations_Applications` FOREIGN KEY (`fromapp`) REFERENCES `Applications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PrivilegeEscalations_Applications_2` FOREIGN KEY (`toapp`) REFERENCES `Applications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PrivilegeEscalations_ICCExitLeaks` FOREIGN KEY (`data_leak_id`) REFERENCES `ICCExitLeaks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PrivilegeEscalations_PermissionStrings` FOREIGN KEY (`PermissionID`) REFERENCES `PermissionStrings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.ProviderAuthorities
CREATE TABLE IF NOT EXISTS `ProviderAuthorities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `provider_id` int(11) NOT NULL,
  `authority` varchar(512) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `provider_id` (`provider_id`),
  CONSTRAINT `PAuthorities_ibfk_1` FOREIGN KEY (`provider_id`) REFERENCES `Providers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.Providers
CREATE TABLE IF NOT EXISTS `Providers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL,
  `grant_uri_permissions` tinyint(1) NOT NULL,
  `read_permission` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL,
  `write_permission` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `component_id` (`component_id`),
  CONSTRAINT `Providers_ibfk_1` FOREIGN KEY (`component_id`) REFERENCES `Components` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.SensitiveChannels
CREATE TABLE IF NOT EXISTS `SensitiveChannels` (
  `fromapp` int(11) NOT NULL,
  `toapp` int(11) NOT NULL,
  `intent_id` int(11) DEFAULT '0',
  `exitpoint` int(11) DEFAULT '0',
  `entryclass` int(11) DEFAULT '0',
  `filter_id` int(11) DEFAULT '0',
  `icc_type` varchar(2) DEFAULT NULL,
  KEY `fromapp` (`fromapp`),
  KEY `toapp` (`toapp`),
  KEY `intent_id` (`intent_id`),
  KEY `exitpoint` (`exitpoint`),
  KEY `entryclass` (`entryclass`),
  KEY `filter_id` (`filter_id`),
  CONSTRAINT `FK_SensitiveChannels_Applications` FOREIGN KEY (`fromapp`) REFERENCES `Applications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SensitiveChannels_Applications_2` FOREIGN KEY (`toapp`) REFERENCES `Applications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SensitiveChannels_Intents` FOREIGN KEY (`intent_id`) REFERENCES `Intents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SensitiveChannels_ExitPoints` FOREIGN KEY (`exitpoint`) REFERENCES `ExitPoints` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SensitiveChannels_Classes` FOREIGN KEY (`entryclass`) REFERENCES `Classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SensitiveChannels_IntentFilters` FOREIGN KEY (`filter_id`) REFERENCES `IntentFilters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.SourceSinkCount
CREATE TABLE IF NOT EXISTS `SourceSinkCount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AppID` int(11) NOT NULL,
  `num_Sources` int(11) NOT NULL,
  `num_sinks` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




-- Dumping structure for table dialdroid_test.UriData
CREATE TABLE IF NOT EXISTS `UriData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scheme` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `ssp` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `uri` longtext COLLATE utf8mb4_bin,
  `path` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `query` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL,
  `authority` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.Uris
CREATE TABLE IF NOT EXISTS `Uris` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exit_id` int(11) NOT NULL,
  `data` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exit_id` (`exit_id`),
  KEY `data` (`data`),
  CONSTRAINT `Uris_ibfk_1` FOREIGN KEY (`exit_id`) REFERENCES `ExitPoints` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Uris_ibfk_2` FOREIGN KEY (`data`) REFERENCES `UriData` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;




-- Dumping structure for table dialdroid_test.UsesPermissions
CREATE TABLE IF NOT EXISTS `UsesPermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `uses_permission` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `app_id` (`app_id`),
  KEY `uses_permission_idx` (`uses_permission`) USING HASH,
  CONSTRAINT `UsesPermissions_ibfk_1` FOREIGN KEY (`app_id`) REFERENCES `Applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `UsesPermissions_ibfk_2` FOREIGN KEY (`uses_permission`) REFERENCES `PermissionStrings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
