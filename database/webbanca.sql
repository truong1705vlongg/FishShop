-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 06, 2026 lúc 08:54 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `webbanca`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart`
--

CREATE TABLE `cart` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-10-31 07:40:29', '2026-10-31 07:43:27'),
(2, 4, '2026-10-31 14:14:40', '2026-11-05 00:23:21'),
(7, 8, '2026-11-05 00:52:15', '2026-11-05 00:56:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `cart_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 1
) ;

--
-- Đang đổ dữ liệu cho bảng `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `quantity`) VALUES
(40, 7, 18, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `status`) VALUES
(1, 'Cá nước ngọt', 'Các loài cá sống trong môi trường nước ngọt.', 'active'),
(2, 'Cá nước mặn', 'Các loài cá sống trong môi trường nước mặn.', 'active'),
(3, 'Cá cảnh', 'Các loài cá nuôi làm cảnh.', 'active'),
(4, 'Sinh vật thần thoại', 'Các sinh vật trong thần thoại và truyền thuyết.', 'active'),
(5, 'Sinh vật cổ đại', 'Các sinh vật cổ đại và tiền sử.', 'active'),
(6, 'Khác', 'Các sản phẩm không thuộc những danh mục trên.', 'active'),
(7, 'Thức ăn cho cá', 'Cung cấp thức ăn cá', 'active'),
(8, 'Hồ thủy sinh', 'Hồ nuôi cá', 'active'),
(9, 'Phụ kiện', 'Phụ kiện cho cá', 'active');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `customer_ranks`
--

CREATE TABLE `customer_ranks` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `total_exp` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `total_eligible_spend` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `spend_remainder` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `current_rank` varchar(24) NOT NULL DEFAULT 'dong',
  `last_rank_up_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Đang đổ dữ liệu cho bảng `customer_ranks`
--

