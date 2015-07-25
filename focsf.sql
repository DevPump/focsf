-- phpMyAdmin SQL Dump
-- version 4.4.10
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 25, 2015 at 04:13 AM
-- Server version: 5.5.41-MariaDB
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `DevStumpPeck-Dev_focsf`
--
CREATE DATABASE IF NOT EXISTS `DevStumpPeck-Dev_focsf` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `DevStumpPeck-Dev_focsf`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `SP_SelectAddressesForAutoComplete`$$
CREATE DEFINER=`DevStumpPeck-Dev`@`localhost` PROCEDURE `SP_SelectAddressesForAutoComplete`()
    NO SQL
    COMMENT 'Reads All addresses for autocompletion selection.'
Select ID,Address
FROM Addresses
WHERE status = 1$$

DROP PROCEDURE IF EXISTS `SP_SelectApprovedEvents`$$
CREATE DEFINER=`DevStumpPeck-Dev`@`localhost` PROCEDURE `SP_SelectApprovedEvents`(IN `maxEvents` INT(11))
    NO SQL
    COMMENT 'Returns all approved events after `NOW()`.'
SELECT Event_Info_Core.EventTitle, Event_Info_Core.EventDescription,
Coordinators.CoordinatorName, Coordinators.CoordinatorPhone, Coordinators.CoordinatorEmail,
Addresses.Address, Addresses.Latitude, Addresses.Longitude,
Event_Info.StartDate, Event_Info.EndDate, Event_Info.ExtraNotes

FROM Event_Info
Join Event_Info_Core
on Event_Info_Core.ID = Event_Info.EventInfoID
Join Coordinators 
On Coordinators.ID = Event_Info.CoordinatorID
Join Addresses
On Addresses.ID = Event_Info.AddressID
where Event_Info.StartDate > NOW()
Limit maxEvents$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Addresses`
--

DROP TABLE IF EXISTS `Addresses`;
CREATE TABLE IF NOT EXISTS `Addresses` (
  `ID` int(11) NOT NULL,
  `Address` varchar(95) NOT NULL,
  `Latitude` float(10,8) NOT NULL,
  `Longitude` float(11,8) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT '0' COMMENT '-1: Denied; 0: Unapproved; 1: Approved.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Coordinators`
--

DROP TABLE IF EXISTS `Coordinators`;
CREATE TABLE IF NOT EXISTS `Coordinators` (
  `ID` int(11) NOT NULL,
  `CoordinatorName` text NOT NULL,
  `CoordinatorPhone` text NOT NULL,
  `CoordinatorEmail` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Event_Info`
--

DROP TABLE IF EXISTS `Event_Info`;
CREATE TABLE IF NOT EXISTS `Event_Info` (
  `ID` int(11) NOT NULL,
  `EventInfoID` int(11) NOT NULL COMMENT 'ID for main event Details',
  `CoordinatorID` int(11) NOT NULL COMMENT 'ID for coordinator information.',
  `AddressID` int(11) NOT NULL COMMENT 'ID linking to Address, Latitude and Longitude.',
  `ExtraNotes` varchar(500) NOT NULL COMMENT 'Notes to show everyone that is specifc information after the description.',
  `ManagerNotes` varchar(500) NOT NULL COMMENT 'Notes only to show the community service manager.',
  `StartDate` datetime NOT NULL COMMENT 'Start date and Start Time.',
  `EndDate` datetime NOT NULL COMMENT 'End date and End Time.',
  `Status` int(11) NOT NULL COMMENT '-1: Denied; 0: Unapproved; 1: Approved.'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Event_Info_Core`
--

DROP TABLE IF EXISTS `Event_Info_Core`;
CREATE TABLE IF NOT EXISTS `Event_Info_Core` (
  `ID` int(11) NOT NULL,
  `EventTitle` text NOT NULL,
  `EventDescription` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Addresses`
--
ALTER TABLE `Addresses`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `Address` (`Address`),
  ADD UNIQUE KEY `Latitude` (`Latitude`),
  ADD UNIQUE KEY `ID` (`ID`,`Address`,`Latitude`,`Longitude`);

--
-- Indexes for table `Coordinators`
--
ALTER TABLE `Coordinators`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Event_Info`
--
ALTER TABLE `Event_Info`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Event_Info_Core`
--
ALTER TABLE `Event_Info_Core`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Addresses`
--
ALTER TABLE `Addresses`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `Coordinators`
--
ALTER TABLE `Coordinators`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `Event_Info`
--
ALTER TABLE `Event_Info`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `Event_Info_Core`
--
ALTER TABLE `Event_Info_Core`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
