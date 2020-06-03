-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 31 mei 2020 om 21:20
-- Serverversie: 10.4.11-MariaDB
-- PHP-versie: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `randstad`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `apartments`
--

CREATE TABLE `apartments` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `citizenid` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden geëxporteerd voor tabel `apartments`
--

INSERT INTO `apartments` (`id`, `name`, `type`, `label`, `citizenid`) VALUES
(1, 'apartment53356', 'apartment5', 'Fantastic Plaza 3356', 'RXT56326');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `bans`
--

CREATE TABLE `bans` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` varchar(50) DEFAULT NULL,
  `expire` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `bans`
--

INSERT INTO `bans` (`id`, `name`, `steam`, `license`, `discord`, `ip`, `reason`, `expire`) VALUES
(5, 'bartieman', 'steam:110000107ff9b7f', 'license:8112d8a6073f43942234e84de18aed18319304e1', 'xbl:2535418960026131', 'live:1688853957365543', 'Helaas', 2147483647),
(10, 'Jakodii', 'steam:110000101de6e7a', 'license:24d983d1a4482dfc6a60cdc89b3b2be56ac76269', 'xbl:2535470573132692', 'live:844425570282186', 'Joejoe', 2147483647),
(11, 'Liggi', 'steam:110000116e71f66', 'license:a55a979e43b6efee99166b7cac81f91893a2de8b', 'xbl:2535472549551469', 'live:844424974444281', 'Nice Try. ', 2147483647),
(13, 'Cola Cinema', 'steam:110000109cd4341', 'license:a276b135383f196d670abc8a6d139123100a4f8f', 'xbl:2533275030448590', 'live:914801162309999', 'Bug abuse', 2147483647),
(14, 'aspiire', 'steam:1100001064d7de2', 'license:ccfc2f3dd9a770397c6e541e3ed81601723b9494', 'xbl:2533275030448590', 'live:914801162309999', 'Bug abuse', 2147483647),
(17, 'Twitch Edjeking', 'steam:110000135e2c897', 'license:95740550baaf4fc47b2a99fa2dc18776e8d90aa5', 'xbl:2535420675869107', 'live:914798254955586', 'Je blijft gedrag vertonen dat niet past bij het ni', 1576528808);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `bills`
--

CREATE TABLE `bills` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `gangs`
--

CREATE TABLE `gangs` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `grades` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `gloveboxitems`
--

CREATE TABLE `gloveboxitems` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `gloveboxitemsnew`
--

CREATE TABLE `gloveboxitemsnew` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `houselocations`
--

CREATE TABLE `houselocations` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `coords` text NOT NULL,
  `owned` tinyint(2) NOT NULL,
  `price` int(11) NOT NULL,
  `tier` tinyint(2) NOT NULL,
  `garage` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `house_plants`
--

CREATE TABLE `house_plants` (
  `id` int(11) NOT NULL,
  `building` varchar(50) DEFAULT NULL,
  `stage` varchar(50) DEFAULT 'stage-a',
  `sort` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `food` int(11) DEFAULT 100,
  `health` int(11) DEFAULT 100,
  `progress` int(11) DEFAULT 0,
  `coords` text DEFAULT NULL,
  `plantid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `grades` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `occasion_vehicles`
--

CREATE TABLE `occasion_vehicles` (
  `id` int(11) NOT NULL,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionId` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `permission` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden geëxporteerd voor tabel `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `steam`, `license`, `permission`) VALUES
(1, 'Maestro', 'steam:1100001062640e8', 'license:8228db7c1b7d1307feacd77f67eaaba679509fee', 'god');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_messages`
--

CREATE TABLE `phone_messages` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_tweets`
--

CREATE TABLE `phone_tweets` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `playerammo`
--

CREATE TABLE `playerammo` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `ammo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden geëxporteerd voor tabel `playerammo`
--

INSERT INTO `playerammo` (`id`, `citizenid`, `ammo`) VALUES
(1, 'RXT56326', '{\"AMMO_SHOTGUN\":2,\"AMMO_SMG\":1,\"AMMO_PISTOL\":0,\"AMMO_RIFLE\":1}');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `playeritems`
--

CREATE TABLE `playeritems` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `players`
--

CREATE TABLE `players` (
  `#` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden geëxporteerd voor tabel `players`
