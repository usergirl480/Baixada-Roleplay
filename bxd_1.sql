-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.6.4-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para bxd
CREATE DATABASE IF NOT EXISTS `bxd` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `bxd`;

-- Copiando estrutura para tabela bxd.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `steam` varchar(50) NOT NULL DEFAULT '0',
  `discord` varchar(50) DEFAULT NULL,
  `token` varchar(5000) DEFAULT NULL,
  `endpoint` varchar(50) DEFAULT NULL,
  `whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `ingame_whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `crypto` int(11) NOT NULL DEFAULT 0,
  `vehicles` int(11) NOT NULL DEFAULT 0,
  `residences` int(11) NOT NULL DEFAULT 0,
  `time_played` int(11) NOT NULL DEFAULT 0,
  `sudo` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`steam`) USING BTREE,
  KEY `steam` (`steam`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(255) NOT NULL,
  `token` varchar(500) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL DEFAULT 'ban',
  `expire_time` int(11) DEFAULT NULL,
  `staff_id` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `steam` (`steam`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.buyers
CREATE TABLE IF NOT EXISTS `buyers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(255) NOT NULL,
  `product` varchar(255) NOT NULL DEFAULT '',
  `expire_time` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expired_at` timestamp NULL DEFAULT NULL,
  `is_active` int(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `steam` (`steam`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `serial` varchar(6) DEFAULT NULL,
  `name` varchar(50) DEFAULT 'Individuo',
  `name2` varchar(50) DEFAULT 'Indigente',
  `surname` varchar(50) DEFAULT 'Desconhecido',
  `bank` int(11) NOT NULL DEFAULT 1500,
  `fines` int(11) NOT NULL DEFAULT 0,
  `garage` int(3) NOT NULL DEFAULT 1,
  `homes` int(3) NOT NULL DEFAULT 1,
  `prison` int(11) NOT NULL DEFAULT 0,
  `port` int(1) NOT NULL DEFAULT 0,
  `oab` int(11) NOT NULL DEFAULT 0,
  `wanted` int(11) NOT NULL DEFAULT 0,
  `penal` int(1) NOT NULL DEFAULT 0,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `uptime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.characters_arena
CREATE TABLE IF NOT EXISTS `characters_arena` (
  `user_id` int(11) NOT NULL,
  `kills` int(11) NOT NULL DEFAULT 0,
  `deaths` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.characters_data
CREATE TABLE IF NOT EXISTS `characters_data` (
  `user_id` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`dkey`),
  KEY `user_id` (`user_id`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.characters_vehicles
CREATE TABLE IF NOT EXISTS `characters_vehicles` (
  `user_id` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `tax` int(20) NOT NULL DEFAULT 0,
  `plate` varchar(20) DEFAULT NULL,
  `hardness` int(1) NOT NULL DEFAULT 0,
  `rental` int(11) NOT NULL DEFAULT 0,
  `rendays` int(11) NOT NULL DEFAULT 0,
  `arrest` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `engine` int(11) NOT NULL DEFAULT 1000,
  `body` int(11) NOT NULL DEFAULT 1000,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `nitro` int(11) NOT NULL DEFAULT 0,
  `work` varchar(10) NOT NULL DEFAULT 'false',
  `doors` varchar(254) NOT NULL,
  `windows` varchar(254) NOT NULL,
  `tyres` varchar(254) NOT NULL,
  `brakes` varchar(254) NOT NULL,
  PRIMARY KEY (`user_id`,`vehicle`),
  KEY `user_id` (`user_id`),
  KEY `vehicle` (`vehicle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.chests
CREATE TABLE IF NOT EXISTS `chests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `weight` int(10) NOT NULL DEFAULT 0,
  `perm` varchar(100) NOT NULL,
  `coords` varchar(100) NOT NULL DEFAULT '[]',
  `logs` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.crafting
CREATE TABLE IF NOT EXISTS `crafting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `coords` varchar(100) NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.entitydata
CREATE TABLE IF NOT EXISTS `entitydata` (
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`dkey`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.groups
CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) NOT NULL,
  `group` varchar(50) NOT NULL,
  `rank` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`character_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=960 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.logs
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.prison
CREATE TABLE IF NOT EXISTS `prison` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `police` varchar(255) DEFAULT '0',
  `nuser_id` int(11) NOT NULL DEFAULT 0,
  `services` int(11) NOT NULL DEFAULT 0,
  `fines` int(11) NOT NULL DEFAULT 0,
  `text` longtext DEFAULT NULL,
  `date` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.properties
CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT 'Homes0001',
  `interior` varchar(255) NOT NULL DEFAULT 'Middle',
  `tax` int(20) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `residents` int(11) NOT NULL DEFAULT 1,
  `vault` int(11) NOT NULL DEFAULT 1,
  `fridge` int(11) NOT NULL DEFAULT 1,
  `owner` int(1) NOT NULL DEFAULT 0,
  `contract` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=385 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.punishments
CREATE TABLE IF NOT EXISTS `punishments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(50) NOT NULL DEFAULT 'ban',
  `duration` varchar(50) DEFAULT NULL,
  `comment` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.races
CREATE TABLE IF NOT EXISTS `races` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `raceid` int(3) NOT NULL DEFAULT 0,
  `user_id` int(5) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL DEFAULT 'Individuo Indigente',
  `vehicle` varchar(50) NOT NULL DEFAULT 'Sultan RS',
  `points` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.requests
CREATE TABLE IF NOT EXISTS `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(50) NOT NULL DEFAULT 'NONE',
  `requested_by` int(11) NOT NULL,
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `attended_by` int(11) DEFAULT NULL,
  `attended_at` timestamp NULL DEFAULT NULL,
  `description` text NOT NULL,
  `location` varchar(50) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_bank_invoices
CREATE TABLE IF NOT EXISTS `smartphone_bank_invoices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `payee_id` int(11) NOT NULL,
  `payer_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL DEFAULT '',
  `value` int(11) NOT NULL,
  `paid` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_blocks
CREATE TABLE IF NOT EXISTS `smartphone_blocks` (
  `user_id` int(11) NOT NULL,
  `phone` varchar(32) NOT NULL,
  PRIMARY KEY (`user_id`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_calls
CREATE TABLE IF NOT EXISTS `smartphone_calls` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `initiator` varchar(255) NOT NULL,
  `target` varchar(255) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL,
  `video` tinyint(4) NOT NULL DEFAULT 0,
  `anonymous` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `initiator_index` (`initiator`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB AUTO_INCREMENT=365 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_contacts
CREATE TABLE IF NOT EXISTS `smartphone_contacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_index` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=396 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_gallery
CREATE TABLE IF NOT EXISTS `smartphone_gallery` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `folder` varchar(255) NOT NULL DEFAULT '/',
  `url` varchar(255) NOT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_instagram
CREATE TABLE IF NOT EXISTS `smartphone_instagram` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `bio` varchar(255) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=305 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_instagram_followers
CREATE TABLE IF NOT EXISTS `smartphone_instagram_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`follower_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_instagram_likes
CREATE TABLE IF NOT EXISTS `smartphone_instagram_likes` (
  `post_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`post_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_instagram_notifications
CREATE TABLE IF NOT EXISTS `smartphone_instagram_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `content` varchar(512) NOT NULL,
  `saw` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2061 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_instagram_posts
CREATE TABLE IF NOT EXISTS `smartphone_instagram_posts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` bigint(20) NOT NULL,
  `post_id` bigint(20) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`),
  KEY `post_id_index` (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=541 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_olx
CREATE TABLE IF NOT EXISTS `smartphone_olx` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `description` varchar(1024) NOT NULL,
  `images` varchar(1024) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_paypal_transactions
CREATE TABLE IF NOT EXISTS `smartphone_paypal_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'payment',
  `description` varchar(255) DEFAULT NULL,
  `value` bigint(20) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_tinder
CREATE TABLE IF NOT EXISTS `smartphone_tinder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(1024) NOT NULL,
  `age` tinyint(4) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `show_gender` tinyint(4) NOT NULL,
  `tags` varchar(255) NOT NULL,
  `show_tags` tinyint(4) NOT NULL,
  `target` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `gender_index` (`gender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_tinder_messages
CREATE TABLE IF NOT EXISTS `smartphone_tinder_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `liked` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_tinder_rating
CREATE TABLE IF NOT EXISTS `smartphone_tinder_rating` (
  `profile_id` int(11) NOT NULL,
  `rated_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`profile_id`,`rated_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_tor_messages
CREATE TABLE IF NOT EXISTS `smartphone_tor_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel` varchar(24) NOT NULL DEFAULT 'geral',
  `sender` varchar(255) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_index` (`channel`),
  KEY `sender_index` (`sender`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_tor_payments
CREATE TABLE IF NOT EXISTS `smartphone_tor_payments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `amount` int(11) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_twitter_followers
CREATE TABLE IF NOT EXISTS `smartphone_twitter_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_twitter_likes
CREATE TABLE IF NOT EXISTS `smartphone_twitter_likes` (
  `tweet_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  KEY `tweet_id_index` (`tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_twitter_profiles
CREATE TABLE IF NOT EXISTS `smartphone_twitter_profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `bannerURL` varchar(255) NOT NULL,
  `bio` varchar(255) DEFAULT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_twitter_tweets
CREATE TABLE IF NOT EXISTS `smartphone_twitter_tweets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` bigint(20) DEFAULT NULL,
  `content` varchar(280) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`),
  KEY `tweet_id_index` (`tweet_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_whatsapp
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp` (
  `owner` varchar(32) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `read_receipts` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_whatsapp_channels
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_channels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_whatsapp_groups
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `members` varchar(2048) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.smartphone_whatsapp_messages
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) unsigned NOT NULL,
  `sender` varchar(50) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL,
  `readed` tinyint(4) NOT NULL DEFAULT 0,
  `saw_at` bigint(20) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `channel_id_index` (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2746 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.squads
CREATE TABLE IF NOT EXISTS `squads` (
  `squad` varchar(255) NOT NULL,
  `squad_name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `reputation` int(11) NOT NULL DEFAULT 0,
  `radio_frequency` int(11) DEFAULT NULL,
  `max_leaders` int(11) NOT NULL DEFAULT 3,
  `max_members` int(11) NOT NULL DEFAULT 30,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  UNIQUE KEY `squad` (`squad`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.uniforms
CREATE TABLE IF NOT EXISTS `uniforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `sex` varchar(50) DEFAULT NULL,
  `custom` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela bxd.vips
CREATE TABLE IF NOT EXISTS `vips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `max_chars` int(11) DEFAULT 1,
  `expire_time` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expired_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `steam` (`steam`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

-- Exportação de dados foi desmarcado.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