INSERT INTO `customer_ranks` (`id`, `user_id`, `total_exp`, `total_eligible_spend`, `spend_remainder`, `current_rank`, `last_rank_up_at`, `created_at`, `updated_at`) VALUES
(1, 1, 20, 200000, 0, 'dong', NULL, '2026-10-28 15:40:49', '2026-10-31 07:53:50'),
(2, 2, 0, 0, 0, 'dong', NULL, '2026-10-29 15:28:40', '2026-10-29 15:28:40'),
(39, 4, 2, 20000, 0, 'dong', NULL, '2026-10-31 12:40:08', '2026-11-01 04:08:41'),
(42, 6, 0, 0, 0, 'dong', NULL, '2026-10-31 13:28:57', '2026-10-31 13:28:57'),
(90, 7, 0, 0, 0, 'dong', NULL, '2026-11-05 00:43:57', '2026-11-05 00:43:57'),
(91, 8, 23, 233000, 3000, 'dong', NULL, '2026-11-05 00:46:02', '2026-11-05 00:57:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `login_google_accounts`
--

CREATE TABLE `login_google_accounts` (
  `google_sub` varchar(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `login_google_accounts`
--

INSERT INTO `login_google_accounts` (`google_sub`, `user_id`) VALUES
('107194758364497775773', 4),
('117511879778188129089', 6),
('115643794673070691728', 7);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `total` decimal(14,0) NOT NULL,
  `shipping_address` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','confirmed','shipping','completed','cancelled') NOT NULL DEFAULT 'pending',
  `payment_status` enum('unpaid','pending_verification','paid','rejected') NOT NULL DEFAULT 'unpaid',
  `payment_method` enum('cash','bank_transfer','payos') NOT NULL DEFAULT 'bank_transfer',
  `payos_payment_link_id` varchar(80) DEFAULT NULL,
  `payos_checkout_url` varchar(500) DEFAULT NULL,
  `payos_paid_at` datetime DEFAULT NULL,
  `shipping_latitude` decimal(10,7) DEFAULT NULL,
  `shipping_longitude` decimal(10,7) DEFAULT NULL,
  `subtotal` decimal(12,0) DEFAULT NULL,
  `discount_amount` decimal(12,0) NOT NULL DEFAULT 0,
  `voucher_code` varchar(32) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL
) ;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total`, `shipping_address`, `phone`, `created_at`, `status`, `payment_status`, `payment_method`, `payos_payment_link_id`, `payos_checkout_url`, `payos_paid_at`, `shipping_latitude`, `shipping_longitude`, `subtotal`, `discount_amount`, `voucher_code`) VALUES
(1, 1, 100000, 'Duy_Vip_Pro', '00000000000', '2026-10-31 07:40:42', 'completed', 'paid', 'bank_transfer', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(2, 1, 100000, 'Duy_Vip_Pro', '00000000000', '2026-10-31 07:41:54', 'cancelled', 'paid', 'bank_transfer', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(3, 1, 100000, 'Duy_Vip_Pro', '00000000000', '2026-10-31 07:43:33', 'completed', 'paid', 'bank_transfer', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(4, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:14:56', 'pending', 'unpaid', 'bank_transfer', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(5, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:33:06', 'pending', 'unpaid', 'cash', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(6, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:38:51', 'pending', 'unpaid', 'payos', '2e9707a8a76f4c1395dda83976db6b01', 'https://pay.payos.vn/web/2e9707a8a76f4c1395dda83976db6b01', NULL, NULL, NULL, NULL, 0, NULL),
(7, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:39:27', 'pending', 'unpaid', 'payos', '2ec809e24a754fa1bc4939254059eae3', 'https://pay.payos.vn/web/2ec809e24a754fa1bc4939254059eae3', NULL, NULL, NULL, NULL, 0, NULL),
(8, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:41:16', 'pending', 'unpaid', 'payos', '2a0a364b9ffd4dc786d2c529b8e95046', 'https://pay.payos.vn/web/2a0a364b9ffd4dc786d2c529b8e95046', NULL, NULL, NULL, NULL, 0, NULL),
(9, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:43:10', 'pending', 'unpaid', 'payos', '2c42a11c494d4a58b3877081357002dd', 'https://pay.payos.vn/web/2c42a11c494d4a58b3877081357002dd', NULL, NULL, NULL, NULL, 0, NULL),
(10, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:45:07', 'pending', 'unpaid', 'payos', '9b96a5c7e315464d9fa18c8041605570', 'https://pay.payos.vn/web/9b96a5c7e315464d9fa18c8041605570', NULL, NULL, NULL, NULL, 0, NULL),
(11, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:46:38', 'pending', 'unpaid', 'payos', '46e50909eaa749cb83f18a48cd7084d1', 'https://pay.payos.vn/web/46e50909eaa749cb83f18a48cd7084d1', NULL, NULL, NULL, NULL, 0, NULL),
(12, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:48:27', 'pending', 'unpaid', 'payos', '127e867d1b144f57bd1a0b07b9e15b59', 'https://pay.payos.vn/web/127e867d1b144f57bd1a0b07b9e15b59', NULL, NULL, NULL, NULL, 0, NULL),
(13, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:50:08', 'pending', 'unpaid', 'payos', 'a9e0b8fc95cd4024ba6a41c09d0ae80d', 'https://pay.payos.vn/web/a9e0b8fc95cd4024ba6a41c09d0ae80d', NULL, NULL, NULL, NULL, 0, NULL),
(14, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:54:16', 'pending', 'unpaid', 'payos', 'e2f8512d897848e4a46a347cae5ac86e', 'https://pay.payos.vn/web/e2f8512d897848e4a46a347cae5ac86e', NULL, NULL, NULL, NULL, 0, NULL),
(15, 4, 10000, 'vvvvvvvv', '00000000000', '2026-10-31 14:57:49', 'pending', 'paid', 'payos', '7006517537964fc785cee2d12bcaa3c9', 'https://pay.payos.vn/web/7006517537964fc785cee2d12bcaa3c9', '2026-10-31 14:58:09', NULL, NULL, NULL, 0, NULL),
(16, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-01 02:25:47', 'completed', 'paid', 'cash', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
(17, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-01 02:42:25', 'completed', 'paid', 'payos', '139ef555db6941d8bb60b1e7116aa1f1', 'https://pay.payos.vn/web/139ef555db6941d8bb60b1e7116aa1f1', NULL, NULL, NULL, NULL, 0, NULL),
(18, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-01 11:22:16', 'pending', 'paid', 'payos', 'c4a6339d20c34f9d88896bdbbd17fce5', 'https://pay.payos.vn/web/c4a6339d20c34f9d88896bdbbd17fce5', '2026-11-01 11:23:04', NULL, NULL, NULL, 0, NULL),
(19, 4, 30000, 'vvvvvvvv', '00000000000', '2026-11-01 11:23:28', 'pending', 'unpaid', 'payos', '6d46c76b97944c388d7ca56af14c160a', 'https://pay.payos.vn/web/6d46c76b97944c388d7ca56af14c160a', NULL, NULL, NULL, NULL, 0, NULL),
(20, 4, 20000, 'vvvvvvvv', '00000000000', '2026-11-01 11:23:37', 'pending', 'unpaid', 'payos', '6d8b378ea3964e3787ac90fd325b6d91', 'https://pay.payos.vn/web/6d8b378ea3964e3787ac90fd325b6d91', NULL, NULL, NULL, NULL, 0, NULL),
(21, 4, 40000, 'vvvvvvvv', '00000000000', '2026-11-02 06:06:51', 'pending', 'unpaid', 'payos', '01cad361ee1641b9856f7037c9d97fdb', 'https://pay.payos.vn/web/01cad361ee1641b9856f7037c9d97fdb', NULL, 10.2500645, 105.9620527, 40000, 0, NULL),
(22, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-02 06:07:15', 'pending', 'unpaid', 'cash', NULL, NULL, NULL, NULL, NULL, 10000, 0, NULL),
(23, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-02 06:49:14', 'pending', 'unpaid', 'payos', '4b10257a52c949c3a243b6a321816cb2', 'https://pay.payos.vn/web/4b10257a52c949c3a243b6a321816cb2', NULL, NULL, NULL, 10000, 0, NULL),
(24, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-02 23:51:40', 'pending', 'unpaid', 'payos', '5b889fb7c3b54478999e6aa15f992295', 'https://pay.payos.vn/web/5b889fb7c3b54478999e6aa15f992295', NULL, 10.2585931, 105.9860772, 10000, 0, NULL),
(25, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-03 01:08:19', 'pending', 'unpaid', 'payos', 'b48065c3cf5d4a3587afc5c9f0ee8ad5', 'https://pay.payos.vn/web/b48065c3cf5d4a3587afc5c9f0ee8ad5', NULL, NULL, NULL, 10000, 0, NULL),
(26, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-04 10:07:13', 'pending', 'unpaid', 'payos', '6993bd0b867b47a49db8dc3b1e18c638', 'https://pay.payos.vn/web/6993bd0b867b47a49db8dc3b1e18c638', NULL, NULL, NULL, 10000, 0, NULL),
(27, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-04 10:31:11', 'pending', 'unpaid', 'payos', 'c00e52ece3fa4570b7ac735aadf36113', 'https://pay.payos.vn/web/c00e52ece3fa4570b7ac735aadf36113', NULL, NULL, NULL, 10000, 0, NULL),
(28, 4, 27100, 'vvvvvvvv', '00000000000', '2026-11-04 13:47:09', 'pending', 'unpaid', 'payos', 'e28b208ce8d44246aed92a1ab0886580', 'https://pay.payos.vn/web/e28b208ce8d44246aed92a1ab0886580', NULL, NULL, NULL, 28000, 900, NULL),
(29, 4, 59900, 'vvvvvvvv', '00000000000', '2026-11-04 13:57:02', 'pending', 'unpaid', 'payos', '120b9e590fa3401ca103ee2067c11e02', 'https://pay.payos.vn/web/120b9e590fa3401ca103ee2067c11e02', NULL, NULL, NULL, 60000, 100, 'NGU'),
(30, 4, 999999999, 'vvvvvvvv', '00000000000', '2026-11-04 23:47:53', 'pending', 'unpaid', 'cash', NULL, NULL, NULL, NULL, NULL, 999999999, 0, NULL),
(31, 4, 235000, 'vvvvvvvv', '00000000000', '2026-11-04 23:48:14', 'pending', 'unpaid', 'payos', '61ab28c3455d4779bb0a1bc2d13df66a', 'https://pay.payos.vn/web/61ab28c3455d4779bb0a1bc2d13df66a', NULL, NULL, NULL, 235000, 0, NULL),
(32, 4, 10000, 'vvvvvvvv', '00000000000', '2026-11-05 00:23:31', 'pending', 'unpaid', 'payos', 'd905aa9787814a06ae0dd36f157e32e3', 'https://pay.payos.vn/web/d905aa9787814a06ae0dd36f157e32e3', NULL, NULL, NULL, 10000, 0, NULL),
(33, 8, 241650, 'hậdasada', '124124121', '2026-11-05 00:54:24', 'pending', 'unpaid', 'payos', '6957049b2ae749bfa650517b318a02d2', 'https://pay.payos.vn/web/6957049b2ae749bfa650517b318a02d2', NULL, NULL, NULL, 242000, 350, NULL),
(34, 8, 233000, 'hậdasada', '124124121', '2026-11-05 00:57:41', 'completed', 'paid', 'cash', NULL, NULL, NULL, NULL, NULL, 235000, 2000, 'FISH');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `price` decimal(12,0) NOT NULL
) ;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 1, 1, 100000),
(2, 2, 1, 1, 100000),
(3, 3, 1, 1, 100000),
(4, 4, 1, 1, 10000),
(5, 5, 1, 1, 10000),
(6, 6, 1, 1, 10000),
(7, 7, 1, 1, 10000),
(8, 8, 1, 1, 10000),
(9, 9, 1, 1, 10000),
(10, 10, 1, 1, 10000),
(11, 11, 1, 1, 10000),
(12, 12, 1, 1, 10000),
(13, 13, 1, 1, 10000),
(14, 14, 1, 1, 10000),
(15, 15, 1, 1, 10000),
(16, 16, 1, 1, 10000),
(17, 17, 1, 1, 10000),
(18, 18, 1, 1, 10000),
(19, 19, 1, 3, 10000),
(20, 20, 1, 2, 10000),
(21, 21, 1, 4, 10000),
(22, 22, 1, 1, 10000),
(23, 23, 1, 1, 10000),
(24, 24, 1, 1, 10000),
(25, 25, 1, 1, 10000),
(26, 26, 1, 1, 10000),
(27, 27, 1, 1, 10000),
(28, 28, 1, 1, 10000),
(29, 28, 12, 1, 17100),
(30, 29, 16, 1, 60000),
(31, 30, 49, 1, 999999999),
(32, 31, 52, 1, 235000),
(33, 32, 1, 1, 10000),
(34, 33, 9, 1, 6650),
(35, 33, 52, 1, 235000),
(36, 34, 52, 1, 235000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_reset_attempts`
--

CREATE TABLE `password_reset_attempts` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `failed_attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `prize_rewards`
--

CREATE TABLE `prize_rewards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `reward_type` enum('miss','coupon','fish') NOT NULL,
  `discount_percent` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('available','used') NOT NULL DEFAULT 'available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `used_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `prize_rewards`
--

INSERT INTO `prize_rewards` (`id`, `user_id`, `reward_type`, `discount_percent`, `product_id`, `status`, `created_at`, `used_at`) VALUES
(1, 4, 'coupon', 5, NULL, 'used', '2026-11-04 11:00:49', '2026-11-04 20:47:09'),
(2, 4, 'coupon', 5, NULL, 'available', '2026-11-04 13:45:50', NULL),
(3, 4, 'coupon', 5, NULL, 'available', '2026-11-04 15:24:01', NULL),
(4, 4, 'coupon', 5, NULL, 'available', '2026-11-04 23:37:56', NULL),
(5, 4, 'coupon', 5, NULL, 'available', '2026-11-04 23:38:06', NULL),
(6, 4, 'coupon', 5, NULL, 'available', '2026-11-04 23:38:06', NULL),
(7, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:31:33', NULL),
(8, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:31:33', NULL),
(9, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:31:50', NULL),
(10, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:00', NULL),
(11, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:00', NULL),
(12, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:07', NULL),
(13, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:12', NULL),
(14, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:15', NULL),
(15, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:19', NULL),
(16, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:19', NULL),
(17, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:19', NULL),
(18, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:23', NULL),
(19, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:23', NULL),
(20, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:31', NULL),
(21, 4, 'fish', 0, 19, 'available', '2026-11-05 00:32:35', NULL),
(22, 4, 'coupon', 5, NULL, 'available', '2026-11-05 00:32:48', NULL),
(23, 8, 'coupon', 5, NULL, 'used', '2026-11-05 00:51:42', '2026-11-05 07:54:24'),
(24, 8, 'fish', 0, 18, 'available', '2026-11-05 00:51:42', NULL),
(25, 8, 'fish', 0, NULL, 'available', '2026-11-05 00:51:47', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `prize_spins`
--

CREATE TABLE `prize_spins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `reward_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `prize_spins`
--

INSERT INTO `prize_spins` (`id`, `user_id`, `reward_id`, `created_at`) VALUES
(1, 4, NULL, '2026-11-04 10:54:51'),
(2, 4, NULL, '2026-11-04 10:55:00'),
(3, 4, NULL, '2026-11-04 10:55:00'),
(4, 4, NULL, '2026-11-04 10:55:00'),
(5, 4, NULL, '2026-11-04 10:55:00'),
(6, 4, NULL, '2026-11-04 10:55:00'),
(7, 4, NULL, '2026-11-04 10:58:32'),
(8, 4, NULL, '2026-11-04 10:58:38'),
(9, 4, NULL, '2026-11-04 10:58:38'),
(10, 4, NULL, '2026-11-04 10:58:38'),
(11, 4, NULL, '2026-11-04 10:58:38'),
(12, 4, NULL, '2026-11-04 10:58:38'),
(13, 4, NULL, '2026-11-04 10:58:52'),
(14, 4, NULL, '2026-11-04 10:58:52'),
(15, 4, NULL, '2026-11-04 10:58:52'),
(16, 4, NULL, '2026-11-04 10:58:52'),
(17, 4, NULL, '2026-11-04 10:58:52'),
(18, 4, NULL, '2026-11-04 10:58:52'),
(19, 4, NULL, '2026-11-04 10:58:52'),
(20, 4, NULL, '2026-11-04 10:58:52'),
(21, 4, NULL, '2026-11-04 10:58:52'),
(22, 4, NULL, '2026-11-04 10:58:52'),
(23, 4, NULL, '2026-11-04 11:00:49'),
(24, 4, NULL, '2026-11-04 11:00:49'),
(25, 4, 1, '2026-11-04 11:00:49'),
(26, 4, NULL, '2026-11-04 11:00:49'),
(27, 4, NULL, '2026-11-04 11:00:49'),
(28, 4, NULL, '2026-11-04 11:00:49'),
(29, 4, NULL, '2026-11-04 11:00:49'),
(30, 4, NULL, '2026-11-04 11:00:49'),
(31, 4, NULL, '2026-11-04 11:00:49'),
(32, 4, NULL, '2026-11-04 11:00:49'),
(33, 4, NULL, '2026-11-04 13:45:47'),
(34, 4, NULL, '2026-11-04 13:45:50'),
(35, 4, NULL, '2026-11-04 13:45:50'),
(36, 4, NULL, '2026-11-04 13:45:50'),
(37, 4, NULL, '2026-11-04 13:45:50'),
(38, 4, NULL, '2026-11-04 13:45:50'),
(39, 4, NULL, '2026-11-04 13:45:50'),
(40, 4, NULL, '2026-11-04 13:45:50'),
(41, 4, NULL, '2026-11-04 13:45:50'),
(42, 4, 2, '2026-11-04 13:45:50'),
(43, 4, NULL, '2026-11-04 13:45:50'),
(44, 4, NULL, '2026-11-04 15:23:58'),
(45, 4, 3, '2026-11-04 15:24:01'),
(46, 4, NULL, '2026-11-04 15:24:01'),
(47, 4, NULL, '2026-11-04 15:24:01'),
(48, 4, NULL, '2026-11-04 15:24:01'),
(49, 4, NULL, '2026-11-04 15:24:01'),
(50, 4, NULL, '2026-11-04 15:24:01'),
(51, 4, NULL, '2026-11-04 15:24:01'),
(52, 4, NULL, '2026-11-04 15:24:01'),
(53, 4, NULL, '2026-11-04 15:24:01'),
(54, 4, NULL, '2026-11-04 15:24:01'),
(55, 4, NULL, '2026-11-04 23:37:36'),
(56, 4, NULL, '2026-11-04 23:37:36'),
(57, 4, NULL, '2026-11-04 23:37:36'),
(58, 4, NULL, '2026-11-04 23:37:36'),
(59, 4, NULL, '2026-11-04 23:37:36'),
(60, 4, NULL, '2026-11-04 23:37:36'),
(61, 4, NULL, '2026-11-04 23:37:36'),
(62, 4, NULL, '2026-11-04 23:37:36'),
(63, 4, NULL, '2026-11-04 23:37:36'),
(64, 4, NULL, '2026-11-04 23:37:36'),
(65, 4, NULL, '2026-11-04 23:37:56'),
(66, 4, NULL, '2026-11-04 23:37:56'),
(67, 4, NULL, '2026-11-04 23:37:56'),
(68, 4, NULL, '2026-11-04 23:37:56'),
(69, 4, 4, '2026-11-04 23:37:56'),
(70, 4, NULL, '2026-11-04 23:37:56'),
(71, 4, NULL, '2026-11-04 23:37:56'),
(72, 4, NULL, '2026-11-04 23:37:56'),
(73, 4, NULL, '2026-11-04 23:37:56'),
(74, 4, NULL, '2026-11-04 23:37:56'),
(75, 4, NULL, '2026-11-04 23:38:00'),
(76, 4, NULL, '2026-11-04 23:38:00'),
(77, 4, NULL, '2026-11-04 23:38:00'),
(78, 4, NULL, '2026-11-04 23:38:00'),
(79, 4, NULL, '2026-11-04 23:38:00'),
(80, 4, NULL, '2026-11-04 23:38:00'),
(81, 4, NULL, '2026-11-04 23:38:00'),
(82, 4, NULL, '2026-11-04 23:38:00'),
(83, 4, NULL, '2026-11-04 23:38:00'),
(84, 4, NULL, '2026-11-04 23:38:00'),
(85, 4, NULL, '2026-11-04 23:38:03'),
(86, 4, NULL, '2026-11-04 23:38:03'),
(87, 4, NULL, '2026-11-04 23:38:03'),
(88, 4, NULL, '2026-11-04 23:38:03'),
(89, 4, NULL, '2026-11-04 23:38:03'),
(90, 4, NULL, '2026-11-04 23:38:03'),
(91, 4, NULL, '2026-11-04 23:38:03'),
(92, 4, NULL, '2026-11-04 23:38:03'),
(93, 4, NULL, '2026-11-04 23:38:03'),
(94, 4, NULL, '2026-11-04 23:38:03'),
(95, 4, NULL, '2026-11-04 23:38:06'),
(96, 4, 5, '2026-11-04 23:38:06'),
(97, 4, 6, '2026-11-04 23:38:06'),
(98, 4, NULL, '2026-11-04 23:38:06'),
(99, 4, NULL, '2026-11-04 23:38:06'),
(100, 4, NULL, '2026-11-04 23:38:06'),
(101, 4, NULL, '2026-11-04 23:38:06'),
(102, 4, NULL, '2026-11-04 23:38:06'),
(103, 4, NULL, '2026-11-04 23:38:06'),
(104, 4, NULL, '2026-11-04 23:38:06'),
(105, 4, NULL, '2026-11-05 00:31:33'),
(106, 4, NULL, '2026-11-05 00:31:33'),
(107, 4, NULL, '2026-11-05 00:31:33'),
(108, 4, NULL, '2026-11-05 00:31:33'),
(109, 4, NULL, '2026-11-05 00:31:33'),
(110, 4, NULL, '2026-11-05 00:31:33'),
(111, 4, 7, '2026-11-05 00:31:33'),
(112, 4, NULL, '2026-11-05 00:31:33'),
(113, 4, 8, '2026-11-05 00:31:33'),
(114, 4, NULL, '2026-11-05 00:31:33'),
(115, 4, NULL, '2026-11-05 00:31:50'),
(116, 4, NULL, '2026-11-05 00:31:50'),
(117, 4, NULL, '2026-11-05 00:31:50'),
(118, 4, NULL, '2026-11-05 00:31:50'),
(119, 4, NULL, '2026-11-05 00:31:50'),
(120, 4, NULL, '2026-11-05 00:31:50'),
(121, 4, NULL, '2026-11-05 00:31:50'),
(122, 4, NULL, '2026-11-05 00:31:50'),
(123, 4, NULL, '2026-11-05 00:31:50'),
(124, 4, 9, '2026-11-05 00:31:50'),
(125, 4, NULL, '2026-11-05 00:31:56'),
(126, 4, NULL, '2026-11-05 00:31:56'),
(127, 4, NULL, '2026-11-05 00:31:56'),
(128, 4, NULL, '2026-11-05 00:31:56'),
(129, 4, NULL, '2026-11-05 00:31:56'),
(130, 4, NULL, '2026-11-05 00:31:56'),
(131, 4, NULL, '2026-11-05 00:31:56'),
(132, 4, NULL, '2026-11-05 00:31:56'),
(133, 4, NULL, '2026-11-05 00:31:56'),
(134, 4, NULL, '2026-11-05 00:31:56'),
(135, 4, NULL, '2026-11-05 00:32:00'),
(136, 4, NULL, '2026-11-05 00:32:00'),
(137, 4, NULL, '2026-11-05 00:32:00'),
(138, 4, 10, '2026-11-05 00:32:00'),
(139, 4, NULL, '2026-11-05 00:32:00'),
(140, 4, NULL, '2026-11-05 00:32:00'),
(141, 4, NULL, '2026-11-05 00:32:00'),
(142, 4, 11, '2026-11-05 00:32:00'),
(143, 4, NULL, '2026-11-05 00:32:00'),
(144, 4, NULL, '2026-11-05 00:32:00'),
(145, 4, NULL, '2026-11-05 00:32:04'),
(146, 4, NULL, '2026-11-05 00:32:04'),
(147, 4, NULL, '2026-11-05 00:32:04'),
(148, 4, NULL, '2026-11-05 00:32:04'),
(149, 4, NULL, '2026-11-05 00:32:04'),
(150, 4, NULL, '2026-11-05 00:32:04'),
(151, 4, NULL, '2026-11-05 00:32:04'),
(152, 4, NULL, '2026-11-05 00:32:04'),
(153, 4, NULL, '2026-11-05 00:32:04'),
(154, 4, NULL, '2026-11-05 00:32:04'),
(155, 4, NULL, '2026-11-05 00:32:07'),
(156, 4, NULL, '2026-11-05 00:32:07'),
(157, 4, NULL, '2026-11-05 00:32:07'),
(158, 4, NULL, '2026-11-05 00:32:07'),
(159, 4, 12, '2026-11-05 00:32:07'),
(160, 4, NULL, '2026-11-05 00:32:07'),
(161, 4, NULL, '2026-11-05 00:32:07'),
(162, 4, NULL, '2026-11-05 00:32:07'),
(163, 4, NULL, '2026-11-05 00:32:07'),
(164, 4, NULL, '2026-11-05 00:32:07'),
(165, 4, NULL, '2026-11-05 00:32:12'),
(166, 4, NULL, '2026-11-05 00:32:12'),
(167, 4, NULL, '2026-11-05 00:32:12'),
(168, 4, 13, '2026-11-05 00:32:12'),
(169, 4, NULL, '2026-11-05 00:32:12'),
(170, 4, NULL, '2026-11-05 00:32:12'),
(171, 4, NULL, '2026-11-05 00:32:12'),
(172, 4, NULL, '2026-11-05 00:32:12'),
(173, 4, NULL, '2026-11-05 00:32:12'),
(174, 4, NULL, '2026-11-05 00:32:12'),
(175, 4, 14, '2026-11-05 00:32:15'),
(176, 4, NULL, '2026-11-05 00:32:15'),
(177, 4, NULL, '2026-11-05 00:32:15'),
(178, 4, NULL, '2026-11-05 00:32:15'),
(179, 4, NULL, '2026-11-05 00:32:15'),
(180, 4, NULL, '2026-11-05 00:32:15'),
(181, 4, NULL, '2026-11-05 00:32:15'),
(182, 4, NULL, '2026-11-05 00:32:15'),
(183, 4, NULL, '2026-11-05 00:32:15'),
(184, 4, NULL, '2026-11-05 00:32:15'),
(185, 4, NULL, '2026-11-05 00:32:19'),
(186, 4, NULL, '2026-11-05 00:32:19'),
(187, 4, NULL, '2026-11-05 00:32:19'),
(188, 4, 15, '2026-11-05 00:32:19'),
(189, 4, 16, '2026-11-05 00:32:19'),
(190, 4, NULL, '2026-11-05 00:32:19'),
(191, 4, 17, '2026-11-05 00:32:19'),
(192, 4, NULL, '2026-11-05 00:32:19'),
(193, 4, NULL, '2026-11-05 00:32:19'),
(194, 4, NULL, '2026-11-05 00:32:19'),
(195, 4, NULL, '2026-11-05 00:32:23'),
(196, 4, 18, '2026-11-05 00:32:23'),
(197, 4, NULL, '2026-11-05 00:32:23'),
(198, 4, NULL, '2026-11-05 00:32:23'),
(199, 4, NULL, '2026-11-05 00:32:23'),
(200, 4, NULL, '2026-11-05 00:32:23'),
(201, 4, NULL, '2026-11-05 00:32:23'),
(202, 4, 19, '2026-11-05 00:32:23'),
(203, 4, NULL, '2026-11-05 00:32:23'),
(204, 4, NULL, '2026-11-05 00:32:23'),
(205, 4, NULL, '2026-11-05 00:32:26'),
(206, 4, NULL, '2026-11-05 00:32:26'),
(207, 4, NULL, '2026-11-05 00:32:26'),
(208, 4, NULL, '2026-11-05 00:32:26'),
(209, 4, NULL, '2026-11-05 00:32:26'),
(210, 4, NULL, '2026-11-05 00:32:26'),
(211, 4, NULL, '2026-11-05 00:32:26'),
(212, 4, NULL, '2026-11-05 00:32:26'),
(213, 4, NULL, '2026-11-05 00:32:26'),
(214, 4, NULL, '2026-11-05 00:32:26'),
(215, 4, NULL, '2026-11-05 00:32:29'),
(216, 4, NULL, '2026-11-05 00:32:29'),
(217, 4, NULL, '2026-11-05 00:32:29'),
(218, 4, NULL, '2026-11-05 00:32:29'),
(219, 4, NULL, '2026-11-05 00:32:29'),
(220, 4, NULL, '2026-11-05 00:32:29'),
(221, 4, NULL, '2026-11-05 00:32:29'),
(222, 4, NULL, '2026-11-05 00:32:29'),
(223, 4, NULL, '2026-11-05 00:32:29'),
(224, 4, NULL, '2026-11-05 00:32:29'),
(225, 4, NULL, '2026-11-05 00:32:31'),
(226, 4, NULL, '2026-11-05 00:32:31'),
(227, 4, NULL, '2026-11-05 00:32:31'),
(228, 4, NULL, '2026-11-05 00:32:31'),
(229, 4, NULL, '2026-11-05 00:32:31'),
(230, 4, NULL, '2026-11-05 00:32:31'),
(231, 4, 20, '2026-11-05 00:32:31'),
(232, 4, NULL, '2026-11-05 00:32:31'),
(233, 4, NULL, '2026-11-05 00:32:31'),
(234, 4, NULL, '2026-11-05 00:32:31'),
(235, 4, 21, '2026-11-05 00:32:35'),
(236, 4, NULL, '2026-11-05 00:32:35'),
(237, 4, NULL, '2026-11-05 00:32:35'),
(238, 4, NULL, '2026-11-05 00:32:35'),
(239, 4, NULL, '2026-11-05 00:32:35'),
(240, 4, NULL, '2026-11-05 00:32:35'),
(241, 4, NULL, '2026-11-05 00:32:35'),
(242, 4, NULL, '2026-11-05 00:32:35'),
(243, 4, NULL, '2026-11-05 00:32:35'),
(244, 4, NULL, '2026-11-05 00:32:35'),
(245, 4, NULL, '2026-11-05 00:32:48'),
(246, 4, NULL, '2026-11-05 00:32:48'),
(247, 4, NULL, '2026-11-05 00:32:48'),
(248, 4, NULL, '2026-11-05 00:32:48'),
(249, 4, NULL, '2026-11-05 00:32:48'),
(250, 4, NULL, '2026-11-05 00:32:48'),
(251, 4, NULL, '2026-11-05 00:32:48'),
(252, 4, NULL, '2026-11-05 00:32:48'),
(253, 4, NULL, '2026-11-05 00:32:48'),
(254, 4, 22, '2026-11-05 00:32:48'),
(255, 4, NULL, '2026-11-05 00:32:54'),
(256, 4, NULL, '2026-11-05 00:32:54'),
(257, 4, NULL, '2026-11-05 00:32:54'),
(258, 4, NULL, '2026-11-05 00:32:54'),
(259, 4, NULL, '2026-11-05 00:32:54'),
(260, 4, NULL, '2026-11-05 00:32:54'),
(261, 4, NULL, '2026-11-05 00:32:54'),
(262, 4, NULL, '2026-11-05 00:32:54'),
(263, 4, NULL, '2026-11-05 00:32:54'),
(264, 4, NULL, '2026-11-05 00:32:54'),
(265, 8, NULL, '2026-11-05 00:51:42'),
(266, 8, 23, '2026-11-05 00:51:42'),
(267, 8, NULL, '2026-11-05 00:51:42'),
(268, 8, NULL, '2026-11-05 00:51:42'),
(269, 8, NULL, '2026-11-05 00:51:42'),
(270, 8, NULL, '2026-11-05 00:51:42'),
(271, 8, NULL, '2026-11-05 00:51:42'),
(272, 8, 24, '2026-11-05 00:51:42'),
(273, 8, NULL, '2026-11-05 00:51:42'),
(274, 8, NULL, '2026-11-05 00:51:42'),
(275, 8, 25, '2026-11-05 00:51:47'),
(276, 8, NULL, '2026-11-05 00:51:47'),
(277, 8, NULL, '2026-11-05 00:51:47'),
(278, 8, NULL, '2026-11-05 00:51:47'),
(279, 8, NULL, '2026-11-05 00:51:47'),
(280, 8, NULL, '2026-11-05 00:51:47'),
(281, 8, NULL, '2026-11-05 00:51:47'),
(282, 8, NULL, '2026-11-05 00:51:47'),
(283, 8, NULL, '2026-11-05 00:51:47'),
(284, 8, NULL, '2026-11-05 00:51:47');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `prize_wallets`
--

CREATE TABLE `prize_wallets` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `prize_wallets`
--

INSERT INTO `prize_wallets` (`user_id`, `balance`, `updated_at`) VALUES
(4, 38370000, '2026-11-05 00:32:54'),
(8, 0, '2026-11-05 00:51:47');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `price` decimal(12,0) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `stock` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `image`, `description`, `category_id`, `stock`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Hồ Thái Khang', 10000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793599752/fishshop/products/b8ad44e761f6357a0407ffbb.jpg', 'Còn sót lại trong kho 1 con', 6, 2, 'active', '2026-10-31 07:40:13', '2026-11-05 00:36:46'),
(2, 'Cá Lóc', 40000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793790604/fishshop/products/3c2f9fcfcf58e0a3ecd9c1ee.webp', 'ngon lắm mua đi', 1, 100, 'active', '2026-11-04 11:10:05', '2026-11-04 11:10:05'),
(3, 'Aquaman', 99999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793791612/fishshop/products/57559a8bd4d8daa6bc4ccd5c.webp', 'Mới bắt', 4, 1, 'active', '2026-11-04 11:26:54', '2026-11-04 13:36:35'),
(4, 'Nguyễn Thành Luân', 15000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793791721/fishshop/products/ffc2b7fa50d2c4f3289a7fc6.jpg', 'trong kho còn dư 1 con', 6, 1, 'active', '2026-11-04 11:28:43', '2026-11-04 11:28:43'),
(5, 'Cá Mập', 900000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793791816/fishshop/products/f12f7eff16e3d9bfc549cd24.webp', 'Sản phẩm nhân giống mới nhất', 3, 25, 'active', '2026-11-04 11:30:17', '2026-11-04 11:30:17'),
(6, 'Cá Heo', 990090, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793791872/fishshop/products/91d9c193a3d9f6a8b9feec94.jpg', 'Cá siêu thân thiện', 2, 50, 'active', '2026-11-04 11:31:13', '2026-11-04 11:31:13'),
(7, 'Piraha', 500000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793791960/fishshop/products/fe7f8c6025d21f7f50620678.jpg', 'Cá siêu cấp thân thiện', 1, 134, 'active', '2026-11-04 11:32:41', '2026-11-04 11:32:41'),
(8, 'Cá Vàng', 9999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793792034/fishshop/products/3dc19db36dcc70d9c8d52a2b.jpg', 'Cá bằng vàng nguyên chất', 3, 150, 'active', '2026-11-04 11:33:55', '2026-11-04 11:33:55'),
(9, 'Cá bảy màu', 7000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793798742/fishshop/products/968c9be21ac8161cc22609f4.jpg', 'Cá cảnh', 3, 168, 'active', '2026-11-04 13:25:43', '2026-11-05 00:54:24'),
(10, 'Cá mập đầu búa', 99999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793798812/fishshop/products/431428c85faabc38da514355.jpg', 'Cá To', 2, 13, 'active', '2026-11-04 13:26:53', '2026-11-04 13:26:53'),
(11, 'Cá nóc', 567000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793798861/fishshop/products/c44bb59593b4eeb48e91ae5c.webp', 'Cá có độc', 2, 67, 'active', '2026-11-04 13:27:42', '2026-11-04 13:27:42'),
(12, 'Cá nục', 18000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793798896/fishshop/products/8a7d0a9730f3d11438160de9.jpg', 'ăn rất', 1, 91, 'active', '2026-11-04 13:28:17', '2026-11-04 13:47:09'),
(13, 'Cápybara', 98000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793798932/fishshop/products/36b1be4e2f4c13ad55db346f.jpg', 'Cá lạ', 3, 67, 'active', '2026-11-04 13:28:54', '2026-11-04 13:28:54'),
(14, 'Cá sấu', 78500000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799117/fishshop/products/9c9b6a24ca1421e463c7e112.webp', 'Cá rất sấu', 1, 26, 'active', '2026-11-04 13:31:58', '2026-11-04 13:31:58'),
(15, 'Cá leo cây', 23000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799177/fishshop/products/b066eb5dfdb9a34fde9a3c3b.jpg', 'Rất nhớt', 1, 67, 'active', '2026-11-04 13:32:58', '2026-11-04 13:32:58'),
(16, 'Cá viên chiên', 60000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799229/fishshop/products/f239690907e0d5f95d4d5a4d.webp', 'Ăn rất ngon', 6, 15, 'active', '2026-11-04 13:33:50', '2026-11-04 13:57:02'),
(17, 'Cá voi trắng', 60000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799297/fishshop/products/a9390bb9150f89ea1642ef64.png', 'Cute', 2, 53, 'active', '2026-11-04 13:34:58', '2026-11-04 13:34:58'),
(18, '(cờ) Cá Ngựa', 120000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799346/fishshop/products/13964022a5725ffb4f3c5c36.jpg', 'Cá không ăn được', 6, 20, 'active', '2026-11-04 13:35:47', '2026-11-04 13:35:47'),
(19, 'Tiên Cá', 999999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799406/fishshop/products/1a5c051cf7d4412aec1f038f.jpg', '...', 4, 1, 'active', '2026-11-04 13:36:20', '2026-11-04 13:36:48'),
(20, '(gà) Vảy Cá', 500000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799468/fishshop/products/af7245d6f9fd6a54ab91a46d.jpg', 'Cá trên cạn', 6, 12, 'active', '2026-11-04 13:37:50', '2026-11-04 13:37:50'),
(21, 'Leviathan', 999999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799504/fishshop/products/fef7916b7f9ce5111153751c.webp', 'Cá hiếm', 4, 1, 'active', '2026-11-04 13:38:25', '2026-11-04 23:49:38'),
(22, 'Mosasaurus', 999999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799537/fishshop/products/ed9847dde2debf87f315dd3a.jpg', 'Cá siêu hiếm', 5, 1, 'active', '2026-11-04 13:38:58', '2026-11-04 13:38:58'),
(23, 'Messie', 989999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799574/fishshop/products/1c3650b968660b30504313a5.jpg', 'Cá siêu hiếm', 5, 1, 'active', '2026-11-04 13:39:35', '2026-11-04 13:39:35'),
(24, 'Rái cá', 6666666, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793799630/fishshop/products/f84f11995cfb3ab984e3caa9.webp', 'Siêu cute', 6, 123, 'active', '2026-11-04 13:40:31', '2026-11-04 13:40:31'),
(25, 'Hồ cỏ', 467000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800089/fishshop/products/c8a8473d848e0faae6b6fda9.webp', 'Hồ kiểng', 8, 23, 'active', '2026-11-04 13:48:10', '2026-11-04 13:48:10'),
(26, 'Thức ăn cá lia thia', 48000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800154/fishshop/products/5caed2a9f0f168e402316ffa.jpg', 'Túi 3.6kg', 7, 36, 'active', '2026-11-04 13:49:15', '2026-11-04 14:07:00'),
(27, 'Hồ thủy sinh mini', 213000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800199/fishshop/products/780954f610f8db73b74a6bc3.jpg', 'Hồ mini', 8, 45, 'active', '2026-11-04 13:50:00', '2026-11-04 13:50:00'),
(28, 'Cobo 3 túi thức ăn cá lia thia', 123000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800321/fishshop/products/b0baec18a1da7721be02aa17.jpg', 'Cobo', 7, 233, 'active', '2026-11-04 13:52:02', '2026-11-04 14:07:21'),
(29, 'Hồ thủy sinh Cây', 786000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800464/fishshop/products/60d5713159b9215aa322dd05.jpg', 'Hồ cảnh 2.0', 8, 23, 'active', '2026-11-04 13:54:25', '2026-11-04 13:54:25'),
(30, 'Hồ thủy sinh cỡ lớn', 900060, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800680/fishshop/products/fc674f698ded5744916f9a95.webp', 'Hồ cảnh lớn', 8, 12, 'active', '2026-11-04 13:58:01', '2026-11-04 13:58:01'),
(31, 'Hồ thủy sinh trống', 150000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800762/fishshop/products/83939b39867d020ae131db68.webp', 'hồ lẻ loi', 8, 123, 'active', '2026-11-04 13:59:23', '2026-11-04 13:59:23'),
(32, 'Thức ăn cá nước mặn', 150000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793800803/fishshop/products/f0a9ae1d4741b2a656a23c22.jpg', 'thức ăn cá', 7, 23, 'active', '2026-11-04 14:00:05', '2026-11-04 14:00:05'),
(33, 'Thức ăn cá koi', 78000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793806968/fishshop/products/9c5e0152a52089402557e994.webp', 'Thức ăn cá', 7, 47, 'active', '2026-11-04 15:42:50', '2026-11-04 15:42:50'),
(34, 'Cá Koi', 479000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793807001/fishshop/products/b03925f99873bce92bfa2965.jpg', 'Cá koi', 3, 7, 'active', '2026-11-04 15:43:22', '2026-11-04 15:43:22'),
(35, 'Bộ test nước', 127000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793808669/fishshop/products/279db9488c18259c3b507fe1.jpg', 'Phụ kiện cho cá', 9, 34, 'active', '2026-11-04 16:11:15', '2026-11-04 16:11:15'),
(36, 'Máy xủi oxy mini', 258000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793808716/fishshop/products/0e3d9b0201a256f13c78ad1c.jpg', 'Phụ kiện cho cá', 9, 13, 'active', '2026-11-04 16:11:57', '2026-11-04 16:11:57'),
(37, 'Máy lọc thác', 548000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793808744/fishshop/products/6fce1fab0766912ad41a6577.jpg', 'Phụ kiện cho cá', 9, 24, 'active', '2026-11-04 16:12:25', '2026-11-04 16:12:25'),
(38, 'Cá la hán kim cương', 7000000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809178/fishshop/products/5acffd15ccf530e34b3811c6.jpg', 'Cá la hán', 3, 5, 'active', '2026-11-04 16:19:39', '2026-11-04 16:19:39'),
(39, 'Cá ngựa', 869000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809216/fishshop/products/2f45ecb1cec441a272a317f6.jpg', 'Cá ngựa', 6, 1, 'active', '2026-11-04 16:20:17', '2026-11-04 16:20:17'),
(40, 'Cá kim Long', 9650000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809249/fishshop/products/20e1d6fafdbd47f03bb14c85.jpg', 'Kim long', 3, 9, 'active', '2026-11-04 16:20:50', '2026-11-04 16:20:50'),
(41, 'Cá la hán thái châu', 754000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809299/fishshop/products/53bf6f706fca5962b0d4c272.jpg', 'Cá la hán', 3, 14, 'active', '2026-11-04 16:21:40', '2026-11-04 16:21:40'),
(42, 'Cá rồng thuyết long', 1530000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809345/fishshop/products/3ad2eb6e5e5a6a8be82ee167.jpg', 'Cá rồng', 3, 17, 'active', '2026-11-04 16:22:26', '2026-11-04 16:22:26'),
(43, 'Kỳ lân biển', 890000000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809381/fishshop/products/3c5b0fa8dcb5fd59cfef3f03.jpg', 'Biển', 2, 12, 'active', '2026-11-04 16:23:03', '2026-11-04 16:23:03'),
(44, 'Lợn Biển', 12500000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809413/fishshop/products/c07bc63500618d06e5481395.jpg', 'Lợn', 2, 12, 'active', '2026-11-04 16:23:34', '2026-11-04 16:23:34'),
(45, 'Tép cherry đỏ', 134000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809587/fishshop/products/5d9e70cc28973058770b035e.jpg', 'tép', 3, 123, 'active', '2026-11-04 16:26:15', '2026-11-04 16:26:28'),
(46, 'Tép rili', 123000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809617/fishshop/products/0fd9a6296e0151c9254e61b3.webp', 'tép', 3, 123, 'active', '2026-11-04 16:26:59', '2026-11-04 16:26:59'),
(47, 'Tép blue dream', 89000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809648/fishshop/products/74972513aaa5505a4b6a3358.jpg', 'tép', 3, 125, 'active', '2026-11-04 16:27:29', '2026-11-04 16:27:29'),
(48, 'Cá sấu bạch tạng', 99900000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793809830/fishshop/products/24041229d8563fd12d2a18a4.webp', 'Túi Gucci vài chục tỏi', 3, 3, 'active', '2026-11-04 16:30:31', '2026-11-04 16:30:31'),
(49, 'Rồng biển xanh', 999999999, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793810011/fishshop/products/725ade925c57da6a6b872ae9.jpg', 'cá không cảnh', 2, 2, 'active', '2026-11-04 16:33:32', '2026-11-04 23:47:53'),
(50, 'Nguyễn Hoàng Duy', 20000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793810055/fishshop/products/0b88b5e1d6d1620f0d8bbb8a.jpg', 'Còn ế 1 con', 6, 1, 'inactive', '2026-11-04 16:34:16', '2026-11-05 00:21:41'),
(51, 'Cá giọt nước', 167800, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793810130/fishshop/products/a4f6990d6f72e0d8579ca1d3.jpg', 'Cá xấu', 2, 12, 'active', '2026-11-04 16:35:31', '2026-11-04 16:35:31'),
(52, 'Cá ngừ vây xanh', 235000, 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793810204/fishshop/products/c4c1ad27e73d6461860e7e08.jpg', 'Cá ăn được', 2, 210, 'active', '2026-11-04 16:36:45', '2026-11-05 00:57:41');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `rank_order_earnings`
--

CREATE TABLE `rank_order_earnings` (
  `order_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `spend_amount` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Đang đổ dữ liệu cho bảng `rank_order_earnings`
--

INSERT INTO `rank_order_earnings` (`order_id`, `user_id`, `spend_amount`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 100000, 1, '2026-10-31 07:52:35', '2026-10-31 07:52:35'),
(3, 1, 100000, 1, '2026-10-31 07:53:50', '2026-10-31 07:53:50'),
(16, 4, 10000, 1, '2026-11-01 04:08:41', '2026-11-01 04:08:41'),
(17, 4, 10000, 1, '2026-11-01 03:55:14', '2026-11-01 03:55:14'),
(34, 8, 233000, 1, '2026-11-05 00:57:56', '2026-11-05 00:57:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `registration_otps`
--

CREATE TABLE `registration_otps` (
  `email` varchar(254) NOT NULL,
  `challenge_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `code_hash` varchar(255) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `registration_otps`
--

INSERT INTO `registration_otps` (`email`, `challenge_hash`, `code_hash`, `expires_at`, `attempts`) VALUES
('hocngu135@gmail.com', 'caf3131dc4fba02de98f99ce732f8a7a4d982ce8fe53e6ad2743c6d909a1e5a1', '$2y$10$CwBfP8a63K6wZfgN74qGVelrSf6KJMZX85vSzcgR87R.HpHncbHx6', 1793548349, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `registration_rate_limits`
--

CREATE TABLE `registration_rate_limits` (
  `bucket` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `started_at` bigint(20) NOT NULL,
  `last_at` bigint(20) NOT NULL,
  `hits` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `registration_rate_limits`
--

INSERT INTO `registration_rate_limits` (`bucket`, `started_at`, `last_at`, `hits`) VALUES
('227a139b2d0f158050b5542327a01af02caf27028d0e765c5c3b769a71257468', 1793839534, 1793839534, 1),
('2b505903c391cbbcbb117677dd3264efa49c7209ccbe1bbe484f6804267d1cbf', 1793839534, 1793839534, 1),
('66f4b9da0c04325045048a2509a968c4bb036561045697c8c9ec1225d1acdb36', 1793547958, 1793548049, 2),
('6c26baaaddd5dde701629f6a50b49fc5cc9ff2fc28b97bdfdb13280c12e80f0b', 1793452897, 1793453319, 3);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Chuỗi băm từ password_hash()',
  `fullname` varchar(100) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `security_question` varchar(40) DEFAULT NULL,
  `security_answer_hash` varchar(255) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL DEFAULT '',
  `avatar` varchar(255) DEFAULT NULL,
  `role` enum('customer','admin') NOT NULL DEFAULT 'customer',
  `account_status` enum('active','locked') NOT NULL DEFAULT 'active',
  `locked_reason` varchar(64) DEFAULT NULL,
  `locked_note` text DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `locked_by_admin_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullname`, `email`, `security_question`, `security_answer_hash`, `phone`, `address`, `avatar`, `role`, `account_status`, `locked_reason`, `locked_note`, `locked_at`, `locked_by_admin_id`, `created_at`) VALUES
(1, 'DuySieuCapDeptrai', '$2y$10$rmtLXlTfWhkJaossU2UODe58JNKrp5QPrz/RTWHx8UmqYv5HTI1ui', 'Nguyễn Hoàng Duy', NULL, 'favorite_teacher', '$2y$10$GztX4qcjTgIGXhh5hdP.AuIlLRiew5K3Zc50fa8F2PuwbVyVIRBGW', '00000000000', 'Duy_Vip_Pro', 'uploads/avatars/17e1fff455cfa2afc05d6c9f.webp', 'admin', 'active', NULL, NULL, NULL, NULL, '2026-10-28 15:40:49'),
(2, 'KhangGay', '$2y$10$m8hgdOa2MtkUSe9eKunTIedwpo.v9TnKwf9axNi6DQw.Nx9Ovtou2', 'Hồ Thái Khang', 'fff2@gmail.com', 'favorite_teacher', '$2y$10$pjYo4IU3fiwjQLnp.CLO6OSNIenwzGfHGN.PtJyimhXpOld3o6aNC', '', 'Địa Ngục', NULL, 'customer', 'locked', 'Có dấu hiệu gian lận đơn hàng', '', '2026-10-29 23:09:52', 1, '2026-10-29 15:28:40'),
(4, 'google_1864f1a90d104e39dd75', '$2y$10$3pLBzvC1UudBL7nt8OVTWOBEkx8FKgq295cWUQnz72vp8WzaFR3Ai', 'Nguyễn Phạm Nhựt Trường', '24004051@st.vlute.edu.vn', NULL, NULL, '00000000000', 'vvvvvvvv', 'uploads/avatars/cfff77e5dc8306217b024bdc.png', 'customer', 'active', NULL, NULL, NULL, NULL, '2026-10-31 12:40:08'),
(6, 'ngu', '$2y$10$jEpsfwyl2SNpqGSDiOSq1.Xlj33XPooQg4lpxuzzfXOtQTpqFwEI6', 'Học Ngu', 'nhutnm2306@gmail.com', NULL, NULL, '', '', NULL, 'customer', 'active', NULL, NULL, NULL, NULL, '2026-10-31 13:28:57'),
(7, 'google_56131271fa2dc4455d1c', '$2y$10$AEQOqPBZXy8himG0giwdJ.9nUVxHaYwOqG9JFhd.Hm5f7ZDJuw.um', 'Tfft6 Hvcb', 'nguvl135@gmail.com', NULL, NULL, '', '', NULL, 'customer', 'active', NULL, NULL, NULL, NULL, '2026-11-05 00:43:57'),
(8, 'Khang', '$2y$10$wWqfZk0C5jgoAyQj2Qz6Le3CThpNsbiKh8G6ltr3543P8ySEtPQfS', 'Hồ Thái Khang', '24004019@st.vlute.edu.vn', NULL, NULL, '124124121', 'hậdasada', 'https://res.cloudinary.com/xhuozpn6/image/upload/v1793839979/fishshop/avatars/6e23801a38a5bb0f1370886d.jpg', 'admin', 'active', NULL, NULL, NULL, NULL, '2026-11-05 00:46:02');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_account_lock_history`
--

CREATE TABLE `user_account_lock_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `action` enum('lock','unlock') NOT NULL,
  `reason` varchar(64) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `performed_by_admin_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `user_account_lock_history`
--

INSERT INTO `user_account_lock_history` (`id`, `user_id`, `action`, `reason`, `note`, `performed_by_admin_id`, `created_at`) VALUES
(1, 2, 'lock', 'Có dấu hiệu gian lận đơn hàng', '', 1, '2026-10-29 16:09:52');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(100) NOT NULL,
  `discount_type` enum('fixed','percent') NOT NULL,
  `discount_value` decimal(12,0) UNSIGNED NOT NULL,
  `min_order_amount` decimal(12,0) UNSIGNED NOT NULL DEFAULT 0,
  `max_discount_amount` decimal(12,0) UNSIGNED DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL,
  `usage_limit` int(10) UNSIGNED DEFAULT NULL,
  `per_user_limit` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `vouchers`
--

INSERT INTO `vouchers` (`id`, `code`, `name`, `discount_type`, `discount_value`, `min_order_amount`, `max_discount_amount`, `starts_at`, `ends_at`, `usage_limit`, `per_user_limit`, `is_active`, `created_at`) VALUES
(1, 'NGU', 'ưu đãi', 'percent', 10, 1, 100, '2026-11-04 18:06:00', '2026-11-05 18:06:00', 2, 1, 1, '2026-11-04 11:06:39'),
(2, 'FISH', 'Cá', 'percent', 20, 120000, 2000, '2026-11-05 07:56:00', '2026-11-06 07:56:00', 12, 1, 1, '2026-11-05 00:56:57');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `voucher_usages`
--

CREATE TABLE `voucher_usages` (
  `id` int(10) UNSIGNED NOT NULL,
  `voucher_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `discount_amount` decimal(12,0) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `voucher_usages`
--

INSERT INTO `voucher_usages` (`id`, `voucher_id`, `user_id`, `order_id`, `discount_amount`, `created_at`) VALUES
(1, 1, 4, 29, 100, '2026-11-04 13:57:02'),
(2, 2, 8, 34, 2000, '2026-11-05 00:57:41');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `wallet_deposits`
--

CREATE TABLE `wallet_deposits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `amount` bigint(20) UNSIGNED NOT NULL,
  `reference_mode` enum('with_code','no_code') NOT NULL DEFAULT 'with_code',
  `request_type` enum('payos','direct') NOT NULL DEFAULT 'direct',
  `sender_name` varchar(100) NOT NULL DEFAULT '',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `payos_payment_link_id` varchar(80) DEFAULT NULL,
  `payos_checkout_url` varchar(500) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `payos_bank_bin` varchar(16) DEFAULT NULL,
  `payos_account_number` varchar(40) DEFAULT NULL,
  `payos_account_name` varchar(150) DEFAULT NULL,
  `payos_transfer_description` varchar(100) DEFAULT NULL,
  `payos_qr_code` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_at` datetime DEFAULT NULL,
  `reviewed_by` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `wallet_deposits`
--

INSERT INTO `wallet_deposits` (`id`, `user_id`, `amount`, `reference_mode`, `request_type`, `sender_name`, `status`, `payos_payment_link_id`, `payos_checkout_url`, `paid_at`, `payos_bank_bin`, `payos_account_number`, `payos_account_name`, `payos_transfer_description`, `payos_qr_code`, `created_at`, `reviewed_at`, `reviewed_by`) VALUES
(1, 4, 1000000, 'with_code', 'direct', '', 'approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 10:31:39', '2026-11-04 17:51:34', 1),
(2, 4, 20000, 'no_code', 'direct', '1212', 'approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 10:45:51', '2026-11-04 17:51:33', 1),
(3, 4, 33430000, 'no_code', 'direct', 'sadas', 'approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 13:56:05', '2026-11-04 22:24:49', 1),
(4, 4, 200000, 'no_code', 'payos', '', 'pending', '9783684dd60d4739ad0704485a6c60bb', 'https://pay.payos.vn/web/9783684dd60d4739ad0704485a6c60bb', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 15:00:32', NULL, NULL),
(5, 4, 2000000, 'no_code', 'payos', '', 'pending', '69d0b85738ca46208c3e118c3c61fa2e', 'https://pay.payos.vn/web/69d0b85738ca46208c3e118c3c61fa2e', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 15:25:28', NULL, NULL),
(6, 4, 200000, 'no_code', 'direct', '', 'approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 15:32:55', '2026-11-04 22:33:16', 1),
(7, 4, 40000, 'no_code', 'direct', '', 'approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 15:33:51', '2026-11-04 22:33:56', 1),
(8, 4, 240000, 'no_code', 'payos', '', 'pending', '338a0b31744c4e1698c8a53feeea0579', 'https://pay.payos.vn/web/338a0b31744c4e1698c8a53feeea0579', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 15:44:04', NULL, NULL),
(9, 4, 240000, 'no_code', 'payos', '', 'pending', '9ca0ab6df658458c97f8e27e22d12870', 'https://pay.payos.vn/web/9ca0ab6df658458c97f8e27e22d12870', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 15:52:23', NULL, NULL),
(10, 4, 20000, 'no_code', 'payos', '', 'pending', 'b723ada736e24396841e78dcb272f1eb', 'https://pay.payos.vn/web/b723ada736e24396841e78dcb272f1eb', NULL, '970416', 'LOCCASS000341542', 'NGUYEN PHAM NHUT TRUONG', 'CSX4GMTUYA8 WV10', '00020101021238600010A000000727013000069704160116LOCCASS0003415420208QRIBFTTA53037045405200005802VN62200816CSX4GMTUYA8 WV106304A213', '2026-11-04 23:35:35', NULL, NULL),
(11, 4, 5000000, 'no_code', 'direct', '', 'approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-04 23:35:58', '2026-11-05 06:37:00', 1),
(12, 8, 100000, 'no_code', 'direct', '', 'approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-05 00:51:26', '2026-11-05 07:51:36', 8),
(13, 8, 120000, 'no_code', 'payos', '', 'pending', '2850829284794e81a8d0687498d71a4e', 'https://pay.payos.vn/web/2850829284794e81a8d0687498d71a4e', NULL, '970416', 'LOCCASS000341542', 'NGUYEN PHAM NHUT TRUONG', 'CS2MGPQOJ82 WV13', '00020101021238600010A000000727013000069704160116LOCCASS0003415420208QRIBFTTA530370454061200005802VN62200816CS2MGPQOJ82 WV136304B560', '2026-11-05 00:53:49', NULL, NULL);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cart_user` (`user_id`);

--
-- Chỉ mục cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cart_product` (`cart_id`,`product_id`),
  ADD KEY `idx_cart_items_product` (`product_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_categories_name` (`name`);

--
-- Chỉ mục cho bảng `customer_ranks`
--
ALTER TABLE `customer_ranks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_customer_ranks_user` (`user_id`);

--
-- Chỉ mục cho bảng `login_google_accounts`
--
ALTER TABLE `login_google_accounts`
  ADD PRIMARY KEY (`google_sub`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_orders_id_user` (`id`,`user_id`),
  ADD KEY `idx_orders_user` (`user_id`),
  ADD KEY `idx_orders_status` (`status`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_order_product` (`order_id`,`product_id`),
  ADD KEY `idx_order_items_order` (`order_id`),
  ADD KEY `idx_order_items_product` (`product_id`);

--
-- Chỉ mục cho bảng `password_reset_attempts`
--
ALTER TABLE `password_reset_attempts`
  ADD PRIMARY KEY (`user_id`);

--
-- Chỉ mục cho bảng `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`user_id`);

--
-- Chỉ mục cho bảng `prize_rewards`
--
ALTER TABLE `prize_rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`,`status`);

--
-- Chỉ mục cho bảng `prize_spins`
--
ALTER TABLE `prize_spins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`,`created_at`),
  ADD KEY `fk_prize_spin_reward` (`reward_id`);

--
-- Chỉ mục cho bảng `prize_wallets`
--
ALTER TABLE `prize_wallets`
  ADD PRIMARY KEY (`user_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_products_category` (`category_id`),
  ADD KEY `idx_products_status` (`status`);

--
-- Chỉ mục cho bảng `rank_order_earnings`
--
ALTER TABLE `rank_order_earnings`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_rank_order_earnings_user` (`user_id`),
  ADD KEY `fk_rank_order_earnings_order` (`order_id`,`user_id`);

--
-- Chỉ mục cho bảng `registration_otps`
--
ALTER TABLE `registration_otps`
  ADD PRIMARY KEY (`email`),
  ADD UNIQUE KEY `challenge_hash` (`challenge_hash`);

--
-- Chỉ mục cho bảng `registration_rate_limits`
--
ALTER TABLE `registration_rate_limits`
  ADD PRIMARY KEY (`bucket`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_username` (`username`),
  ADD UNIQUE KEY `uq_users_email` (`email`),
  ADD KEY `idx_users_account_status` (`account_status`),
  ADD KEY `idx_users_locked_by_admin` (`locked_by_admin_id`);

--
-- Chỉ mục cho bảng `user_account_lock_history`
--
ALTER TABLE `user_account_lock_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_lock_history_user` (`user_id`),
  ADD KEY `idx_user_lock_history_admin` (`performed_by_admin_id`);

--
-- Chỉ mục cho bảng `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Chỉ mục cho bảng `voucher_usages`
--
ALTER TABLE `voucher_usages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_id` (`order_id`),
  ADD KEY `idx_voucher_usage_user` (`voucher_id`,`user_id`),
  ADD KEY `fk_voucher_usage_user` (`user_id`);

--
-- Chỉ mục cho bảng `wallet_deposits`
--
ALTER TABLE `wallet_deposits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_wallet_deposit_payos_link` (`payos_payment_link_id`),
  ADD KEY `status` (`status`,`created_at`),
  ADD KEY `user_id` (`user_id`,`created_at`),
  ADD KEY `fk_wallet_deposit_reviewer` (`reviewed_by`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `customer_ranks`
--
ALTER TABLE `customer_ranks`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `prize_rewards`
--
ALTER TABLE `prize_rewards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT cho bảng `prize_spins`
--
ALTER TABLE `prize_spins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=285;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `user_account_lock_history`
--
ALTER TABLE `user_account_lock_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `voucher_usages`
--
ALTER TABLE `voucher_usages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `wallet_deposits`
--
ALTER TABLE `wallet_deposits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cart_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `customer_ranks`
--
ALTER TABLE `customer_ranks`
  ADD CONSTRAINT `fk_customer_ranks_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `login_google_accounts`
--
ALTER TABLE `login_google_accounts`
  ADD CONSTRAINT `fk_login_google_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `password_reset_attempts`
--
ALTER TABLE `password_reset_attempts`
  ADD CONSTRAINT `fk_password_reset_attempts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `fk_password_reset_tokens_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `prize_rewards`
--
ALTER TABLE `prize_rewards`
  ADD CONSTRAINT `fk_prize_reward_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `prize_spins`
--
ALTER TABLE `prize_spins`
  ADD CONSTRAINT `fk_prize_spin_reward` FOREIGN KEY (`reward_id`) REFERENCES `prize_rewards` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_prize_spin_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `prize_wallets`
--
ALTER TABLE `prize_wallets`
  ADD CONSTRAINT `fk_prize_wallet_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `rank_order_earnings`
--
ALTER TABLE `rank_order_earnings`
  ADD CONSTRAINT `fk_rank_order_earnings_order` FOREIGN KEY (`order_id`,`user_id`) REFERENCES `orders` (`id`, `user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rank_order_earnings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_locked_by_admin` FOREIGN KEY (`locked_by_admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `user_account_lock_history`
--
ALTER TABLE `user_account_lock_history`
  ADD CONSTRAINT `fk_user_lock_history_admin` FOREIGN KEY (`performed_by_admin_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_lock_history_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `voucher_usages`
--
ALTER TABLE `voucher_usages`
  ADD CONSTRAINT `fk_voucher_usage_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_voucher_usage_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_voucher_usage_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `wallet_deposits`
--
ALTER TABLE `wallet_deposits`
  ADD CONSTRAINT `fk_wallet_deposit_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_wallet_deposit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
