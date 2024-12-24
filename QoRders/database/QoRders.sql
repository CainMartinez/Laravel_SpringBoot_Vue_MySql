-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: mysql_container
-- Tiempo de generación: 24-12-2024 a las 03:01:33
-- Versión del servidor: 8.0.40
-- Versión de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
CREATE DATABASE IF NOT EXISTS QoRders;

USE QoRders;
--
-- Base de datos: `QoRders`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Blacklist`
--

CREATE TABLE `Blacklist` (
  `id` bigint NOT NULL,
  `token` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `expiration_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Blacklist`
--

INSERT INTO `Blacklist` (`id`, `token`, `email`, `expiration_date`) VALUES
(1, 'eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiY2xpZW50Iiwic3ViIjoianVhbkBnbWFpbC5jb20iLCJpYXQiOjE3MzQ5OTg5NTgsImV4cCI6MTczNTAwMjU1OH0.SunnUpFuRkcKzqnui_juRkTGDtqTeGJ6qfubzxg5fCo', 'juan@gmail.com', '2024-12-24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Booking`
--

CREATE TABLE `Booking` (
  `booking_id` int NOT NULL,
  `booking_uuid` char(36) NOT NULL,
  `email` varchar(150) NOT NULL,
  `room_shift_id` int NOT NULL,
  `guest_count` int NOT NULL,
  `status` enum('Pending','Confirmed','InProgress','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Booking`
--

INSERT INTO `Booking` (`booking_id`, `booking_uuid`, `email`, `room_shift_id`, `guest_count`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, '84e9a868-c908-4126-b404-7221e819298d', 'yomogan@gmail.com', 3, 3, 'Confirmed', 'Silla para niño pequeño.', '2024-12-24 01:20:56', '2024-12-24 01:20:56'),
(2, '84e9a868-c908-4126-b404-7221e819298e', 'yomogan@gmail.com', 4, 2, 'Confirmed', 'Mesa cerca de la ventana.', '2024-12-24 01:21:56', '2024-12-24 01:21:56'),
(3, '84e9a868-c908-4126-b404-7221e819298f', 'juan@gmail.com', 3, 4, 'Confirmed', 'Mesa en la terraza.', '2024-12-24 01:22:56', '2024-12-24 01:22:56'),
(4, '84e9a868-c908-4126-b404-7221e8192990', 'juan@gmail.com', 5, 3, 'Confirmed', 'Mesa cerca de la entrada.', '2024-12-24 01:23:56', '2024-12-24 01:23:56'),
(5, '84e9a868-c908-4126-b404-7221e8192991', 'ramon@gmail.com', 2, 2, 'Confirmed', 'Mesa en el patio.', '2024-12-24 01:24:56', '2024-12-24 01:24:56'),
(6, '84e9a868-c908-4126-b404-7221e8192992', 'ramon@gmail.com', 1, 5, 'Confirmed', 'Mesa en el salón principal.', '2024-12-24 01:25:56', '2024-12-24 01:25:56'),
(7, '84e9a868-c908-4126-b404-7221e8192993', 'hasan@gmail.com', 3, 3, 'Confirmed', 'Mesa en la esquina.', '2024-12-24 01:26:56', '2024-12-24 01:26:56'),
(8, '84e9a868-c908-4126-b404-7221e8192994', 'hasan@gmail.com', 4, 2, 'Confirmed', 'Mesa cerca del bar.', '2024-12-24 01:27:56', '2024-12-24 01:27:56'),
(9, '84e9a868-c908-4126-b404-7221e8192995', 'abdel@gmail.com', 5, 4, 'Confirmed', 'Mesa en el jardín.', '2024-12-24 01:28:56', '2024-12-24 01:28:56'),
(10, '84e9a868-c908-4126-b404-7221e8192996', 'abdel@gmail.com', 1, 3, 'Confirmed', 'Mesa en el salón VIP.', '2024-12-24 01:29:56', '2024-12-24 01:29:56'),
(11, '84e9a868-c908-4126-b404-7221e8192997', 'mohamed@gmail.com', 2, 2, 'Confirmed', 'Mesa en la terraza.', '2024-12-24 01:30:56', '2024-12-24 01:30:56'),
(12, '84e9a868-c908-4126-b404-7221e8192998', 'mohamed@gmail.com', 3, 5, 'Confirmed', 'Mesa en el salón principal.', '2024-12-24 01:31:56', '2024-12-24 01:31:56'),
(13, '84e9a868-c908-4126-b404-7221e8192999', 'ali@gmail.com', 4, 3, 'Confirmed', 'Mesa en la esquina.', '2024-12-24 01:32:56', '2024-12-24 01:32:56'),
(14, '84e9a868-c908-4126-b404-7221e8193000', 'ali@gmail.com', 5, 2, 'Confirmed', 'Mesa cerca del bar.', '2024-12-24 01:33:56', '2024-12-24 01:33:56'),
(15, '84e9a868-c908-4126-b404-7221e8193001', 'yamal@gmail.com', 1, 4, 'Confirmed', 'Mesa en el jardín.', '2024-12-24 01:34:56', '2024-12-24 01:34:56'),
(16, '84e9a868-c908-4126-b404-7221e8193002', 'yamal@gmail.com', 2, 3, 'Confirmed', 'Mesa en el salón VIP.', '2024-12-24 01:35:56', '2024-12-24 01:35:56'),
(17, '84e9a868-c908-4126-b404-7221e8193003', 'omar@gmail.com', 3, 2, 'Confirmed', 'Mesa en la terraza.', '2024-12-24 01:36:56', '2024-12-24 01:36:56'),
(18, '84e9a868-c908-4126-b404-7221e8193004', 'omar@gmail.com', 4, 5, 'Confirmed', 'Mesa en el salón principal.', '2024-12-24 01:37:56', '2024-12-24 01:37:56'),
(19, '84e9a868-c908-4126-b404-7221e8193005', 'drills@gmail.com', 5, 3, 'Confirmed', 'Mesa en la esquina.', '2024-12-24 01:38:56', '2024-12-24 01:38:56'),
(20, '84e9a868-c908-4126-b404-7221e8193006', 'drills@gmail.com', 1, 2, 'Confirmed', 'Mesa cerca del bar.', '2024-12-24 01:39:56', '2024-12-24 01:39:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Booking_Waiter`
--

CREATE TABLE `Booking_Waiter` (
  `booking_waiter_id` int NOT NULL,
  `booking_waiter_uuid` char(36) NOT NULL,
  `booking_id` int NOT NULL,
  `waiter_id` int NOT NULL,
  `role` enum('Lead','Support') DEFAULT 'Support',
  `notes` text,
  `assigned_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Customer`
--

CREATE TABLE `Customer` (
  `customer_id` int NOT NULL,
  `customer_uuid` char(36) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `address` text,
  `email` varchar(150) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `avatar_url` text,
  `bio` text,
  `has_coupon` tinyint(1) DEFAULT '0',
  `loyalty_points` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `is_seated` tinyint(1) DEFAULT '0',
  `refresh_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Customer`
--

INSERT INTO `Customer` (`customer_id`, `customer_uuid`, `first_name`, `last_name`, `age`, `address`, `email`, `phone_number`, `password`, `avatar_url`, `bio`, `has_coupon`, `loyalty_points`, `is_active`, `is_seated`, `refresh_token`, `created_at`, `updated_at`) VALUES
(21, '394e3a53-3c2c-4132-9b10-4a757a4efac4', 'Yolanda', 'Yolanda', NULL, NULL, 'yomogan@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$LlZawwwdCHzz1ztxqNBNQg$eXlXClwlNahzjzpE8iP8GWOcY2tcohFIPZstJ0HHm1Q', 'https://i.pravatar.cc/150?u=Yolanda', NULL, 0, 0, 1, 0, 'eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiY2xpZW50Iiwic3ViIjoieW9tb2dhbkBnbWFpbC5jb20iLCJpYXQiOjE3MzUwMDMyMzMsImV4cCI6MTczNTYwODAzM30.oRVLloPnt6VLdy2wt9xRxPw5K-L6GEwwD_Svepmr_Po', '2024-12-11 22:38:47', '2024-12-24 01:20:34'),
(22, '0efe659e-a186-4976-82f0-1b3682b2d247', 'Juan', 'Cuesta', NULL, NULL, 'juan@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$auhKCd8nlIeWU0LZFocohA$nyJ7uplPd1nwvLaMxRGKtSsNqjUPL5ZNpfhhczK5fGU', 'https://i.pravatar.cc/150?u=Juan', NULL, 0, 0, 1, 0, 'eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiY2xpZW50Iiwic3ViIjoianVhbkBnbWFpbC5jb20iLCJpYXQiOjE3MzQ5OTg5NTgsImV4cCI6MTczNTYwMzc1OH0.ZsrZcCh7Bh_pAND1wdYEpSPaLGm-YkAx8pV3yi4eqj0', '2024-12-24 00:08:59', '2024-12-24 00:09:18'),
(23, '55e18edb-382e-493d-8924-0e431b398f37', 'Ramón', 'García', NULL, NULL, 'ramon@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$CCkz5/EaJUpRPRCuMTPWKw$+trduusnsBNLgbmsteFQsXE1WR6TlEyJkRCX2MlgXvQ', 'https://i.pravatar.cc/150?u=Ramón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:09:14', '2024-12-24 01:09:14'),
(24, 'dcb2cebc-a6b1-4c67-a09c-5270f2947be3', 'Saúl', 'Hasan', NULL, NULL, 'hasan@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$ZzsyTAzkdW4mH6SV+Thzvg$Gw2erf/wiB+JJKWJCJjJlsYDGDEk6xT2UwcEPWlP3aM', 'https://i.pravatar.cc/150?u=Salomón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:10:14', '2024-12-24 01:10:14'),
(25, 'dcb2cebc-a6b1-4c67-a09c-5270f2947be2', 'Jose', 'Abdel', NULL, NULL, 'abdel@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$ZzsyTAzkdW4mH6SV+Thzvg$Gw2erf/wiB+JJKWJCJjJlsYDGDEk6xT2UwcEPWlP3aM', 'https://i.pravatar.cc/150?u=Salomón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:10:14', '2024-12-24 01:10:14'),
(26, 'dcb2cebc-a6b1-4c67-a09c-5270f2947be1', 'Perez', 'Mohamed', NULL, NULL, 'mohamed@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$ZzsyTAzkdW4mH6SV+Thzvg$Gw2erf/wiB+JJKWJCJjJlsYDGDEk6xT2UwcEPWlP3aM', 'https://i.pravatar.cc/150?u=Salomón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:10:14', '2024-12-24 01:10:14'),
(27, 'dcb2cebc-a6b1-4c67-a09c-5270f2947be4', 'Paloma', 'Ali', NULL, NULL, 'ali@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$ZzsyTAzkdW4mH6SV+Thzvg$Gw2erf/wiB+JJKWJCJjJlsYDGDEk6xT2UwcEPWlP3aM', 'https://i.pravatar.cc/150?u=Salomón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:10:14', '2024-12-24 01:10:14'),
(28, 'dcb2cebc-a6b1-4c67-a09c-5270f2947be5', 'Raquel', 'Yamal', NULL, NULL, 'yamal@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$ZzsyTAzkdW4mH6SV+Thzvg$Gw2erf/wiB+JJKWJCJjJlsYDGDEk6xT2UwcEPWlP3aM', 'https://i.pravatar.cc/150?u=Salomón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:10:14', '2024-12-24 01:10:14'),
(29, 'dcb2cebc-a6b1-4c67-a09c-5270f2947be6', 'Rosa', 'Omar', NULL, NULL, 'omar@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$ZzsyTAzkdW4mH6SV+Thzvg$Gw2erf/wiB+JJKWJCJjJlsYDGDEk6xT2UwcEPWlP3aM', 'https://i.pravatar.cc/150?u=Salomón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:10:14', '2024-12-24 01:10:14'),
(30, 'dcb2cebc-a6b1-4c67-a09c-5270f2947be7', 'Carmen', 'Drills', NULL, NULL, 'drills@gmail.com', NULL, '$argon2id$v=19$m=4096,t=3,p=1$ZzsyTAzkdW4mH6SV+Thzvg$Gw2erf/wiB+JJKWJCJjJlsYDGDEk6xT2UwcEPWlP3aM', 'https://i.pravatar.cc/150?u=Salomón', NULL, 0, 0, 1, 0, NULL, '2024-12-24 01:10:14', '2024-12-24 01:19:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Donations`
--

CREATE TABLE `Donations` (
  `donation_id` int NOT NULL,
  `customer_username` varchar(255) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `ngo_slug` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Feedback`
--

CREATE TABLE `Feedback` (
  `feedback_id` int NOT NULL,
  `feedback_uuid` char(36) NOT NULL,
  `booking_id` int NOT NULL,
  `comment` text,
  `room_rating` tinyint NOT NULL,
  `personal_rating` tinyint NOT NULL,
  `is_visible` tinyint(1) DEFAULT '1',
  `response` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Manager`
--

CREATE TABLE `Manager` (
  `manager_id` int NOT NULL,
  `manager_uuid` char(36) NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `address` text,
  `salary` decimal(10,2) DEFAULT '3000.00',
  `is_active` tinyint(1) DEFAULT '1',
  `bio` text,
  `avatar_url` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Manager`
--

INSERT INTO `Manager` (`manager_id`, `manager_uuid`, `firstName`, `lastName`, `email`, `password`, `phone_number`, `address`, `salary`, `is_active`, `bio`, `avatar_url`, `created_at`, `updated_at`) VALUES
(4, '5a7dc3c4-0c4f-4e58-9d6d-9891001e29e2', 'Yolanda', 'Yolanda', 'yomogan@gmail.com', '$argon2i$v=19$m=65536,t=4,p=2$MHNlajQzSm5sdUpJbnVqeQ$HlSX+aeCSSju7FSADXNbivXApitNpty4BeduU8mou1c', NULL, NULL, 3000.00, 1, NULL, 'https://i.pravatar.cc/300?u=de76af6dc1a4d90e3d02c61e013d0175', '2024-12-11 22:39:37', '2024-12-11 22:39:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `NGO`
--

CREATE TABLE `NGO` (
  `ngo_id` int NOT NULL,
  `ngo_uuid` char(36) NOT NULL,
  `ngo_name` varchar(150) NOT NULL,
  `ngo_slug` varchar(150) NOT NULL,
  `description` text,
  `country` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `website_url` text,
  `logo_url` text,
  `image_url` text,
  `description_img_url` text,
  `is_active` tinyint(1) DEFAULT '1',
  `total_donations` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `NGO`
--

INSERT INTO `NGO` (`ngo_id`, `ngo_uuid`, `ngo_name`, `ngo_slug`, `description`, `country`, `email`, `phone_number`, `website_url`, `logo_url`, `image_url`, `description_img_url`, `is_active`, `total_donations`, `created_at`, `updated_at`) VALUES
(1, 'bfe0dd93-a383-11ef-a437-0242ac140002', 'Sakura Foundation', 'Sakura_Foundation_123456', 'La Sakura Foundation está dedicada a preservar el patrimonio cultural japonés y apoyar a las comunidades desfavorecidas. Fundada en 1995, ha trabajado incansablemente para promover la educación y la cultura japonesa en todo el mundo.; La fundación organiza eventos culturales, talleres educativos y programas de intercambio para jóvenes. Además, proporciona becas a estudiantes de bajos recursos para que puedan continuar sus estudios. Su misión es crear un puente entre Japón y el resto del mundo, fomentando el entendimiento y la cooperación internacional.', 'Japón', 'contact@sakurafoundation.jp', '+81345678901', 'https://www.sakurafoundation.jp', '/src/assets/ngos/SakuraFoundation_01.webp', '/src/assets/ngos/SakuraFoundation_03.webp', '/src/assets/ngos/SakuraFoundation_02.webp', 1, 1500.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(2, 'bfe0e287-a383-11ef-a437-0242ac140002', 'Helping Hands India', 'Helping_Hands_India_375839', 'Helping Hands India se centra en la educación y la atención médica para niños desfavorecidos en India. Desde su creación en 2001, ha impactado positivamente en la vida de miles de niños.; La organización ofrece programas de tutoría, clínicas móviles y campañas de concienciación sobre la salud. También colabora con escuelas locales para mejorar la infraestructura educativa y proporcionar materiales de estudio. Su objetivo es romper el ciclo de pobreza a través de la educación y la salud.', 'India', 'info@helpinghands.in', '+911234567890', 'https://www.helpinghandsindia.org', '/src/assets/ngos/HelpingHandsIndia_01.webp', '/src/assets/ngos/HelpingHandsIndia_03.webp', '/src/assets/ngos/HelpingHandsIndia_02.webp', 1, 2400.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(3, 'bfe0e439-a383-11ef-a437-0242ac140002', 'Solidaridad Española', 'Solidaridad_Española_740284', 'Solidaridad Española promueve la inclusión social y proporciona ayuda a comunidades marginadas en España. Desde su fundación en 1987, ha trabajado en proyectos de integración y apoyo social.; La organización ofrece servicios de asesoramiento legal, apoyo psicológico y programas de formación laboral. También organiza actividades recreativas y culturales para fomentar la cohesión social. Su misión es construir una sociedad más justa e inclusiva.', 'España', 'solidaridad@espanola.es', '+34912345678', 'https://www.solidaridadespanola.org', '/src/assets/ngos/SolidaridadEspanyola_01.webp', '/src/assets/ngos/SolidaridadEspanyola_03.webp', '/src/assets/ngos/SolidaridadEspanyola_02.webp', 1, 1800.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(4, 'bfe0e52b-a383-11ef-a437-0242ac140002', 'Amici della Vita', 'Amici_della_Vita_982023', 'Amici della Vita apoya a familias y niños necesitados, enfocándose en la educación y la atención médica en Italia. Desde 1990, ha proporcionado recursos esenciales a comunidades vulnerables.; La organización gestiona centros comunitarios, clínicas de salud y programas de apoyo escolar. También trabaja en la sensibilización sobre la importancia de la educación y la salud. Su visión es garantizar que todos los niños tengan acceso a una vida digna y saludable.', 'Italia', 'info@amicivita.it', '+390123456789', 'https://www.amicidellavita.it', '/src/assets/ngos/AmiciDellaVita_01.webp', '/src/assets/ngos/AmiciDellaVita_03.webp', '/src/assets/ngos/AmiciDellaVita_02.webp', 1, 2000.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(5, 'bfe0e635-a383-11ef-a437-0242ac140002', 'Manos Unidas México', 'Manos_Unidas_México_954623', 'Manos Unidas México proporciona apoyo para programas de desarrollo rural y educación en México. Desde su creación en 1998, ha trabajado para mejorar la calidad de vida en comunidades rurales.; La organización implementa proyectos de agricultura sostenible, acceso a agua potable y educación básica. También colabora con gobiernos locales y otras ONGs para maximizar el impacto de sus programas. Su misión es empoderar a las comunidades rurales para que puedan alcanzar un desarrollo sostenible.', 'México', 'contacto@manosunidas.mx', '+525512345678', 'https://www.manosunidasmexico.org', '/src/assets/ngos/ManosUnidasMexico_01.webp', '/src/assets/ngos/ManosUnidasMexico_03.webp', '/src/assets/ngos/ManosUnidasMexico_02.webp', 1, 2300.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(6, 'bfe0e6dd-a383-11ef-a437-0242ac140002', 'Hope for Türkiye', 'Hope_for_Türkiye_468134', 'Hope for Türkiye ofrece ayuda en casos de desastre y apoya proyectos de reconstrucción comunitaria en Turquía. Desde su fundación en 2005, ha sido un pilar en la respuesta a emergencias.; La organización proporciona refugio, alimentos y atención médica a las víctimas de desastres naturales. También trabaja en proyectos de reconstrucción y desarrollo comunitario a largo plazo. Su objetivo es ayudar a las comunidades a recuperarse y reconstruir sus vidas después de una crisis.', 'Turquía', 'support@hopeforturkiye.tr', '+905312345678', 'https://www.hopeforturkiye.org', '/src/assets/ngos/HopeForTurkikye_01.webp', '/src/assets/ngos/HopeForTurkikye_03.webp', '/src/assets/ngos/HopeForTurkikye_02.webp', 1, 2200.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Orders`
--

CREATE TABLE `Orders` (
  `order_id` int NOT NULL,
  `order_uuid` char(36) NOT NULL,
  `booking_id` int NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `order_status` enum('Waiting','Assigned','Delivered') NOT NULL DEFAULT 'Waiting',
  `payment_status` enum('Paid','Unpaid') NOT NULL DEFAULT 'Unpaid',
  `total_amount` decimal(10,2) NOT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Orders`
--

INSERT INTO `Orders` (`order_id`, `order_uuid`, `booking_id`, `is_active`, `order_status`, `payment_status`, `total_amount`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'bfb268f8-cf23-499b-8bb5-7aae73abfb53', 1, 0, 'Waiting', 'Paid', 47.00, 'Somos 1 persona más, traed 1 cubierto extra.', '2024-12-24 01:21:31', '2024-12-24 01:22:42'),
(2, 'bfb268f8-cf23-499b-8bb5-7aae73abfb54', 2, 0, 'Waiting', 'Paid', 50.00, 'Traed una silla alta para bebé.', '2024-12-24 01:23:31', '2024-12-24 01:24:42'),
(3, 'bfb268f8-cf23-499b-8bb5-7aae73abfb55', 3, 0, 'Waiting', 'Paid', 60.00, 'Mesa con vista al mar.', '2024-12-24 01:25:31', '2024-12-24 01:26:42'),
(4, 'bfb268f8-cf23-499b-8bb5-7aae73abfb56', 4, 0, 'Waiting', 'Paid', 70.00, 'Mesa cerca de la chimenea.', '2024-12-24 01:27:31', '2024-12-24 01:28:42'),
(5, 'bfb268f8-cf23-499b-8bb5-7aae73abfb57', 5, 0, 'Waiting', 'Paid', 80.00, 'Mesa en el jardín.', '2024-12-24 01:29:31', '2024-12-24 01:30:42'),
(6, 'bfb268f8-cf23-499b-8bb5-7aae73abfb58', 6, 0, 'Waiting', 'Paid', 90.00, 'Mesa en el salón principal.', '2024-12-24 01:31:31', '2024-12-24 01:32:42'),
(7, 'bfb268f8-cf23-499b-8bb5-7aae73abfb59', 7, 0, 'Waiting', 'Paid', 100.00, 'Mesa en la esquina.', '2024-12-24 01:33:31', '2024-12-24 01:34:42'),
(8, 'bfb268f8-cf23-499b-8bb5-7aae73abfb60', 8, 0, 'Waiting', 'Paid', 110.00, 'Mesa cerca del bar.', '2024-12-24 01:35:31', '2024-12-24 01:36:42'),
(9, 'bfb268f8-cf23-499b-8bb5-7aae73abfb61', 9, 0, 'Waiting', 'Paid', 120.00, 'Mesa en el jardín.', '2024-12-24 01:37:31', '2024-12-24 01:38:42'),
(10, 'bfb268f8-cf23-499b-8bb5-7aae73abfb62', 10, 0, 'Waiting', 'Paid', 130.00, 'Mesa en el salón VIP.', '2024-12-24 01:39:31', '2024-12-24 01:40:42'),
(11, 'bfb268f8-cf23-499b-8bb5-7aae73abfb63', 11, 0, 'Waiting', 'Paid', 140.00, 'Mesa en la terraza.', '2024-12-24 01:41:31', '2024-12-24 01:42:42'),
(12, 'bfb268f8-cf23-499b-8bb5-7aae73abfb64', 12, 0, 'Waiting', 'Paid', 150.00, 'Mesa en el salón principal.', '2024-12-24 01:43:31', '2024-12-24 01:44:42'),
(13, 'bfb268f8-cf23-499b-8bb5-7aae73abfb65', 13, 0, 'Waiting', 'Paid', 160.00, 'Mesa en la esquina.', '2024-12-24 01:45:31', '2024-12-24 01:46:42'),
(14, 'bfb268f8-cf23-499b-8bb5-7aae73abfb66', 14, 0, 'Waiting', 'Paid', 170.00, 'Mesa cerca del bar.', '2024-12-24 01:47:31', '2024-12-24 01:48:42'),
(15, 'bfb268f8-cf23-499b-8bb5-7aae73abfb67', 15, 0, 'Waiting', 'Paid', 180.00, 'Mesa en el jardín.', '2024-12-24 01:49:31', '2024-12-24 01:50:42'),
(16, 'bfb268f8-cf23-499b-8bb5-7aae73abfb68', 16, 0, 'Waiting', 'Paid', 190.00, 'Mesa en el salón VIP.', '2024-12-24 01:51:31', '2024-12-24 01:52:42'),
(17, 'bfb268f8-cf23-499b-8bb5-7aae73abfb69', 17, 0, 'Waiting', 'Paid', 200.00, 'Mesa en la terraza.', '2024-12-24 01:53:31', '2024-12-24 01:54:42'),
(18, 'bfb268f8-cf23-499b-8bb5-7aae73abfb70', 18, 0, 'Waiting', 'Paid', 210.00, 'Mesa en el salón principal.', '2024-12-24 01:55:31', '2024-12-24 01:56:42'),
(19, 'bfb268f8-cf23-499b-8bb5-7aae73abfb71', 19, 0, 'Waiting', 'Paid', 220.00, 'Mesa en la esquina.', '2024-12-24 01:57:31', '2024-12-24 01:58:42'),
(20, 'bfb268f8-cf23-499b-8bb5-7aae73abfb72', 20, 0, 'Waiting', 'Paid', 230.00, 'Mesa cerca del bar.', '2024-12-24 01:59:31', '2024-12-24 02:00:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Orders_Products`
--

CREATE TABLE `Orders_Products` (
  `order_product_id` int NOT NULL,
  `order_product_uuid` char(36) NOT NULL,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `is_delivered` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Orders_Products`
--

INSERT INTO `Orders_Products` (`order_product_id`, `order_product_uuid`, `order_id`, `product_id`, `quantity`, `is_delivered`, `created_at`, `updated_at`) VALUES
(1, '19e938d0-8d64-45e3-b4be-da80a8e34af6', 1, 44, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(2, '6fcaa5c9-afe9-4f14-977f-dcbdc204b308', 1, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(3, '7b25ed02-221c-4cdc-b86e-1c4a2cd6f9f8', 3, 5, 5, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(4, '19e938d0-8d64-45e3-b4be-da80a8e34af7', 4, 44, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(5, '6fcaa5c9-afe9-4f14-977f-dcbdc204b309', 5, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(6, '7b25ed02-221c-4cdc-b86e-1c4a2cd6f9f9', 6, 5, 5, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(7, '19e938d0-8d64-45e3-b4be-da80a8e34af8', 7, 44, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(8, '6fcaa5c9-afe9-4f14-977f-dcbdc204b310', 8, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(9, '7b25ed02-221c-4cdc-b86e-1c4a2cd6f9f0', 9, 5, 5, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(10, '19e938d0-8d64-45e3-b4be-da80a8e34af9', 10, 44, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(11, '6fcaa5c9-afe9-4f14-977f-dcbdc204b311', 11, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(12, '7b25ed02-221c-4cdc-b86e-1c4a2cd6f9f1', 12, 5, 5, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(13, '19e938d0-8d64-45e3-b4be-da80a8e34af0', 13, 44, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(14, '6fcaa5c9-afe9-4f14-977f-dcbdc204b312', 14, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(15, '7b25ed02-221c-4cdc-b86e-1c4a2cd6f9f2', 15, 5, 5, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(16, '19e938d0-8d64-45e3-b4be-da80a8e34af1', 16, 44, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(17, '6fcaa5c9-afe9-4f14-977f-dcbdc204b313', 17, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(18, '7b25ed02-221c-4cdc-b86e-1c4a2cd6f9f3', 18, 5, 5, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(19, '19e938d0-8d64-45e3-b4be-da80a8e34af2', 19, 44, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(20, '6fcaa5c9-afe9-4f14-977f-dcbdc2043338', 2, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11'),
(21, '6fcaa5c9-afe9-45e3-b4be-da80a8e34af2', 20, 33, 2, 0, '2024-12-24 01:22:11', '2024-12-24 01:22:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Products`
--

CREATE TABLE `Products` (
  `product_id` int NOT NULL,
  `product_uuid` char(36) NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `product_slug` varchar(150) NOT NULL,
  `description` text,
  `unit_price` decimal(10,2) NOT NULL,
  `allergens` text,
  `stock` int DEFAULT '0',
  `image_url` text,
  `product_type` enum('Starter','Main Course','Dessert','Drink','Other') NOT NULL,
  `origin` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Products`
--

INSERT INTO `Products` (`product_id`, `product_uuid`, `product_name`, `product_slug`, `description`, `unit_price`, `allergens`, `stock`, `image_url`, `product_type`, `origin`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'e35412ac-a383-11ef-a437-0242ac140002', 'Croquetas de Jamón', 'Croquetas_de_Jamón_258103', 'Deliciosas croquetas caseras rellenas de jamón serrano.', 5.50, 'Gluten, Lactosa', 100, '/src/assets/products/spain/CroquetasDeJamon.webp', 'Starter', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(2, 'e3541600-a383-11ef-a437-0242ac140002', 'Tortilla Española', 'Tortilla_Española_161382', 'Clásica tortilla de patatas con cebolla caramelizada.', 4.50, 'Huevo', 50, '/src/assets/products/spain/TortillaEspanola.webp', 'Starter', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(3, 'e35416be-a383-11ef-a437-0242ac140002', 'Pan con Tomate', 'Pan_con_Tomate_190974', 'Rebanadas de pan crujiente con tomate rallado y aceite de oliva.', 3.00, 'Gluten', 150, '/src/assets/products/spain/PanConTomate.webp', 'Starter', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(4, 'e3541704-a383-11ef-a437-0242ac140002', 'Gambas al Ajillo', 'Gambas_al_Ajillo_469576', 'Gambas salteadas con ajo, aceite de oliva y guindilla.', 7.00, 'Mariscos', 30, '/src/assets/products/spain/GambasAlAjillo.webp', 'Starter', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(5, 'e354173c-a383-11ef-a437-0242ac140002', 'Pimientos de Padrón', 'Pimientos_de_Padrón_662718', 'Pimientos verdes pequeños fritos, algunos picantes.', 5.00, NULL, 80, '/src/assets/products/spain/PimientosDePadron.webp', 'Starter', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(6, 'e35417c3-a383-11ef-a437-0242ac140002', 'Paella Valenciana', 'Paella_Valenciana_448734', 'Tradicional paella con pollo, conejo, y verduras frescas.', 15.00, 'Gluten, Mariscos', 40, '/src/assets/products/spain/PaellaValenciana.webp', 'Main Course', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(7, 'e3541801-a383-11ef-a437-0242ac140002', 'Cocido Madrileño', 'Cocido_Madrileño_758697', 'Guiso tradicional con garbanzos, carne y embutidos.', 12.00, NULL, 25, '/src/assets/products/spain/CocidoMadrileno.webp', 'Main Course', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(8, 'e354183a-a383-11ef-a437-0242ac140002', 'Fabada Asturiana', 'Fabada_Asturiana_166836', 'Plato típico asturiano con fabes, chorizo, y morcilla.', 13.50, NULL, 20, '/src/assets/products/spain/FabadaAsturiana.webp', 'Main Course', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(9, 'e35418a3-a383-11ef-a437-0242ac140002', 'Bacalao al Pil-Pil', 'Bacalao_al_Pil-Pil_517100', 'Bacalao cocinado en una salsa de ajo, aceite de oliva y guindilla.', 14.00, 'Pescado', 30, '/src/assets/products/spain/BacalaoAlPilPil.webp', 'Main Course', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(10, 'e35418d8-a383-11ef-a437-0242ac140002', 'Pollo al Chilindrón', 'Pollo_al_Chilindrón_013665', 'Pollo cocido en salsa de pimientos, tomate y jamón.', 11.00, NULL, 50, '/src/assets/products/spain/PolloAlChilindron.webp', 'Main Course', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(11, 'e354190a-a383-11ef-a437-0242ac140002', 'Tarta de Santiago', 'Tarta_de_Santiago_536333', 'Tarta de almendras con azúcar glas y un toque de limón.', 5.00, 'Frutos Secos, Huevo', 60, '/src/assets/products/spain/TartaDeSantiago.webp', 'Dessert', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(12, 'e3541956-a383-11ef-a437-0242ac140002', 'Flan Casero', 'Flan_Casero_115207', 'Flan de huevo y leche con caramelo líquido.', 4.00, 'Lactosa, Huevo', 80, '/src/assets/products/spain/FlanCasero.webp', 'Dessert', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(13, 'e35419d2-a383-11ef-a437-0242ac140002', 'Churros con Chocolate', 'Churros_con_Chocolate_823226', 'Churros crujientes acompañados de chocolate caliente.', 6.00, 'Gluten', 100, '/src/assets/products/spain/ChurrosConChocolate.webp', 'Dessert', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(14, 'e3541a13-a383-11ef-a437-0242ac140002', 'Natillas', 'Natillas_053910', 'Postre cremoso con leche, huevo y canela.', 3.50, 'Lactosa, Huevo', 70, '/src/assets/products/spain/Natillas.webp', 'Dessert', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(15, 'e3541a42-a383-11ef-a437-0242ac140002', 'Arroz con Leche', 'Arroz_con_Leche_188108', 'Arroz cocido en leche con canela y ralladura de limón.', 4.50, 'Lactosa', 50, '/src/assets/products/spain/ArrozConLeche.webp', 'Dessert', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(16, 'e3541a9e-a383-11ef-a437-0242ac140002', 'Sangría', 'Sangría_697570', 'Refrescante mezcla de vino tinto, frutas y soda.', 7.00, 'Sulfitos', 30, '/src/assets/products/spain/Sangria.webp', 'Drink', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(17, 'e3541add-a383-11ef-a437-0242ac140002', 'Cerveza Artesanal', 'Cerveza_Artesanal_847397', 'Cerveza española elaborada artesanalmente.', 5.00, 'Gluten, Sulfitos', 100, '/src/assets/products/spain/CervezaArtesanal.webp', 'Drink', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(18, 'e3541b09-a383-11ef-a437-0242ac140002', 'Tinto de Verano', 'Tinto_de_Verano_489230', 'Bebida refrescante de vino tinto con gaseosa.', 6.00, 'Sulfitos', 40, '/src/assets/products/spain/TintoDeVerano.webp', 'Drink', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(19, 'e3541b74-a383-11ef-a437-0242ac140002', 'Sidra', 'Sidra_597649', 'Sidra asturiana de manzana.', 3.50, NULL, 200, '/src/assets/products/spain/Sidra.webp', 'Drink', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(20, 'e3541bb1-a383-11ef-a437-0242ac140002', 'Cava', 'Cava_628159', 'Vino espumoso catalán ideal para celebraciones.', 10.00, 'Sulfitos', 20, '/src/assets/products/spain/Cava.webp', 'Drink', 'España', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(21, '149c39a0-a396-11ef-a437-0242ac140002', 'Edamame', 'Edamame_291334', 'Judías de soja al vapor con sal marina.', 4.50, 'Soja', 100, '/src/assets/products/japan/Edamame.webp', 'Starter', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(22, '149c3e1c-a396-11ef-a437-0242ac140002', 'Gyozas', 'Gyozas_191918', 'Empanadillas japonesas rellenas de carne y verduras.', 6.50, 'Gluten', 80, '/src/assets/products/japan/Gyozas.webp', 'Starter', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(23, '149c3ea5-a396-11ef-a437-0242ac140002', 'Sunomono', 'Sunomono_527815', 'Ensalada japonesa de pepino con vinagre de arroz.', 5.00, NULL, 70, '/src/assets/products/japan/Sunomono.webp', 'Starter', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(24, '149c3eef-a396-11ef-a437-0242ac140002', 'Takoyaki', 'Takoyaki_522903', 'Bolas de masa rellenas de pulpo, con salsa takoyaki y copos de bonito.', 7.00, 'Gluten, Mariscos', 50, '/src/assets/products/japan/Takoyaki.webp', 'Starter', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(25, '149c3f49-a396-11ef-a437-0242ac140002', 'Agedashi Tofu', 'Agedashi_Tofu_640037', 'Tofu frito servido con caldo dashi.', 6.00, 'Soja, Gluten', 60, '/src/assets/products/japan/AgedashiTofu.webp', 'Starter', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(26, '149c3f8c-a396-11ef-a437-0242ac140002', 'Sushi Variado', 'Sushi_Variado_881366', 'Selección de nigiri, maki y sashimi fresco.', 18.00, 'Pescado, Soja, Gluten', 30, '/src/assets/products/japan/SushiVariado.webp', 'Main Course', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(27, '149c4033-a396-11ef-a437-0242ac140002', 'Ramen', 'Ramen_117235', 'Sopa de fideos con caldo de cerdo, huevo y cebolleta.', 12.00, 'Gluten, Huevo', 40, '/src/assets/products/japan/Ramen.webp', 'Main Course', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(28, '149c4074-a396-11ef-a437-0242ac140002', 'Katsu Curry', 'Katsu_Curry_198201', 'Cerdo empanado servido con curry japonés y arroz.', 14.00, 'Gluten', 30, '/src/assets/products/japan/KatsuCurry.webp', 'Main Course', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(29, '149c40aa-a396-11ef-a437-0242ac140002', 'Okonomiyaki', 'Okonomiyaki_085069', 'Tortilla japonesa con col, carne y salsa okonomiyaki.', 10.00, 'Gluten, Huevo', 50, '/src/assets/products/japan/Okonomiyaki.webp', 'Main Course', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(30, '149c40db-a396-11ef-a437-0242ac140002', 'Unagi Don', 'Unagi_Don_859285', 'Anguila a la parrilla servida sobre arroz.', 16.00, 'Pescado, Soja', 25, '/src/assets/products/japan/UnagiDon.webp', 'Main Course', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(31, '149c410c-a396-11ef-a437-0242ac140002', 'Mochi', 'Mochi_644538', 'Dulces de arroz glutinoso rellenos de helado.', 5.00, 'Soja', 70, '/src/assets/products/japan/Mochi.webp', 'Dessert', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(32, '149c4144-a396-11ef-a437-0242ac140002', 'Dorayaki', 'Dorayaki_491684', 'Tortitas rellenas de crema de judía roja.', 4.50, 'Gluten', 80, '/src/assets/products/japan/Dorayaki.webp', 'Dessert', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(33, '149c4176-a396-11ef-a437-0242ac140002', 'Matcha Ice Cream', 'Matcha_Ice_Cream_675058', 'Helado de té verde matcha.', 6.00, 'Lactosa', 50, '/src/assets/products/japan/MatchaIceCream.webp', 'Dessert', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(34, '149c41af-a396-11ef-a437-0242ac140002', 'Anmitsu', 'Anmitsu_596536', 'Postre de gelatina agar con frutas y jarabe dulce.', 7.00, NULL, 40, '/src/assets/products/japan/Anmitsu.webp', 'Dessert', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(35, '149c41e4-a396-11ef-a437-0242ac140002', 'Taiyaki', 'Taiyaki_122373', 'Pastel en forma de pez relleno de crema de judía roja.', 5.50, 'Gluten', 60, '/src/assets/products/japan/Taiyaki.webp', 'Dessert', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(36, '149c4219-a396-11ef-a437-0242ac140002', 'Sake', 'Sake_339717', 'Bebida alcohólica tradicional de arroz fermentado.', 10.00, NULL, 30, '/src/assets/products/japan/Sake.webp', 'Drink', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(37, '149c4275-a396-11ef-a437-0242ac140002', 'Té Verde', 'Té_Verde_080732', 'Infusión tradicional japonesa, servida caliente.', 3.50, NULL, 100, '/src/assets/products/japan/TeVerde.webp', 'Drink', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(38, '149c42e5-a396-11ef-a437-0242ac140002', 'Ramune', 'Ramune_819440', 'Refresco japonés con un toque dulce y burbujeante.', 4.00, NULL, 80, '/src/assets/products/japan/Ramune.webp', 'Drink', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(39, '149c4352-a396-11ef-a437-0242ac140002', 'Shochu', 'Shochu_533163', 'Bebida alcohólica destilada, típica en Japón.', 8.00, NULL, 20, '/src/assets/products/japan/Shochu.webp', 'Drink', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(40, '149c438e-a396-11ef-a437-0242ac140002', 'Umeshu', 'Umeshu_612413', 'Licor dulce japonés elaborado con ciruelas.', 9.00, NULL, 25, '/src/assets/products/japan/Umeshu.webp', 'Drink', 'Japón', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(41, '240f80df-a396-11ef-a437-0242ac140002', 'Guacamole con Totopos', 'Guacamole_con_Totopos_521933', 'Crema de aguacate servida con totopos crujientes.', 5.50, NULL, 100, '/src/assets/products/mexico/GuacamoleConTotopos.webp', 'Starter', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(42, '240f841a-a396-11ef-a437-0242ac140002', 'Sopes', 'Sopes_916282', 'Pequeñas bases de maíz con frijoles, carne y queso.', 6.00, 'Gluten, Lactosa', 80, '/src/assets/products/mexico/Sopes.webp', 'Starter', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(43, '240f84a4-a396-11ef-a437-0242ac140002', 'Tostadas de Tinga', 'Tostadas_de_Tinga_624830', 'Tostadas de maíz cubiertas con tinga de pollo.', 7.00, 'Gluten', 70, '/src/assets/products/mexico/TostadasDeTinga.webp', 'Starter', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(44, '240f84f1-a396-11ef-a437-0242ac140002', 'Quesadillas', 'Quesadillas_015572', 'Tortillas de maíz rellenas de queso derretido.', 5.00, 'Lactosa, Gluten', 90, '/src/assets/products/mexico/Quesadillas.webp', 'Starter', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(45, '240f8598-a396-11ef-a437-0242ac140002', 'Ceviche Mexicano', 'Ceviche_Mexicano_207682', 'Mariscos frescos marinados con limón, tomate y cilantro.', 8.00, 'Mariscos', 50, '/src/assets/products/mexico/CevicheMexicano.webp', 'Starter', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(46, '240f85e2-a396-11ef-a437-0242ac140002', 'Tacos al Pastor', 'Tacos_al_Pastor_509978', 'Tacos de cerdo adobado servidos con piña y cilantro.', 10.00, 'Gluten', 100, '/src/assets/products/mexico/TacosAlPastor.webp', 'Main Course', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(47, '240f8621-a396-11ef-a437-0242ac140002', 'Enchiladas Verdes', 'Enchiladas_Verdes_674418', 'Tortillas rellenas de pollo bañadas en salsa verde.', 11.50, 'Gluten, Lactosa', 80, '/src/assets/products/mexico/EnchiladasVerdes.webp', 'Main Course', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(48, '240f865e-a396-11ef-a437-0242ac140002', 'Pozole Rojo', 'Pozole_Rojo_428890', 'Sopa tradicional con maíz, carne de cerdo y chile.', 12.00, NULL, 60, '/src/assets/products/mexico/PozoleRojo.webp', 'Main Course', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(49, '240f86fa-a396-11ef-a437-0242ac140002', 'Chiles en Nogada', 'Chiles_en_Nogada_372947', 'Pimientos rellenos de carne y frutas, cubiertos con salsa de nuez.', 14.00, 'Frutos Secos, Lactosa', 40, '/src/assets/products/mexico/ChilesEnNogada.webp', 'Main Course', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(50, '240fde8a-a396-11ef-a437-0242ac140002', 'Mole Poblano', 'Mole_Poblano_182690', 'Pollo cubierto con mole de chiles, especias y chocolate.', 13.50, 'Frutos Secos', 50, '/src/assets/products/mexico/MolePoblano.webp', 'Main Course', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(51, '240fdeef-a396-11ef-a437-0242ac140002', 'Flan Napolitano', 'Flan_Napolitano_116927', 'Postre cremoso de leche, huevos y caramelo.', 4.50, 'Lactosa, Huevo', 80, '/src/assets/products/mexico/FlanNapolitano.webp', 'Dessert', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(52, '240fdf34-a396-11ef-a437-0242ac140002', 'Arroz con Leche', 'Arroz_con_Leche_203478', 'Arroz cocido en leche con canela y azúcar.', 4.00, 'Lactosa', 100, '/src/assets/products/mexico/ArrozConLeche.webp', 'Dessert', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(53, '240fdfcd-a396-11ef-a437-0242ac140002', 'Buñuelos', 'Buñuelos_890233', 'Postres fritos espolvoreados con azúcar y canela.', 3.50, 'Gluten', 90, '/src/assets/products/mexico/Bunuelos.webp', 'Dessert', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(54, '240fe00b-a396-11ef-a437-0242ac140002', 'Tres Leches', 'Tres_Leches_177952', 'Bizcocho empapado en tres tipos de leche.', 5.00, 'Lactosa, Gluten', 70, '/src/assets/products/mexico/TresLeches.webp', 'Dessert', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(55, '240fe042-a396-11ef-a437-0242ac140002', 'Capirotada', 'Capirotada_612493', 'Postre tradicional de pan, miel, frutas y queso.', 4.50, 'Lactosa, Gluten', 50, '/src/assets/products/mexico/Capirotada.webp', 'Dessert', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(56, '240fe07b-a396-11ef-a437-0242ac140002', 'Agua de Horchata', 'Agua_de_Horchata_417680', 'Bebida dulce hecha de arroz, leche y canela.', 3.00, 'Lactosa', 100, '/src/assets/products/mexico/AguaDeHorchata.webp', 'Drink', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(57, '240fe0b1-a396-11ef-a437-0242ac140002', 'Margarita', 'Margarita_832109', 'Cóctel clásico de tequila, lima y sal.', 8.00, NULL, 50, '/src/assets/products/mexico/Margarita.webp', 'Drink', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(58, '240fe0e8-a396-11ef-a437-0242ac140002', 'Tequila', 'Tequila_728963', 'Licor tradicional destilado de agave.', 10.00, NULL, 60, '/src/assets/products/mexico/Tequila.webp', 'Drink', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(59, '240fe120-a396-11ef-a437-0242ac140002', 'Michelada', 'Michelada_934620', 'Cerveza preparada con limón, salsas y especias.', 6.50, 'Gluten', 70, '/src/assets/products/mexico/Michelada.webp', 'Drink', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(60, '240fe15e-a396-11ef-a437-0242ac140002', 'Champurrado', 'Champurrado_654871', 'Bebida caliente de chocolate y masa de maíz.', 4.50, 'Lactosa', 80, '/src/assets/products/mexico/Champurrado.webp', 'Drink', 'México', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(61, '38d20a17-a396-11ef-a437-0242ac140002', 'Bruschetta', 'Bruschetta_149683', 'Rebanadas de pan tostado con tomate, albahaca y aceite de oliva.', 4.50, 'Gluten', 100, '/src/assets/products/italy/Bruschetta.webp', 'Starter', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(62, '38d20e7a-a396-11ef-a437-0242ac140002', 'Carpaccio de Ternera', 'Carpaccio_de_Ternera_861273', 'Láminas finas de ternera cruda con rúcula, parmesano y aceite de oliva.', 7.00, 'Lactosa', 60, '/src/assets/products/italy/CarpaccioDeTernera.webp', 'Starter', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(63, '38d20f24-a396-11ef-a437-0242ac140002', 'Caprese', 'Caprese_502367', 'Ensalada de tomate, mozzarella fresca y albahaca.', 6.00, 'Lactosa', 80, '/src/assets/products/italy/Caprese.webp', 'Starter', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(64, '38d20f71-a396-11ef-a437-0242ac140002', 'Arancini', 'Arancini_490712', 'Bolas de arroz rellenas de queso y fritas.', 5.50, 'Gluten, Lactosa', 70, '/src/assets/products/italy/Arancini.webp', 'Starter', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(65, '38d20fba-a396-11ef-a437-0242ac140002', 'Antipasto', 'Antipasto_194235', 'Selección de embutidos, quesos y aceitunas.', 8.00, 'Lactosa', 50, '/src/assets/products/italy/Antipasto.webp', 'Starter', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(66, '38d20ff8-a396-11ef-a437-0242ac140002', 'Pizza Margherita', 'Pizza_Margherita_745612', 'Pizza clásica con tomate, mozzarella y albahaca.', 10.00, 'Gluten, Lactosa', 100, '/src/assets/products/italy/PizzaMargherita.webp', 'Main Course', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(67, '38d21037-a396-11ef-a437-0242ac140002', 'Spaghetti Carbonara', 'Spaghetti_Carbonara_839410', 'Pasta con salsa de huevo, panceta y queso pecorino.', 11.50, 'Gluten, Lactosa', 80, '/src/assets/products/italy/SpaghettiCarbonara.webp', 'Main Course', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(68, '38d21073-a396-11ef-a437-0242ac140002', 'Lasagna', 'Lasagna_638902', 'Capa de pasta, carne y bechamel horneada con queso.', 12.00, 'Gluten, Lactosa', 70, '/src/assets/products/italy/Lasagna.webp', 'Main Course', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(69, '38d210dc-a396-11ef-a437-0242ac140002', 'Risotto de Setas', 'Risotto_de_Setas_019834', 'Arroz cremoso cocinado con setas y parmesano.', 13.00, 'Lactosa', 50, '/src/assets/products/italy/RisottoDeSetas.webp', 'Main Course', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(70, '38d2115b-a396-11ef-a437-0242ac140002', 'Pollo a la Parmesana', 'Pollo_a_la_Parmesana_674523', 'Pechuga de pollo empanada con salsa de tomate y queso.', 14.00, 'Gluten, Lactosa', 40, '/src/assets/products/italy/PolloALaParmesana.webp', 'Main Course', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(71, '38d211e6-a396-11ef-a437-0242ac140002', 'Tiramisú', 'Tiramisú_378924', 'Postre de capas de bizcocho, café y crema de mascarpone.', 5.50, 'Lactosa, Gluten', 70, '/src/assets/products/italy/Tiramisu.webp', 'Dessert', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(72, '38d2135e-a396-11ef-a437-0242ac140002', 'Panna Cotta', 'Panna_Cotta_590834', 'Postre cremoso de nata con coulis de frutas.', 4.50, 'Lactosa', 80, '/src/assets/products/italy/PannaCotta.webp', 'Dessert', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(73, '38d213bd-a396-11ef-a437-0242ac140002', 'Cannoli', 'Cannoli_284762', 'Rollo de masa crujiente relleno de ricotta y fruta confitada.', 5.00, 'Lactosa, Gluten', 60, '/src/assets/products/italy/Cannoli.webp', 'Dessert', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(74, '38d21474-a396-11ef-a437-0242ac140002', 'Gelato de Pistacho', 'Gelato_de_Pistacho_481905', 'Helado artesanal de pistacho.', 6.00, 'Lactosa, Frutos Secos', 50, '/src/assets/products/italy/GelatoDePistacho.webp', 'Dessert', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(75, '38d214b1-a396-11ef-a437-0242ac140002', 'Zabaglione', 'Zabaglione_193847', 'Crema de yema de huevo con vino Marsala.', 5.00, 'Huevo, Alcohol', 40, '/src/assets/products/italy/Zabaglione.webp', 'Dessert', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(76, '38d214ec-a396-11ef-a437-0242ac140002', 'Espresso', 'Espresso_283649', 'Café concentrado italiano.', 2.50, NULL, 100, '/src/assets/products/italy/Espresso.webp', 'Drink', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(77, '38d21530-a396-11ef-a437-0242ac140002', 'Cappuccino', 'Cappuccino_940273', 'Café con leche y espuma de leche.', 3.50, 'Lactosa', 90, '/src/assets/products/italy/Cappuccino.webp', 'Drink', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(78, '38d2156c-a396-11ef-a437-0242ac140002', 'Aperol Spritz', 'Aperol_Spritz_620934', 'Cóctel refrescante de Aperol, prosecco y soda.', 7.00, 'Alcohol', 60, '/src/assets/products/italy/AperolSpritz.webp', 'Drink', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(79, '38d215a0-a396-11ef-a437-0242ac140002', 'Prosecco', 'Prosecco_834720', 'Vino espumoso seco típico italiano.', 9.00, 'Sulfitos', 50, '/src/assets/products/italy/Prosecco.webp', 'Drink', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(80, '38d215d5-a396-11ef-a437-0242ac140002', 'Limoncello', 'Limoncello_479023', 'Licor dulce de limón.', 8.00, 'Alcohol', 40, '/src/assets/products/italy/Limoncello.webp', 'Drink', 'Italia', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(81, '483a138d-a396-11ef-a437-0242ac140002', 'Hummus', 'Hummus_746102', 'Puré de garbanzos con tahini, ajo, y aceite de oliva.', 4.50, 'Sésamo', 100, '/src/assets/products/turkey/Hummus.webp', 'Starter', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(82, '483a1731-a396-11ef-a437-0242ac140002', 'Dolma', 'Dolma_529387', 'Hojas de parra rellenas de arroz y especias.', 5.50, NULL, 80, '/src/assets/products/turkey/Dolma.webp', 'Starter', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(83, '483a17c3-a396-11ef-a437-0242ac140002', 'Ezme', 'Ezme_684930', 'Ensalada picante de tomate, pimiento y especias.', 4.00, NULL, 90, '/src/assets/products/turkey/Ezme.webp', 'Starter', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(84, '483a181d-a396-11ef-a437-0242ac140002', 'Lahmacun', 'Lahmacun_138620', 'Pizza turca con carne picada y especias.', 6.00, 'Gluten', 70, '/src/assets/products/turkey/Lahmacun.webp', 'Starter', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(85, '483a18be-a396-11ef-a437-0242ac140002', 'Sigara Börek', 'Sigara_Börek_843562', 'Rollos fritos de masa rellenos de queso feta.', 5.00, 'Gluten, Lactosa', 100, '/src/assets/products/turkey/SigaraBorek.webp', 'Starter', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(86, '483a85b2-a396-11ef-a437-0242ac140002', 'Kebab de Cordero', 'Kebab_de__Cordero_908412', 'Cordero marinado y asado al estilo tradicional.', 12.50, NULL, 60, '/src/assets/products/turkey/KebabDeCordero.webp', 'Main Course', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(87, '483a8650-a396-11ef-a437-0242ac140002', 'Manti', 'Manti_264953', 'Raviolis turcos rellenos de carne, servidos con yogur y especias.', 11.00, 'Gluten, Lactosa', 70, '/src/assets/products/turkey/Manti.webp', 'Main Course', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(88, '483a86a9-a396-11ef-a437-0242ac140002', 'Pide', 'Pide_742618', 'Barca de pan turco rellena de queso y carne.', 10.00, 'Gluten, Lactosa', 80, '/src/assets/products/turkey/Pide.webp', 'Main Course', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(89, '483a86e9-a396-11ef-a437-0242ac140002', 'Kuru Fasulye', 'Kuru_Fasulye_563901', 'Guiso de alubias blancas con tomate y carne.', 9.50, NULL, 90, '/src/assets/products/turkey/KuruFasulye.webp', 'Main Course', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(90, '483a872d-a396-11ef-a437-0242ac140002', 'Imam Bayildi', 'Imam_Bayildi_380621', 'Berenjenas rellenas de tomate, cebolla y ajo.', 8.50, NULL, 100, '/src/assets/products/turkey/ImamBayildi.webp', 'Main Course', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(91, '483a8766-a396-11ef-a437-0242ac140002', 'Baklava', 'Baklava_764092', 'Capas de masa filo con nueces y miel.', 5.50, 'Frutos Secos, Gluten', 100, '/src/assets/products/turkey/Baklava.webp', 'Dessert', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(92, '483a87ad-a396-11ef-a437-0242ac140002', 'Künefe', 'Künefe_582416', 'Postre caliente de masa filo con queso y almíbar.', 6.00, 'Lactosa, Gluten', 80, '/src/assets/products/turkey/Kunefe.webp', 'Dessert', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(93, '483a87ee-a396-11ef-a437-0242ac140002', 'Lokum', 'Lokum_946283', 'Dulces turcos de gelatina con sabores variados.', 4.50, NULL, 90, '/src/assets/products/turkey/Lokum.webp', 'Dessert', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(94, '483a88a8-a396-11ef-a437-0242ac140002', 'Sütlaç', 'Sütlaç_105372', 'Arroz con leche al estilo turco, con canela.', 4.00, 'Lactosa', 70, '/src/assets/products/turkey/Sutlac.webp', 'Dessert', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(95, '483a88ec-a396-11ef-a437-0242ac140002', 'Revani', 'Revani_498307', 'Bizcocho de sémola bañado en almíbar.', 4.50, 'Gluten', 90, '/src/assets/products/turkey/Revani.webp', 'Dessert', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(96, '483a8920-a396-11ef-a437-0242ac140002', 'Ayran', 'Ayran_634821', 'Bebida refrescante de yogur, agua y sal.', 3.00, 'Lactosa', 100, '/src/assets/products/turkey/Ayran.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(97, '483a8955-a396-11ef-a437-0242ac140002', 'Té Turco', 'Té_Turco_371820', 'Té negro fuerte, servido en vasos pequeños.', 2.50, NULL, 120, '/src/assets/products/turkey/TeTurco.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(98, '483a8988-a396-11ef-a437-0242ac140002', 'Café Turco', 'Café_Turco_285940', 'Café preparado al estilo tradicional con posos.', 3.50, NULL, 100, '/src/assets/products/turkey/CafeTurco.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(99, '483a89bf-a396-11ef-a437-0242ac140002', 'Raki', 'Raki_419075', 'Bebida alcohólica anisada, típica de Turquía.', 7.00, 'Alcohol', 50, '/src/assets/products/turkey/Raki.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(100, '483a89f4-a396-11ef-a437-0242ac140002', 'Salgam', 'Salgam_983201', 'Bebida de nabo fermentado, ligeramente ácida.', 3.50, NULL, 70, '/src/assets/products/turkey/Salgam.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(101, '63e1eca9-a396-11ef-a437-0242ac140002', 'Samosas', 'Samosas_482901', 'Empanadillas fritas rellenas de patata, guisantes y especias.', 4.50, 'Gluten', 100, '/src/assets/products/india/Samosas.webp', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(102, '63e1f01c-a396-11ef-a437-0242ac140002', 'Pakoras', 'Pakoras_620938', 'Verduras rebozadas y fritas en harina de garbanzo.', 5.00, 'Gluten', 80, '/src/assets/products/india/Pakoras.webp', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(103, '63e1f099-a396-11ef-a437-0242ac140002', 'Pani Puri', 'Pani_Puri_839274', 'Bolitas crujientes rellenas de agua especiada y chutneys.', 6.00, 'Gluten', 70, '/src/assets/products/india/PaniPuri.webp', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(104, '63e1f0e4-a396-11ef-a437-0242ac140002', 'Aloo Tikki', 'Aloo_Tikki_920374', 'Croquetas de patata especiadas.', 4.00, NULL, 90, '/src/assets/products/india/AlooTikki.webp', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(105, '63e1f133-a396-11ef-a437-0242ac140002', 'Dhokla', 'Dhokla_293847', 'Pastelito salado hecho con harina de garbanzo.', 5.50, NULL, 70, '/src/assets/products/india/Dhokla.webp', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(106, '63e1f175-a396-11ef-a437-0242ac140002', 'Pollo Tikka Masala', 'Pollo_Tikka_Masala_574829', 'Pollo cocinado en una cremosa salsa de tomate y especias.', 12.00, 'Lactosa', 80, '/src/assets/products/india/PolloTikkaMasala.webp', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(107, '63e1f1b9-a396-11ef-a437-0242ac140002', 'Biryani', 'Biryani_621948', 'Arroz especiado con cordero, pollo o vegetales.', 11.50, 'Frutos Secos', 60, '/src/assets/products/india/Biryani.webp', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(108, '63e1f1f9-a396-11ef-a437-0242ac140002', 'Paneer Butter Masala', 'Paneer_Butter_Masala_748930', 'Queso fresco cocinado en una salsa de tomate y mantequilla.', 10.00, 'Lactosa', 70, '/src/assets/products/india/PaneerButterMasala.webp', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(109, '63e1f233-a396-11ef-a437-0242ac140002', 'Chana Masala', 'Chana_Masala_284760', 'Curry de garbanzos cocinado con cebolla y especias.', 9.50, NULL, 90, '/src/assets/products/india/ChanaMasala.webp', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(110, '63e1f26f-a396-11ef-a437-0242ac140002', 'Rogan Josh', 'Rogan_Josh_934812', 'Curry de cordero con yogur y especias.', 13.00, 'Lactosa', 50, '/src/assets/products/india/RoganJosh.webp', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(111, '63e1f2cd-a396-11ef-a437-0242ac140002', 'Gulab Jamun', 'Gulab_Jamun_452367', 'Bolas de masa fritas empapadas en almíbar.', 4.50, 'Lactosa', 80, '/src/assets/products/india/GulabJamun.webp', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(112, '63e1f30b-a396-11ef-a437-0242ac140002', 'Rasgulla', 'Rasgulla_291830', 'Bolas de queso en almíbar ligero.', 5.00, 'Lactosa', 70, '/src/assets/products/india/Rasgulla.webp', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(113, '63e1f346-a396-11ef-a437-0242ac140002', 'Kulfi', 'Kulfi_873924', 'Helado tradicional indio de cardamomo y pistacho.', 6.00, 'Lactosa, Frutos Secos', 60, '/src/assets/products/india/Kulfi.webp', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(114, '63e1f38f-a396-11ef-a437-0242ac140002', 'Ladoo', 'Ladoo_483027', 'Dulce hecho de harina de garbanzo, ghee y azúcar.', 4.00, 'Lactosa', 90, '/src/assets/products/india/Ladoo.webp', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(115, '63e1f3c7-a396-11ef-a437-0242ac140002', 'Kheer', 'Kheer_927634', 'Arroz con leche especiado con cardamomo.', 4.50, 'Lactosa', 70, '/src/assets/products/india/Kheer.webp', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(116, '63e1f4f3-a396-11ef-a437-0242ac140002', 'Lassi', 'Lassi_738495', 'Bebida a base de yogur con sabores dulces o salados.', 3.50, 'Lactosa', 100, '/src/assets/products/india/Lassi.webp', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(117, '63e1f541-a396-11ef-a437-0242ac140002', 'Masala Chai', 'Masala_Chai_184920', 'Té negro con especias, leche y azúcar.', 3.00, 'Lactosa', 120, '/src/assets/products/india/MasalaChai.webp', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(118, '63e1f577-a396-11ef-a437-0242ac140002', 'Thandai', 'Thandai_409283', 'Bebida fría hecha con leche, almendras y especias.', 5.00, 'Lactosa, Frutos Secos', 80, '/src/assets/products/india/Thandai.webp', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(119, '63e1f5ab-a396-11ef-a437-0242ac140002', 'Nimbu Pani', 'Nimbu_Pani_738462', 'Limonada especiada con sal negra.', 3.50, NULL, 150, '/src/assets/products/india/NimbuPani.webp', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(120, '63e1f5e3-a396-11ef-a437-0242ac140002', 'Filter Coffee', 'Filter_Coffee_602394', 'Café tradicional del sur de la India.', 4.00, 'Lactosa', 70, '/src/assets/products/india/FilterCoffee.webp', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(121, '6f96d9e8-a396-11ef-a437-0242ac140002', 'Agua Mineral', 'Agua_Mineral_294615', 'Agua embotellada pura y refrescante.', 1.50, NULL, 500, '/src/assets/products/genericas/AguaMineral.webp', 'Drink', 'Japón', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(122, '6f96ddac-a396-11ef-a437-0242ac140002', 'Coca-Cola', 'Coca-Cola_758203', 'Refresco clásico con gas.', 2.00, NULL, 400, '/src/assets/products/genericas/CocaCola.webp', 'Drink', 'Japón', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(123, '6f96de3d-a396-11ef-a437-0242ac140002', 'Fanta Naranja', 'Fanta_Naranja_183592', 'Refresco de naranja con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaNaranja.webp', 'Drink', 'Japón', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(124, '6f96de8b-a396-11ef-a437-0242ac140002', 'Fanta Limón', 'Fanta_Limón_473829', 'Refresco de limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaLimon.webp', 'Drink', 'Japón', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(125, '6f96ded5-a396-11ef-a437-0242ac140002', 'Sprite', 'Sprite_840276', 'Refresco de lima-limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/Sprite.webp', 'Drink', 'Japón', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(126, '6f96df58-a396-11ef-a437-0242ac140002', 'Tónica', 'Tónica_526748', 'Refresco amargo con burbujas, ideal para combinados.', 2.50, NULL, 200, '/src/assets/products/genericas/Tonica.webp', 'Drink', 'Japón', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(127, 'zz96ddac-a396-11ef-a437-0242ac140002', 'Coca-Cola', 'Coca-Cola_758203', 'Refresco clásico con gas.', 2.00, NULL, 400, '/src/assets/products/genericas/CocaCola.webp', 'Drink', 'India', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(128, 'z196de3d-a396-11ef-a437-0242ac140002', 'Fanta Naranja', 'Fanta_Naranja_183592', 'Refresco de naranja con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaNaranja.webp', 'Drink', 'India', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(129, 'z296de8b-a396-11ef-a437-0242ac140002', 'Fanta Limón', 'Fanta_Limón_473829', 'Refresco de limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaLimon.webp', 'Drink', 'India', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(130, 'z396ded5-a396-11ef-a437-0242ac140002', 'Sprite', 'Sprite_840276', 'Refresco de lima-limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/Sprite.webp', 'Drink', 'India', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(131, 'z496df58-a396-11ef-a437-0242ac140002', 'Tónica', 'Tónica_526748', 'Refresco amargo con burbujas, ideal para combinados.', 2.50, NULL, 200, '/src/assets/products/genericas/Tonica.webp', 'Drink', 'India', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(132, 'z596ddac-a396-11ef-a437-0242ac140002', 'Coca-Cola', 'Coca-Cola_758203', 'Refresco clásico con gas.', 2.00, NULL, 400, '/src/assets/products/genericas/CocaCola.webp', 'Drink', 'España', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(133, 'z696de3d-a396-11ef-a437-0242ac140002', 'Fanta Naranja', 'Fanta_Naranja_183592', 'Refresco de naranja con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaNaranja.webp', 'Drink', 'España', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(134, 'z796de8b-a396-11ef-a437-0242ac140002', 'Fanta Limón', 'Fanta_Limón_473829', 'Refresco de limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaLimon.webp', 'Drink', 'España', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(135, 'z896ded5-a396-11ef-a437-0242ac140002', 'Sprite', 'Sprite_840276', 'Refresco de lima-limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/Sprite.webp', 'Drink', 'España', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(136, 'z996df58-a396-11ef-a437-0242ac140002', 'Tónica', 'Tónica_526748', 'Refresco amargo con burbujas, ideal para combinados.', 2.50, NULL, 200, '/src/assets/products/genericas/Tonica.webp', 'Drink', 'España', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(137, 'xx96ddac-a396-11ef-a437-0242ac140002', 'Coca-Cola', 'Coca-Cola_758203', 'Refresco clásico con gas.', 2.00, NULL, 400, '/src/assets/products/genericas/CocaCola.webp', 'Drink', 'Italia', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(138, 'x196de3d-a396-11ef-a437-0242ac140002', 'Fanta Naranja', 'Fanta_Naranja_183592', 'Refresco de naranja con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaNaranja.webp', 'Drink', 'Italia', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(139, 'x296de8b-a396-11ef-a437-0242ac140002', 'Fanta Limón', 'Fanta_Limón_473829', 'Refresco de limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaLimon.webp', 'Drink', 'Italia', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(140, 'x396ded5-a396-11ef-a437-0242ac140002', 'Sprite', 'Sprite_840276', 'Refresco de lima-limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/Sprite.webp', 'Drink', 'Italia', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(141, 'x496df58-a396-11ef-a437-0242ac140002', 'Tónica', 'Tónica_526748', 'Refresco amargo con burbujas, ideal para combinados.', 2.50, NULL, 200, '/src/assets/products/genericas/Tonica.webp', 'Drink', 'Italia', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(142, 'x596ddac-a396-11ef-a437-0242ac140002', 'Coca-Cola', 'Coca-Cola_758203', 'Refresco clásico con gas.', 2.00, NULL, 400, '/src/assets/products/genericas/CocaCola.webp', 'Drink', 'México', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(143, 'x696de3d-a396-11ef-a437-0242ac140002', 'Fanta Naranja', 'Fanta_Naranja_183592', 'Refresco de naranja con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaNaranja.webp', 'Drink', 'México', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(144, 'x796de8b-a396-11ef-a437-0242ac140002', 'Fanta Limón', 'Fanta_Limón_473829', 'Refresco de limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaLimon.webp', 'Drink', 'México', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(145, 'x896ded5-a396-11ef-a437-0242ac140002', 'Sprite', 'Sprite_840276', 'Refresco de lima-limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/Sprite.webp', 'Drink', 'México', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(146, 'x996df58-a396-11ef-a437-0242ac140002', 'Tónica', 'Tónica_526748', 'Refresco amargo con burbujas, ideal para combinados.', 2.50, NULL, 200, '/src/assets/products/genericas/Tonica.webp', 'Drink', 'México', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(147, 'cc96ddac-a396-11ef-a437-0242ac140002', 'Coca-Cola', 'Coca-Cola_758203', 'Refresco clásico con gas.', 2.00, NULL, 400, '/src/assets/products/genericas/CocaCola.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(148, 'c196de3d-a396-11ef-a437-0242ac140002', 'Fanta Naranja', 'Fanta_Naranja_183592', 'Refresco de naranja con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaNaranja.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(149, 'c296de8b-a396-11ef-a437-0242ac140002', 'Fanta Limón', 'Fanta_Limón_473829', 'Refresco de limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/FantaLimon.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(150, 'c396ded5-a396-11ef-a437-0242ac140002', 'Sprite', 'Sprite_840276', 'Refresco de lima-limón con gas.', 2.00, NULL, 300, '/src/assets/products/genericas/Sprite.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(151, 'c496df58-a396-11ef-a437-0242ac140002', 'Tónica', 'Tónica_526748', 'Refresco amargo con burbujas, ideal para combinados.', 2.50, NULL, 200, '/src/assets/products/genericas/Tonica.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(152, 'c593df9c-a396-11ef-a437-0242ac140002', 'Agua con gas', 'Agua_con_gas_912847', 'Agua con gas refrescante sacada directamene del Monte Fuji.', 2.50, NULL, 300, '/src/assets/products/genericas/AguaConGas.webp', 'Drink', 'Japón', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(153, '6f96df9c-a396-11ef-a437-0242ac140002', 'Batido de chocolate', 'Batido_de_chocolate_912847', 'Bebida de chocolate con una cobertura de nata y virutas de chocolate, cacao de origen turco.', 2.50, NULL, 300, '/src/assets/products/genericas/BatidoDeChocolate.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(154, '6f96dfdc-a396-11ef-a437-0242ac140002', 'Jugo de manzana', 'Jugo_de_manzana_473502', 'Jugo de Manzana natural de los mejores manzanos mediterraneos italianos.', 2.50, NULL, 300, '/src/assets/products/genericas/JugoDeManzana.webp', 'Drink', 'Italia', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(155, '6f96e018-a396-11ef-a437-0242ac140002', 'Jugo de naranja', 'Jugo_de_naranja_847260', 'Jugo de naranja natural exprimido con auténticas narajas de Valencia.', 3.00, NULL, 200, '/src/assets/products/genericas/JugoDeNaranja.webp', 'Drink', 'España', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(156, 'c696d9e8-a396-11ef-a437-0242ac140002', 'Agua Mineral', 'Agua_Mineral_294615', 'Agua embotellada pura y refrescante.', 1.50, NULL, 500, '/src/assets/products/genericas/AguaMineral.webp', 'Drink', 'Italia', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(157, 'c796d9e8-a396-11ef-a437-0242ac140002', 'Agua Mineral', 'Agua_Mineral_294615', 'Agua embotellada pura y refrescante.', 1.50, NULL, 500, '/src/assets/products/genericas/AguaMineral.webp', 'Drink', 'España', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(158, 'c896d9e8-a396-11ef-a437-0242ac140002', 'Agua Mineral', 'Agua_Mineral_294615', 'Agua embotellada pura y refrescante.', 1.50, NULL, 500, '/src/assets/products/genericas/AguaMineral.webp', 'Drink', 'Turquía', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(159, 'c996d9e8-a396-11ef-a437-0242ac140002', 'Agua Mineral', 'Agua_Mineral_294615', 'Agua embotellada pura y refrescante.', 1.50, NULL, 500, '/src/assets/products/genericas/AguaMineral.webp', 'Drink', 'India', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(160, 'vv96d9e8-a396-11ef-a437-0242ac140002', 'Agua Mineral', 'Agua_Mineral_294615', 'Agua embotellada pura y refrescante.', 1.50, NULL, 500, '/src/assets/products/genericas/AguaMineral.webp', 'Drink', 'México', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `QR`
--

CREATE TABLE `QR` (
  `id` bigint NOT NULL,
  `booking_id` int NOT NULL,
  `url` varchar(500) NOT NULL,
  `status` enum('Generated','Printed','In_progress','Expired') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `QR`
--

INSERT INTO `QR` (`id`, `booking_id`, `url`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'http://localhost:8090/spring/api/qr/validate?data=iUEJUNjwupNpvVpXeOjIh%2BR8rDDG8AASs0v98kVC5zdaylyHR53V9%2BouYoK6VnVFXFC1jYcAvkKXpENHn9uN6%2BrWTsDREw7VARgUzvbgqd%2FI7EZWHUkh20SMMU%2Fjqi%2BdJROBsjuWA7cME%2BwNJJQSrhmvVNdWrm4tMpk9ymT1QQF89o0BNkmt4d3%2BEPCtBZ5GDH7NSkRCfBGC90rmZbgbmFYX64CJEDj%2Fqwp4XLlG6gNQP6zgvyYoAOMVU3JriCNdVp5reBqZ58ZVsMVd3N9ZwdwBF7%2Fg2NJt4jhJJfJKUL8zXCGzciucwCtorxsoqebL', 'Generated', '2024-12-24 01:20:56', '2024-12-24 01:20:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Room`
--

CREATE TABLE `Room` (
  `room_id` int NOT NULL,
  `room_uuid` char(36) NOT NULL,
  `room_name` varchar(100) NOT NULL,
  `room_slug` varchar(100) NOT NULL,
  `description` text,
  `theme` varchar(100) NOT NULL,
  `max_capacity` int NOT NULL,
  `total_bookings` int DEFAULT '0',
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `image_url` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ngo_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Room`
--

INSERT INTO `Room` (`room_id`, `room_uuid`, `room_name`, `room_slug`, `description`, `theme`, `max_capacity`, `total_bookings`, `average_rating`, `image_url`, `is_active`, `created_at`, `updated_at`, `ngo_id`) VALUES
(1, '0abbb126-a39b-11ef-a437-0242ac140002', 'Jardín de los Cerezos', 'Jardin_de_los_Cerezos_781230', 'Una sala inspirada en los paisajes japoneses, con decoración de cerezos en flor y detalles tradicionales.', 'Japón', 30, 0, 0.00, '/src/assets/rooms/japan.webp', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 1),
(2, '0abbbfde-a39b-11ef-a437-0242ac140002', 'Palacio de los Maharajás', 'Palacio_de_los_Maharajas_871237', 'Una sala con elementos decorativos indios, desde alfombras hasta lámparas tradicionales.', 'India', 30, 0, 0.00, '/src/assets/rooms/india.webp', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 2),
(3, '0abbc1b6-a39b-11ef-a437-0242ac140002', 'Taberna Española', 'Taberna_Espanola_612342', 'Un espacio acogedor con motivos tradicionales españoles, como azulejos y jamones colgados.', 'España', 30, 0, 0.00, '/src/assets/rooms/spain.webp', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 3),
(4, '0abbc27b-a39b-11ef-a437-0242ac140002', 'Villa Toscana', 'Villa_Toscana_891243', 'Sala que evoca la tranquilidad y belleza de los viñedos italianos, con una decoración elegante.', 'Italia', 30, 0, 0.00, '/src/assets/rooms/italy.webp', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 4),
(5, '0abbc32a-a39b-11ef-a437-0242ac140002', 'Hacienda Mexicana', 'Hacienda_Mexicana_612384', 'Sala inspirada en las haciendas tradicionales mexicanas, con colores vivos y detalles coloniales.', 'México', 30, 0, 0.00, '/src/assets/rooms/mexico.webp', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 5),
(6, '0abbc48f-a39b-11ef-a437-0242ac140002', 'Salón del Bósforo', 'Salon_del_Bosforo_781234', 'Sala con decoración otomana y vistas simuladas del estrecho del Bósforo.', 'Turquía', 30, 0, 0.00, '/src/assets/rooms/turkey.webp', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Room_Shift`
--

CREATE TABLE `Room_Shift` (
  `room_shift_id` int NOT NULL,
  `room_shift_uuid` char(36) NOT NULL,
  `room_id` int NOT NULL,
  `shift_id` int NOT NULL,
  `reserved_capacity` int DEFAULT '0',
  `total_revenue` decimal(10,2) DEFAULT '0.00',
  `status` enum('Active','Closed','Pending') NOT NULL DEFAULT 'Pending',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Room_Shift`
--

INSERT INTO `Room_Shift` (`room_shift_id`, `room_shift_uuid`, `room_id`, `shift_id`, `reserved_capacity`, `total_revenue`, `status`, `is_active`, `created_at`, `updated_at`) VALUES
(1, '3ba12f5d-b7f1-11ef-9c5f-0242ac120004', 1, 1, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(2, '3ba13024-b7f1-11ef-9c5f-0242ac120004', 1, 2, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(3, '3ba1307e-b7f1-11ef-9c5f-0242ac120004', 1, 3, 3, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-24 01:20:56'),
(4, '3ba130a1-b7f1-11ef-9c5f-0242ac120004', 1, 4, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(5, '3ba130b6-b7f1-11ef-9c5f-0242ac120004', 1, 5, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(6, '3ba130cb-b7f1-11ef-9c5f-0242ac120004', 1, 6, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(7, '3ba130e1-b7f1-11ef-9c5f-0242ac120004', 1, 7, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(8, '3ba130f6-b7f1-11ef-9c5f-0242ac120004', 1, 8, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(9, '3ba1310b-b7f1-11ef-9c5f-0242ac120004', 1, 9, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(10, '3ba1311e-b7f1-11ef-9c5f-0242ac120004', 1, 10, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(11, '3ba13132-b7f1-11ef-9c5f-0242ac120004', 1, 11, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(12, '3ba13159-b7f1-11ef-9c5f-0242ac120004', 1, 12, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(13, '3ba1316d-b7f1-11ef-9c5f-0242ac120004', 1, 13, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(14, '3ba13181-b7f1-11ef-9c5f-0242ac120004', 1, 14, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(15, '3ba13196-b7f1-11ef-9c5f-0242ac120004', 1, 15, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(16, '3ba131ac-b7f1-11ef-9c5f-0242ac120004', 1, 16, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(17, '3ba131c4-b7f1-11ef-9c5f-0242ac120004', 1, 17, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(18, '3ba131db-b7f1-11ef-9c5f-0242ac120004', 1, 18, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(19, '3ba131ef-b7f1-11ef-9c5f-0242ac120004', 1, 19, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(20, '3ba13204-b7f1-11ef-9c5f-0242ac120004', 1, 20, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(21, '3ba13218-b7f1-11ef-9c5f-0242ac120004', 1, 21, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(22, '3ba1322c-b7f1-11ef-9c5f-0242ac120004', 1, 22, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(23, '3ba13240-b7f1-11ef-9c5f-0242ac120004', 1, 23, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(24, '3ba13254-b7f1-11ef-9c5f-0242ac120004', 1, 24, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(25, '3ba13267-b7f1-11ef-9c5f-0242ac120004', 1, 25, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(26, '3ba1327a-b7f1-11ef-9c5f-0242ac120004', 1, 26, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(27, '3ba1328e-b7f1-11ef-9c5f-0242ac120004', 1, 27, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(28, '3ba132a1-b7f1-11ef-9c5f-0242ac120004', 1, 28, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(29, '3ba132b8-b7f1-11ef-9c5f-0242ac120004', 1, 29, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(30, '3ba132d4-b7f1-11ef-9c5f-0242ac120004', 1, 30, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(31, '3ba132ed-b7f1-11ef-9c5f-0242ac120004', 1, 31, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(32, '3ba13303-b7f1-11ef-9c5f-0242ac120004', 1, 32, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(33, '3ba13316-b7f1-11ef-9c5f-0242ac120004', 1, 33, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(34, '3ba1332a-b7f1-11ef-9c5f-0242ac120004', 1, 34, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(35, '3ba1333e-b7f1-11ef-9c5f-0242ac120004', 1, 35, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(36, '3ba13351-b7f1-11ef-9c5f-0242ac120004', 1, 36, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(37, '3ba13365-b7f1-11ef-9c5f-0242ac120004', 1, 37, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(38, '3ba13378-b7f1-11ef-9c5f-0242ac120004', 1, 38, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(39, '3ba1338c-b7f1-11ef-9c5f-0242ac120004', 1, 39, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(40, '3ba133a0-b7f1-11ef-9c5f-0242ac120004', 1, 40, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(41, '3ba133b3-b7f1-11ef-9c5f-0242ac120004', 1, 41, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(42, '3ba133c6-b7f1-11ef-9c5f-0242ac120004', 1, 42, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(43, '3ba133d9-b7f1-11ef-9c5f-0242ac120004', 1, 43, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(44, '3ba133ed-b7f1-11ef-9c5f-0242ac120004', 1, 44, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(45, '3ba13400-b7f1-11ef-9c5f-0242ac120004', 1, 45, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(46, '3ba13413-b7f1-11ef-9c5f-0242ac120004', 1, 46, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(47, '3ba13426-b7f1-11ef-9c5f-0242ac120004', 1, 47, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(48, '3ba13439-b7f1-11ef-9c5f-0242ac120004', 1, 48, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(49, '3ba1344b-b7f1-11ef-9c5f-0242ac120004', 1, 49, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(50, '3ba1345e-b7f1-11ef-9c5f-0242ac120004', 1, 50, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(51, '3ba13471-b7f1-11ef-9c5f-0242ac120004', 1, 51, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(52, '3ba13484-b7f1-11ef-9c5f-0242ac120004', 1, 52, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(53, '3ba13497-b7f1-11ef-9c5f-0242ac120004', 1, 53, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(54, '3ba134aa-b7f1-11ef-9c5f-0242ac120004', 1, 54, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(55, '3ba134bd-b7f1-11ef-9c5f-0242ac120004', 1, 55, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(56, '3ba134d0-b7f1-11ef-9c5f-0242ac120004', 1, 56, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(57, '3ba134e3-b7f1-11ef-9c5f-0242ac120004', 1, 57, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(58, '3ba134f9-b7f1-11ef-9c5f-0242ac120004', 1, 58, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(59, '3ba1350b-b7f1-11ef-9c5f-0242ac120004', 1, 59, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(60, '3ba1351e-b7f1-11ef-9c5f-0242ac120004', 1, 60, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(61, '3ba13531-b7f1-11ef-9c5f-0242ac120004', 1, 61, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(62, '3ba13544-b7f1-11ef-9c5f-0242ac120004', 1, 62, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(63, '3ba1600b-b7f1-11ef-9c5f-0242ac120004', 2, 1, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(64, '3ba16076-b7f1-11ef-9c5f-0242ac120004', 2, 2, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(65, '3ba16092-b7f1-11ef-9c5f-0242ac120004', 2, 3, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(66, '3ba160a6-b7f1-11ef-9c5f-0242ac120004', 2, 4, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(67, '3ba160ba-b7f1-11ef-9c5f-0242ac120004', 2, 5, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(68, '3ba160cf-b7f1-11ef-9c5f-0242ac120004', 2, 6, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(69, '3ba160e3-b7f1-11ef-9c5f-0242ac120004', 2, 7, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(70, '3ba160f5-b7f1-11ef-9c5f-0242ac120004', 2, 8, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(71, '3ba16108-b7f1-11ef-9c5f-0242ac120004', 2, 9, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(72, '3ba1611b-b7f1-11ef-9c5f-0242ac120004', 2, 10, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(73, '3ba1612f-b7f1-11ef-9c5f-0242ac120004', 2, 11, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(74, '3ba16141-b7f1-11ef-9c5f-0242ac120004', 2, 12, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(75, '3ba16154-b7f1-11ef-9c5f-0242ac120004', 2, 13, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(76, '3ba16167-b7f1-11ef-9c5f-0242ac120004', 2, 14, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(77, '3ba1617a-b7f1-11ef-9c5f-0242ac120004', 2, 15, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(78, '3ba1618f-b7f1-11ef-9c5f-0242ac120004', 2, 16, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(79, '3ba161a3-b7f1-11ef-9c5f-0242ac120004', 2, 17, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(80, '3ba161b6-b7f1-11ef-9c5f-0242ac120004', 2, 18, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(81, '3ba161c9-b7f1-11ef-9c5f-0242ac120004', 2, 19, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(82, '3ba161db-b7f1-11ef-9c5f-0242ac120004', 2, 20, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(83, '3ba161ee-b7f1-11ef-9c5f-0242ac120004', 2, 21, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(84, '3ba16201-b7f1-11ef-9c5f-0242ac120004', 2, 22, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(85, '3ba16214-b7f1-11ef-9c5f-0242ac120004', 2, 23, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(86, '3ba16226-b7f1-11ef-9c5f-0242ac120004', 2, 24, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(87, '3ba16238-b7f1-11ef-9c5f-0242ac120004', 2, 25, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(88, '3ba1624b-b7f1-11ef-9c5f-0242ac120004', 2, 26, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(89, '3ba1625e-b7f1-11ef-9c5f-0242ac120004', 2, 27, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(90, '3ba16271-b7f1-11ef-9c5f-0242ac120004', 2, 28, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(91, '3ba16283-b7f1-11ef-9c5f-0242ac120004', 2, 29, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(92, '3ba1629c-b7f1-11ef-9c5f-0242ac120004', 2, 30, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(93, '3ba162af-b7f1-11ef-9c5f-0242ac120004', 2, 31, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(94, '3ba162c0-b7f1-11ef-9c5f-0242ac120004', 2, 32, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(95, '3ba162d2-b7f1-11ef-9c5f-0242ac120004', 2, 33, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(96, '3ba162e2-b7f1-11ef-9c5f-0242ac120004', 2, 34, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(97, '3ba162f3-b7f1-11ef-9c5f-0242ac120004', 2, 35, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(98, '3ba16305-b7f1-11ef-9c5f-0242ac120004', 2, 36, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(99, '3ba16316-b7f1-11ef-9c5f-0242ac120004', 2, 37, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(100, '3ba16327-b7f1-11ef-9c5f-0242ac120004', 2, 38, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(101, '3ba16338-b7f1-11ef-9c5f-0242ac120004', 2, 39, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(102, '3ba16349-b7f1-11ef-9c5f-0242ac120004', 2, 40, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(103, '3ba1635a-b7f1-11ef-9c5f-0242ac120004', 2, 41, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(104, '3ba1636b-b7f1-11ef-9c5f-0242ac120004', 2, 42, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(105, '3ba1637d-b7f1-11ef-9c5f-0242ac120004', 2, 43, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(106, '3ba1638e-b7f1-11ef-9c5f-0242ac120004', 2, 44, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(107, '3ba1639f-b7f1-11ef-9c5f-0242ac120004', 2, 45, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(108, '3ba163b0-b7f1-11ef-9c5f-0242ac120004', 2, 46, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(109, '3ba163c1-b7f1-11ef-9c5f-0242ac120004', 2, 47, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(110, '3ba163d2-b7f1-11ef-9c5f-0242ac120004', 2, 48, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(111, '3ba163e3-b7f1-11ef-9c5f-0242ac120004', 2, 49, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(112, '3ba163f4-b7f1-11ef-9c5f-0242ac120004', 2, 50, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(113, '3ba16405-b7f1-11ef-9c5f-0242ac120004', 2, 51, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(114, '3ba16416-b7f1-11ef-9c5f-0242ac120004', 2, 52, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(115, '3ba16427-b7f1-11ef-9c5f-0242ac120004', 2, 53, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(116, '3ba16437-b7f1-11ef-9c5f-0242ac120004', 2, 54, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(117, '3ba16448-b7f1-11ef-9c5f-0242ac120004', 2, 55, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(118, '3ba16459-b7f1-11ef-9c5f-0242ac120004', 2, 56, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(119, '3ba1646a-b7f1-11ef-9c5f-0242ac120004', 2, 57, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(120, '3ba16481-b7f1-11ef-9c5f-0242ac120004', 2, 58, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(121, '3ba16492-b7f1-11ef-9c5f-0242ac120004', 2, 59, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(122, '3ba164a4-b7f1-11ef-9c5f-0242ac120004', 2, 60, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(123, '3ba164b5-b7f1-11ef-9c5f-0242ac120004', 2, 61, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(124, '3ba164c7-b7f1-11ef-9c5f-0242ac120004', 2, 62, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(125, '3ba1a268-b7f1-11ef-9c5f-0242ac120004', 3, 1, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(126, '3ba1a2e4-b7f1-11ef-9c5f-0242ac120004', 3, 2, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(127, '3ba1a304-b7f1-11ef-9c5f-0242ac120004', 3, 3, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(128, '3ba1a31c-b7f1-11ef-9c5f-0242ac120004', 3, 4, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(129, '3ba1a333-b7f1-11ef-9c5f-0242ac120004', 3, 5, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(130, '3ba1a346-b7f1-11ef-9c5f-0242ac120004', 3, 6, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(131, '3ba1a35b-b7f1-11ef-9c5f-0242ac120004', 3, 7, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(132, '3ba1a36e-b7f1-11ef-9c5f-0242ac120004', 3, 8, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(133, '3ba1a3a3-b7f1-11ef-9c5f-0242ac120004', 3, 9, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(134, '3ba1a3b9-b7f1-11ef-9c5f-0242ac120004', 3, 10, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(135, '3ba1a3cd-b7f1-11ef-9c5f-0242ac120004', 3, 11, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(136, '3ba1a3e5-b7f1-11ef-9c5f-0242ac120004', 3, 12, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(137, '3ba1a3f9-b7f1-11ef-9c5f-0242ac120004', 3, 13, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(138, '3ba1a40d-b7f1-11ef-9c5f-0242ac120004', 3, 14, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(139, '3ba1a422-b7f1-11ef-9c5f-0242ac120004', 3, 15, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(140, '3ba1a437-b7f1-11ef-9c5f-0242ac120004', 3, 16, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(141, '3ba1a449-b7f1-11ef-9c5f-0242ac120004', 3, 17, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(142, '3ba1a45c-b7f1-11ef-9c5f-0242ac120004', 3, 18, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(143, '3ba1a46f-b7f1-11ef-9c5f-0242ac120004', 3, 19, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(144, '3ba1a482-b7f1-11ef-9c5f-0242ac120004', 3, 20, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(145, '3ba1a495-b7f1-11ef-9c5f-0242ac120004', 3, 21, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(146, '3ba1a4a7-b7f1-11ef-9c5f-0242ac120004', 3, 22, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(147, '3ba1a4ba-b7f1-11ef-9c5f-0242ac120004', 3, 23, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(148, '3ba1a4cd-b7f1-11ef-9c5f-0242ac120004', 3, 24, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(149, '3ba1a4e1-b7f1-11ef-9c5f-0242ac120004', 3, 25, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(150, '3ba1a4f5-b7f1-11ef-9c5f-0242ac120004', 3, 26, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(151, '3ba1a507-b7f1-11ef-9c5f-0242ac120004', 3, 27, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(152, '3ba1a519-b7f1-11ef-9c5f-0242ac120004', 3, 28, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(153, '3ba1a529-b7f1-11ef-9c5f-0242ac120004', 3, 29, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(154, '3ba1a53c-b7f1-11ef-9c5f-0242ac120004', 3, 30, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(155, '3ba1a54d-b7f1-11ef-9c5f-0242ac120004', 3, 31, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(156, '3ba1a55f-b7f1-11ef-9c5f-0242ac120004', 3, 32, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(157, '3ba1a56f-b7f1-11ef-9c5f-0242ac120004', 3, 33, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(158, '3ba1a581-b7f1-11ef-9c5f-0242ac120004', 3, 34, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(159, '3ba1a592-b7f1-11ef-9c5f-0242ac120004', 3, 35, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(160, '3ba1a5a3-b7f1-11ef-9c5f-0242ac120004', 3, 36, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(161, '3ba1b8c7-b7f1-11ef-9c5f-0242ac120004', 3, 37, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(162, '3ba1b8ee-b7f1-11ef-9c5f-0242ac120004', 3, 38, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(163, '3ba1b903-b7f1-11ef-9c5f-0242ac120004', 3, 39, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(164, '3ba1b917-b7f1-11ef-9c5f-0242ac120004', 3, 40, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(165, '3ba1b92b-b7f1-11ef-9c5f-0242ac120004', 3, 41, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(166, '3ba1b93e-b7f1-11ef-9c5f-0242ac120004', 3, 42, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(167, '3ba1b951-b7f1-11ef-9c5f-0242ac120004', 3, 43, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(168, '3ba1b965-b7f1-11ef-9c5f-0242ac120004', 3, 44, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(169, '3ba1b977-b7f1-11ef-9c5f-0242ac120004', 3, 45, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(170, '3ba1b98b-b7f1-11ef-9c5f-0242ac120004', 3, 46, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(171, '3ba1b99d-b7f1-11ef-9c5f-0242ac120004', 3, 47, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(172, '3ba1b9b0-b7f1-11ef-9c5f-0242ac120004', 3, 48, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(173, '3ba1b9c2-b7f1-11ef-9c5f-0242ac120004', 3, 49, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(174, '3ba1b9d5-b7f1-11ef-9c5f-0242ac120004', 3, 50, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(175, '3ba1b9e9-b7f1-11ef-9c5f-0242ac120004', 3, 51, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(176, '3ba1b9fc-b7f1-11ef-9c5f-0242ac120004', 3, 52, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(177, '3ba1ba0f-b7f1-11ef-9c5f-0242ac120004', 3, 53, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(178, '3ba1ba22-b7f1-11ef-9c5f-0242ac120004', 3, 54, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(179, '3ba1ba35-b7f1-11ef-9c5f-0242ac120004', 3, 55, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(180, '3ba1ba48-b7f1-11ef-9c5f-0242ac120004', 3, 56, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(181, '3ba1ba5a-b7f1-11ef-9c5f-0242ac120004', 3, 57, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(182, '3ba1ba70-b7f1-11ef-9c5f-0242ac120004', 3, 58, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(183, '3ba1ba83-b7f1-11ef-9c5f-0242ac120004', 3, 59, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(184, '3ba1ba96-b7f1-11ef-9c5f-0242ac120004', 3, 60, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(185, '3ba1baaa-b7f1-11ef-9c5f-0242ac120004', 3, 61, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(186, '3ba1babc-b7f1-11ef-9c5f-0242ac120004', 3, 62, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(187, '3ba26de4-b7f1-11ef-9c5f-0242ac120004', 4, 1, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(188, '3ba26e46-b7f1-11ef-9c5f-0242ac120004', 4, 2, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(189, '3ba26e5f-b7f1-11ef-9c5f-0242ac120004', 4, 3, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(190, '3ba26e73-b7f1-11ef-9c5f-0242ac120004', 4, 4, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(191, '3ba26e86-b7f1-11ef-9c5f-0242ac120004', 4, 5, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(192, '3ba26e99-b7f1-11ef-9c5f-0242ac120004', 4, 6, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(193, '3ba26eaf-b7f1-11ef-9c5f-0242ac120004', 4, 7, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(194, '3ba26ec2-b7f1-11ef-9c5f-0242ac120004', 4, 8, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(195, '3ba26ed4-b7f1-11ef-9c5f-0242ac120004', 4, 9, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(196, '3ba26ee7-b7f1-11ef-9c5f-0242ac120004', 4, 10, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(197, '3ba26efa-b7f1-11ef-9c5f-0242ac120004', 4, 11, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(198, '3ba26f0c-b7f1-11ef-9c5f-0242ac120004', 4, 12, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(199, '3ba26f20-b7f1-11ef-9c5f-0242ac120004', 4, 13, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(200, '3ba26f31-b7f1-11ef-9c5f-0242ac120004', 4, 14, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(201, '3ba26f44-b7f1-11ef-9c5f-0242ac120004', 4, 15, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(202, '3ba26f57-b7f1-11ef-9c5f-0242ac120004', 4, 16, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(203, '3ba26f69-b7f1-11ef-9c5f-0242ac120004', 4, 17, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(204, '3ba26f7c-b7f1-11ef-9c5f-0242ac120004', 4, 18, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(205, '3ba26f8e-b7f1-11ef-9c5f-0242ac120004', 4, 19, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(206, '3ba26f9f-b7f1-11ef-9c5f-0242ac120004', 4, 20, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(207, '3ba26fb1-b7f1-11ef-9c5f-0242ac120004', 4, 21, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(208, '3ba26fc4-b7f1-11ef-9c5f-0242ac120004', 4, 22, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(209, '3ba26fd6-b7f1-11ef-9c5f-0242ac120004', 4, 23, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(210, '3ba26fe8-b7f1-11ef-9c5f-0242ac120004', 4, 24, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(211, '3ba26ff9-b7f1-11ef-9c5f-0242ac120004', 4, 25, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(212, '3ba27066-b7f1-11ef-9c5f-0242ac120004', 4, 26, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(213, '3ba27083-b7f1-11ef-9c5f-0242ac120004', 4, 27, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(214, '3ba27097-b7f1-11ef-9c5f-0242ac120004', 4, 28, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(215, '3ba270ab-b7f1-11ef-9c5f-0242ac120004', 4, 29, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(216, '3ba270bf-b7f1-11ef-9c5f-0242ac120004', 4, 30, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(217, '3ba270cf-b7f1-11ef-9c5f-0242ac120004', 4, 31, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(218, '3ba270df-b7f1-11ef-9c5f-0242ac120004', 4, 32, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(219, '3ba270f0-b7f1-11ef-9c5f-0242ac120004', 4, 33, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(220, '3ba27101-b7f1-11ef-9c5f-0242ac120004', 4, 34, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(221, '3ba27111-b7f1-11ef-9c5f-0242ac120004', 4, 35, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(222, '3ba27121-b7f1-11ef-9c5f-0242ac120004', 4, 36, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(223, '3ba27132-b7f1-11ef-9c5f-0242ac120004', 4, 37, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(224, '3ba27141-b7f1-11ef-9c5f-0242ac120004', 4, 38, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(225, '3ba27152-b7f1-11ef-9c5f-0242ac120004', 4, 39, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(226, '3ba27162-b7f1-11ef-9c5f-0242ac120004', 4, 40, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(227, '3ba27172-b7f1-11ef-9c5f-0242ac120004', 4, 41, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(228, '3ba27182-b7f1-11ef-9c5f-0242ac120004', 4, 42, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(229, '3ba27192-b7f1-11ef-9c5f-0242ac120004', 4, 43, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(230, '3ba271a2-b7f1-11ef-9c5f-0242ac120004', 4, 44, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(231, '3ba271b2-b7f1-11ef-9c5f-0242ac120004', 4, 45, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(232, '3ba271c3-b7f1-11ef-9c5f-0242ac120004', 4, 46, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(233, '3ba271d2-b7f1-11ef-9c5f-0242ac120004', 4, 47, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(234, '3ba271e3-b7f1-11ef-9c5f-0242ac120004', 4, 48, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(235, '3ba271f3-b7f1-11ef-9c5f-0242ac120004', 4, 49, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(236, '3ba27203-b7f1-11ef-9c5f-0242ac120004', 4, 50, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(237, '3ba27213-b7f1-11ef-9c5f-0242ac120004', 4, 51, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(238, '3ba27222-b7f1-11ef-9c5f-0242ac120004', 4, 52, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(239, '3ba27232-b7f1-11ef-9c5f-0242ac120004', 4, 53, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(240, '3ba29db9-b7f1-11ef-9c5f-0242ac120004', 4, 54, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(241, '3ba29df2-b7f1-11ef-9c5f-0242ac120004', 4, 55, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(242, '3ba29e0d-b7f1-11ef-9c5f-0242ac120004', 4, 56, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(243, '3ba29e23-b7f1-11ef-9c5f-0242ac120004', 4, 57, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(244, '3ba29e3e-b7f1-11ef-9c5f-0242ac120004', 4, 58, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(245, '3ba29e53-b7f1-11ef-9c5f-0242ac120004', 4, 59, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(246, '3ba29e66-b7f1-11ef-9c5f-0242ac120004', 4, 60, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(247, '3ba29e7a-b7f1-11ef-9c5f-0242ac120004', 4, 61, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(248, '3ba29e8d-b7f1-11ef-9c5f-0242ac120004', 4, 62, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(249, '3ba2c93f-b7f1-11ef-9c5f-0242ac120004', 5, 1, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(250, '3ba2c99f-b7f1-11ef-9c5f-0242ac120004', 5, 2, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(251, '3ba2c9b8-b7f1-11ef-9c5f-0242ac120004', 5, 3, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(252, '3ba2c9cc-b7f1-11ef-9c5f-0242ac120004', 5, 4, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(253, '3ba2c9df-b7f1-11ef-9c5f-0242ac120004', 5, 5, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(254, '3ba2c9f3-b7f1-11ef-9c5f-0242ac120004', 5, 6, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(255, '3ba2ca06-b7f1-11ef-9c5f-0242ac120004', 5, 7, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(256, '3ba2ca18-b7f1-11ef-9c5f-0242ac120004', 5, 8, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(257, '3ba2ca2c-b7f1-11ef-9c5f-0242ac120004', 5, 9, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(258, '3ba2ca3f-b7f1-11ef-9c5f-0242ac120004', 5, 10, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(259, '3ba2ca51-b7f1-11ef-9c5f-0242ac120004', 5, 11, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(260, '3ba2ca62-b7f1-11ef-9c5f-0242ac120004', 5, 12, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(261, '3ba2ca75-b7f1-11ef-9c5f-0242ac120004', 5, 13, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(262, '3ba2ca86-b7f1-11ef-9c5f-0242ac120004', 5, 14, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(263, '3ba2ca99-b7f1-11ef-9c5f-0242ac120004', 5, 15, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(264, '3ba2caad-b7f1-11ef-9c5f-0242ac120004', 5, 16, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(265, '3ba2cabf-b7f1-11ef-9c5f-0242ac120004', 5, 17, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(266, '3ba2cad1-b7f1-11ef-9c5f-0242ac120004', 5, 18, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(267, '3ba2cae4-b7f1-11ef-9c5f-0242ac120004', 5, 19, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(268, '3ba2caf6-b7f1-11ef-9c5f-0242ac120004', 5, 20, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(269, '3ba2cb07-b7f1-11ef-9c5f-0242ac120004', 5, 21, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(270, '3ba2cb1a-b7f1-11ef-9c5f-0242ac120004', 5, 22, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(271, '3ba2cb2c-b7f1-11ef-9c5f-0242ac120004', 5, 23, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(272, '3ba2cb3d-b7f1-11ef-9c5f-0242ac120004', 5, 24, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(273, '3ba2cb50-b7f1-11ef-9c5f-0242ac120004', 5, 25, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(274, '3ba2cb63-b7f1-11ef-9c5f-0242ac120004', 5, 26, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(275, '3ba2cb76-b7f1-11ef-9c5f-0242ac120004', 5, 27, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(276, '3ba2cb87-b7f1-11ef-9c5f-0242ac120004', 5, 28, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(277, '3ba2cb9a-b7f1-11ef-9c5f-0242ac120004', 5, 29, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(278, '3ba2cbad-b7f1-11ef-9c5f-0242ac120004', 5, 30, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(279, '3ba2cbc0-b7f1-11ef-9c5f-0242ac120004', 5, 31, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(280, '3ba2cbd2-b7f1-11ef-9c5f-0242ac120004', 5, 32, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(281, '3ba2cbe4-b7f1-11ef-9c5f-0242ac120004', 5, 33, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(282, '3ba2cbf6-b7f1-11ef-9c5f-0242ac120004', 5, 34, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(283, '3ba2cc09-b7f1-11ef-9c5f-0242ac120004', 5, 35, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(284, '3ba2cc1d-b7f1-11ef-9c5f-0242ac120004', 5, 36, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(285, '3ba2cc2f-b7f1-11ef-9c5f-0242ac120004', 5, 37, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(286, '3ba2cc40-b7f1-11ef-9c5f-0242ac120004', 5, 38, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(287, '3ba2cc50-b7f1-11ef-9c5f-0242ac120004', 5, 39, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(288, '3ba2cc60-b7f1-11ef-9c5f-0242ac120004', 5, 40, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(289, '3ba2cc71-b7f1-11ef-9c5f-0242ac120004', 5, 41, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(290, '3ba2cc82-b7f1-11ef-9c5f-0242ac120004', 5, 42, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(291, '3ba2cc93-b7f1-11ef-9c5f-0242ac120004', 5, 43, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(292, '3ba2cca3-b7f1-11ef-9c5f-0242ac120004', 5, 44, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(293, '3ba2ccb4-b7f1-11ef-9c5f-0242ac120004', 5, 45, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(294, '3ba2ccc4-b7f1-11ef-9c5f-0242ac120004', 5, 46, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(295, '3ba2ccd4-b7f1-11ef-9c5f-0242ac120004', 5, 47, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(296, '3ba2cce5-b7f1-11ef-9c5f-0242ac120004', 5, 48, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(297, '3ba2ccf5-b7f1-11ef-9c5f-0242ac120004', 5, 49, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(298, '3ba2cd05-b7f1-11ef-9c5f-0242ac120004', 5, 50, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(299, '3ba2cd16-b7f1-11ef-9c5f-0242ac120004', 5, 51, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(300, '3ba2cd26-b7f1-11ef-9c5f-0242ac120004', 5, 52, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(301, '3ba2cd36-b7f1-11ef-9c5f-0242ac120004', 5, 53, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(302, '3ba2cd47-b7f1-11ef-9c5f-0242ac120004', 5, 54, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(303, '3ba2cd58-b7f1-11ef-9c5f-0242ac120004', 5, 55, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(304, '3ba2cd68-b7f1-11ef-9c5f-0242ac120004', 5, 56, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(305, '3ba2cd78-b7f1-11ef-9c5f-0242ac120004', 5, 57, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(306, '3ba2cd8b-b7f1-11ef-9c5f-0242ac120004', 5, 58, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(307, '3ba2cd9c-b7f1-11ef-9c5f-0242ac120004', 5, 59, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(308, '3ba2cdad-b7f1-11ef-9c5f-0242ac120004', 5, 60, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(309, '3ba2cdbd-b7f1-11ef-9c5f-0242ac120004', 5, 61, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(310, '3ba2cdce-b7f1-11ef-9c5f-0242ac120004', 5, 62, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(311, '3ba308c1-b7f1-11ef-9c5f-0242ac120004', 6, 1, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(312, '3ba3091a-b7f1-11ef-9c5f-0242ac120004', 6, 2, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(313, '3ba30932-b7f1-11ef-9c5f-0242ac120004', 6, 3, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(314, '3ba30946-b7f1-11ef-9c5f-0242ac120004', 6, 4, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(315, '3ba3095a-b7f1-11ef-9c5f-0242ac120004', 6, 5, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(316, '3ba3096c-b7f1-11ef-9c5f-0242ac120004', 6, 6, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(317, '3ba3097e-b7f1-11ef-9c5f-0242ac120004', 6, 7, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(318, '3ba30990-b7f1-11ef-9c5f-0242ac120004', 6, 8, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(319, '3ba309a3-b7f1-11ef-9c5f-0242ac120004', 6, 9, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(320, '3ba309b9-b7f1-11ef-9c5f-0242ac120004', 6, 10, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(321, '3ba309cd-b7f1-11ef-9c5f-0242ac120004', 6, 11, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(322, '3ba309de-b7f1-11ef-9c5f-0242ac120004', 6, 12, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(323, '3ba309f0-b7f1-11ef-9c5f-0242ac120004', 6, 13, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(324, '3ba30a02-b7f1-11ef-9c5f-0242ac120004', 6, 14, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(325, '3ba30a14-b7f1-11ef-9c5f-0242ac120004', 6, 15, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(326, '3ba30a27-b7f1-11ef-9c5f-0242ac120004', 6, 16, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(327, '3ba30a39-b7f1-11ef-9c5f-0242ac120004', 6, 17, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(328, '3ba30a4b-b7f1-11ef-9c5f-0242ac120004', 6, 18, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(329, '3ba30a5d-b7f1-11ef-9c5f-0242ac120004', 6, 19, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(330, '3ba30a6e-b7f1-11ef-9c5f-0242ac120004', 6, 20, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(331, '3ba30a80-b7f1-11ef-9c5f-0242ac120004', 6, 21, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(332, '3ba30a92-b7f1-11ef-9c5f-0242ac120004', 6, 22, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(333, '3ba30aa4-b7f1-11ef-9c5f-0242ac120004', 6, 23, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(334, '3ba30ab6-b7f1-11ef-9c5f-0242ac120004', 6, 24, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(335, '3ba30ac7-b7f1-11ef-9c5f-0242ac120004', 6, 25, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(336, '3ba30ad9-b7f1-11ef-9c5f-0242ac120004', 6, 26, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(337, '3ba30aea-b7f1-11ef-9c5f-0242ac120004', 6, 27, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(338, '3ba30afc-b7f1-11ef-9c5f-0242ac120004', 6, 28, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(339, '3ba30b0d-b7f1-11ef-9c5f-0242ac120004', 6, 29, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(340, '3ba30b20-b7f1-11ef-9c5f-0242ac120004', 6, 30, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(341, '3ba30b32-b7f1-11ef-9c5f-0242ac120004', 6, 31, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(342, '3ba30b45-b7f1-11ef-9c5f-0242ac120004', 6, 32, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(343, '3ba30b57-b7f1-11ef-9c5f-0242ac120004', 6, 33, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(344, '3ba30b69-b7f1-11ef-9c5f-0242ac120004', 6, 34, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(345, '3ba30b7c-b7f1-11ef-9c5f-0242ac120004', 6, 35, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(346, '3ba30b8f-b7f1-11ef-9c5f-0242ac120004', 6, 36, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(347, '3ba30ba0-b7f1-11ef-9c5f-0242ac120004', 6, 37, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(348, '3ba30bb0-b7f1-11ef-9c5f-0242ac120004', 6, 38, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(349, '3ba30bc0-b7f1-11ef-9c5f-0242ac120004', 6, 39, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(350, '3ba30bd1-b7f1-11ef-9c5f-0242ac120004', 6, 40, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(351, '3ba30be2-b7f1-11ef-9c5f-0242ac120004', 6, 41, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(352, '3ba30bf1-b7f1-11ef-9c5f-0242ac120004', 6, 42, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(353, '3ba30c01-b7f1-11ef-9c5f-0242ac120004', 6, 43, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(354, '3ba30c12-b7f1-11ef-9c5f-0242ac120004', 6, 44, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(355, '3ba30c22-b7f1-11ef-9c5f-0242ac120004', 6, 45, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(356, '3ba30c32-b7f1-11ef-9c5f-0242ac120004', 6, 46, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(357, '3ba30c42-b7f1-11ef-9c5f-0242ac120004', 6, 47, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(358, '3ba30c8c-b7f1-11ef-9c5f-0242ac120004', 6, 48, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(359, '3ba30ca0-b7f1-11ef-9c5f-0242ac120004', 6, 49, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(360, '3ba30cb1-b7f1-11ef-9c5f-0242ac120004', 6, 50, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(361, '3ba30cc1-b7f1-11ef-9c5f-0242ac120004', 6, 51, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(362, '3ba30cd1-b7f1-11ef-9c5f-0242ac120004', 6, 52, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(363, '3ba30ce2-b7f1-11ef-9c5f-0242ac120004', 6, 53, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(364, '3ba30cf2-b7f1-11ef-9c5f-0242ac120004', 6, 54, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(365, '3ba30d01-b7f1-11ef-9c5f-0242ac120004', 6, 55, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(366, '3ba30d11-b7f1-11ef-9c5f-0242ac120004', 6, 56, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(367, '3ba30d22-b7f1-11ef-9c5f-0242ac120004', 6, 57, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(368, '3ba30d34-b7f1-11ef-9c5f-0242ac120004', 6, 58, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(369, '3ba30d45-b7f1-11ef-9c5f-0242ac120004', 6, 59, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(370, '3ba30d56-b7f1-11ef-9c5f-0242ac120004', 6, 60, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(371, '3ba30d66-b7f1-11ef-9c5f-0242ac120004', 6, 61, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(372, '3ba30d76-b7f1-11ef-9c5f-0242ac120004', 6, 62, 0, 0.00, 'Pending', 1, '2024-12-11 18:53:38', '2024-12-11 18:53:38'),
(373, '28c49379-0e4d-4782-b19d-c73ef93ff2ea', 1, 63, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(374, '1cc97303-7564-4e50-b103-fe07ba3c8c80', 1, 64, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(375, '1c20f4bf-ef76-4304-b247-557b38afaf2a', 1, 65, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(376, 'b62744b9-5407-4a22-9907-09167633f680', 1, 66, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(377, '1c7cbf5f-b2a4-4335-a4f5-3c8eb22bd6cb', 1, 67, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(378, 'a90ef844-69a6-4d8f-8344-34c65ac30152', 1, 68, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(379, '88e711e9-9a1e-4f1b-9f2e-835272a2ca41', 1, 69, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(380, '20325035-028d-42a4-9641-a92e77c3c203', 1, 70, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(381, '05c2bcbc-5abb-472a-8d76-7b97b9637ae1', 1, 71, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(382, '20d691b6-1627-468d-8e51-9d9c9ca71657', 1, 72, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(383, '29fbaf28-efd1-44d2-acf3-be08e9c7865d', 1, 73, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(384, '36dfbf02-7679-4e6b-9f5d-35761a592d3b', 1, 74, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(385, '49666a25-75cf-47b1-896f-69c2b07c3ed4', 1, 75, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(386, '43936cb3-4c66-4c24-9530-c5c1c57932a1', 1, 76, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(387, '55cab232-ad9e-48a0-82d3-ecb73fbaff59', 1, 77, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(388, '72528c6c-1b98-425b-ab56-ba31229b2858', 1, 78, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(389, '85c4cec9-8cd0-4037-b91b-900a21dc5ffc', 1, 79, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(390, 'd53eefec-2ea7-4206-9564-aacf2fd08857', 1, 80, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(391, 'd0d0627d-07c7-47db-bfa9-2334b6ad2e2f', 1, 81, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(392, '9c97743c-c916-4fb3-b0f9-a2d25a52e065', 1, 82, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(393, 'f39dec0a-68ef-484a-9662-53dae05d35dd', 1, 83, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(394, '31f375b0-59f7-43ea-acaf-07abc5550311', 1, 84, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(395, 'dd5250bf-aa1f-4b96-9b1c-2f1a032583c5', 1, 85, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(396, '285cd761-c86a-4beb-aa82-8fd298367d08', 1, 86, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(397, 'dd947f4c-4ea8-4526-bf0f-809e089c070e', 1, 87, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(398, '728faf6e-f4cf-443f-8dcb-810ced79f3c4', 1, 88, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(399, '45c0bf61-b4f2-42d2-b4ee-4a8916c40129', 1, 89, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(400, '492c8f43-9e21-4382-aa41-8467a75675a9', 1, 90, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(401, 'de222ac4-02ef-4b49-adaa-cabed275f761', 1, 91, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(402, 'd76cb28b-3867-4295-a617-0eec4604ab1c', 1, 92, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(403, 'ef41a3f2-7e75-4f5a-9e06-a10feb6ca13e', 1, 93, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(404, 'd209952d-301d-4cfc-a5e4-a0cd84939450', 1, 94, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(405, '8e4c5846-7c92-4909-b231-97d9721dc72b', 1, 95, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(406, '19ecf23f-fa15-4065-a25f-02248fefa995', 1, 96, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(407, 'b3100165-7180-4dad-b001-8996cbd82825', 1, 97, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(408, '8e68656b-fea7-4b9e-bbac-c04334a302b4', 1, 98, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(409, 'a6e99487-9d5d-48b5-be69-37e919f301fb', 1, 99, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(410, 'a4b9a610-025b-4786-84c0-64612133e3b1', 1, 100, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(411, '210c2cfc-521d-418c-a396-7eca9643dd1a', 1, 101, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(412, 'aa8c994a-7ff4-459f-8b22-61d952bfd068', 1, 102, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(413, '845dc741-3f06-4afc-8ac1-328631716f1b', 1, 103, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00');
INSERT INTO `Room_Shift` (`room_shift_id`, `room_shift_uuid`, `room_id`, `shift_id`, `reserved_capacity`, `total_revenue`, `status`, `is_active`, `created_at`, `updated_at`) VALUES
(414, '285ff867-64ae-47d6-bb2a-dd3a2f4af3e9', 1, 104, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(415, 'e288f5ab-2dc7-4db6-956a-cbd755032862', 1, 105, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(416, '87b7ce60-a496-4251-97bc-82ae18f30aa6', 1, 106, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(417, '8e755178-e527-48cc-a9fa-f3e7fdca6707', 1, 107, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(418, '52d7bb10-e8af-48c7-80cc-40582b7d4d5a', 1, 108, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(419, '5d29be52-f7aa-4d95-a772-6966337df702', 1, 109, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(420, '59665e1f-c4e3-44e0-a3d4-49608f08fb78', 1, 110, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(421, 'edd30593-4340-4d79-a1f1-639964d55c66', 1, 111, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(422, 'bf44bf09-95eb-481c-8711-5ce993fbb427', 1, 112, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(423, '334054a0-ea46-481c-8ff7-aa6a6700152d', 1, 113, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(424, 'e1d8f554-fb72-41e2-a3cc-5d0b95245abf', 1, 114, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(425, 'c547715f-9fd8-4eab-a722-674d1e2dc843', 1, 115, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(426, '23a69bde-fbef-4b96-8c3e-b14316ffbae0', 1, 116, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(427, '8a9887e8-fed3-4d3b-ac5b-2f20e2607f92', 1, 117, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(428, '8e499a48-22c8-48ee-ae13-159aede81c11', 1, 118, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(429, '85494d99-8662-4b5e-894e-044b23c6c824', 1, 119, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(430, 'd374d87c-98ea-47cb-9705-dcca73088eb3', 1, 120, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(431, '0821ea1b-7bc3-4e53-8c06-a3625dab6b45', 1, 121, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(432, '2c9d8cc8-bb5b-4ec9-ae70-ec4c8426b558', 1, 122, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(433, '7658a5c9-612d-4991-8a24-f4766cddd5e0', 1, 123, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(434, '75c67462-a251-4e36-98b1-777437e88ca5', 1, 124, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(435, '10a3d175-724e-41ff-9f7a-3fc9f6924bcd', 2, 63, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(436, '9bfd53c3-6b9d-4aa7-b44c-3bdf9eb5f380', 2, 64, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(437, '9356ab2e-5c09-42b4-9553-7656d6dbe9b6', 2, 65, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(438, 'cbf94f55-cb0e-4da6-8992-5281f382e6aa', 2, 66, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(439, '677305c3-ee0a-49c4-9e51-1fcdaf624d72', 2, 67, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(440, 'ebe35226-33d5-4c1a-bc14-27f80f0a1d94', 2, 68, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(441, '3edf7dd1-3e2c-45e7-aece-98be433b509d', 2, 69, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(442, 'f7962f2b-e610-4be0-b08d-4174bc899013', 2, 70, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(443, 'c2e9666b-3394-4055-9dac-3488eccc9911', 2, 71, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(444, 'f882c2dd-d896-4945-a2ac-9f93c44889be', 2, 72, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(445, 'ce73c52e-911b-45d4-b117-967b3cb2c425', 2, 73, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(446, 'cbe56d50-fec9-44b0-bbb9-3104911e8d84', 2, 74, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(447, '2d815ec7-93ca-4b35-a319-9e2a03cac8cf', 2, 75, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(448, 'f137c948-429b-4b90-9276-6e8bc1b7254d', 2, 76, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(449, '83b6d4b5-4c33-484c-89e8-0e0862f652cc', 2, 77, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(450, '2f6aa62e-a87e-423b-9c7c-836c45de57d6', 2, 78, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(451, 'f9d66e30-08a1-4626-8277-25a7609af0cd', 2, 79, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(452, 'a9d62c61-dadf-40c9-b7d9-9962f24b2bef', 2, 80, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(453, '87dce58f-5245-43f4-95b0-95af43c278eb', 2, 81, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(454, '7bb020c9-da71-4245-8340-e54d0923410d', 2, 82, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(455, '7d1086ca-98ef-4a2e-9ace-7796191510a2', 2, 83, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(456, '0c664810-1ddd-4c40-b360-e77143c25247', 2, 84, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(457, 'd00d61f4-606a-4c18-a31b-96f610d77fde', 2, 85, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(458, '0a193d14-a5bd-4b15-b459-9fa6b0db28be', 2, 86, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(459, 'a00b6369-9aa4-4ead-9e2d-3620ab9f6ff5', 2, 87, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(460, '3e906d23-ad51-4705-b604-2cf631e69f0f', 2, 88, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(461, '50ba66f2-e675-4ce2-bd58-291175cade1c', 2, 89, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(462, '330b8b10-de11-46e0-86db-81010e78ea64', 2, 90, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(463, '8286915b-df51-4c80-8162-fa2aff9daba1', 2, 91, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(464, '4166b593-6d5a-403d-934e-d95c21319284', 2, 92, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(465, 'cdb4c4b1-ca99-4b68-829d-e114e89bd3a1', 2, 93, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(466, 'caea0b3c-d112-46ea-a756-3fe939222fcb', 2, 94, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(467, '1cf7555e-33be-4034-afe4-a96bfe21d152', 2, 95, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(468, '344c58e8-4c04-4060-aae1-b692273aa67d', 2, 96, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(469, '6d99275f-e1df-4638-895e-c7974c05d3a7', 2, 97, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(470, '88aabcab-6fb9-4cb1-a8ba-a75cc48543f8', 2, 98, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(471, 'd150cb8d-15de-4fdb-99ff-fa2d6fab7710', 2, 99, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(472, '606db51f-174b-4cfe-b79b-96cbaaef6557', 2, 100, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(473, 'fbc09625-e442-4b6c-b3d6-abf4cc082c3a', 2, 101, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(474, 'f7cd892a-6f1e-4f98-90c8-541a422ae1cc', 2, 102, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(475, '1a56807b-7b7c-40ba-8089-014a84b180e2', 2, 103, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(476, 'd32a55a8-c389-4e6d-8cb6-88e7bc5023dc', 2, 104, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(477, '355d9d44-4a4d-4b7d-a654-72ee1289024e', 2, 105, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(478, '525a50f9-4c5c-4673-946f-9b0edfdec8cf', 2, 106, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(479, '68c7d64f-3efe-4006-bbff-9ed5b183d98b', 2, 107, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(480, '7e0f8b60-d438-4294-a5ca-970fe41ba20b', 2, 108, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(481, '863255a1-77d4-416c-988e-7967c3e1daed', 2, 109, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(482, '0b50120b-13ba-4533-9ac1-a43d7b50abb4', 2, 110, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(483, 'b5c28971-65fe-4183-8414-11626c998fcd', 2, 111, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(484, 'e1213950-8886-4492-b3ae-d2b455c37db8', 2, 112, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(485, '403e1893-8f37-4a44-b35a-ec497edee749', 2, 113, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(486, 'e8161313-4fd3-4e77-bba5-6a51500e39ed', 2, 114, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(487, 'fdfcace5-7693-4801-bc4d-f23df138586d', 2, 115, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(488, 'e8426a6f-f8fa-405b-bbbe-d4dcecebe77c', 2, 116, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(489, '21a4a1cf-51fe-480c-8834-9e30701cabf3', 2, 117, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(490, '997e6b69-2354-4f05-9aa9-851ad41a9dba', 2, 118, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(491, 'c9759e18-8ba0-4598-b35f-19c60af5031f', 2, 119, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(492, '2c464081-732f-4d0f-94e6-42953b270303', 2, 120, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(493, 'e4c116c4-3af8-4b91-81a7-c2115dbfb790', 2, 121, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(494, 'c2d4a6e2-f4c1-4502-bce0-e0d043930980', 2, 122, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(495, 'b4375210-cc1f-4a4c-b628-2122d6f90250', 2, 123, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(496, 'f6f79b11-669f-4fcb-9bb7-c3d262ff91a8', 2, 124, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(497, '5a6d96af-a0a8-4bf3-b313-8f1255206ac6', 3, 63, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(498, '4a6f8fe4-6032-46d6-9277-866788692a41', 3, 64, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(499, 'a8902477-1491-4c97-9220-ad539c4e9714', 3, 65, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(500, 'a14eba2a-cc85-4aeb-92c5-1c97545b081c', 3, 66, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(501, '78ff7221-de41-46fb-80bb-2d6adf85940c', 3, 67, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(502, '7990eac1-f86d-4dd3-895f-fb2c43ed38d1', 3, 68, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(503, '8431e2de-6bff-4c93-9fa1-f215ebedc4ba', 3, 69, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(504, '281091ac-c91a-4843-8a92-fc9d6cd27fde', 3, 70, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(505, '1bd9fd00-478d-4e07-a1e4-9e8f36846abd', 3, 71, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(506, 'fde36086-505c-4ba9-9e46-a846e3b406c3', 3, 72, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(507, '491331a8-6a65-4e00-a21b-8ec388d89d2a', 3, 73, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(508, '95faed75-dac6-48ba-bf2e-bb4b005cd651', 3, 74, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(509, '98f2f99d-1055-4ea7-8ffc-54d1083e25c6', 3, 75, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(510, '817633b0-081e-4e7a-a999-74f19ce22f47', 3, 76, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(511, '66e2a62d-5892-4a25-80cc-c80675b19282', 3, 77, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(512, '7422ab5b-3f8c-4d91-92a6-d87241ec0c36', 3, 78, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(513, 'c4885011-0b95-45a0-9990-791db89e4b1c', 3, 79, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(514, '698ebdf4-63e1-4ee5-ab7e-123f11d48e4f', 3, 80, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(515, 'd2de7ac1-d5d0-4272-adc5-9aca1bd70f48', 3, 81, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(516, '45ae35b7-7649-4329-b2e8-e5d969ca49d9', 3, 82, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(517, '8579b11a-8bd4-4c85-99f6-c33540a2bd94', 3, 83, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(518, '08ecace4-df49-4aaf-8b73-764c14258451', 3, 84, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(519, '20c3de78-f70c-4331-976f-9b2dc74ed1d2', 3, 85, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(520, '5cb57c3c-e781-4f16-bbb6-a5abda2c31ea', 3, 86, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(521, '0a714cdd-e0b4-452b-8972-eb5bc4ed9ff9', 3, 87, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(522, '36fc0f96-fc56-4091-ae7e-80f86ae10feb', 3, 88, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(523, '50d21221-ea0a-4d66-a89b-1bab2a7b9d13', 3, 89, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(524, 'f18e8fd2-8fc5-4296-a8d9-ca8544519bbb', 3, 90, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(525, 'a28d92ef-2701-4e8c-b65e-8d0cab451d94', 3, 91, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(526, 'da41845c-d4fc-4408-9ec7-535a47bd0d81', 3, 92, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(527, 'fa60bfdc-b950-455e-8ac1-15b4b13a4425', 3, 93, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(528, 'b5722d6e-3a46-47f8-b047-818b1ae9a285', 3, 94, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(529, '76427a0b-149a-4f49-9320-fd04beabc11a', 3, 95, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(530, '1e01d1d9-f37a-48c8-8f26-9da3b738a413', 3, 96, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(531, '1e6d7153-3b81-4555-9ee6-f4ceb22f3b0f', 3, 97, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(532, '1e061c46-e1b8-4fc1-8caa-bb094404859b', 3, 98, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(533, 'daa47816-49c9-451a-9c5f-211e5626c0ce', 3, 99, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(534, '4aa74482-c78a-4497-a1ef-8e8df081de04', 3, 100, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(535, 'cd115a9b-8d0b-4640-8e4d-c810ba9bf732', 3, 101, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(536, '42d0df22-73b3-4615-b930-e9b5343656fc', 3, 102, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(537, 'c315ddf9-b0ee-402e-88a4-00b1d158f95e', 3, 103, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(538, 'fe7126cb-6993-4d22-b93c-e338d3d5bbc9', 3, 104, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(539, 'de08cfdf-c1a7-47b0-9c14-325288787fc6', 3, 105, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(540, '64f34494-e07f-4d42-8fbf-9bcbab5df9a9', 3, 106, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(541, '92d85c18-515d-46cf-bdc7-9ae5ebcaa9a4', 3, 107, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(542, 'ee62bc65-d5db-4fc2-b163-708150681aa3', 3, 108, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(543, 'cabae633-605d-4a30-bf6c-ff09b1881f96', 3, 109, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(544, '5706c860-852f-4c06-945c-e353ae4aec2e', 3, 110, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(545, '99c23b56-8b73-4315-82e0-72505b07b102', 3, 111, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(546, 'b502e748-8e7d-4cdf-8b4f-b8ad1acf159e', 3, 112, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(547, 'd21905d5-2530-459e-a37a-501204c2328e', 3, 113, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(548, '9b733ec2-4ddd-4096-9463-f0fd88153f77', 3, 114, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(549, '625318c8-581c-4aa8-abc2-d7a24bfc4ea6', 3, 115, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(550, '9cc10a0a-f82e-4e2b-9c35-06a12ee41ac4', 3, 116, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(551, '2c3e4831-2407-4189-b504-929df132dc6c', 3, 117, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(552, 'f4f6b42a-2981-4428-ab3c-ef45e8c598bc', 3, 118, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(553, '19235926-9424-4836-8f74-ae92f9c78d7f', 3, 119, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(554, '429e2f32-87d1-402c-8e9f-fcce54b0bdde', 3, 120, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(555, '876f8a27-564a-44a5-9a79-b95f617b0b2e', 3, 121, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(556, '1f7bc5b8-56e8-4655-9323-cb6c3dc70b8c', 3, 122, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(557, 'fd496a24-1386-4115-aee8-8293dcf50054', 3, 123, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(558, 'd06165eb-a593-4a4c-8b24-5a1fb67743fe', 3, 124, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(559, '7eb8a6f9-caf4-4b15-84c8-4dbee8719515', 4, 63, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(560, '45aa1bbb-972c-40a3-b5a1-86e2a8785216', 4, 64, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(561, '2c893179-8405-4498-bd42-abb3e1405991', 4, 65, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(562, 'eb979bb2-b4dc-4b93-a09e-a911ebf79462', 4, 66, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(563, 'fb3ef251-9bb8-48a6-9058-a250a05e5e0c', 4, 67, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(564, 'd462020f-c422-43dc-a08a-005691747aa2', 4, 68, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(565, '7ed0bcdf-801b-4194-9034-44cfb076f59f', 4, 69, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(566, '5ee4773d-1b1e-4742-b540-c0c77a92acd9', 4, 70, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(567, 'b5e8a163-10f9-4bca-ae6e-67880442a33d', 4, 71, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(568, 'f5e12c41-d4c8-4652-bc42-154d14b1e1f3', 4, 72, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(569, '254c590a-a93d-4175-b258-5f26e79ea4f6', 4, 73, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(570, 'bc8cdbfe-ee5f-4467-9a85-7aec42381e8e', 4, 74, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(571, '2697d0b5-ca81-49ca-91e4-ea913d1fe088', 4, 75, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(572, 'cce6c1c9-3470-4d32-8100-f91cd1852a18', 4, 76, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(573, 'dc6b8b4e-9aba-427c-ad91-d7eefb35dfc4', 4, 77, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(574, 'cd75f8b7-e334-4801-82c8-56ceb906d026', 4, 78, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(575, 'f9d47c1d-6b64-4d94-a016-7395f2f58326', 4, 79, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(576, '16104c65-0746-4ee5-bbde-da686f784f94', 4, 80, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(577, '15677444-71d4-4163-91e1-b4d0e7b8907e', 4, 81, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(578, '956eb312-9a15-4a5a-b30a-060f5587ad90', 4, 82, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(579, '4a3168ef-9ffc-4e24-aa61-e6d6adf5623b', 4, 83, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(580, 'c10aba76-d6e6-461c-989f-9dc91472fb1b', 4, 84, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(581, 'f01811ca-0927-4fe8-917e-08fa517509d3', 4, 85, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(582, '55004b9b-33cc-4ee0-a286-4c2361c07e43', 4, 86, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(583, 'b3c96e80-36a1-462c-a1bc-fe4b71112851', 4, 87, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(584, 'c3cd9505-7b3e-45ef-aa61-39165c21e7f3', 4, 88, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(585, '4488c91c-fd5d-4879-a3ae-c4be0a44be07', 4, 89, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(586, '2eab35eb-a72f-4515-9f71-fd455130c88a', 4, 90, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(587, '0d778527-d89b-4175-9bff-edecffe1c00e', 4, 91, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(588, '87bde56a-438d-4198-94c8-51b8a2b84d40', 4, 92, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(589, 'c2347219-57f5-4798-b280-b0afccf23412', 4, 93, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(590, '9baea079-682f-46bb-8ff1-1387eb2f3520', 4, 94, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(591, '5429af4d-873e-4eb2-9032-2246b075b86c', 4, 95, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(592, 'dcbc10c6-3671-4767-ae89-b40747594f05', 4, 96, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(593, '660479cd-fce1-4e6a-9f37-a36a3d03db68', 4, 97, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(594, '3aa0d7ff-3ee4-406b-95df-77ac47a78b5b', 4, 98, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(595, '1e05b9af-0fa8-4fe7-8247-6f32386b77f3', 4, 99, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(596, '41dece20-c59f-4eab-a9ee-c06cf17200c1', 4, 100, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(597, '4b06a9f3-b3f4-4bd8-8839-fd48a621277b', 4, 101, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(598, '9bac43e8-35dd-42e9-b24f-8eabc81d54a8', 4, 102, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(599, 'fede85ef-30d0-48c5-9b4a-c1c00e28dd12', 4, 103, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(600, 'd68a9e52-addb-4381-98f5-f045b1d92b61', 4, 104, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(601, '741a7515-c5b5-4d71-9926-9fd573157383', 4, 105, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(602, 'c5fc6ccf-7c74-40e1-8e98-b0f9fa38abdb', 4, 106, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(603, 'fe0507fa-22a7-4e95-bfe7-764e1cfdb977', 4, 107, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(604, 'e90f63d4-4995-4471-94f9-6d99e8c46a5c', 4, 108, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(605, 'c04ceb4e-df6c-4315-8bbc-4a63f00f5da1', 4, 109, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(606, 'c5f8591d-56cf-4320-b011-7d8bfd904234', 4, 110, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(607, '435a78fa-89c3-44ea-9a2d-b3e9be152428', 4, 111, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(608, '9b292d96-ec0b-4a1b-9ed2-87edd4b0f752', 4, 112, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(609, '087dae50-bf99-4157-a4c9-d500da14a624', 4, 113, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(610, '991a103d-69cd-4d39-a139-ec63f31e6b04', 4, 114, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(611, '1a204fa2-f511-43af-86a6-6a9e8ce5f3dc', 4, 115, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(612, 'e6401044-a489-4736-a876-12d86b8373e9', 4, 116, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(613, 'c1405ac4-d9c6-49c8-8283-6e7139c993d0', 4, 117, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(614, '72dd8313-d900-43c5-8364-b3734623826a', 4, 118, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(615, 'a2660584-658f-4ec2-b42a-e39afc574e49', 4, 119, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(616, '380f7cca-ad4f-43ca-891a-808c607c036b', 4, 120, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(617, 'bb7220c2-f8b4-4636-97e9-dbbdfcc55bed', 4, 121, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(618, '7b9ac58f-876e-4c56-a657-1965cd998317', 4, 122, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(619, '865960f0-4781-4c37-8253-1335156da27f', 4, 123, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(620, '54678197-06f6-45d1-a231-919c66ef8168', 4, 124, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(621, '77fe5219-4a9b-4b35-939f-eed3d501cfaf', 5, 63, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(622, '33a0e870-a52d-480d-b87d-d74c1ba5993a', 5, 64, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(623, '92aa09b7-5d29-42df-8904-dbba2bad164d', 5, 65, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(624, '2585d8c3-4449-4af8-8999-1c74c403c6a5', 5, 66, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(625, '2d49e7dc-7eeb-4c04-b6f5-a0101d0bf1ac', 5, 67, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(626, '039b9b87-cb65-4e4e-a12f-b7b036bdcfd7', 5, 68, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(627, '1507a95e-a2c0-4b08-9847-a46e394a7385', 5, 69, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(628, '775941ac-8649-459c-8a96-6ed4525dea21', 5, 70, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(629, '6a3cd200-03d9-4be6-97d6-e228be17942e', 5, 71, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(630, '4223a128-b507-4f81-8dbc-afbfec389c18', 5, 72, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(631, '45b882c1-2ac0-4d41-a3b6-d7efd946afcd', 5, 73, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(632, 'a810d9e6-fbb1-40ed-b6b5-6ffd5107a921', 5, 74, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(633, 'b099ac98-9db8-4d0e-9b95-7cc7a577f974', 5, 75, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(634, 'c1de27b7-f30c-4cf9-a38e-d752bd1bb7c6', 5, 76, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(635, 'f44e81b3-b65d-4e81-bd64-47bafcc5b216', 5, 77, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(636, 'de0aa322-25c5-42fd-9c6c-df4d636f741d', 5, 78, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(637, 'b66e5c8a-36eb-4f9d-845c-2675404cc3c3', 5, 79, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(638, '0c40196c-c95b-4a57-8f20-34738edd3285', 5, 80, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(639, '9e098f50-227e-47fe-92a8-89ece1a00e30', 5, 81, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(640, 'c178ac3d-2690-4e33-bd0d-d4600fc0b838', 5, 82, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(641, '90cac3ff-ba96-4079-9d78-fa6ad1b809c9', 5, 83, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(642, '3b64fcb3-e818-42b9-a842-9c5477c5ede2', 5, 84, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(643, '928ad17f-1eba-4035-9228-d85a76a6cabb', 5, 85, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(644, 'c3946e37-a54f-4a43-9991-45fb21471818', 5, 86, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(645, 'd6179e42-839d-4285-89ca-594fd2a09c31', 5, 87, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(646, 'b7477a84-c224-4971-bdba-4cbc16d2e03e', 5, 88, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(647, 'c3011952-f07c-4f78-af00-8c557a2a0961', 5, 89, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(648, '1759cee2-fb2d-4476-859e-507a59dba303', 5, 90, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(649, '93324a43-40c1-4eed-8a44-7e3fea9bc9c9', 5, 91, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(650, '849de215-9362-412b-b5b2-408b16992341', 5, 92, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(651, '159eba67-8bad-4981-85ea-9f1056af81f1', 5, 93, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(652, '337713c8-b1d6-491d-b156-3c84dce705ad', 5, 94, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(653, '6e07b8d2-21b4-4b65-a4e0-35a0eb367a4e', 5, 95, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(654, '62148010-2448-4c81-8ae9-9f3e3d9f9e8f', 5, 96, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(655, '4a6cc29a-03e7-4021-b3ce-90d01bb5365b', 5, 97, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(656, '1afef04b-10aa-44e9-b5c5-c4fbb2ec759e', 5, 98, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(657, '923c2642-5789-48fe-92d6-71d4980251e1', 5, 99, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(658, '2dc460d8-8c4f-4f6c-bc2d-d30a00c08e0f', 5, 100, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(659, '0352b1b4-0388-46aa-a618-7708ad69dd52', 5, 101, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(660, '73ba3972-f413-4c0c-906b-beb3d6975455', 5, 102, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(661, '80cf23ba-049b-498c-a399-39d0fa60f159', 5, 103, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(662, '67ae4c78-627d-4979-9513-bff5752311be', 5, 104, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(663, '09c44739-c359-4065-b6cf-05abb0dfeb89', 5, 105, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(664, '4ca1a500-61ee-4795-871e-f2e1a172c3ec', 5, 106, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(665, 'd2cc63ab-3ffa-4aa1-9da2-ab4ba81d0e1b', 5, 107, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(666, '82df645f-8b8d-4df9-98d1-707b1dc483dc', 5, 108, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(667, '6d6f3c43-f249-4af7-a4c9-f67d6f98e46e', 5, 109, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(668, '92fb351d-7f70-41cb-83ab-915d9693f556', 5, 110, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(669, 'cc610e43-47e8-4010-adef-2abb1295d13d', 5, 111, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(670, 'ae101a87-b610-476e-84b2-9d89c011fcaf', 5, 112, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(671, 'adbf67b4-f13b-431c-9b59-aa00547dd83f', 5, 113, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(672, 'df061527-d7bc-4f80-b69a-f8b0175a7e59', 5, 114, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(673, '7d0fd117-81d9-4b75-94e2-82caab078c4e', 5, 115, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(674, '681915cd-28eb-4944-ab08-78fd6ac868a2', 5, 116, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(675, 'ebef42a7-0e67-448c-b113-d894759f5102', 5, 117, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(676, '82805d61-2d78-4f2f-af83-d5989df6925e', 5, 118, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(677, '99e286b7-5690-4f43-9664-05258a445c3a', 5, 119, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(678, 'e1aca8b7-2ff5-4425-a16d-a57138a24acd', 5, 120, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(679, '024a6541-d125-4e60-bf81-f822125f1d7e', 5, 121, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(680, '26840bfc-eea5-4e86-b7d4-ec5534145f58', 5, 122, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(681, '4535deed-3ccc-498b-8e4a-8bffb93f49d6', 5, 123, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(682, 'b811ded3-8bb3-4bc3-9f92-e43709175991', 5, 124, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(683, '5d9032ae-1e0f-48c4-905c-11ffd37c392a', 6, 63, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(684, '650cafa9-fdc9-41f6-afc2-cf9518b6a863', 6, 64, 0, 0.00, 'Pending', 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
(685, '1401070c-d5fb-4837-8418-34c34eb322c9', 6, 65, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(686, 'be3d99b1-9f9e-414e-bb1c-a1b153b36403', 6, 66, 0, 0.00, 'Pending', 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
(687, '6723f398-9382-4943-9e61-54744b428b7b', 6, 67, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(688, '1a0b9a66-8a3b-4cf7-ae03-b51a9e82d932', 6, 68, 0, 0.00, 'Pending', 1, '2025-01-03 00:00:00', '2025-01-03 00:00:00'),
(689, '81c1fa20-6fc4-466e-988d-fe823a53597f', 6, 69, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(690, '9e318b88-6151-4a29-9363-d5078fb6e566', 6, 70, 0, 0.00, 'Pending', 1, '2025-01-04 00:00:00', '2025-01-04 00:00:00'),
(691, '5c8e61d4-0f5b-4bef-a807-367775e900be', 6, 71, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(692, '916cc01b-e96d-423e-8fe1-64b4ac1313cc', 6, 72, 0, 0.00, 'Pending', 1, '2025-01-05 00:00:00', '2025-01-05 00:00:00'),
(693, '153ff464-1b6f-48dd-938f-2acdb7cdc2ae', 6, 73, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(694, '21ac290a-90bd-4d8d-a207-027a97022bec', 6, 74, 0, 0.00, 'Pending', 1, '2025-01-06 00:00:00', '2025-01-06 00:00:00'),
(695, '416fb816-c8ef-4611-8f69-e1d29f034209', 6, 75, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(696, '9140debb-6655-48a4-b64d-f7476d783ea3', 6, 76, 0, 0.00, 'Pending', 1, '2025-01-07 00:00:00', '2025-01-07 00:00:00'),
(697, 'f5634380-55ec-4763-b5da-c369a1e7c693', 6, 77, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(698, 'f7594d4a-04f7-4092-93fb-991f98cf4e4c', 6, 78, 0, 0.00, 'Pending', 1, '2025-01-08 00:00:00', '2025-01-08 00:00:00'),
(699, '9b30d932-8360-4c81-aa99-5cdfd995c919', 6, 79, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(700, 'fa912ffd-8ccc-49e4-82b7-9cf8348bd7a4', 6, 80, 0, 0.00, 'Pending', 1, '2025-01-09 00:00:00', '2025-01-09 00:00:00'),
(701, '63ae6249-90a8-4212-adfa-a329294ded4f', 6, 81, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(702, '77947918-f0c0-4c95-a305-b331f356d81d', 6, 82, 0, 0.00, 'Pending', 1, '2025-01-10 00:00:00', '2025-01-10 00:00:00'),
(703, '4281525e-851e-4afa-8e28-27e432387d71', 6, 83, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(704, '4438ea5d-c307-4e6e-981e-10419fb5534e', 6, 84, 0, 0.00, 'Pending', 1, '2025-01-11 00:00:00', '2025-01-11 00:00:00'),
(705, '7b347a95-761a-49ca-bd4b-07b8f5ee0e88', 6, 85, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(706, '35bf4e2b-68be-41dc-866f-54315c29ec66', 6, 86, 0, 0.00, 'Pending', 1, '2025-01-12 00:00:00', '2025-01-12 00:00:00'),
(707, '7a6300d5-2b38-4ce3-917e-df2c72feb536', 6, 87, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(708, 'a6f03945-6504-46f4-8c87-f54cbdef283f', 6, 88, 0, 0.00, 'Pending', 1, '2025-01-13 00:00:00', '2025-01-13 00:00:00'),
(709, 'f9c31a91-772c-4f0a-8ac5-f767b05856b8', 6, 89, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(710, '6a20b9db-9406-442c-a383-c18f95cc9654', 6, 90, 0, 0.00, 'Pending', 1, '2025-01-14 00:00:00', '2025-01-14 00:00:00'),
(711, '305c8e65-c01b-402a-8df9-26b5cd0e9ba1', 6, 91, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(712, 'e13d7e07-32cb-48c4-8e3d-e3dba1485a48', 6, 92, 0, 0.00, 'Pending', 1, '2025-01-15 00:00:00', '2025-01-15 00:00:00'),
(713, 'ddf72c33-c330-47c1-a116-b9c8f204ca7f', 6, 93, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(714, '92339e07-c42b-4b89-bdec-78ffcb8a6566', 6, 94, 0, 0.00, 'Pending', 1, '2025-01-16 00:00:00', '2025-01-16 00:00:00'),
(715, '3718ae6a-749e-442d-9bd0-e9b3cb515300', 6, 95, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(716, '4eb9a3d2-b027-41df-bb35-5284aa9885f7', 6, 96, 0, 0.00, 'Pending', 1, '2025-01-17 00:00:00', '2025-01-17 00:00:00'),
(717, 'b6b31ce5-0def-4cec-9544-a0e77ae9b263', 6, 97, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(718, '42214e01-d8e7-4f06-a7c4-b39023902a3f', 6, 98, 0, 0.00, 'Pending', 1, '2025-01-18 00:00:00', '2025-01-18 00:00:00'),
(719, '81bab2b4-43d4-49cb-b288-a5cff225752d', 6, 99, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(720, 'b38f040d-2097-4bc5-a983-2d77f5a8aeb4', 6, 100, 0, 0.00, 'Pending', 1, '2025-01-19 00:00:00', '2025-01-19 00:00:00'),
(721, '1957bb61-2526-45f9-bb72-3ae454c465df', 6, 101, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(722, '255de5ae-bda8-46c6-a288-2ea0b76a488b', 6, 102, 0, 0.00, 'Pending', 1, '2025-01-20 00:00:00', '2025-01-20 00:00:00'),
(723, 'c5368781-07bc-4dac-b071-65f5ea6dda01', 6, 103, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(724, 'f655a903-03b1-44d6-89b9-7a87d7211798', 6, 104, 0, 0.00, 'Pending', 1, '2025-01-21 00:00:00', '2025-01-21 00:00:00'),
(725, '727df83e-c66f-4d95-83ba-c268ecc92d96', 6, 105, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(726, '76b0e219-24cb-4ab4-83b0-0ce6aad6dedf', 6, 106, 0, 0.00, 'Pending', 1, '2025-01-22 00:00:00', '2025-01-22 00:00:00'),
(727, 'cefebb3a-1f40-42b0-a675-679c9ed29cf6', 6, 107, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(728, 'ccc4add3-b70c-4c55-b0fc-d876c9d97c57', 6, 108, 0, 0.00, 'Pending', 1, '2025-01-23 00:00:00', '2025-01-23 00:00:00'),
(729, 'b079a9ce-083d-4aec-ae3e-6a5a31aa7ef6', 6, 109, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(730, 'f98a41d7-a05f-42ce-b5f4-b1639ccb02ea', 6, 110, 0, 0.00, 'Pending', 1, '2025-01-24 00:00:00', '2025-01-24 00:00:00'),
(731, 'd0bde0b3-0e3c-493d-90a7-9537532c210a', 6, 111, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(732, 'f39ab9d8-5756-4742-89f1-cf2d750cca00', 6, 112, 0, 0.00, 'Pending', 1, '2025-01-25 00:00:00', '2025-01-25 00:00:00'),
(733, '3cc0d94b-ad3c-4a01-a15f-cfcc34ecaaa0', 6, 113, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(734, '11447b4e-7702-4237-b4f8-20bef8543de4', 6, 114, 0, 0.00, 'Pending', 1, '2025-01-26 00:00:00', '2025-01-26 00:00:00'),
(735, '707b605f-4462-4857-ba9f-d802f42b2ac1', 6, 115, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(736, '59e0fa7c-8adf-4c1c-a6ac-7c44d80aa95c', 6, 116, 0, 0.00, 'Pending', 1, '2025-01-27 00:00:00', '2025-01-27 00:00:00'),
(737, '2d9bb6a0-a38f-4779-9812-f91a91168b15', 6, 117, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(738, '8b135eb1-604c-4660-a47e-60d6f03a16ec', 6, 118, 0, 0.00, 'Pending', 1, '2025-01-28 00:00:00', '2025-01-28 00:00:00'),
(739, '951f10e3-6737-4d79-97b2-3c4d82a30e35', 6, 119, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(740, '2706fe58-1fd3-49ee-814e-01a66d1c01e6', 6, 120, 0, 0.00, 'Pending', 1, '2025-01-29 00:00:00', '2025-01-29 00:00:00'),
(741, '2d009211-2680-4d1f-af80-66218e14bf28', 6, 121, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(742, '39ff9698-1407-44ce-befb-f605c3afc983', 6, 122, 0, 0.00, 'Pending', 1, '2025-01-30 00:00:00', '2025-01-30 00:00:00'),
(743, '53787898-3df5-4dbe-afa0-a005faf6df58', 6, 123, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00'),
(744, 'ce476129-3647-430c-b1ce-7db85c250f39', 6, 124, 0, 0.00, 'Pending', 1, '2025-01-31 00:00:00', '2025-01-31 00:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Shift`
--

CREATE TABLE `Shift` (
  `shift_id` int NOT NULL,
  `shift_uuid` char(36) NOT NULL,
  `shift_date` date NOT NULL,
  `shift_type` enum('Lunch','Dinner') NOT NULL,
  `total_revenue` decimal(10,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Shift`
--

INSERT INTO `Shift` (`shift_id`, `shift_uuid`, `shift_date`, `shift_type`, `total_revenue`, `is_active`) VALUES
(1, '3ba47d2c-b7f1-11ef-9c5f-0242ac120004', '2024-12-01', 'Lunch', 0.00, 1),
(2, '3ba47d95-b7f1-11ef-9c5f-0242ac120004', '2024-12-01', 'Dinner', 0.00, 1),
(3, '3ba47dde-b7f1-11ef-9c5f-0242ac120004', '2024-12-02', 'Lunch', 0.00, 1),
(4, '3ba47df6-b7f1-11ef-9c5f-0242ac120004', '2024-12-02', 'Dinner', 0.00, 1),
(5, '3ba47e08-b7f1-11ef-9c5f-0242ac120004', '2024-12-03', 'Lunch', 0.00, 1),
(6, '3ba47e1b-b7f1-11ef-9c5f-0242ac120004', '2024-12-03', 'Dinner', 0.00, 1),
(7, '3ba47e2d-b7f1-11ef-9c5f-0242ac120004', '2024-12-04', 'Lunch', 0.00, 1),
(8, '3ba47e67-b7f1-11ef-9c5f-0242ac120004', '2024-12-04', 'Dinner', 0.00, 1),
(9, '3ba47e79-b7f1-11ef-9c5f-0242ac120004', '2024-12-05', 'Lunch', 0.00, 1),
(10, '3ba47e8a-b7f1-11ef-9c5f-0242ac120004', '2024-12-05', 'Dinner', 0.00, 1),
(11, '3ba47e9b-b7f1-11ef-9c5f-0242ac120004', '2024-12-06', 'Lunch', 0.00, 1),
(12, '3ba47eab-b7f1-11ef-9c5f-0242ac120004', '2024-12-06', 'Dinner', 0.00, 1),
(13, '3ba47ebe-b7f1-11ef-9c5f-0242ac120004', '2024-12-07', 'Lunch', 0.00, 1),
(14, '3ba47ece-b7f1-11ef-9c5f-0242ac120004', '2024-12-07', 'Dinner', 0.00, 1),
(15, '3ba47edf-b7f1-11ef-9c5f-0242ac120004', '2024-12-08', 'Lunch', 0.00, 1),
(16, '3ba47eef-b7f1-11ef-9c5f-0242ac120004', '2024-12-08', 'Dinner', 0.00, 1),
(17, '3ba47f00-b7f1-11ef-9c5f-0242ac120004', '2024-12-09', 'Lunch', 0.00, 1),
(18, '3ba47f12-b7f1-11ef-9c5f-0242ac120004', '2024-12-09', 'Dinner', 0.00, 1),
(19, '3ba47f23-b7f1-11ef-9c5f-0242ac120004', '2024-12-10', 'Lunch', 0.00, 1),
(20, '3ba47f33-b7f1-11ef-9c5f-0242ac120004', '2024-12-10', 'Dinner', 0.00, 1),
(21, '3ba47f47-b7f1-11ef-9c5f-0242ac120004', '2024-12-11', 'Lunch', 0.00, 1),
(22, '3ba47f58-b7f1-11ef-9c5f-0242ac120004', '2024-12-11', 'Dinner', 0.00, 1),
(23, '3ba47f68-b7f1-11ef-9c5f-0242ac120004', '2024-12-12', 'Lunch', 0.00, 1),
(24, '3ba47f79-b7f1-11ef-9c5f-0242ac120004', '2024-12-12', 'Dinner', 0.00, 1),
(25, '3ba47f8a-b7f1-11ef-9c5f-0242ac120004', '2024-12-13', 'Lunch', 0.00, 1),
(26, '3ba47f9c-b7f1-11ef-9c5f-0242ac120004', '2024-12-13', 'Dinner', 0.00, 1),
(27, '3ba47faf-b7f1-11ef-9c5f-0242ac120004', '2024-12-14', 'Lunch', 0.00, 1),
(28, '3ba47fc0-b7f1-11ef-9c5f-0242ac120004', '2024-12-14', 'Dinner', 0.00, 1),
(29, '3ba47fcf-b7f1-11ef-9c5f-0242ac120004', '2024-12-15', 'Lunch', 0.00, 1),
(30, '3ba47fdf-b7f1-11ef-9c5f-0242ac120004', '2024-12-15', 'Dinner', 0.00, 1),
(31, '3ba47fee-b7f1-11ef-9c5f-0242ac120004', '2024-12-16', 'Lunch', 0.00, 1),
(32, '3ba47ffd-b7f1-11ef-9c5f-0242ac120004', '2024-12-16', 'Dinner', 0.00, 1),
(33, '3ba4800c-b7f1-11ef-9c5f-0242ac120004', '2024-12-17', 'Lunch', 0.00, 1),
(34, '3ba4801c-b7f1-11ef-9c5f-0242ac120004', '2024-12-17', 'Dinner', 0.00, 1),
(35, '3ba4802b-b7f1-11ef-9c5f-0242ac120004', '2024-12-18', 'Lunch', 0.00, 1),
(36, '3ba4803a-b7f1-11ef-9c5f-0242ac120004', '2024-12-18', 'Dinner', 0.00, 1),
(37, '3ba48049-b7f1-11ef-9c5f-0242ac120004', '2024-12-19', 'Lunch', 0.00, 1),
(38, '3ba48058-b7f1-11ef-9c5f-0242ac120004', '2024-12-19', 'Dinner', 0.00, 1),
(39, '3ba48067-b7f1-11ef-9c5f-0242ac120004', '2024-12-20', 'Lunch', 0.00, 1),
(40, '3ba48076-b7f1-11ef-9c5f-0242ac120004', '2024-12-20', 'Dinner', 0.00, 1),
(41, '3ba48087-b7f1-11ef-9c5f-0242ac120004', '2024-12-21', 'Lunch', 0.00, 1),
(42, '3ba48096-b7f1-11ef-9c5f-0242ac120004', '2024-12-21', 'Dinner', 0.00, 1),
(43, '3ba480a5-b7f1-11ef-9c5f-0242ac120004', '2024-12-22', 'Lunch', 0.00, 1),
(44, '3ba480b4-b7f1-11ef-9c5f-0242ac120004', '2024-12-22', 'Dinner', 0.00, 1),
(45, '3ba480c3-b7f1-11ef-9c5f-0242ac120004', '2024-12-23', 'Lunch', 0.00, 1),
(46, '3ba480d2-b7f1-11ef-9c5f-0242ac120004', '2024-12-23', 'Dinner', 0.00, 1),
(47, '3ba480e1-b7f1-11ef-9c5f-0242ac120004', '2024-12-24', 'Lunch', 0.00, 1),
(48, '3ba480f0-b7f1-11ef-9c5f-0242ac120004', '2024-12-24', 'Dinner', 0.00, 1),
(49, '3ba480ff-b7f1-11ef-9c5f-0242ac120004', '2024-12-25', 'Lunch', 0.00, 1),
(50, '3ba4810e-b7f1-11ef-9c5f-0242ac120004', '2024-12-25', 'Dinner', 0.00, 1),
(51, '3ba4811d-b7f1-11ef-9c5f-0242ac120004', '2024-12-26', 'Lunch', 0.00, 1),
(52, '3ba4812c-b7f1-11ef-9c5f-0242ac120004', '2024-12-26', 'Dinner', 0.00, 1),
(53, '3ba4813b-b7f1-11ef-9c5f-0242ac120004', '2024-12-27', 'Lunch', 0.00, 1),
(54, '3ba4814a-b7f1-11ef-9c5f-0242ac120004', '2024-12-27', 'Dinner', 0.00, 1),
(55, '3ba48158-b7f1-11ef-9c5f-0242ac120004', '2024-12-28', 'Lunch', 0.00, 1),
(56, '3ba48167-b7f1-11ef-9c5f-0242ac120004', '2024-12-28', 'Dinner', 0.00, 1),
(57, '3ba48176-b7f1-11ef-9c5f-0242ac120004', '2024-12-29', 'Lunch', 0.00, 1),
(58, '3ba48184-b7f1-11ef-9c5f-0242ac120004', '2024-12-29', 'Dinner', 0.00, 1),
(59, '3ba48193-b7f1-11ef-9c5f-0242ac120004', '2024-12-30', 'Lunch', 0.00, 1),
(60, '3ba481a3-b7f1-11ef-9c5f-0242ac120004', '2024-12-30', 'Dinner', 0.00, 1),
(61, '3ba481b2-b7f1-11ef-9c5f-0242ac120004', '2024-12-31', 'Lunch', 0.00, 1),
(62, '3ba481c1-b7f1-11ef-9c5f-0242ac120004', '2024-12-31', 'Dinner', 0.00, 1),
(63, '3ba481d0-b7f1-11ef-9c5f-0242ac120004', '2025-01-01', 'Lunch', 0.00, 1),
(64, '3ba481df-b7f1-11ef-9c5f-0242ac120004', '2025-01-01', 'Dinner', 0.00, 1),
(65, '3ba481ee-b7f1-11ef-9c5f-0242ac120004', '2025-01-02', 'Lunch', 0.00, 1),
(66, '3ba481fd-b7f1-11ef-9c5f-0242ac120004', '2025-01-02', 'Dinner', 0.00, 1),
(67, '3ba4820c-b7f1-11ef-9c5f-0242ac120004', '2025-01-03', 'Lunch', 0.00, 1),
(68, '3ba4821b-b7f1-11ef-9c5f-0242ac120004', '2025-01-03', 'Dinner', 0.00, 1),
(69, '3ba4822a-b7f1-11ef-9c5f-0242ac120004', '2025-01-04', 'Lunch', 0.00, 1),
(70, '3ba48239-b7f1-11ef-9c5f-0242ac120004', '2025-01-04', 'Dinner', 0.00, 1),
(71, '3ba48248-b7f1-11ef-9c5f-0242ac120004', '2025-01-05', 'Lunch', 0.00, 1),
(72, '3ba48257-b7f1-11ef-9c5f-0242ac120004', '2025-01-05', 'Dinner', 0.00, 1),
(73, '3ba48266-b7f1-11ef-9c5f-0242ac120004', '2025-01-06', 'Lunch', 0.00, 1),
(74, '3ba48275-b7f1-11ef-9c5f-0242ac120004', '2025-01-06', 'Dinner', 0.00, 1),
(75, '3ba48284-b7f1-11ef-9c5f-0242ac120004', '2025-01-07', 'Lunch', 0.00, 1),
(76, '3ba48293-b7f1-11ef-9c5f-0242ac120004', '2025-01-07', 'Dinner', 0.00, 1),
(77, '3ba482a2-b7f1-11ef-9c5f-0242ac120004', '2025-01-08', 'Lunch', 0.00, 1),
(78, '3ba482b1-b7f1-11ef-9c5f-0242ac120004', '2025-01-08', 'Dinner', 0.00, 1),
(79, '3ba482c0-b7f1-11ef-9c5f-0242ac120004', '2025-01-09', 'Lunch', 0.00, 1),
(80, '3ba482cf-b7f1-11ef-9c5f-0242ac120004', '2025-01-09', 'Dinner', 0.00, 1),
(81, '3ba482de-b7f1-11ef-9c5f-0242ac120004', '2025-01-10', 'Lunch', 0.00, 1),
(82, '3ba482ed-b7f1-11ef-9c5f-0242ac120004', '2025-01-10', 'Dinner', 0.00, 1),
(83, '3ba482fc-b7f1-11ef-9c5f-0242ac120004', '2025-01-11', 'Lunch', 0.00, 1),
(84, '3ba4830b-b7f1-11ef-9c5f-0242ac120004', '2025-01-11', 'Dinner', 0.00, 1),
(85, '3ba4831a-b7f1-11ef-9c5f-0242ac120004', '2025-01-12', 'Lunch', 0.00, 1),
(86, '3ba48329-b7f1-11ef-9c5f-0242ac120004', '2025-01-12', 'Dinner', 0.00, 1),
(87, '3ba48338-b7f1-11ef-9c5f-0242ac120004', '2025-01-13', 'Lunch', 0.00, 1),
(88, '3ba48347-b7f1-11ef-9c5f-0242ac120004', '2025-01-13', 'Dinner', 0.00, 1),
(89, '3ba48356-b7f1-11ef-9c5f-0242ac120004', '2025-01-14', 'Lunch', 0.00, 1),
(90, '3ba48365-b7f1-11ef-9c5f-0242ac120004', '2025-01-14', 'Dinner', 0.00, 1),
(91, '3ba48374-b7f1-11ef-9c5f-0242ac120004', '2025-01-15', 'Lunch', 0.00, 1),
(92, '3ba48383-b7f1-11ef-9c5f-0242ac120004', '2025-01-15', 'Dinner', 0.00, 1),
(93, '3ba48392-b7f1-11ef-9c5f-0242ac120004', '2025-01-16', 'Lunch', 0.00, 1),
(94, '3ba483a1-b7f1-11ef-9c5f-0242ac120004', '2025-01-16', 'Dinner', 0.00, 1),
(95, '3ba483b0-b7f1-11ef-9c5f-0242ac120004', '2025-01-17', 'Lunch', 0.00, 1),
(96, '3ba483bf-b7f1-11ef-9c5f-0242ac120004', '2025-01-17', 'Dinner', 0.00, 1),
(97, '3ba483ce-b7f1-11ef-9c5f-0242ac120004', '2025-01-18', 'Lunch', 0.00, 1),
(98, '3ba483dd-b7f1-11ef-9c5f-0242ac120004', '2025-01-18', 'Dinner', 0.00, 1),
(99, '3ba483ec-b7f1-11ef-9c5f-0242ac120004', '2025-01-19', 'Lunch', 0.00, 1),
(100, '3ba483fb-b7f1-11ef-9c5f-0242ac120004', '2025-01-19', 'Dinner', 0.00, 1),
(101, '3ba4840a-b7f1-11ef-9c5f-0242ac120004', '2025-01-20', 'Lunch', 0.00, 1),
(102, '3ba48419-b7f1-11ef-9c5f-0242ac120004', '2025-01-20', 'Dinner', 0.00, 1),
(103, '3ba48428-b7f1-11ef-9c5f-0242ac120004', '2025-01-21', 'Lunch', 0.00, 1),
(104, '3ba48437-b7f1-11ef-9c5f-0242ac120004', '2025-01-21', 'Dinner', 0.00, 1),
(105, '3ba48446-b7f1-11ef-9c5f-0242ac120004', '2025-01-22', 'Lunch', 0.00, 1),
(106, '3ba48455-b7f1-11ef-9c5f-0242ac120004', '2025-01-22', 'Dinner', 0.00, 1),
(107, '3ba48464-b7f1-11ef-9c5f-0242ac120004', '2025-01-23', 'Lunch', 0.00, 1),
(108, '3ba48473-b7f1-11ef-9c5f-0242ac120004', '2025-01-23', 'Dinner', 0.00, 1),
(109, '3ba48482-b7f1-11ef-9c5f-0242ac120004', '2025-01-24', 'Lunch', 0.00, 1),
(110, '3ba48491-b7f1-11ef-9c5f-0242ac120004', '2025-01-24', 'Dinner', 0.00, 1),
(111, '3ba484a0-b7f1-11ef-9c5f-0242ac120004', '2025-01-25', 'Lunch', 0.00, 1),
(112, '3ba484af-b7f1-11ef-9c5f-0242ac120004', '2025-01-25', 'Dinner', 0.00, 1),
(113, '3ba484be-b7f1-11ef-9c5f-0242ac120004', '2025-01-26', 'Lunch', 0.00, 1),
(114, '3ba484cd-b7f1-11ef-9c5f-0242ac120004', '2025-01-26', 'Dinner', 0.00, 1),
(115, '3ba484dc-b7f1-11ef-9c5f-0242ac120004', '2025-01-27', 'Lunch', 0.00, 1),
(116, '3ba484eb-b7f1-11ef-9c5f-0242ac120004', '2025-01-27', 'Dinner', 0.00, 1),
(117, '3ba484fa-b7f1-11ef-9c5f-0242ac120004', '2025-01-28', 'Lunch', 0.00, 1),
(118, '3ba48509-b7f1-11ef-9c5f-0242ac120004', '2025-01-28', 'Dinner', 0.00, 1),
(119, '3ba48518-b7f1-11ef-9c5f-0242ac120004', '2025-01-29', 'Lunch', 0.00, 1),
(120, '3ba48527-b7f1-11ef-9c5f-0242ac120004', '2025-01-29', 'Dinner', 0.00, 1),
(121, '3ba48536-b7f1-11ef-9c5f-0242ac120004', '2025-01-30', 'Lunch', 0.00, 1),
(122, '3ba48545-b7f1-11ef-9c5f-0242ac120004', '2025-01-30', 'Dinner', 0.00, 1),
(123, '3ba48554-b7f1-11ef-9c5f-0242ac120004', '2025-01-31', 'Lunch', 0.00, 1),
(124, '3ba48563-b7f1-11ef-9c5f-0242ac120004', '2025-01-31', 'Dinner', 0.00, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Tickets`
--

CREATE TABLE `Tickets` (
  `ticket_id` int NOT NULL,
  `ticket_uuid` char(36) NOT NULL,
  `booking_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `amount_to_pay` decimal(10,2) NOT NULL,
  `donated_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('Paid','Pending','Partial') NOT NULL DEFAULT 'Pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Tickets`
--

INSERT INTO `Tickets` (`ticket_id`, `ticket_uuid`, `booking_id`, `total_amount`, `amount_to_pay`, `donated_amount`, `payment_status`, `created_at`, `updated_at`) VALUES
(1, '84e9a868-c908-4126-b404-7221e819298d', 1, 47.00, 0.00, 2.35, 'Paid', '2024-12-24 02:24:37', '2024-12-24 01:27:15'),
(2, 'f3b1b1b4-0b3b-4b1b-8b1b-4b1b1b1b1b1b', 2, 50.00, 0.00, 2.50, 'Paid', '2024-12-24 02:24:37', '2024-12-24 01:27:15'),
(3, 'f3b1b1b4-0b3b-4b1b-8b1b-4b1b1b1b1b1b', 3, 20.00, 0.00, 1.00, 'Paid', '2024-12-24 02:24:37', '2024-12-24 01:27:15'),
(4, 'f3b1b1b4-0b3b-4b1b-8b1b-4b1b1b1b1b1b', 4, 210.00, 0.00, 10.50, 'Paid', '2024-12-24 02:24:37', '2024-12-24 01:27:15'),
(5, 'f3b1b1b4-0b3b-4b1b-8b1b-4b1b1b1b1b1b', 5, 100.00, 0.00, 5.00, 'Pending', '2024-12-24 02:24:37', '2024-12-24 01:27:15'),
(6, 'f3b1b1b4-0b3b-4b1b-8b1b-4b1b1b1b1b1b', 6, 150.00, 0.00, 7.50, 'Pending', '2024-12-24 02:24:37', '2024-12-24 01:27:15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Waiter`
--

CREATE TABLE `Waiter` (
  `waiter_id` int NOT NULL,
  `waiter_uuid` char(36) NOT NULL,
  `room_id` int NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `hire_date` date NOT NULL,
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `salary` decimal(10,2) DEFAULT '1000.00',
  `shift_disponibility` enum('Lunch','Dinner','Flexible') NOT NULL DEFAULT 'Flexible',
  `is_active` tinyint(1) DEFAULT '1',
  `avatar_url` text,
  `bio` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Waiter`
--

INSERT INTO `Waiter` (`waiter_id`, `waiter_uuid`, `room_id`, `firstName`, `lastName`, `email`, `password`, `phone_number`, `hire_date`, `average_rating`, `salary`, `shift_disponibility`, `is_active`, `avatar_url`, `bio`, `created_at`, `updated_at`) VALUES
(31, 'a0b846e9-37c8-4003-8cba-a8fdd26eb421', 1, 'Yolanda', 'Monerris', 'yomogan@gmail.com', '$argon2i$v=19$m=65536,t=4,p=2$NHQxbmZGNlFtMGpPcHFoMQ$5ibTak/21NOtA/xFducdEjTxWZaENlAeNlJJ7j7jzrQ', NULL, '2024-12-11', 0.00, 1500.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=c064c3f90164e2848de12c6df5060e29', NULL, '2024-12-11 22:39:17', '2024-12-24 01:07:33'),
(33, '3a17067a-a7b9-4b1a-b32b-45192494d44b', 1, 'John', 'Doe', 'john.doe1@example.com', '$argon2i$v=19$m=65536,t=4,p=2$d2ZPM2FMRElMdGdhSzZXdw$ZmMal9HDyN4WaOaP+PhKGSniK6igKdBPv9muP7JvxgA', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=70c67e7ed74e24e3003f92f54bfdb0cf', NULL, '2024-12-24 00:46:40', '2024-12-24 00:46:40'),
(34, 'e7f876d9-097d-4b7d-a2fe-d83f7b694127', 1, 'Jane', 'Smith', 'jane.smith1@example.com', '$argon2i$v=19$m=65536,t=4,p=2$MlUxWGk1U2hEM2UvZTBadQ$NvicB7ivhBwEpepC9uIMjQvb1vEhtnagVNjO1eYqWPY', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=d3c4b9da5bd47363d295d5c88d612bc0', NULL, '2024-12-24 00:58:12', '2024-12-24 01:06:58'),
(35, '0bb531f7-0d33-4796-a032-180e3f7516fe', 2, 'Alice', 'Johnson', 'alice.johnson1@example.com', '$argon2i$v=19$m=65536,t=4,p=2$S3ZRbU50ekpUQS8xMzRnOQ$e1RKf8rspPTNq/jG2mWgsbZIcmIEU4bfeu0G1qcqC84', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=5c7b7edfafb172b11fcfd296b384a218', NULL, '2024-12-24 00:58:40', '2024-12-24 00:58:40'),
(36, '6a4ad095-0a2d-47eb-a2b8-3e6f7d4bc694', 2, 'Bob', 'Smith', 'bob.smith2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$ZXJyQml3MjEzZ3pLZUpoQg$i5PzJMaODAzh8x/1+EawXkGhGaz5inBgssTi0HcaEG0', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=42ffdbe40c2ca304fd15224fb3b6f1eb', NULL, '2024-12-24 01:01:19', '2024-12-24 01:06:58'),
(37, '4a0251df-215b-44e9-8299-30087d1803c0', 2, 'Charlie', 'Brown', 'charlie.brown2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$elBJdXNVNy9aQmZRbmxlVQ$5ZJ7TFdM0n5Gu12zcvayRRP9v+iGu0MjVp8uzF/vYyU', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=b6fc245c9d9fa6f20d7089257495d475', NULL, '2024-12-24 01:01:30', '2024-12-24 01:06:58'),
(38, '9b67b2e6-b4d0-4d15-ae83-6ed4d56d9ad0', 3, 'David', 'Wilson', 'david.wilson2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$dFRDY3BMSnJFQ3FpY1Nadg$4T7nD7Zi4tHXjLU4Iw0RfA0tPaZuDRrh7PnmdL5nDZM', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=ac1f14a605b13e725a80d5ca04db6047', NULL, '2024-12-24 01:01:42', '2024-12-24 01:06:58'),
(39, '2b2347c6-455d-4904-b522-817925e063b2', 3, 'Eve', 'Davis', 'eve.davis2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$YTFvaHBjd1hQTncxWE15Nw$pvgTsjWly/epT3xgAXNpnBZjbav5Lnl3EbNExU6JHAk', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=ef4bfe01a75cad389f96d0626ca0b5ad', NULL, '2024-12-24 01:01:53', '2024-12-24 01:01:53'),
(40, '75c64bdb-7a16-4d2c-ae9a-47b93fb101aa', 3, 'Frank', 'Miller', 'frank.miller2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$OHVXNkNwRVMzbGw5cmsudg$5CpdLPJ2uYy0tzcEhbFeUyO3t3vzrcqAHDiuiKoRra8', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=072f145d7a317b9866c65d8b4325d22e', NULL, '2024-12-24 01:02:06', '2024-12-24 01:06:58'),
(41, '650d39e7-5fa5-46ab-93ae-75b41d1f6bc9', 4, 'Grace', 'Garcia', 'grace.garcia2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$TElCU01WT1djNUpzWXgwUQ$UKphQlTc69I+bI9wUY9TlyxTXs7fopoOSXTSmBXuPu0', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=95a122f4ada9fec261c454d32feb8b65', NULL, '2024-12-24 01:02:14', '2024-12-24 01:06:58'),
(42, '1ceee906-1d75-4ea8-a6fb-d44a0e2fd0de', 4, 'Hank', 'Martinez', 'hank.martinez2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$dW9GbHJHWnZ6VXlUOXIyMw$x0EIpqcEDw19vs9T0mcMiNe5ZUkXiidkCbpBu33A060', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=ad95b7e0831f168fdf808118f5bdab38', NULL, '2024-12-24 01:02:29', '2024-12-24 01:06:58'),
(43, '3c6b992e-8d0a-4765-8308-576588831898', 4, 'Ivy', 'Rodriguez', 'ivy.rodriguez2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$Sm9aZEh2bUNOZW5DLkNWaQ$6uUXNtDbZ457VMSjaUFzh0BKUrxKTZ2zr4tH1SL6wwg', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=f33c27f22962902c080bd968062c2d64', NULL, '2024-12-24 01:02:37', '2024-12-24 01:06:58'),
(44, 'd0157c5d-2f32-474f-84da-6bb95f9b3772', 5, 'Jack', 'Martinez', 'jack.martinez2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$LnZ5SGxiN3llZEIwSEZTaQ$ECYHl/Pp6+j3O5PtLfaiMCLC5wfTAp80dfJ2RJAXY9U', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=4019791af587ac8c4aba969bc6d564aa', NULL, '2024-12-24 01:02:45', '2024-12-24 01:06:58'),
(45, '5683a54f-00ec-4db2-a6e5-75e3fb02995e', 5, 'Karen', 'Hernandez', 'karen.hernandez2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$ckhaMld1RWUuZ1BNM2Z5Yg$hiZFyJZFlgqsRurvEblddPNKZVNalHktE3UQtEYuN8g', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=c0bbba8ea3ff52198ef9e3fd8d61b747', NULL, '2024-12-24 01:02:53', '2024-12-24 01:06:58'),
(46, '66d3e211-598f-473b-8cb7-decea50c8ab8', 5, 'Leo', 'Lopez', 'leo.lopez2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$dERVRjIxcFc1aTV5RlBydw$fJRWVkrsHeuC9M/AKgx83LQe6O3wK6AL87Z65NUxGGE', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=7c90caeb7fe5e927c4263a2f7f3fe53f', NULL, '2024-12-24 01:03:01', '2024-12-24 01:06:58'),
(47, 'ac890dd0-2f1d-4561-b838-aa7caf4428fe', 6, 'Mia', 'Gonzalez', 'mia.gonzalez2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$RmFQaGJ1dUJmTDBVVVRGNw$Zq5kyn8oq/NjWqSS72yvjyEMO8H2HW/+QZUu4TS0Niw', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=294de2b2e0291b675164c636458da98c', NULL, '2024-12-24 01:03:07', '2024-12-24 01:03:07'),
(48, '9b041428-6f34-4ecb-9d21-c83ac9b64c97', 6, 'Nina', 'Perez', 'nina.perez2@example.com', '$argon2i$v=19$m=65536,t=4,p=2$Q2V1VEJ2cjJhcFMxSGwuQQ$axBgXpaeVsQ9H29Fwelo5yQowNySo1E0NOZQlg72AmU', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=8ede275b574b0fa7665ff7cb4804fd81', NULL, '2024-12-24 01:03:15', '2024-12-24 01:06:58'),
(49, 'e6937fb2-1b40-49e9-8f4c-94925fbfb228', 6, 'Pepe', 'Botika', 'pepe@gmail.com', '$argon2i$v=19$m=65536,t=4,p=2$UkptcVoyNmJtVm9OY2N1cA$Qwu29/CQxOZPvA+uKCaJ+hI6ScZOa4vwZoQ7iIUeRSw', NULL, '2024-12-24', 0.00, 1000.00, 'Flexible', 1, 'https://i.pravatar.cc/300?u=7ae4cdbadce369dee2f6f440210e4f75', NULL, '2024-12-24 01:03:59', '2024-12-24 01:06:58');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Blacklist`
--
ALTER TABLE `Blacklist`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Booking`
--
ALTER TABLE `Booking`
  ADD PRIMARY KEY (`booking_id`),
  ADD UNIQUE KEY `booking_uuid` (`booking_uuid`);

--
-- Indices de la tabla `Booking_Waiter`
--
ALTER TABLE `Booking_Waiter`
  ADD PRIMARY KEY (`booking_waiter_id`),
  ADD UNIQUE KEY `booking_waiter_uuid` (`booking_waiter_uuid`);

--
-- Indices de la tabla `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `customer_uuid` (`customer_uuid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `Donations`
--
ALTER TABLE `Donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indices de la tabla `Feedback`
--
ALTER TABLE `Feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD UNIQUE KEY `feedback_uuid` (`feedback_uuid`);

--
-- Indices de la tabla `Manager`
--
ALTER TABLE `Manager`
  ADD PRIMARY KEY (`manager_id`),
  ADD UNIQUE KEY `manager_uuid` (`manager_uuid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `NGO`
--
ALTER TABLE `NGO`
  ADD PRIMARY KEY (`ngo_id`),
  ADD UNIQUE KEY `ngo_uuid` (`ngo_uuid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `Orders`
--
ALTER TABLE `Orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_uuid` (`order_uuid`);

--
-- Indices de la tabla `Orders_Products`
--
ALTER TABLE `Orders_Products`
  ADD PRIMARY KEY (`order_product_id`),
  ADD UNIQUE KEY `order_product_uuid` (`order_product_uuid`);

--
-- Indices de la tabla `Products`
--
ALTER TABLE `Products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `product_uuid` (`product_uuid`);

--
-- Indices de la tabla `QR`
--
ALTER TABLE `QR`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`room_id`),
  ADD UNIQUE KEY `room_uuid` (`room_uuid`);

--
-- Indices de la tabla `Room_Shift`
--
ALTER TABLE `Room_Shift`
  ADD PRIMARY KEY (`room_shift_id`),
  ADD UNIQUE KEY `room_shift_uuid` (`room_shift_uuid`);

--
-- Indices de la tabla `Shift`
--
ALTER TABLE `Shift`
  ADD PRIMARY KEY (`shift_id`),
  ADD UNIQUE KEY `shift_uuid` (`shift_uuid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
