-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.37 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for campus_db
CREATE DATABASE IF NOT EXISTS `campus_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `campus_db`;

-- Dumping structure for table campus_db.batches
CREATE TABLE IF NOT EXISTS `batches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `batch` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `batches_batch_unique` (`batch`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.batches: ~4 rows (approximately)
REPLACE INTO `batches` (`id`, `batch`, `created_at`, `updated_at`) VALUES
	(1, '23.1', '2026-04-02 05:30:50', '2026-04-02 05:30:50'),
	(2, '23.2', '2026-04-02 05:30:50', '2026-04-02 05:30:50'),
	(3, '24.1', '2026-04-02 05:30:50', '2026-04-02 05:30:50'),
	(4, '24.2', '2026-04-02 05:30:50', '2026-04-02 05:30:50');

-- Dumping structure for table campus_db.cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.cache: ~0 rows (approximately)

-- Dumping structure for table campus_db.cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.cache_locks: ~0 rows (approximately)

-- Dumping structure for table campus_db.conversations
CREATE TABLE IF NOT EXISTS `conversations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `lost_found_item_id` bigint unsigned NOT NULL,
  `user_one_id` bigint unsigned NOT NULL,
  `user_two_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `conversations_lost_found_item_id_foreign` (`lost_found_item_id`),
  KEY `conversations_user_one_id_foreign` (`user_one_id`),
  KEY `conversations_user_two_id_foreign` (`user_two_id`),
  CONSTRAINT `conversations_lost_found_item_id_foreign` FOREIGN KEY (`lost_found_item_id`) REFERENCES `lost_found_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `conversations_user_one_id_foreign` FOREIGN KEY (`user_one_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `conversations_user_two_id_foreign` FOREIGN KEY (`user_two_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.conversations: ~0 rows (approximately)

-- Dumping structure for table campus_db.degrees
CREATE TABLE IF NOT EXISTS `degrees` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `degrees_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.degrees: ~2 rows (approximately)
REPLACE INTO `degrees` (`id`, `name`, `created_at`, `updated_at`) VALUES
	(1, 'Robotics engineering', '2026-04-02 00:22:09', '2026-04-02 00:22:09'),
	(2, 'BSc (Hons) Software Engineering – Plymouth University (UK)', '2026-04-02 00:59:11', '2026-04-02 00:59:11');

-- Dumping structure for table campus_db.departments
CREATE TABLE IF NOT EXISTS `departments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `departments_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.departments: ~2 rows (approximately)
REPLACE INTO `departments` (`id`, `name`, `created_at`, `updated_at`) VALUES
	(1, 'Industry Engineering', '2026-04-02 00:21:53', '2026-04-02 00:21:53'),
	(2, 'Department of SE', '2026-04-02 00:59:03', '2026-04-02 00:59:03');

-- Dumping structure for table campus_db.faculties
CREATE TABLE IF NOT EXISTS `faculties` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `faculties_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.faculties: ~2 rows (approximately)
REPLACE INTO `faculties` (`id`, `name`, `created_at`, `updated_at`) VALUES
	(1, 'Engineering', '2026-04-02 00:21:00', '2026-04-02 00:21:00'),
	(2, 'Computing Faculty', '2026-04-02 00:58:56', '2026-04-02 00:58:56');

-- Dumping structure for table campus_db.failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.failed_jobs: ~0 rows (approximately)

-- Dumping structure for table campus_db.feedbacks
CREATE TABLE IF NOT EXISTS `feedbacks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `feedbacks_user_id_foreign` (`user_id`),
  CONSTRAINT `feedbacks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.feedbacks: ~0 rows (approximately)
REPLACE INTO `feedbacks` (`id`, `user_id`, `message`, `created_at`, `updated_at`) VALUES
	(1, 1, 'ggf', '2026-04-01 11:13:10', '2026-04-01 11:13:10');

-- Dumping structure for table campus_db.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.jobs: ~0 rows (approximately)

-- Dumping structure for table campus_db.job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.job_batches: ~0 rows (approximately)

-- Dumping structure for table campus_db.lost_found_items
CREATE TABLE IF NOT EXISTS `lost_found_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `type` enum('lost','found') COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lost_found_items_user_id_foreign` (`user_id`),
  CONSTRAINT `lost_found_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.lost_found_items: ~0 rows (approximately)
REPLACE INTO `lost_found_items` (`id`, `user_id`, `type`, `item_name`, `description`, `phone`, `image`, `status`, `created_at`, `updated_at`) VALUES
	(2, 1, 'lost', 'book', 'kshhx', '0776655222', '/uploads/lost_found/1775070559_images (4).jpg', 'open', '2026-04-01 13:39:19', '2026-04-01 13:39:19');

-- Dumping structure for table campus_db.messages
CREATE TABLE IF NOT EXISTS `messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint unsigned NOT NULL,
  `sender_id` bigint unsigned NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `messages_conversation_id_foreign` (`conversation_id`),
  KEY `messages_sender_id_foreign` (`sender_id`),
  CONSTRAINT `messages_conversation_id_foreign` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.messages: ~0 rows (approximately)

-- Dumping structure for table campus_db.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.migrations: ~18 rows (approximately)
REPLACE INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '0001_01_01_000001_create_cache_table', 1),
	(3, '0001_01_01_000002_create_jobs_table', 1),
	(4, '2025_12_14_150313_create_personal_access_tokens_table', 1),
	(5, '2025_12_14_150858_add_role_to_users_table', 1),
	(6, '2025_12_14_164035_create_request_models_table', 1),
	(7, '2025_12_18_163810_add_profile_fields_to_users_table', 1),
	(8, '2025_12_19_171047_create_feedbacks_table', 1),
	(9, '2025_12_20_174612_create_reminders_table', 1),
	(10, '2025_12_21_062434_update_reminders_table', 1),
	(11, '2025_12_21_062815_create_notifications_table', 1),
	(12, '2025_12_21_160823_create_lost_found_items_table', 1),
	(13, '2025_12_21_161030_create_conversations_table', 1),
	(14, '2025_12_21_161127_create_messages_table', 1),
	(15, '2026_03_05_113319_add_batch_number_to_users_table', 1),
	(16, '2026_03_07_120846_add_batch_to_users_table', 1),
	(17, '2026_03_15_110722_create_batches_table', 1),
	(18, '2026_03_16_131427_create_timetables_table', 1);

-- Dumping structure for table campus_db.notifications
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_user_id_foreign` (`user_id`),
  CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.notifications: ~0 rows (approximately)

-- Dumping structure for table campus_db.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.password_reset_tokens: ~0 rows (approximately)

-- Dumping structure for table campus_db.personal_access_tokens
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.personal_access_tokens: ~35 rows (approximately)
REPLACE INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
	(1, 'App\\Models\\User', 1, 'auth_token', '48404c8da7647f491e33ba38182f63968eec324f58ff5ccf0d232da7cedaca56', '["*"]', NULL, NULL, '2026-03-30 01:41:40', '2026-03-30 01:41:40'),
	(2, 'App\\Models\\User', 1, 'mobile_token', '1f380862539873ea92fa1eaf61d0e7006a97f7b50382f9b692f59a37aaf63fc2', '["*"]', '2026-03-30 01:43:11', NULL, '2026-03-30 01:42:10', '2026-03-30 01:43:11'),
	(3, 'App\\Models\\User', 2, 'auth_token', '2aba26b946f9e448e44b5b5290e6658f1eed9049488c471cc5ef1744fa5fc94e', '["*"]', NULL, NULL, '2026-03-30 01:43:50', '2026-03-30 01:43:50'),
	(4, 'App\\Models\\User', 2, 'mobile_token', '1d5ed9d8e80c52684be416b244ccc063d34dce4226a8f7500826377d1b0b4221', '["*"]', NULL, NULL, '2026-03-30 01:44:08', '2026-03-30 01:44:08'),
	(5, 'App\\Models\\User', 1, 'mobile_token', '1ff3a7b00ed46a678e0af6e808476b3ada46810915ff869ebf396eccbc55f461', '["*"]', '2026-03-31 12:05:49', NULL, '2026-03-31 12:04:21', '2026-03-31 12:05:49'),
	(6, 'App\\Models\\User', 2, 'mobile_token', 'd70d952473de459b992d5c8efa493d941e32852bb6cdb461ff6e2a6ea6c6afc5', '["*"]', '2026-03-31 12:09:16', NULL, '2026-03-31 12:08:58', '2026-03-31 12:09:16'),
	(7, 'App\\Models\\User', 2, 'mobile_token', '9db8873667bbd2511845dd5f6acc21c205d3bc485e44d95a144e0c6a73c23305', '["*"]', '2026-04-01 09:32:05', NULL, '2026-04-01 09:29:51', '2026-04-01 09:32:05'),
	(8, 'App\\Models\\User', 2, 'mobile_token', '4d0304ac517177cce6a6416c9954585d3059beef9899c4e6b3f99192cfee3150', '["*"]', '2026-04-01 10:19:34', NULL, '2026-04-01 10:15:47', '2026-04-01 10:19:34'),
	(9, 'App\\Models\\User', 2, 'mobile_token', 'bc4fa2f77ef2e9c2e0f8518ea43ed0a8ed5089996c42862def98348e839cf220', '["*"]', '2026-04-01 10:45:56', NULL, '2026-04-01 10:40:52', '2026-04-01 10:45:56'),
	(10, 'App\\Models\\User', 2, 'mobile_token', '8c892480b1ca2e061275ffe5c2ab22a23c80ed75d7afdc2645ac69e3f36cca54', '["*"]', '2026-04-01 10:57:42', NULL, '2026-04-01 10:56:14', '2026-04-01 10:57:42'),
	(11, 'App\\Models\\User', 2, 'mobile_token', 'b0caea9b5d7a0a3f8041377c4c7202bedbb3391ff690131e42df894bd58105da', '["*"]', '2026-04-01 11:04:35', NULL, '2026-04-01 11:04:06', '2026-04-01 11:04:35'),
	(12, 'App\\Models\\User', 1, 'mobile_token', '680104893dee0e8b65924d5a4cd632184b4c88f77b0ef2549cf7b6b4712c94aa', '["*"]', '2026-04-01 11:13:37', NULL, '2026-04-01 11:07:39', '2026-04-01 11:13:37'),
	(13, 'App\\Models\\User', 1, 'mobile_token', '9c33920c2f4109cfd2803b86a9ec050ff51bbbb2997ec4425e064230eee85822', '["*"]', '2026-04-01 11:32:50', NULL, '2026-04-01 11:30:35', '2026-04-01 11:32:50'),
	(14, 'App\\Models\\User', 1, 'mobile_token', '6d7e700506a211de4cd6174834b8b48abf3cf627c9d96c52f6d11a57059b2574', '["*"]', '2026-04-01 13:25:58', NULL, '2026-04-01 13:25:18', '2026-04-01 13:25:58'),
	(15, 'App\\Models\\User', 1, 'mobile_token', '335a48c67f00deb5c2b4e92317f371830bbcc0a3fd921f2c0970ebf1d776e16c', '["*"]', '2026-04-01 13:39:23', NULL, '2026-04-01 13:38:51', '2026-04-01 13:39:23'),
	(16, 'App\\Models\\User', 3, 'mobile_token', 'c888e418d6bb078c115c57b2d34164d0678592df0fcdd8fd32d562bdc0e81cd7', '["*"]', '2026-04-02 01:19:54', NULL, '2026-04-02 01:18:39', '2026-04-02 01:19:54'),
	(17, 'App\\Models\\User', 3, 'mobile_token', '6cf443ed89db44095c1c66227bd2b9f11ac1998c848e5dc4079a5e6e602f94d8', '["*"]', NULL, NULL, '2026-04-02 01:38:41', '2026-04-02 01:38:41'),
	(18, 'App\\Models\\User', 4, 'mobile_token', '3c95096dc88870a8a233b03372f8a7cef815a50c2d034b556ab799bbb7b2c9bf', '["*"]', NULL, NULL, '2026-04-02 02:03:11', '2026-04-02 02:03:11'),
	(19, 'App\\Models\\User', 3, 'mobile_token', '971eeeac85033683c84e8d058fce200c3d62392d0824b0862b5db766f8767b93', '["*"]', '2026-04-02 02:05:11', NULL, '2026-04-02 02:03:58', '2026-04-02 02:05:11'),
	(20, 'App\\Models\\User', 3, 'mobile_token', 'ecb94f33e706d1999a770e497a0f3d2ee56af806da66f273b0c005e5e9a11b08', '["*"]', '2026-04-02 04:05:32', NULL, '2026-04-02 04:00:01', '2026-04-02 04:05:32'),
	(21, 'App\\Models\\User', 4, 'mobile_token', '3e7364142df5eb8085a023275a34e077afdb8de246e85f7a649fa16d8dd3155e', '["*"]', NULL, NULL, '2026-04-02 04:05:56', '2026-04-02 04:05:56'),
	(22, 'App\\Models\\User', 3, 'mobile_token', '3a10a1877a51fc845f6f0b41c5a6cea529bbc403688bc4acd7785ea20da18c2a', '["*"]', '2026-04-02 04:09:58', NULL, '2026-04-02 04:09:26', '2026-04-02 04:09:58'),
	(23, 'App\\Models\\User', 4, 'mobile_token', 'e1e37956267a4f701389f4cc9fdb4e168c436b49d2c97affdaafdc7256039a3d', '["*"]', '2026-04-02 04:10:13', NULL, '2026-04-02 04:10:11', '2026-04-02 04:10:13'),
	(24, 'App\\Models\\User', 3, 'mobile_token', 'f6bd09e5d56c84ab7eca663195c9868d69faaf136c2077f40d75a2c40ce69f0f', '["*"]', '2026-04-02 04:25:33', NULL, '2026-04-02 04:24:41', '2026-04-02 04:25:33'),
	(25, 'App\\Models\\User', 4, 'mobile_token', '63dc3d32c8a86dd8b03cad0d7cb6e4fb4c096e900a6dc92a93679a1fe65d4d0f', '["*"]', '2026-04-02 04:26:42', NULL, '2026-04-02 04:25:47', '2026-04-02 04:26:42'),
	(26, 'App\\Models\\User', 3, 'mobile_token', 'ddec5abade2b44989308284e3e11a89fff687e2c39ea20e1864e8427b21e4fef', '["*"]', NULL, NULL, '2026-04-02 04:28:06', '2026-04-02 04:28:06'),
	(27, 'App\\Models\\User', 3, 'mobile_token', '3717408eb47d695b4c538a0fceaaa52d724da30a176f7d26043fecbaca8489bc', '["*"]', '2026-04-02 04:49:07', NULL, '2026-04-02 04:48:12', '2026-04-02 04:49:07'),
	(28, 'App\\Models\\User', 3, 'mobile_token', 'c89fe2d337b23751812edf914ab4d100af8c1a596421d57fd3dd8137917fc3a3', '["*"]', '2026-04-02 04:49:43', NULL, '2026-04-02 04:49:24', '2026-04-02 04:49:43'),
	(29, 'App\\Models\\User', 3, 'mobile_token', 'c9b424e21c78e5b8da1f46c4c1143aca2da9fc807b93bceed87f6c9bd99362cd', '["*"]', NULL, NULL, '2026-04-02 04:53:11', '2026-04-02 04:53:11'),
	(30, 'App\\Models\\User', 3, 'mobile_token', 'cd48931bc2c4487d8a42f4179121f82982d1cd71ef6b27766e3acbc1a4276df8', '["*"]', '2026-04-02 04:56:39', NULL, '2026-04-02 04:55:34', '2026-04-02 04:56:39'),
	(31, 'App\\Models\\User', 4, 'mobile_token', '715696d6f9776ac77547d9db37436f5b85d41083d81b1befe6711c036b356282', '["*"]', '2026-04-02 04:56:55', NULL, '2026-04-02 04:56:51', '2026-04-02 04:56:55'),
	(32, 'App\\Models\\User', 3, 'mobile_token', '70aa5da6e97e61d26462cde17fef5c999c51ae29d7ac8f3d1c561670b02481d2', '["*"]', '2026-04-02 05:00:42', NULL, '2026-04-02 05:00:08', '2026-04-02 05:00:42'),
	(33, 'App\\Models\\User', 3, 'mobile_token', '1dc97c6c1cd2eb1353b522984c78dd0e66fcf103be963ac69d6c42de4d415be3', '["*"]', '2026-04-02 05:07:05', NULL, '2026-04-02 05:07:00', '2026-04-02 05:07:05'),
	(34, 'App\\Models\\User', 3, 'mobile_token', '6cd6f7d87cdcc172600a2ad02a5f76f74f60cb3a098b648b486e718389293546', '["*"]', '2026-04-02 05:17:21', NULL, '2026-04-02 05:08:31', '2026-04-02 05:17:21'),
	(35, 'App\\Models\\User', 4, 'mobile_token', 'ee0c94a093ff20f30565ec046ea50066ed31ffdef8dc333eb682beec015547b7', '["*"]', '2026-04-02 05:17:52', NULL, '2026-04-02 05:17:33', '2026-04-02 05:17:52');

-- Dumping structure for table campus_db.reminders
CREATE TABLE IF NOT EXISTS `reminders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `target_role` enum('student','lecturer') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'student',
  `is_shared` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reminders_user_id_foreign` (`user_id`),
  CONSTRAINT `reminders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.reminders: ~2 rows (approximately)
REPLACE INTO `reminders` (`id`, `user_id`, `title`, `date`, `time`, `target_role`, `is_shared`, `created_at`, `updated_at`) VALUES
	(25, 2, 'hb', '2026-04-01', '22:06:00', 'student', 0, '2026-04-01 11:04:23', '2026-04-01 11:04:23'),
	(26, 1, 'ggh', '2026-04-01', '22:14:00', 'student', 0, '2026-04-01 11:13:36', '2026-04-01 11:13:36'),
	(27, 3, 'gg', '2026-04-02', '16:17:00', 'student', 0, '2026-04-02 05:16:48', '2026-04-02 05:16:48');

-- Dumping structure for table campus_db.request_models
CREATE TABLE IF NOT EXISTS `request_models` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `assigned_to` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `request_models_user_id_foreign` (`user_id`),
  KEY `request_models_assigned_to_foreign` (`assigned_to`),
  CONSTRAINT `request_models_assigned_to_foreign` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`),
  CONSTRAINT `request_models_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.request_models: ~4 rows (approximately)
REPLACE INTO `request_models` (`id`, `user_id`, `type`, `title`, `description`, `image`, `location`, `priority`, `status`, `assigned_to`, `created_at`, `updated_at`) VALUES
	(1, 1, 'problem', 'Projector not working', 'Projector not working', NULL, '303', 'high', 'open', NULL, '2026-03-30 01:42:50', '2026-03-30 01:42:50'),
	(2, 2, 'problem', 'Room not clean', 'Room not clean', 'uploads/problems/1775060798_scaled_27cb91ba-f46d-44e5-8189-6621f77b363a6134392804948249271.jpg', 'Lecture Hall C', 'medium', 'open', NULL, '2026-04-01 10:56:38', '2026-04-01 10:56:38'),
	(3, 3, 'problem', 'Room not clean', 'Room not clean', 'uploads/problems/1775112555_scaled_96c6aed4-677f-4676-ba40-a63d8b54852d8199241908242892221.jpg', 'Lecture Hall C', 'high', 'open', NULL, '2026-04-02 01:19:15', '2026-04-02 01:19:15'),
	(4, 3, 'problem', 'Lights not working', 'Lights not working', 'uploads/problems/1775126767_scaled_bfeac959-94e7-4c8d-87be-ce1c85e6c62f186898859299421767.jpg', 'Lecture Hall C', 'high', 'open', NULL, '2026-04-02 05:16:07', '2026-04-02 05:16:07');

-- Dumping structure for table campus_db.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.sessions: ~0 rows (approximately)

-- Dumping structure for table campus_db.timetables
CREATE TABLE IF NOT EXISTS `timetables` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `batch` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `excel_link` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.timetables: ~1 rows (approximately)
REPLACE INTO `timetables` (`id`, `batch`, `excel_link`, `created_at`, `updated_at`) VALUES
	(1, '23.1', 'llkml', '2026-04-02 01:09:40', '2026-04-02 01:09:40');

-- Dumping structure for table campus_db.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'student',
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `faculty` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `degree` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `campus_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table campus_db.users: ~4 rows (approximately)
REPLACE INTO `users` (`id`, `name`, `email`, `batch_number`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `role`, `department`, `faculty`, `degree`, `campus_id`) VALUES
	(1, 'panchayu', 'panchayu@gmail.com', '23.2', NULL, '$2y$12$7wfg26UYuOByLxE.KrWOT.6bhGIMpfwh..O9QuW0NVJJgfxLTIEm2', NULL, '2026-03-30 01:41:40', '2026-04-02 00:20:16', 'student', 'Department of SE', 'Computing Faculty', 'BSc (Hons) Software Engineering – Plymouth University (UK)', '26667'),
	(2, 'dhanushika', 'dhanushika@gmail.com', NULL, NULL, '$2y$12$d0RpPvFII9X32JY/yqSZCeaqcWQNS1WcdjQ9r4yISwJHEKvDu8b.a', NULL, '2026-03-30 01:43:50', '2026-04-02 00:54:48', 'lecturer', 'Industry Engineering', 'Engineering', NULL, '898453'),
	(3, 'Pathum Nissanka', 'pathum@gmail.com', '23.1', NULL, '$2y$12$X7QQ7gSdb.aenKz/5529heXDfU034zR.oaP229Zo4aujpL2VHICZ2', NULL, '2026-04-02 00:30:04', '2026-04-02 04:49:44', 'student', 'Industry Engineering', 'Engineering', 'Robotics engineering', '045839'),
	(4, 'Kusal Mendis', 'kusal@gmail.com', NULL, NULL, '$2y$12$lk4t6uZbjRKhFrxiodgj.OivVAvwC.Vt0T3kYIYAHviqL15czKa5S', NULL, '2026-04-02 01:10:25', '2026-04-02 01:10:25', 'lecturer', 'Department of SE', 'Computing Faculty', NULL, '495645');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