--

INSERT INTO `players` (`#`, `citizenid`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `job`, `position`, `metadata`, `inventory`) VALUES
(1, 'RXT56326', 1, 'steam:1100001062640e8', 'license:8228db7c1b7d1307feacd77f67eaaba679509fee', 'Maestro', '{\"cash\":1238.0,\"crypto\":0,\"bank\":8321560}', '{\"birthdate\":\"1990-10-10\",\"cid\":\"1\",\"gender\":0,\"backstory\":\"placeholder backstory\",\"nationality\":\"Turks\",\"account\":\"NL03RANDSTAD5971769525\",\"phone\":\"0671799045\",\"lastname\":\"Cinar\",\"firstname\":\"Sait\"}', '{\"payment\":500,\"name\":\"ambulance\",\"onduty\":true,\"label\":\"Ambulance\"}', '{\"y\":-330.22232055664,\"z\":37.503883361816,\"a\":165.12271118164,\"x\":-832.92413330078}', '{\"jailitems\":[],\"tracker\":false,\"status\":[],\"criminalrecord\":{\"hasRecord\":false},\"hunger\":83.2,\"dealerrep\":0,\"thirst\":84.8,\"currentapartment\":\"apartment53356\",\"bloodtype\":\"A+\",\"callsign\":\"NO CALLSIGN\",\"licences\":{\"driver\":true,\"business\":false},\"inside\":{\"apartment\":[]},\"jobrep\":{\"tow\":0,\"trucker\":0,\"taxi\":0},\"craftingrep\":0,\"fitbit\":[],\"armor\":0,\"commandbinds\":{\"F9\":{\"argument\":\"\",\"command\":\"\"},\"F7\":{\"argument\":\"\",\"command\":\"\"},\"F6\":{\"argument\":\"\",\"command\":\"\"},\"F10\":{\"argument\":\"\",\"command\":\"\"},\"F5\":{\"argument\":\"\",\"command\":\"\"},\"F2\":{\"argument\":\"\",\"command\":\"admin\"},\"F3\":{\"argument\":\"\",\"command\":\"\"}},\"phone\":{\"settings\":{\"background\":\"bg-3\",\"notifications\":false}},\"isdead\":false,\"fingerprint\":\"vT542q56uNZ7931\",\"ishandcuffed\":false,\"injail\":0}', '[{\"amount\":1,\"slot\":1,\"name\":\"weapon_pistol_mk2\",\"info\":{\"serie\":\"82Erw3Pa109aarH\",\"attachments\":[{\"component\":\"COMPONENT_AT_PI_FLSH_02\",\"label\":\"Flashlight\"}]},\"type\":\"weapon\"},{\"amount\":1,\"slot\":2,\"name\":\"weapon_stungun\",\"info\":{\"serie\":\"92lqQ1tu106DQGL\"},\"type\":\"weapon\"},{\"amount\":1,\"slot\":3,\"name\":\"weapon_pumpshotgun\",\"info\":{\"serie\":\"32XaX6iU263nKgX\",\"attachments\":[{\"component\":\"COMPONENT_AT_AR_FLSH\",\"label\":\"Flashlight\"}]},\"type\":\"weapon\"},{\"amount\":1,\"slot\":4,\"name\":\"weapon_smg\",\"info\":{\"serie\":\"32KfW6Hj985TaKD\",\"attachments\":[{\"component\":\"COMPONENT_AT_SCOPE_MACRO_02\",\"label\":\"1x Scope\"},{\"component\":\"COMPONENT_AT_AR_FLSH\",\"label\":\"Flashlight\"}]},\"type\":\"weapon\"},{\"amount\":1,\"slot\":5,\"name\":\"weapon_carbinerifle\",\"info\":{\"serie\":\"70JmC3Yl648rMQY\",\"attachments\":[{\"component\":\"COMPONENT_AT_AR_FLSH\",\"label\":\"Flashlight\"},{\"component\":\"COMPONENT_AT_SCOPE_MEDIUM\",\"label\":\"3x Scope\"}]},\"type\":\"weapon\"},{\"amount\":1,\"slot\":6,\"name\":\"id_card\",\"info\":{\"birthdate\":\"1990-10-10\",\"nationality\":\"Turks\",\"citizenid\":\"RXT56326\",\"gender\":0,\"lastname\":\"Cinar\",\"firstname\":\"Sait\"},\"type\":\"item\"},{\"amount\":1,\"slot\":7,\"name\":\"driver_license\",\"info\":{\"birthdate\":\"1990-10-10\",\"lastname\":\"Cinar\",\"firstname\":\"Sait\",\"type\":\"A1-A2-A | AM-B | C1-C-CE\"},\"type\":\"item\"},{\"amount\":1,\"slot\":8,\"name\":\"phone\",\"info\":[],\"type\":\"item\"},{\"amount\":4,\"slot\":9,\"name\":\"lockpick\",\"info\":[],\"type\":\"item\"},{\"amount\":1,\"slot\":10,\"name\":\"heavyarmor\",\"info\":\"\",\"type\":\"item\"},{\"amount\":1,\"slot\":11,\"name\":\"weapon_snspistol\",\"info\":{\"serie\":\"83pvk8bD289udXK\"},\"type\":\"weapon\"},{\"amount\":1,\"slot\":12,\"name\":\"weapon_carbinerifle\",\"info\":{\"serie\":\"82gdc4Jy887fmmz\"},\"type\":\"weapon\"},{\"amount\":8,\"slot\":13,\"name\":\"rifle_ammo\",\"info\":[],\"type\":\"item\"},{\"amount\":1,\"slot\":14,\"name\":\"advancedlockpick\",\"info\":\"\",\"type\":\"item\"}]');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `playerskins`
--

