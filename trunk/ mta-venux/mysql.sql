-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Machine: localhost
-- Genereertijd: 11 feb 2012 om 13:12
-- Serverversie: 5.5.16
-- PHP-Versie: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `rpvx`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL,
  `password` varchar(180) NOT NULL,
  `serial` varchar(200) NOT NULL,
  `rank` int(2) NOT NULL,
  `adminduty` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `characters`
--

CREATE TABLE IF NOT EXISTS `characters` (
  `charid` int(20) NOT NULL AUTO_INCREMENT,
  `charactername` varchar(60) NOT NULL,
  `accountid` int(20) NOT NULL,
  `charskin` int(3) NOT NULL,
  `age` int(5) NOT NULL,
  `intelligence` int(5) NOT NULL,
  `faction_id` int(3) NOT NULL DEFAULT '1',
  `faction_name` varchar(70) NOT NULL DEFAULT 'San Andreas Government',
  `faction_rank` int(5) NOT NULL DEFAULT '1',
  `hospitalized` int(30) NOT NULL DEFAULT '0',
  `driverslicense` int(1) NOT NULL DEFAULT '0',
  `drivingexperience` int(30) NOT NULL,
  `charlevel` int(3) NOT NULL,
  `charexp` int(20) NOT NULL,
  `perk1` varchar(20) NOT NULL,
  `perk2` varchar(20) NOT NULL,
  `cash` int(50) NOT NULL,
  `savedX` varchar(100) NOT NULL,
  `savedY` varchar(100) NOT NULL,
  `savedZ` varchar(100) NOT NULL,
  `health` int(3) NOT NULL DEFAULT '100',
  `armor` int(3) NOT NULL DEFAULT '0',
  `interior` int(5) NOT NULL DEFAULT '0',
  `dimension` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`charid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `interiors`
--

CREATE TABLE IF NOT EXISTS `interiors` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `type` int(1) NOT NULL,
  `interior` int(5) NOT NULL,
  `dimension` int(50) NOT NULL,
  `owner` varchar(120) NOT NULL,
  `locked` int(1) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `intx` float NOT NULL,
  `inty` float NOT NULL,
  `intz` float NOT NULL,
  `cost` int(100) NOT NULL,
  `rented` int(1) NOT NULL,
  `renter` int(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `itemid` int(100) NOT NULL,
  `itemname` varchar(100) NOT NULL,
  `owner` int(10) NOT NULL,
  `itemvalue` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
  `vehicleID` int(100) NOT NULL AUTO_INCREMENT,
  `model` int(5) NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotX` float NOT NULL,
  `rotY` float NOT NULL,
  `rotZ` float NOT NULL,
  `numberplate` text NOT NULL,
  `ownerID` int(100) NOT NULL,
  `interior` int(30) NOT NULL,
  `dimension` int(30) NOT NULL,
  `enginestate` tinyint(1) NOT NULL,
  `fuel` int(4) NOT NULL,
  `tintedwindows` int(1) NOT NULL,
  `faction` int(10) NOT NULL,
  `locked` tinyint(1) NOT NULL,
  `lights` int(1) NOT NULL,
  `respawnX` float NOT NULL,
  `respawnY` float NOT NULL,
  `respawnZ` float NOT NULL,
  `respawnRotX` float NOT NULL,
  `respawnRotY` float NOT NULL,
  `respawnRotZ` float NOT NULL,
  `red1` int(3) NOT NULL,
  `green1` int(3) NOT NULL,
  `blue1` int(3) NOT NULL,
  `red2` int(3) NOT NULL,
  `green2` int(3) NOT NULL,
  `blue2` int(3) NOT NULL,
  `health` int(5) NOT NULL,
  PRIMARY KEY (`vehicleID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
