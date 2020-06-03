-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 14 dec 2019 om 15:59
-- Serverversie: 10.4.8-MariaDB
-- PHP-versie: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Randstad`
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
(1, 'fiets', 'steam:11000010b95efb8', 'license:8c96c478587afdcd517de36f0b4ed45957ba2123', 'discord:191320816862887937', 'ip:80.114.206.249', 'Je kunt je blijkbaar niet gedragen', 2147483647),
(3, 'tim', 'steam:11000011a3c4ff1', 'license:bc41c31883378b67607fb548e16d3d6bc87be95d', 'discord:331046686153768960', 'ip:217.121.53.14', 'RDM', 2147483647),
(5, 'bartieman', 'steam:110000107ff9b7f', 'license:8112d8a6073f43942234e84de18aed18319304e1', 'xbl:2535418960026131', 'live:1688853957365543', 'Helaas', 2147483647),
(7, 'floes', 'steam:110000110044f24', 'license:3ea534055ef3c252b02dc429e411746b139a8218', 'xbl:2535444702978834', 'live:1055521588245682', 'FailRP', 1576410602),
(8, 'JoZo', 'steam:11000010b9ff7cd', 'license:d14008e09a91eef97eb44b365d93d989a3a48286', 'xbl:2535414149498345', 'live:1899947114653993', 'r9k', 2147483647),
(10, 'Jakodii', 'steam:110000101de6e7a', 'license:24d983d1a4482dfc6a60cdc89b3b2be56ac76269', 'xbl:2535470573132692', 'live:844425570282186', 'Joejoe', 2147483647),
(11, 'Liggi', 'steam:110000116e71f66', 'license:a55a979e43b6efee99166b7cac81f91893a2de8b', 'xbl:2535472549551469', 'live:844424974444281', 'Nice Try. ', 2147483647),
(12, 'Duyvis', 'steam:11000011a37e12a', 'license:521319182ef0306c1e9fabcd8a60bcb0ed5b2c5a', 'xbl:2533275030448590', 'live:914801162309999', 'Meerdere mensen neersteken zonder reden.', 2147483647),
(13, 'Cola Cinema', 'steam:110000109cd4341', 'license:a276b135383f196d670abc8a6d139123100a4f8f', 'xbl:2533275030448590', 'live:914801162309999', 'Bug abuse', 2147483647),
(14, 'aspiire', 'steam:1100001064d7de2', 'license:ccfc2f3dd9a770397c6e541e3ed81601723b9494', 'xbl:2533275030448590', 'live:914801162309999', 'Bug abuse', 2147483647),
(15, 'Giorgos', 'steam:11000010b049298', 'license:4c6a5405c77b5a0a1254e00cc4a01d81fa0c1d77', 'xbl:2535452325047754', 'live:1688849988895279', 'Ik dacht dat we duidelijk waren gisterenavond. Ste', 2147483647),
(16, 'Lana Drahrepus', 'steam:11000010e8ca55c', 'license:023c89a1df763ca838f0aafae797026b53971555', 'xbl:2535447453517914', 'live:914801459232571', 'RP ontwijken en OOC gaan. We verwachten hier echt ', 1576526835),
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
(1, 's0me1', 'steam:110000117fd5be8', 'license:b19a466c8a6553b860896f6724db32dfec9d5aad', 'god'),
(23, 'KASH', 'steam:11000011376add8', 'license:02ee00616b7a259a2e770718ab577fe21bb0b640', 'god'),
(24, 'Vortex', 'steam:11000010ba7977c', 'license:d6e09d6f6b57e9d1f39154704392eeec3ee7ef20', 'admin'),
(25, 'SirMark', 'steam:110000102fca591', 'license:e6da0d712dcaabed8ef7e22bebd0444af0f240ea', 'admin'),
(27, 'Puddingboom-TTV', 'steam:110000106b19d57', 'license:538085036f695619ff679de99518b74cc9dab223', 'admin'),
(28, 'Yan', 'steam:11000013444703e', 'license:8179607422194caf30d13cef18e2c5e4f1b29c38', 'admin'),
(32, 'Rowan', 'steam:11000010f01d610', 'license:8b35c5ea48b3bd15519074cafcd3be59b456046d', 'admin'),
(33, 'Pickleface', 'steam:110000101b63911', 'license:f57de2c8993463ea1b646030404591bea68e2824', 'admin'),
(36, 'RedHawk504', 'steam:1100001055c2ddb', 'license:c080da33eb1b155a4d4c0985e5549e00c7c40d80', 'admin');

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
(1, 'steam:110000117fd5be8', 'license:b19a466c8a6553b860896f6724db32dfec9d5aad', 's0me1', 99),
(2, 'steam:110000103090871', 'license:d13d94bf29cea8bfda8144c4dc9a653df957f72f', 'swekmeister', 50),
(3, 'steam:110000102530ea7', 'license:658ad0dbfe1172453c84bf7f625e30e2b01eceac', 'Saints', 50),
(4, 'steam:1100001062c0a56', 'license:60d55531e88500dc4730064cd8d7865fb0a76d8a', 'ultimateorc', 50);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `playerammo`
--
ALTER TABLE `playerammo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `playeritems`
--
ALTER TABLE `playeritems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `players`
--
ALTER TABLE `players`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `playerskins`
--
ALTER TABLE `playerskins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