CREATE TABLE `playerskins` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden geëxporteerd voor tabel `playerskins`
--

INSERT INTO `playerskins` (`id`, `citizenid`, `model`, `skin`, `active`) VALUES
(3, 'RXT56326', '1885233650', '{\"lipstick\":{\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1,\"item\":-1},\"watch\":{\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0,\"item\":-1},\"bracelet\":{\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0,\"item\":-1},\"shoes\":{\"defaultTexture\":0,\"defaultItem\":1,\"texture\":0,\"item\":4},\"ear\":{\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0,\"item\":-1},\"arms\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"mask\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"hair\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"beard\":{\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1,\"item\":-1},\"torso2\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":7},\"blush\":{\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1,\"item\":-1},\"ageing\":{\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0,\"item\":-1},\"vest\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"decals\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"pants\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":4},\"eyebrows\":{\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1,\"item\":-1},\"hat\":{\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0,\"item\":-1},\"bag\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"face\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"accessory\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"t-shirt\":{\"defaultTexture\":0,\"defaultItem\":1,\"texture\":0,\"item\":17},\"glass\":{\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0,\"item\":0},\"makeup\":{\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1,\"item\":-1}}', 1);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_boats`
--

CREATE TABLE `player_boats` (
  `#` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `boathouse` varchar(50) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `state` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_contacts`
--

CREATE TABLE `player_contacts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_houses`
--

CREATE TABLE `player_houses` (
  `house` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` text NOT NULL,
  `stash` text NOT NULL,
  `outfit` text NOT NULL,
  `logout` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_mails`
--

CREATE TABLE `player_mails` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_outfits`
--

CREATE TABLE `player_outfits` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `player_outfits`
--

INSERT INTO `player_outfits` (`id`, `citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES
(1, 'RXT56326', 'test', '1885233650', '{\"beard\":{\"defaultTexture\":1,\"defaultItem\":-1,\"item\":-1,\"texture\":1},\"vest\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"arms\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"decals\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"bracelet\":{\"defaultTexture\":0,\"defaultItem\":-1,\"item\":-1,\"texture\":0},\"ageing\":{\"defaultTexture\":0,\"defaultItem\":-1,\"item\":-1,\"texture\":0},\"face\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"t-shirt\":{\"defaultTexture\":0,\"defaultItem\":1,\"item\":17,\"texture\":0},\"hair\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"torso2\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":7,\"texture\":0},\"hat\":{\"defaultTexture\":0,\"defaultItem\":-1,\"item\":-1,\"texture\":0},\"watch\":{\"defaultTexture\":0,\"defaultItem\":-1,\"item\":-1,\"texture\":0},\"makeup\":{\"defaultTexture\":1,\"defaultItem\":-1,\"item\":-1,\"texture\":1},\"glass\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"accessory\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"shoes\":{\"defaultTexture\":0,\"defaultItem\":1,\"item\":4,\"texture\":0},\"mask\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0},\"blush\":{\"defaultTexture\":1,\"defaultItem\":-1,\"item\":-1,\"texture\":1},\"lipstick\":{\"defaultTexture\":1,\"defaultItem\":-1,\"item\":-1,\"texture\":1},\"eyebrows\":{\"defaultTexture\":1,\"defaultItem\":-1,\"item\":-1,\"texture\":1},\"pants\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":4,\"texture\":0},\"ear\":{\"defaultTexture\":0,\"defaultItem\":-1,\"item\":-1,\"texture\":0},\"bag\":{\"defaultTexture\":0,\"defaultItem\":0,\"item\":0,\"texture\":0}}', 'outfit-4-6280');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_vehicles`
--

CREATE TABLE `player_vehicles` (
  `steam` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(50) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `player_vehicles`
--

INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `fakeplate`, `garage`, `fuel`, `engine`, `body`, `state`, `depotprice`) VALUES
('steam:1100001062640e8', 'RXT56326', 't20', '1663218586', '{\"modFrame\":-1,\"modOrnaments\":-1,\"modSuspension\":-1,\"modExhaust\":-1,\"color1\":0,\"modStruts\":-1,\"modSpoilers\":-1,\"modAirFilter\":-1,\"modArmor\":-1,\"modFender\":-1,\"modLivery\":-1,\"modXenon\":false,\"modSpeakers\":-1,\"modSideSkirt\":-1,\"modShifterLeavers\":-1,\"color2\":0,\"modPlateHolder\":-1,\"modSteeringWheel\":-1,\"modCustomTyres\":false,\"neonEnabled\":[false,false,false,false],\"modHorns\":-1,\"modDashboard\":-1,\"neonColor\":[255,0,255],\"modDoorSpeaker\":-1,\"modWindows\":-1,\"modTransmission\":-1,\"modTrimA\":-1,\"modTrunk\":-1,\"modGrille\":-1,\"modTrimB\":-1,\"modSmokeEnabled\":false,\"modEngineBlock\":-1,\"modHydrolic\":-1,\"plateIndex\":0,\"modSeats\":-1,\"extras\":[],\"modFrontBumper\":-1,\"plate\":\"7MI174LL\",\"model\":1663218586,\"wheels\":7,\"windowTint\":0,\"modBrakes\":-1,\"health\":998,\"tyreSmokeColor\":[255,255,255],\"modTurbo\":false,\"pearlescentColor\":3,\"modEngine\":2,\"modVanityPlate\":-1,\"modDial\":-1,\"modArchCover\":-1,\"modTank\":-1,\"modRoof\":-1,\"modFrontWheels\":-1,\"wheelColor\":0,\"dirtLevel\":7.4001407623291,\"modRearBumper\":-1,\"modRightFender\":-1,\"modAPlate\":-1,\"modAerials\":-1,\"modHood\":-1,\"modBackWheels\":-1}', '7MI174LL', NULL, NULL, 100, 1000, 1000, 0, 0);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_warns`
--

CREATE TABLE `player_warns` (
  `#` int(11) NOT NULL,
  `senderIdentifier` varchar(50) DEFAULT NULL,
  `targetIdentifier` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warnId` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `queue`
--

CREATE TABLE `queue` (
  `id` int(11) NOT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `priority` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `queue`
--

INSERT INTO `queue` (`id`, `steam`, `license`, `name`, `priority`) VALUES
(1, 'steam:1100001062640e8', 'license:8228db7c1b7d1307feacd77f67eaaba679509fee', 'Maestro', 99);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `stashitems`
--

CREATE TABLE `stashitems` (
  `id` int(11) NOT NULL,
  `stash` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `stashitemsnew`
--

CREATE TABLE `stashitemsnew` (
  `id` int(11) NOT NULL,
  `stash` varchar(255) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden geëxporteerd voor tabel `stashitemsnew`
--

INSERT INTO `stashitemsnew` (`id`, `stash`, `items`) VALUES
(1, 'apartment53356', '[]'),
(2, 'policeevidence', '[]');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `trunkitems`
--

CREATE TABLE `trunkitems` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `trunkitemsnew`
--

CREATE TABLE `trunkitemsnew` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `whitelist`
--

CREATE TABLE `whitelist` (
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gegevens worden geëxporteerd voor tabel `whitelist`
--

INSERT INTO `whitelist` (`steam`, `license`, `name`) VALUES
('steam:1100001062640e8', 'license:8228db7c1b7d1307feacd77f67eaaba679509fee', 'Maestro');

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `apartments`
--
ALTER TABLE `apartments`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `gangs`
--
ALTER TABLE `gangs`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `gloveboxitems`
--
ALTER TABLE `gloveboxitems`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `gloveboxitemsnew`
--
ALTER TABLE `gloveboxitemsnew`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `houselocations`
--
ALTER TABLE `houselocations`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `house_plants`
--
ALTER TABLE `house_plants`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `occasion_vehicles`
--
ALTER TABLE `occasion_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `phone_messages`
--
ALTER TABLE `phone_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `phone_tweets`
--
ALTER TABLE `phone_tweets`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `playerammo`
--
ALTER TABLE `playerammo`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `playeritems`
--
ALTER TABLE `playeritems`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`#`);

--
-- Indexen voor tabel `playerskins`
--
ALTER TABLE `playerskins`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_boats`
--
ALTER TABLE `player_boats`
  ADD PRIMARY KEY (`#`);

--
-- Indexen voor tabel `player_contacts`
--
ALTER TABLE `player_contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_houses`
--
ALTER TABLE `player_houses`
  ADD PRIMARY KEY (`house`);

--
-- Indexen voor tabel `player_mails`
--
ALTER TABLE `player_mails`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_outfits`
--
ALTER TABLE `player_outfits`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_vehicles`
--
ALTER TABLE `player_vehicles`
  ADD PRIMARY KEY (`plate`);

--
-- Indexen voor tabel `player_warns`
--
ALTER TABLE `player_warns`
  ADD PRIMARY KEY (`#`);

--
-- Indexen voor tabel `queue`
--
ALTER TABLE `queue`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `stashitems`
--
ALTER TABLE `stashitems`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `stashitemsnew`
--
ALTER TABLE `stashitemsnew`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `trunkitems`
--
ALTER TABLE `trunkitems`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `trunkitemsnew`
--
ALTER TABLE `trunkitemsnew`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `whitelist`
--
ALTER TABLE `whitelist`
  ADD PRIMARY KEY (`steam`),
  ADD UNIQUE KEY `identifier` (`license`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `apartments`
--
ALTER TABLE `apartments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT voor een tabel `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT voor een tabel `bills`
--
ALTER TABLE `bills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `gangs`
--
ALTER TABLE `gangs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `gloveboxitems`
--
ALTER TABLE `gloveboxitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `gloveboxitemsnew`
--
ALTER TABLE `gloveboxitemsnew`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `houselocations`
--
ALTER TABLE `houselocations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT voor een tabel `house_plants`
--
ALTER TABLE `house_plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `occasion_vehicles`
--
ALTER TABLE `occasion_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT voor een tabel `phone_messages`
--
ALTER TABLE `phone_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `phone_tweets`
--
ALTER TABLE `phone_tweets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT voor een tabel `playerammo`
--
ALTER TABLE `playerammo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT voor een tabel `playeritems`
--
ALTER TABLE `playeritems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `players`
--
ALTER TABLE `players`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT voor een tabel `playerskins`
--
ALTER TABLE `playerskins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT voor een tabel `player_boats`
--
ALTER TABLE `player_boats`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `player_contacts`
--
ALTER TABLE `player_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `player_mails`
--
ALTER TABLE `player_mails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `player_outfits`
--
ALTER TABLE `player_outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT voor een tabel `player_warns`
--
ALTER TABLE `player_warns`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `queue`
--
ALTER TABLE `queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT voor een tabel `stashitems`
--
ALTER TABLE `stashitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `stashitemsnew`
--
ALTER TABLE `stashitemsnew`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT voor een tabel `trunkitems`
--
ALTER TABLE `trunkitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `trunkitemsnew`
--
ALTER TABLE `trunkitemsnew`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
