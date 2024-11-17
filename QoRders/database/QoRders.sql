-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: mysql_container
-- Tiempo de generación: 15-11-2024 a las 21:46:32
-- Versión del servidor: 8.0.40
-- Versión de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `QoRders`
--
CREATE DATABASE IF NOT EXISTS QoRders;

-- Usar la base de datos QoRders
USE QoRders;
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Booking`
--

CREATE TABLE `Booking` (
  `booking_id` int NOT NULL,
  `booking_uuid` char(36) NOT NULL,
  `user_id` int NOT NULL,
  `room_shift_id` int NOT NULL,
  `guest_count` int NOT NULL,
  `status` enum('Pending','Confirmed','Completed') NOT NULL DEFAULT 'Pending',
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `password_hash` varchar(255) NOT NULL,
  `avatar_url` text,
  `bio` text,
  `has_coupon` tinyint(1) DEFAULT '0',
  `loyalty_points` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ;

--
-- Volcado de datos para la tabla `Customer`
--

INSERT INTO `Customer` (`customer_id`, `customer_uuid`, `first_name`, `last_name`, `age`, `address`, `email`, `phone_number`, `password_hash`, `avatar_url`, `bio`, `has_coupon`, `loyalty_points`, `is_active`, `created_at`, `updated_at`) VALUES
(1, '07c8e525-a383-11ef-a437-0242ac140002', 'John', 'Doe', 28, '123 Elm Street', 'john.doe@example.com', '+123456789', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'A regular customer.', 0, 150, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(2, '07c8eba4-a383-11ef-a437-0242ac140002', 'Jane', 'Smith', 34, '456 Oak Street', 'jane.smith@example.com', '+123456790', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Loves desserts.', 1, 200, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(3, '07c8ed41-a383-11ef-a437-0242ac140002', 'Robert', 'Brown', 45, '789 Pine Avenue', 'robert.brown@example.com', '+123456791', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Food enthusiast.', 0, 80, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(4, '07c8edc4-a383-11ef-a437-0242ac140002', 'Emily', 'Davis', 30, '321 Birch Lane', 'emily.davis@example.com', '+123456792', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Health-conscious.', 1, 120, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(5, '07c8ee83-a383-11ef-a437-0242ac140002', 'Michael', 'Taylor', 27, '654 Cedar Drive', 'michael.taylor@example.com', '+123456793', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Loves spicy food.', 0, 50, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(6, '07c8ef87-a383-11ef-a437-0242ac140002', 'Sarah', 'White', 22, '987 Maple Street', 'sarah.white@example.com', '+123456794', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'New to dining out.', 1, 70, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(7, '07c8f044-a383-11ef-a437-0242ac140002', 'William', 'Clark', 36, '567 Walnut Blvd', 'william.clark@example.com', '+123456795', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Enjoys family dinners.', 1, 95, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(8, '07c8f0f6-a383-11ef-a437-0242ac140002', 'Olivia', 'Lewis', 29, '234 Poplar Way', 'olivia.lewis@example.com', '+123456796', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Vegan and gluten-free.', 1, 110, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(9, '07c8f1fa-a383-11ef-a437-0242ac140002', 'James', 'Robinson', 31, '765 Sycamore Road', 'james.robinson@example.com', '+123456797', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Prefers local cuisine.', 0, 65, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(10, '07c8f2a1-a383-11ef-a437-0242ac140002', 'Sophia', 'Walker', 26, '432 Aspen Court', 'sophia.walker@example.com', '+123456798', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Adventurous eater.', 1, 85, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(11, '07c8f350-a383-11ef-a437-0242ac140002', 'Benjamin', 'Hall', 40, '987 Spruce Avenue', 'benjamin.hall@example.com', '+123456799', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Enjoys gourmet meals.', 0, 130, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(12, '07c8f3d2-a383-11ef-a437-0242ac140002', 'Ava', 'Young', 24, '123 Fir Street', 'ava.young@example.com', '+123456800', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Big fan of desserts.', 1, 140, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(13, '07c8f4a1-a383-11ef-a437-0242ac140002', 'Noah', 'King', 33, '456 Palm Boulevard', 'noah.king@example.com', '+123456801', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Enjoys wine pairing.', 0, 100, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(14, '07c8f557-a383-11ef-a437-0242ac140002', 'Charlotte', 'Green', 37, '789 Cypress Drive', 'charlotte.green@example.com', '+123456802', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Food blogger.', 1, 150, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(15, '07c8f5be-a383-11ef-a437-0242ac140002', 'Lucas', 'Harris', 29, '321 Redwood Lane', 'lucas.harris@example.com', '+123456803', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Loves experimenting with food.', 0, 90, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(16, '07c8f61a-a383-11ef-a437-0242ac140002', 'Mia', 'Nelson', 32, '654 Bamboo Street', 'mia.nelson@example.com', '+123456804', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Adventurous palate.', 1, 105, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(17, '07c8f66c-a383-11ef-a437-0242ac140002', 'Elijah', 'Mitchell', 35, '987 Chestnut Court', 'elijah.mitchell@example.com', '+123456805', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Classic diner.', 0, 80, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(18, '07c8f78e-a383-11ef-a437-0242ac140002', 'Isabella', 'Carter', 27, '567 Magnolia Way', 'isabella.carter@example.com', '+123456806', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Prefers vegetarian options.', 1, 125, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(19, '07c8f822-a383-11ef-a437-0242ac140002', 'Ethan', 'Reed', 38, '234 Olive Road', 'ethan.reed@example.com', '+123456807', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Food critic.', 0, 170, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23'),
(20, '07c8f8cb-a383-11ef-a437-0242ac140002', 'Amelia', 'Parker', 41, '765 Willow Lane', 'amelia.parker@example.com', '+123456808', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', NULL, 'Loves traditional recipes.', 1, 200, 1, '2024-11-15 18:54:23', '2024-11-15 18:54:23');

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
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Manager`
--

CREATE TABLE `Manager` (
  `manager_id` int NOT NULL,
  `manager_uuid` char(36) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `address` text,
  `salary` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `bio` text,
  `avatar_url` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Manager`
--

INSERT INTO `Manager` (`manager_id`, `manager_uuid`, `first_name`, `last_name`, `email`, `phone_number`, `address`, `salary`, `is_active`, `bio`, `avatar_url`, `created_at`, `updated_at`) VALUES
(1, '45a7227e-a383-11ef-a437-0242ac140002', 'Alice', 'Johnson', 'alice.johnson@qorders.com', '+1987654321', 'HQ Office', 5000.00, 1, 'Head of operations.', NULL, '2024-11-15 18:56:07', '2024-11-15 18:56:07'),
(2, '45a72848-a383-11ef-a437-0242ac140002', 'Bob', 'Williams', 'bob.williams@qorders.com', '+1987654322', 'Branch Office', 4500.00, 1, 'Branch manager.', NULL, '2024-11-15 18:56:07', '2024-11-15 18:56:07');

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
  `total_donations` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `NGO`
--

INSERT INTO `NGO` (`ngo_id`, `ngo_uuid`, `ngo_name`, `ngo_slug`, `description`, `country`, `email`, `phone_number`, `website_url`, `logo_url`, `image_url`, `total_donations`, `created_at`, `updated_at`) VALUES
(1, 'bfe0dd93-a383-11ef-a437-0242ac140002', 'Sakura Foundation', 'Sakura Foundation_123456', 'Dedicada a preservar el patrimonio cultural japonés y apoyar a las comunidades desfavorecidas.', 'Japan', 'contact@sakurafoundation.jp', '+81345678901', 'https://www.sakurafoundation.jp', 'https://example.com/logos/sakura.png', 'https://example.com/images/sakura.jpg', 1500.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(2, 'bfe0e287-a383-11ef-a437-0242ac140002', 'Helping Hands India', 'Helping Hands India_375839', 'Se centra en la educación y la atención médica para niños desfavorecidos en India.', 'India', 'info@helpinghands.in', '+911234567890', 'https://www.helpinghandsindia.org', 'https://example.com/logos/helpinghands.png', 'https://example.com/images/helpinghands.jpg', 2400.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(3, 'bfe0e439-a383-11ef-a437-0242ac140002', 'Solidaridad Española', 'Solidaridad Española_740284', 'Promueve la inclusión social y proporciona ayuda a comunidades marginadas en España.', 'Spain', 'solidaridad@espanola.es', '+34912345678', 'https://www.solidaridadespanola.org', 'https://example.com/logos/solidaridad.png', 'https://example.com/images/solidaridad.jpg', 1800.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(4, 'bfe0e52b-a383-11ef-a437-0242ac140002', 'Amici della Vita', 'Amici della Vita_982023', 'Apoya a familias y niños necesitados, enfocándose en la educación y la atención médica en Italia.', 'Italy', 'info@amicivita.it', '+390123456789', 'https://www.amicidellavita.it', 'https://example.com/logos/amicivita.png', 'https://example.com/images/amicivita.jpg', 2000.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(5, 'bfe0e635-a383-11ef-a437-0242ac140002', 'Manos Unidas México', 'Manos Unidas México_954623', 'Proporciona apoyo para programas de desarrollo rural y educación en México.', 'Mexico', 'contacto@manosunidas.mx', '+525512345678', 'https://www.manosunidasmexico.org', 'https://example.com/logos/manosunidas.png', 'https://example.com/images/manosunidas.jpg', 2300.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32'),
(6, 'bfe0e6dd-a383-11ef-a437-0242ac140002', 'Hope for Türkiye', 'Hope for Türkiye_468134', 'Ofrece ayuda en casos de desastre y apoya proyectos de reconstrucción comunitaria en Turquía.', 'Turkey', 'support@hopeforturkiye.tr', '+905312345678', 'https://www.hopeforturkiye.org', 'https://example.com/logos/hopeforturkiye.png', 'https://example.com/images/hopeforturkiye.jpg', 2200.00, '2024-11-15 18:59:32', '2024-11-15 18:59:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Orders`
--

CREATE TABLE `Orders` (
  `order_id` int NOT NULL,
  `order_uuid` char(36) NOT NULL,
  `booking_id` int NOT NULL,
  `order_status` enum('Pending','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
  `payment_status` enum('Paid','Unpaid') NOT NULL DEFAULT 'Unpaid',
  `total_amount` decimal(10,2) NOT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(1, 'e35412ac-a383-11ef-a437-0242ac140002', 'Croquetas de Jamón', 'Croquetas de Jamón_258103', 'Deliciosas croquetas caseras rellenas de jamón serrano.', 5.50, 'Gluten, Lactosa', 100, 'https://example.com/images/croquetas.jpg', 'Starter', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(2, 'e3541600-a383-11ef-a437-0242ac140002', 'Tortilla Española', 'Tortilla Española_161382', 'Clásica tortilla de patatas con cebolla caramelizada.', 4.50, 'Huevo', 50, 'https://example.com/images/tortilla.jpg', 'Starter', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(3, 'e35416be-a383-11ef-a437-0242ac140002', 'Pan con Tomate', 'Pan con Tomate_190974', 'Rebanadas de pan crujiente con tomate rallado y aceite de oliva.', 3.00, 'Gluten', 150, 'https://example.com/images/pan_tomate.jpg', 'Starter', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(4, 'e3541704-a383-11ef-a437-0242ac140002', 'Gambas al Ajillo', 'Gambas al Ajillo_469576', 'Gambas salteadas con ajo, aceite de oliva y guindilla.', 7.00, 'Mariscos', 30, 'https://example.com/images/gambas.jpg', 'Starter', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(5, 'e354173c-a383-11ef-a437-0242ac140002', 'Pimientos de Padrón', 'Pimientos de Padrón_662718', 'Pimientos verdes pequeños fritos, algunos picantes.', 5.00, NULL, 80, 'https://example.com/images/pimientos.jpg', 'Starter', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(6, 'e35417c3-a383-11ef-a437-0242ac140002', 'Paella Valenciana', 'Paella Valenciana_448734', 'Tradicional paella con pollo, conejo, y verduras frescas.', 15.00, 'Gluten, Mariscos', 40, 'https://example.com/images/paella.jpg', 'Main Course', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(7, 'e3541801-a383-11ef-a437-0242ac140002', 'Cocido Madrileño', 'Cocido Madrileño_758697', 'Guiso tradicional con garbanzos, carne y embutidos.', 12.00, NULL, 25, 'https://example.com/images/cocido.jpg', 'Main Course', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(8, 'e354183a-a383-11ef-a437-0242ac140002', 'Fabada Asturiana', 'Fabada Asturiana_166836', 'Plato típico asturiano con fabes, chorizo, y morcilla.', 13.50, NULL, 20, 'https://example.com/images/fabada.jpg', 'Main Course', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(9, 'e35418a3-a383-11ef-a437-0242ac140002', 'Bacalao al Pil-Pil', 'Bacalao al Pil-Pil_517100', 'Bacalao cocinado en una salsa de ajo, aceite de oliva y guindilla.', 14.00, 'Pescado', 30, 'https://example.com/images/bacalao.jpg', 'Main Course', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(10, 'e35418d8-a383-11ef-a437-0242ac140002', 'Pollo al Chilindrón', 'Pollo al Chilindrón_013665', 'Pollo cocido en salsa de pimientos, tomate y jamón.', 11.00, NULL, 50, 'https://example.com/images/chilindron.jpg', 'Main Course', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(11, 'e354190a-a383-11ef-a437-0242ac140002', 'Tarta de Santiago', 'Tarta de Santiago_536333', 'Tarta de almendras con azúcar glas y un toque de limón.', 5.00, 'Frutos Secos, Huevo', 60, 'https://example.com/images/tarta_santiago.jpg', 'Dessert', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(12, 'e3541956-a383-11ef-a437-0242ac140002', 'Flan Casero', 'Flan Casero_115207', 'Flan de huevo y leche con caramelo líquido.', 4.00, 'Lactosa, Huevo', 80, 'https://example.com/images/flan.jpg', 'Dessert', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(13, 'e35419d2-a383-11ef-a437-0242ac140002', 'Churros con Chocolate', 'Churros con Chocolate_823226', 'Churros crujientes acompañados de chocolate caliente.', 6.00, 'Gluten', 100, 'https://example.com/images/churros.jpg', 'Dessert', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(14, 'e3541a13-a383-11ef-a437-0242ac140002', 'Natillas', 'Natillas_053910', 'Postre cremoso con leche, huevo y canela.', 3.50, 'Lactosa, Huevo', 70, 'https://example.com/images/natillas.jpg', 'Dessert', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(15, 'e3541a42-a383-11ef-a437-0242ac140002', 'Arroz con Leche', 'Arroz con Leche_188108', 'Arroz cocido en leche con canela y ralladura de limón.', 4.50, 'Lactosa', 50, 'https://example.com/images/arroz_leche.jpg', 'Dessert', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(16, 'e3541a9e-a383-11ef-a437-0242ac140002', 'Sangría', 'Sangría_697570', 'Refrescante mezcla de vino tinto, frutas y soda.', 7.00, 'Sulfitos', 30, 'https://example.com/images/sangria.jpg', 'Drink', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(17, 'e3541add-a383-11ef-a437-0242ac140002', 'Cerveza Artesanal', 'Cerveza Artesanal_847397', 'Cerveza española elaborada artesanalmente.', 5.00, 'Gluten, Sulfitos', 100, 'https://example.com/images/cerveza.jpg', 'Drink', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(18, 'e3541b09-a383-11ef-a437-0242ac140002', 'Tinto de Verano', 'Tinto de Verano_489230', 'Bebida refrescante de vino tinto con gaseosa.', 6.00, 'Sulfitos', 40, 'https://example.com/images/tinto_verano.jpg', 'Drink', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(19, 'e3541b74-a383-11ef-a437-0242ac140002', 'Sidra', 'Sidra_597649', 'Sidra asturiana de manzana.', 3.50, NULL, 200, 'https://example.com/images/sidra.jpg', 'Drink', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(20, 'e3541bb1-a383-11ef-a437-0242ac140002', 'Cava', 'Cava_628159', 'Vino espumoso catalán ideal para celebraciones.', 10.00, 'Sulfitos', 20, 'https://example.com/images/cava.jpg', 'Drink', 'Spain', 1, '2024-11-15 19:00:32', '2024-11-15 19:00:32'),
(21, 'ed670e65-a395-11ef-a437-0242ac140002', 'Croquetas de Jamón', 'Croquetas de Jamón_258103', 'Deliciosas croquetas caseras rellenas de jamón serrano.', 5.50, 'Gluten, Lactosa', 100, 'https://example.com/images/croquetas.jpg', 'Starter', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(22, 'ed671ccf-a395-11ef-a437-0242ac140002', 'Tortilla Española', 'Tortilla Española_161382', 'Clásica tortilla de patatas con cebolla caramelizada.', 4.50, 'Huevo', 50, 'https://example.com/images/tortilla.jpg', 'Starter', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(23, 'ed671d84-a395-11ef-a437-0242ac140002', 'Pan con Tomate', 'Pan con Tomate_190974', 'Rebanadas de pan crujiente con tomate rallado y aceite de oliva.', 3.00, 'Gluten', 150, 'https://example.com/images/pan_tomate.jpg', 'Starter', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(24, 'ed671dcf-a395-11ef-a437-0242ac140002', 'Gambas al Ajillo', 'Gambas al Ajillo_469576', 'Gambas salteadas con ajo, aceite de oliva y guindilla.', 7.00, 'Mariscos', 30, 'https://example.com/images/gambas.jpg', 'Starter', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(25, 'ed671f05-a395-11ef-a437-0242ac140002', 'Pimientos de Padrón', 'Pimientos de Padrón_662718', 'Pimientos verdes pequeños fritos, algunos picantes.', 5.00, NULL, 80, 'https://example.com/images/pimientos.jpg', 'Starter', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(26, 'ed671fed-a395-11ef-a437-0242ac140002', 'Paella Valenciana', 'Paella Valenciana_448734', 'Tradicional paella con pollo, conejo, y verduras frescas.', 15.00, 'Gluten, Mariscos', 40, 'https://example.com/images/paella.jpg', 'Main Course', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(27, 'ed672042-a395-11ef-a437-0242ac140002', 'Cocido Madrileño', 'Cocido Madrileño_758697', 'Guiso tradicional con garbanzos, carne y embutidos.', 12.00, NULL, 25, 'https://example.com/images/cocido.jpg', 'Main Course', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(28, 'ed6720d0-a395-11ef-a437-0242ac140002', 'Fabada Asturiana', 'Fabada Asturiana_166836', 'Plato típico asturiano con fabes, chorizo, y morcilla.', 13.50, NULL, 20, 'https://example.com/images/fabada.jpg', 'Main Course', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(29, 'ed67212c-a395-11ef-a437-0242ac140002', 'Bacalao al Pil-Pil', 'Bacalao al Pil-Pil_517100', 'Bacalao cocinado en una salsa de ajo, aceite de oliva y guindilla.', 14.00, 'Pescado', 30, 'https://example.com/images/bacalao.jpg', 'Main Course', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(30, 'ed67216f-a395-11ef-a437-0242ac140002', 'Pollo al Chilindrón', 'Pollo al Chilindrón_013665', 'Pollo cocido en salsa de pimientos, tomate y jamón.', 11.00, NULL, 50, 'https://example.com/images/chilindron.jpg', 'Main Course', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(31, 'ed6721e1-a395-11ef-a437-0242ac140002', 'Tarta de Santiago', 'Tarta de Santiago_536333', 'Tarta de almendras con azúcar glas y un toque de limón.', 5.00, 'Frutos Secos, Huevo', 60, 'https://example.com/images/tarta_santiago.jpg', 'Dessert', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(32, 'ed672248-a395-11ef-a437-0242ac140002', 'Flan Casero', 'Flan Casero_115207', 'Flan de huevo y leche con caramelo líquido.', 4.00, 'Lactosa, Huevo', 80, 'https://example.com/images/flan.jpg', 'Dessert', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(33, 'ed6722d9-a395-11ef-a437-0242ac140002', 'Churros con Chocolate', 'Churros con Chocolate_823226', 'Churros crujientes acompañados de chocolate caliente.', 6.00, 'Gluten', 100, 'https://example.com/images/churros.jpg', 'Dessert', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(34, 'ed6723f9-a395-11ef-a437-0242ac140002', 'Natillas', 'Natillas_053910', 'Postre cremoso con leche, huevo y canela.', 3.50, 'Lactosa, Huevo', 70, 'https://example.com/images/natillas.jpg', 'Dessert', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(35, 'ed672469-a395-11ef-a437-0242ac140002', 'Arroz con Leche', 'Arroz con Leche_188108', 'Arroz cocido en leche con canela y ralladura de limón.', 4.50, 'Lactosa', 50, 'https://example.com/images/arroz_leche.jpg', 'Dessert', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(36, 'ed6724f7-a395-11ef-a437-0242ac140002', 'Sangría', 'Sangría_697570', 'Refrescante mezcla de vino tinto, frutas y soda.', 7.00, 'Sulfitos', 30, 'https://example.com/images/sangria.jpg', 'Drink', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(37, 'ed672588-a395-11ef-a437-0242ac140002', 'Cerveza Artesanal', 'Cerveza Artesanal_847397', 'Cerveza española elaborada artesanalmente.', 5.00, 'Gluten, Sulfitos', 100, 'https://example.com/images/cerveza.jpg', 'Drink', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(38, 'ed6725f9-a395-11ef-a437-0242ac140002', 'Tinto de Verano', 'Tinto de Verano_489230', 'Bebida refrescante de vino tinto con gaseosa.', 6.00, 'Sulfitos', 40, 'https://example.com/images/tinto_verano.jpg', 'Drink', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(39, 'ed672686-a395-11ef-a437-0242ac140002', 'Sidra', 'Sidra_597649', 'Sidra asturiana de manzana.', 3.50, NULL, 200, 'https://example.com/images/sidra.jpg', 'Drink', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(40, 'ed6726ee-a395-11ef-a437-0242ac140002', 'Cava', 'Cava_628159', 'Vino espumoso catalán ideal para celebraciones.', 10.00, 'Sulfitos', 20, 'https://example.com/images/cava.jpg', 'Drink', 'Spain', 1, '2024-11-15 21:09:40', '2024-11-15 21:09:40'),
(41, '149c39a0-a396-11ef-a437-0242ac140002', 'Edamame', 'Edamame_291334', 'Judías de soja al vapor con sal marina.', 4.50, 'Soja', 100, 'https://example.com/images/edamame.jpg', 'Starter', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(42, '149c3e1c-a396-11ef-a437-0242ac140002', 'Gyozas', 'Gyozas_191918', 'Empanadillas japonesas rellenas de carne y verduras.', 6.50, 'Gluten', 80, 'https://example.com/images/gyoza.jpg', 'Starter', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(43, '149c3ea5-a396-11ef-a437-0242ac140002', 'Sunomono', 'Sunomono_527815', 'Ensalada japonesa de pepino con vinagre de arroz.', 5.00, NULL, 70, 'https://example.com/images/sunomono.jpg', 'Starter', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(44, '149c3eef-a396-11ef-a437-0242ac140002', 'Takoyaki', 'Takoyaki_522903', 'Bolas de masa rellenas de pulpo, con salsa takoyaki y copos de bonito.', 7.00, 'Gluten, Mariscos', 50, 'https://example.com/images/takoyaki.jpg', 'Starter', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(45, '149c3f49-a396-11ef-a437-0242ac140002', 'Agedashi Tofu', 'Agedashi Tofu_640037', 'Tofu frito servido con caldo dashi.', 6.00, 'Soja, Gluten', 60, 'https://example.com/images/agedashi_tofu.jpg', 'Starter', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(46, '149c3f8c-a396-11ef-a437-0242ac140002', 'Sushi Variado', 'Sushi Variado_881366', 'Selección de nigiri, maki y sashimi fresco.', 18.00, 'Pescado, Soja, Gluten', 30, 'https://example.com/images/sushi.jpg', 'Main Course', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(47, '149c4033-a396-11ef-a437-0242ac140002', 'Ramen', 'Ramen_117235', 'Sopa de fideos con caldo de cerdo, huevo y cebolleta.', 12.00, 'Gluten, Huevo', 40, 'https://example.com/images/ramen.jpg', 'Main Course', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(48, '149c4074-a396-11ef-a437-0242ac140002', 'Katsu Curry', 'Katsu Curry_198201', 'Cerdo empanado servido con curry japonés y arroz.', 14.00, 'Gluten', 30, 'https://example.com/images/katsu_curry.jpg', 'Main Course', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(49, '149c40aa-a396-11ef-a437-0242ac140002', 'Okonomiyaki', 'Okonomiyaki_085069', 'Tortilla japonesa con col, carne y salsa okonomiyaki.', 10.00, 'Gluten, Huevo', 50, 'https://example.com/images/okonomiyaki.jpg', 'Main Course', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(50, '149c40db-a396-11ef-a437-0242ac140002', 'Unagi Don', 'Unagi Don_859285', 'Anguila a la parrilla servida sobre arroz.', 16.00, 'Pescado, Soja', 25, 'https://example.com/images/unagi_don.jpg', 'Main Course', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(51, '149c410c-a396-11ef-a437-0242ac140002', 'Mochi', 'Mochi_644538', 'Dulces de arroz glutinoso rellenos de helado.', 5.00, 'Soja', 70, 'https://example.com/images/mochi.jpg', 'Dessert', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(52, '149c4144-a396-11ef-a437-0242ac140002', 'Dorayaki', 'Dorayaki_491684', 'Tortitas rellenas de crema de judía roja.', 4.50, 'Gluten', 80, 'https://example.com/images/dorayaki.jpg', 'Dessert', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(53, '149c4176-a396-11ef-a437-0242ac140002', 'Matcha Ice Cream', 'Matcha Ice Cream_675058', 'Helado de té verde matcha.', 6.00, 'Lactosa', 50, 'https://example.com/images/matcha_ice_cream.jpg', 'Dessert', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(54, '149c41af-a396-11ef-a437-0242ac140002', 'Anmitsu', 'Anmitsu_596536', 'Postre de gelatina agar con frutas y jarabe dulce.', 7.00, NULL, 40, 'https://example.com/images/anmitsu.jpg', 'Dessert', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(55, '149c41e4-a396-11ef-a437-0242ac140002', 'Taiyaki', 'Taiyaki_122373', 'Pastel en forma de pez relleno de crema de judía roja.', 5.50, 'Gluten', 60, 'https://example.com/images/taiyaki.jpg', 'Dessert', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(56, '149c4219-a396-11ef-a437-0242ac140002', 'Sake', 'Sake_339717', 'Bebida alcohólica tradicional de arroz fermentado.', 10.00, NULL, 30, 'https://example.com/images/sake.jpg', 'Drink', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(57, '149c4275-a396-11ef-a437-0242ac140002', 'Té Verde', 'Té Verde_080732', 'Infusión tradicional japonesa, servida caliente.', 3.50, NULL, 100, 'https://example.com/images/te_verde.jpg', 'Drink', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(58, '149c42e5-a396-11ef-a437-0242ac140002', 'Ramune', 'Ramune_819440', 'Refresco japonés con un toque dulce y burbujeante.', 4.00, NULL, 80, 'https://example.com/images/ramune.jpg', 'Drink', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(59, '149c4352-a396-11ef-a437-0242ac140002', 'Shochu', 'Shochu_533163', 'Bebida alcohólica destilada, típica en Japón.', 8.00, NULL, 20, 'https://example.com/images/shochu.jpg', 'Drink', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(60, '149c438e-a396-11ef-a437-0242ac140002', 'Umeshu', 'Umeshu_612413', 'Licor dulce japonés elaborado con ciruelas.', 9.00, NULL, 25, 'https://example.com/images/umeshu.jpg', 'Drink', 'Japan', 1, '2024-11-15 21:10:45', '2024-11-15 21:10:45'),
(61, '240f80df-a396-11ef-a437-0242ac140002', 'Guacamole con Totopos', 'Guacamole con Totopos_521933', 'Crema de aguacate servida con totopos crujientes.', 5.50, NULL, 100, 'https://example.com/images/guacamole.jpg', 'Starter', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(62, '240f841a-a396-11ef-a437-0242ac140002', 'Sopes', 'Sopes_916282', 'Pequeñas bases de maíz con frijoles, carne y queso.', 6.00, 'Gluten, Lactosa', 80, 'https://example.com/images/sopes.jpg', 'Starter', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(63, '240f84a4-a396-11ef-a437-0242ac140002', 'Tostadas de Tinga', 'Tostadas de Tinga_624830', 'Tostadas de maíz cubiertas con tinga de pollo.', 7.00, 'Gluten', 70, 'https://example.com/images/tostadas.jpg', 'Starter', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(64, '240f84f1-a396-11ef-a437-0242ac140002', 'Quesadillas', 'Quesadillas_015572', 'Tortillas de maíz rellenas de queso derretido.', 5.00, 'Lactosa, Gluten', 90, 'https://example.com/images/quesadillas.jpg', 'Starter', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(65, '240f8598-a396-11ef-a437-0242ac140002', 'Ceviche Mexicano', 'Ceviche Mexicano_207682', 'Mariscos frescos marinados con limón, tomate y cilantro.', 8.00, 'Mariscos', 50, 'https://example.com/images/ceviche.jpg', 'Starter', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(66, '240f85e2-a396-11ef-a437-0242ac140002', 'Tacos al Pastor', 'Tacos al Pastor_509978', 'Tacos de cerdo adobado servidos con piña y cilantro.', 10.00, 'Gluten', 100, 'https://example.com/images/tacos_pastor.jpg', 'Main Course', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(67, '240f8621-a396-11ef-a437-0242ac140002', 'Enchiladas Verdes', 'Enchiladas Verdes_674418', 'Tortillas rellenas de pollo bañadas en salsa verde.', 11.50, 'Gluten, Lactosa', 80, 'https://example.com/images/enchiladas.jpg', 'Main Course', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(68, '240f865e-a396-11ef-a437-0242ac140002', 'Pozole Rojo', 'Pozole Rojo_428890', 'Sopa tradicional con maíz, carne de cerdo y chile.', 12.00, NULL, 60, 'https://example.com/images/pozole.jpg', 'Main Course', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(69, '240f86fa-a396-11ef-a437-0242ac140002', 'Chiles en Nogada', 'Chiles en Nogada_372947', 'Pimientos rellenos de carne y frutas, cubiertos con salsa de nuez.', 14.00, 'Frutos Secos, Lactosa', 40, 'https://example.com/images/chiles_nogada.jpg', 'Main Course', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(70, '240fde8a-a396-11ef-a437-0242ac140002', 'Mole Poblano', 'Mole Poblano_182690', 'Pollo cubierto con mole de chiles, especias y chocolate.', 13.50, 'Frutos Secos', 50, 'https://example.com/images/mole.jpg', 'Main Course', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(71, '240fdeef-a396-11ef-a437-0242ac140002', 'Flan Napolitano', 'Flan Napolitano_116927', 'Postre cremoso de leche, huevos y caramelo.', 4.50, 'Lactosa, Huevo', 80, 'https://example.com/images/flan_mexicano.jpg', 'Dessert', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(72, '240fdf34-a396-11ef-a437-0242ac140002', 'Arroz con Leche', 'Arroz con Leche_203478', 'Arroz cocido en leche con canela y azúcar.', 4.00, 'Lactosa', 100, 'https://example.com/images/arroz_leche_mexicano.jpg', 'Dessert', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(73, '240fdfcd-a396-11ef-a437-0242ac140002', 'Buñuelos', 'Buñuelos_890233', 'Postres fritos espolvoreados con azúcar y canela.', 3.50, 'Gluten', 90, 'https://example.com/images/bunuelos.jpg', 'Dessert', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(74, '240fe00b-a396-11ef-a437-0242ac140002', 'Tres Leches', 'Tres Leches_177952', 'Bizcocho empapado en tres tipos de leche.', 5.00, 'Lactosa, Gluten', 70, 'https://example.com/images/tres_leches.jpg', 'Dessert', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(75, '240fe042-a396-11ef-a437-0242ac140002', 'Capirotada', 'Capirotada_612493', 'Postre tradicional de pan, miel, frutas y queso.', 4.50, 'Lactosa, Gluten', 50, 'https://example.com/images/capirotada.jpg', 'Dessert', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(76, '240fe07b-a396-11ef-a437-0242ac140002', 'Agua de Horchata', 'Agua de Horchata_417680', 'Bebida dulce hecha de arroz, leche y canela.', 3.00, 'Lactosa', 100, 'https://example.com/images/horchata.jpg', 'Drink', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(77, '240fe0b1-a396-11ef-a437-0242ac140002', 'Margarita', 'Margarita_832109', 'Cóctel clásico de tequila, lima y sal.', 8.00, NULL, 50, 'https://example.com/images/margarita.jpg', 'Drink', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(78, '240fe0e8-a396-11ef-a437-0242ac140002', 'Tequila', 'Tequila_728963', 'Licor tradicional destilado de agave.', 10.00, NULL, 60, 'https://example.com/images/tequila.jpg', 'Drink', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(79, '240fe120-a396-11ef-a437-0242ac140002', 'Michelada', 'Michelada_934620', 'Cerveza preparada con limón, salsas y especias.', 6.50, 'Gluten', 70, 'https://example.com/images/michelada.jpg', 'Drink', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(80, '240fe15e-a396-11ef-a437-0242ac140002', 'Champurrado', 'Champurrado_654871', 'Bebida caliente de chocolate y masa de maíz.', 4.50, 'Lactosa', 80, 'https://example.com/images/champurrado.jpg', 'Drink', 'Mexico', 1, '2024-11-15 21:11:11', '2024-11-15 21:11:11'),
(81, '38d20a17-a396-11ef-a437-0242ac140002', 'Bruschetta', 'Bruschetta_149683', 'Rebanadas de pan tostado con tomate, albahaca y aceite de oliva.', 4.50, 'Gluten', 100, 'https://example.com/images/bruschetta.jpg', 'Starter', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(82, '38d20e7a-a396-11ef-a437-0242ac140002', 'Carpaccio de Ternera', 'Carpaccio de Ternera_861273', 'Láminas finas de ternera cruda con rúcula, parmesano y aceite de oliva.', 7.00, 'Lactosa', 60, 'https://example.com/images/carpaccio.jpg', 'Starter', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(83, '38d20f24-a396-11ef-a437-0242ac140002', 'Caprese', 'Caprese_502367', 'Ensalada de tomate, mozzarella fresca y albahaca.', 6.00, 'Lactosa', 80, 'https://example.com/images/caprese.jpg', 'Starter', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(84, '38d20f71-a396-11ef-a437-0242ac140002', 'Arancini', 'Arancini_490712', 'Bolas de arroz rellenas de queso y fritas.', 5.50, 'Gluten, Lactosa', 70, 'https://example.com/images/arancini.jpg', 'Starter', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(85, '38d20fba-a396-11ef-a437-0242ac140002', 'Antipasto', 'Antipasto_194235', 'Selección de embutidos, quesos y aceitunas.', 8.00, 'Lactosa', 50, 'https://example.com/images/antipasto.jpg', 'Starter', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(86, '38d20ff8-a396-11ef-a437-0242ac140002', 'Pizza Margherita', 'Pizza Margherita_745612', 'Pizza clásica con tomate, mozzarella y albahaca.', 10.00, 'Gluten, Lactosa', 100, 'https://example.com/images/pizza_margherita.jpg', 'Main Course', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(87, '38d21037-a396-11ef-a437-0242ac140002', 'Spaghetti Carbonara', 'Spaghetti Carbonara_839410', 'Pasta con salsa de huevo, panceta y queso pecorino.', 11.50, 'Gluten, Lactosa', 80, 'https://example.com/images/carbonara.jpg', 'Main Course', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(88, '38d21073-a396-11ef-a437-0242ac140002', 'Lasagna', 'Lasagna_638902', 'Capa de pasta, carne y bechamel horneada con queso.', 12.00, 'Gluten, Lactosa', 70, 'https://example.com/images/lasagna.jpg', 'Main Course', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(89, '38d210dc-a396-11ef-a437-0242ac140002', 'Risotto de Setas', 'Risotto de Setas_019834', 'Arroz cremoso cocinado con setas y parmesano.', 13.00, 'Lactosa', 50, 'https://example.com/images/risotto.jpg', 'Main Course', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(90, '38d2115b-a396-11ef-a437-0242ac140002', 'Pollo a la Parmesana', 'Pollo a la Parmesana_674523', 'Pechuga de pollo empanada con salsa de tomate y queso.', 14.00, 'Gluten, Lactosa', 40, 'https://example.com/images/pollo_parmesana.jpg', 'Main Course', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(91, '38d211e6-a396-11ef-a437-0242ac140002', 'Tiramisú', 'Tiramisú_378924', 'Postre de capas de bizcocho, café y crema de mascarpone.', 5.50, 'Lactosa, Gluten', 70, 'https://example.com/images/tiramisu.jpg', 'Dessert', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(92, '38d2135e-a396-11ef-a437-0242ac140002', 'Panna Cotta', 'Panna Cotta_590834', 'Postre cremoso de nata con coulis de frutas.', 4.50, 'Lactosa', 80, 'https://example.com/images/panna_cotta.jpg', 'Dessert', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(93, '38d213bd-a396-11ef-a437-0242ac140002', 'Cannoli', 'Cannoli_284762', 'Rollo de masa crujiente relleno de ricotta y fruta confitada.', 5.00, 'Lactosa, Gluten', 60, 'https://example.com/images/cannoli.jpg', 'Dessert', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(94, '38d21474-a396-11ef-a437-0242ac140002', 'Gelato de Pistacho', 'Gelato de Pistacho_481905', 'Helado artesanal de pistacho.', 6.00, 'Lactosa, Frutos Secos', 50, 'https://example.com/images/gelato.jpg', 'Dessert', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(95, '38d214b1-a396-11ef-a437-0242ac140002', 'Zabaglione', 'Zabaglione_193847', 'Crema de yema de huevo con vino Marsala.', 5.00, 'Huevo, Alcohol', 40, 'https://example.com/images/zabaglione.jpg', 'Dessert', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(96, '38d214ec-a396-11ef-a437-0242ac140002', 'Espresso', 'Espresso_283649', 'Café concentrado italiano.', 2.50, NULL, 100, 'https://example.com/images/espresso.jpg', 'Drink', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(97, '38d21530-a396-11ef-a437-0242ac140002', 'Cappuccino', 'Cappuccino_940273', 'Café con leche y espuma de leche.', 3.50, 'Lactosa', 90, 'https://example.com/images/cappuccino.jpg', 'Drink', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(98, '38d2156c-a396-11ef-a437-0242ac140002', 'Aperol Spritz', 'Aperol Spritz_620934', 'Cóctel refrescante de Aperol, prosecco y soda.', 7.00, 'Alcohol', 60, 'https://example.com/images/aperol_spritz.jpg', 'Drink', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(99, '38d215a0-a396-11ef-a437-0242ac140002', 'Prosecco', 'Prosecco_834720', 'Vino espumoso seco típico italiano.', 9.00, 'Sulfitos', 50, 'https://example.com/images/prosecco.jpg', 'Drink', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(100, '38d215d5-a396-11ef-a437-0242ac140002', 'Limoncello', 'Limoncello_479023', 'Licor dulce de limón.', 8.00, 'Alcohol', 40, 'https://example.com/images/limoncello.jpg', 'Drink', 'Italy', 1, '2024-11-15 21:11:46', '2024-11-15 21:11:46'),
(101, '483a138d-a396-11ef-a437-0242ac140002', 'Hummus', 'Hummus_746102', 'Puré de garbanzos con tahini, ajo, y aceite de oliva.', 4.50, 'Sésamo', 100, 'https://example.com/images/hummus.jpg', 'Starter', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(102, '483a1731-a396-11ef-a437-0242ac140002', 'Dolma', 'Dolma_529387', 'Hojas de parra rellenas de arroz y especias.', 5.50, NULL, 80, 'https://example.com/images/dolma.jpg', 'Starter', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(103, '483a17c3-a396-11ef-a437-0242ac140002', 'Ezme', 'Ezme_684930', 'Ensalada picante de tomate, pimiento y especias.', 4.00, NULL, 90, 'https://example.com/images/ezme.jpg', 'Starter', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(104, '483a181d-a396-11ef-a437-0242ac140002', 'Lahmacun', 'Lahmacun_138620', 'Pizza turca con carne picada y especias.', 6.00, 'Gluten', 70, 'https://example.com/images/lahmacun.jpg', 'Starter', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(105, '483a18be-a396-11ef-a437-0242ac140002', 'Sigara Börek', 'Sigara Börek_843562', 'Rollos fritos de masa rellenos de queso feta.', 5.00, 'Gluten, Lactosa', 100, 'https://example.com/images/sigara_borek.jpg', 'Starter', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(106, '483a85b2-a396-11ef-a437-0242ac140002', 'Kebab de Cordero', 'Kebab de Cordero_908412', 'Cordero marinado y asado al estilo tradicional.', 12.50, NULL, 60, 'https://example.com/images/kebab_cordero.jpg', 'Main Course', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(107, '483a8650-a396-11ef-a437-0242ac140002', 'Manti', 'Manti_264953', 'Raviolis turcos rellenos de carne, servidos con yogur y especias.', 11.00, 'Gluten, Lactosa', 70, 'https://example.com/images/manti.jpg', 'Main Course', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(108, '483a86a9-a396-11ef-a437-0242ac140002', 'Pide', 'Pide_742618', 'Barca de pan turco rellena de queso y carne.', 10.00, 'Gluten, Lactosa', 80, 'https://example.com/images/pide.jpg', 'Main Course', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(109, '483a86e9-a396-11ef-a437-0242ac140002', 'Kuru Fasulye', 'Kuru Fasulye_563901', 'Guiso de alubias blancas con tomate y carne.', 9.50, NULL, 90, 'https://example.com/images/kuru_fasulye.jpg', 'Main Course', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(110, '483a872d-a396-11ef-a437-0242ac140002', 'Imam Bayildi', 'Imam Bayildi_380621', 'Berenjenas rellenas de tomate, cebolla y ajo.', 8.50, NULL, 100, 'https://example.com/images/imam_bayildi.jpg', 'Main Course', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(111, '483a8766-a396-11ef-a437-0242ac140002', 'Baklava', 'Baklava_764092', 'Capas de masa filo con nueces y miel.', 5.50, 'Frutos Secos, Gluten', 100, 'https://example.com/images/baklava.jpg', 'Dessert', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(112, '483a87ad-a396-11ef-a437-0242ac140002', 'Künefe', 'Künefe_582416', 'Postre caliente de masa filo con queso y almíbar.', 6.00, 'Lactosa, Gluten', 80, 'https://example.com/images/kunefe.jpg', 'Dessert', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(113, '483a87ee-a396-11ef-a437-0242ac140002', 'Lokum', 'Lokum_946283', 'Dulces turcos de gelatina con sabores variados.', 4.50, NULL, 90, 'https://example.com/images/lokum.jpg', 'Dessert', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(114, '483a88a8-a396-11ef-a437-0242ac140002', 'Sütlaç', 'Sütlaç_105372', 'Arroz con leche al estilo turco, con canela.', 4.00, 'Lactosa', 70, 'https://example.com/images/sutlac.jpg', 'Dessert', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(115, '483a88ec-a396-11ef-a437-0242ac140002', 'Revani', 'Revani_498307', 'Bizcocho de sémola bañado en almíbar.', 4.50, 'Gluten', 90, 'https://example.com/images/revani.jpg', 'Dessert', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(116, '483a8920-a396-11ef-a437-0242ac140002', 'Ayran', 'Ayran_634821', 'Bebida refrescante de yogur, agua y sal.', 3.00, 'Lactosa', 100, 'https://example.com/images/ayran.jpg', 'Drink', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(117, '483a8955-a396-11ef-a437-0242ac140002', 'Té Turco', 'Té Turco_371820', 'Té negro fuerte, servido en vasos pequeños.', 2.50, NULL, 120, 'https://example.com/images/te_turco.jpg', 'Drink', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(118, '483a8988-a396-11ef-a437-0242ac140002', 'Café Turco', 'Café Turco_285940', 'Café preparado al estilo tradicional con posos.', 3.50, NULL, 100, 'https://example.com/images/cafe_turco.jpg', 'Drink', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(119, '483a89bf-a396-11ef-a437-0242ac140002', 'Rakı', 'Rakı_419075', 'Bebida alcohólica anisada, típica de Turquía.', 7.00, 'Alcohol', 50, 'https://example.com/images/raki.jpg', 'Drink', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(120, '483a89f4-a396-11ef-a437-0242ac140002', 'Şalgam', 'Şalgam_983201', 'Bebida de nabo fermentado, ligeramente ácida.', 3.50, NULL, 70, 'https://example.com/images/salgam.jpg', 'Drink', 'Turkey', 1, '2024-11-15 21:12:12', '2024-11-15 21:12:12'),
(121, '63e1eca9-a396-11ef-a437-0242ac140002', 'Samosas', 'Samosas_482901', 'Empanadillas fritas rellenas de patata, guisantes y especias.', 4.50, 'Gluten', 100, 'https://example.com/images/samosas.jpg', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(122, '63e1f01c-a396-11ef-a437-0242ac140002', 'Pakoras', 'Pakoras_620938', 'Verduras rebozadas y fritas en harina de garbanzo.', 5.00, 'Gluten', 80, 'https://example.com/images/pakoras.jpg', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(123, '63e1f099-a396-11ef-a437-0242ac140002', 'Pani Puri', 'Pani Puri_839274', 'Bolitas crujientes rellenas de agua especiada y chutneys.', 6.00, 'Gluten', 70, 'https://example.com/images/pani_puri.jpg', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(124, '63e1f0e4-a396-11ef-a437-0242ac140002', 'Aloo Tikki', 'Aloo Tikki_920374', 'Croquetas de patata especiadas.', 4.00, NULL, 90, 'https://example.com/images/aloo_tikki.jpg', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(125, '63e1f133-a396-11ef-a437-0242ac140002', 'Dhokla', 'Dhokla_293847', 'Pastelito salado hecho con harina de garbanzo.', 5.50, NULL, 70, 'https://example.com/images/dhokla.jpg', 'Starter', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(126, '63e1f175-a396-11ef-a437-0242ac140002', 'Pollo Tikka Masala', 'Pollo Tikka Masala_574829', 'Pollo cocinado en una cremosa salsa de tomate y especias.', 12.00, 'Lactosa', 80, 'https://example.com/images/tikka_masala.jpg', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(127, '63e1f1b9-a396-11ef-a437-0242ac140002', 'Biryani', 'Biryani_621948', 'Arroz especiado con cordero, pollo o vegetales.', 11.50, 'Frutos Secos', 60, 'https://example.com/images/biryani.jpg', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(128, '63e1f1f9-a396-11ef-a437-0242ac140002', 'Paneer Butter Masala', 'Paneer Butter Masala_748930', 'Queso fresco cocinado en una salsa de tomate y mantequilla.', 10.00, 'Lactosa', 70, 'https://example.com/images/paneer.jpg', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(129, '63e1f233-a396-11ef-a437-0242ac140002', 'Chana Masala', 'Chana Masala_284760', 'Curry de garbanzos cocinado con cebolla y especias.', 9.50, NULL, 90, 'https://example.com/images/chana_masala.jpg', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(130, '63e1f26f-a396-11ef-a437-0242ac140002', 'Rogan Josh', 'Rogan Josh_934812', 'Curry de cordero con yogur y especias.', 13.00, 'Lactosa', 50, 'https://example.com/images/rogan_josh.jpg', 'Main Course', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(131, '63e1f2cd-a396-11ef-a437-0242ac140002', 'Gulab Jamun', 'Gulab Jamun_452367', 'Bolas de masa fritas empapadas en almíbar.', 4.50, 'Lactosa', 80, 'https://example.com/images/gulab_jamun.jpg', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(132, '63e1f30b-a396-11ef-a437-0242ac140002', 'Rasgulla', 'Rasgulla_291830', 'Bolas de queso en almíbar ligero.', 5.00, 'Lactosa', 70, 'https://example.com/images/rasgulla.jpg', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(133, '63e1f346-a396-11ef-a437-0242ac140002', 'Kulfi', 'Kulfi_873924', 'Helado tradicional indio de cardamomo y pistacho.', 6.00, 'Lactosa, Frutos Secos', 60, 'https://example.com/images/kulfi.jpg', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(134, '63e1f38f-a396-11ef-a437-0242ac140002', 'Ladoo', 'Ladoo_483027', 'Dulce hecho de harina de garbanzo, ghee y azúcar.', 4.00, 'Lactosa', 90, 'https://example.com/images/ladoo.jpg', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(135, '63e1f3c7-a396-11ef-a437-0242ac140002', 'Kheer', 'Kheer_927634', 'Arroz con leche especiado con cardamomo.', 4.50, 'Lactosa', 70, 'https://example.com/images/kheer.jpg', 'Dessert', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(136, '63e1f4f3-a396-11ef-a437-0242ac140002', 'Lassi', 'Lassi_738495', 'Bebida a base de yogur con sabores dulces o salados.', 3.50, 'Lactosa', 100, 'https://example.com/images/lassi.jpg', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(137, '63e1f541-a396-11ef-a437-0242ac140002', 'Masala Chai', 'Masala Chai_184920', 'Té negro con especias, leche y azúcar.', 3.00, 'Lactosa', 120, 'https://example.com/images/masala_chai.jpg', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(138, '63e1f577-a396-11ef-a437-0242ac140002', 'Thandai', 'Thandai_409283', 'Bebida fría hecha con leche, almendras y especias.', 5.00, 'Lactosa, Frutos Secos', 80, 'https://example.com/images/thandai.jpg', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(139, '63e1f5ab-a396-11ef-a437-0242ac140002', 'Nimbu Pani', 'Nimbu Pani_738462', 'Limonada especiada con sal negra.', 3.50, NULL, 150, 'https://example.com/images/nimbu_pani.jpg', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(140, '63e1f5e3-a396-11ef-a437-0242ac140002', 'Filter Coffee', 'Filter Coffee_602394', 'Café tradicional del sur de la India.', 4.00, 'Lactosa', 70, 'https://example.com/images/filter_coffee.jpg', 'Drink', 'India', 1, '2024-11-15 21:12:58', '2024-11-15 21:12:58'),
(141, '6f96d9e8-a396-11ef-a437-0242ac140002', 'Agua Mineral', 'Agua Mineral_294615', 'Agua embotellada pura y refrescante.', 1.50, NULL, 500, 'https://example.com/images/agua_mineral.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(142, '6f96ddac-a396-11ef-a437-0242ac140002', 'Coca-Cola', 'Coca-Cola_758203', 'Refresco clásico con gas.', 2.00, NULL, 400, 'https://example.com/images/coca_cola.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(143, '6f96de3d-a396-11ef-a437-0242ac140002', 'Fanta Naranja', 'Fanta Naranja_183592', 'Refresco de naranja con gas.', 2.00, NULL, 300, 'https://example.com/images/fanta_naranja.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(144, '6f96de8b-a396-11ef-a437-0242ac140002', 'Fanta Limón', 'Fanta Limón_473829', 'Refresco de limón con gas.', 2.00, NULL, 300, 'https://example.com/images/fanta_limon.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(145, '6f96ded5-a396-11ef-a437-0242ac140002', 'Sprite', 'Sprite_840276', 'Refresco de lima-limón con gas.', 2.00, NULL, 300, 'https://example.com/images/sprite.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(146, '6f96df17-a396-11ef-a437-0242ac140002', 'Pepsi', 'Pepsi_362891', 'Refresco de cola con gas.', 2.00, NULL, 300, 'https://example.com/images/pepsi.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(147, '6f96df58-a396-11ef-a437-0242ac140002', 'Tónica', 'Tónica_526748', 'Refresco amargo con burbujas, ideal para combinados.', 2.50, NULL, 200, 'https://example.com/images/tonica.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(148, '6f96df9c-a396-11ef-a437-0242ac140002', 'Aquarius', 'Aquarius_912847', 'Bebida isotónica con sabor a limón.', 2.50, NULL, 300, 'https://example.com/images/aquarius.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(149, '6f96dfdc-a396-11ef-a437-0242ac140002', 'Nestea', 'Nestea_473502', 'Té frío con limón.', 2.50, NULL, 300, 'https://example.com/images/nestea.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18'),
(150, '6f96e018-a396-11ef-a437-0242ac140002', 'Red Bull', 'Red Bull_847260', 'Bebida energética clásica.', 3.00, NULL, 200, 'https://example.com/images/red_bull.jpg', 'Drink', 'Generic', 1, '2024-11-15 21:13:18', '2024-11-15 21:13:18');

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
(1, '0abbb126-a39b-11ef-a437-0242ac140002', 'Jardín de los Cerezos', 'Jardin_de_los_Cerezos_781230', 'Una sala inspirada en los paisajes japoneses, con decoración de cerezos en flor y detalles tradicionales.', 'Japan', 50, 0, 0.00, 'https://example.com/images/jardin_cerezos.jpg', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 1),
(2, '0abbbfde-a39b-11ef-a437-0242ac140002', 'Palacio de los Maharajás', 'Palacio_de_los_Maharajas_871237', 'Una sala con elementos decorativos indios, desde alfombras hasta lámparas tradicionales.', 'India', 60, 0, 0.00, 'https://example.com/images/palacio_maharajas.jpg', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 2),
(3, '0abbc1b6-a39b-11ef-a437-0242ac140002', 'Taberna Española', 'Taberna_Espanola_612342', 'Un espacio acogedor con motivos tradicionales españoles, como azulejos y jamones colgados.', 'Spain', 40, 0, 0.00, 'https://example.com/images/taberna_espanola.jpg', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 3),
(4, '0abbc27b-a39b-11ef-a437-0242ac140002', 'Villa Toscana', 'Villa_Toscana_891243', 'Sala que evoca la tranquilidad y belleza de los viñedos italianos, con una decoración elegante.', 'Italy', 70, 0, 0.00, 'https://example.com/images/villa_toscana.jpg', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 4),
(5, '0abbc32a-a39b-11ef-a437-0242ac140002', 'Hacienda Mexicana', 'Hacienda_Mexicana_612384', 'Sala inspirada en las haciendas tradicionales mexicanas, con colores vivos y detalles coloniales.', 'Mexico', 55, 0, 0.00, 'https://example.com/images/hacienda_mexicana.jpg', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 5),
(6, '0abbc48f-a39b-11ef-a437-0242ac140002', 'Salón del Bósforo', 'Salon_del_Bosforo_781234', 'Sala con decoración otomana y vistas simuladas del estrecho del Bósforo.', 'Turkey', 65, 0, 0.00, 'https://example.com/images/salon_bosforo.jpg', 1, '2024-11-15 21:46:16', '2024-11-15 21:46:16', 6);

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Waiter`
--

CREATE TABLE `Waiter` (
  `waiter_id` int NOT NULL,
  `waiter_uuid` char(36) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `hire_date` date NOT NULL,
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `salary` decimal(10,2) NOT NULL,
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

INSERT INTO `Waiter` (`waiter_id`, `waiter_uuid`, `first_name`, `last_name`, `email`, `phone_number`, `hire_date`, `average_rating`, `salary`, `shift_disponibility`, `is_active`, `avatar_url`, `bio`, `created_at`, `updated_at`) VALUES
(1, '52a52df2-a383-11ef-a437-0242ac140002', 'Charlie', 'Garcia', 'charlie.garcia@qorders.com', '+1987654323', '2023-01-15', 4.50, 1800.00, 'Lunch', 1, NULL, 'Experienced waiter.', '2024-11-15 18:56:29', '2024-11-15 18:56:29'),
(2, '52a5353d-a383-11ef-a437-0242ac140002', 'Diana', 'Lopez', 'diana.lopez@qorders.com', '+1987654324', '2022-06-10', 4.70, 1850.00, 'Dinner', 1, NULL, 'Friendly and attentive.', '2024-11-15 18:56:29', '2024-11-15 18:56:29'),
(3, '52a53696-a383-11ef-a437-0242ac140002', 'Ethan', 'Martinez', 'ethan.martinez@qorders.com', '+1987654325', '2021-11-20', 4.20, 1700.00, 'Flexible', 1, NULL, 'Specialist in desserts.', '2024-11-15 18:56:29', '2024-11-15 18:56:29'),
(4, '52a53707-a383-11ef-a437-0242ac140002', 'Sophia', 'Rivera', 'sophia.rivera@qorders.com', '+1987654326', '2020-09-12', 4.80, 1900.00, 'Lunch', 1, NULL, 'Expert in customer service.', '2024-11-15 18:56:29', '2024-11-15 18:56:29'),
(5, '52a53767-a383-11ef-a437-0242ac140002', 'Liam', 'Fernandez', 'liam.fernandez@qorders.com', '+1987654327', '2019-03-08', 4.30, 1750.00, 'Dinner', 1, NULL, 'Efficient and reliable.', '2024-11-15 18:56:29', '2024-11-15 18:56:29'),
(6, '52a537bb-a383-11ef-a437-0242ac140002', 'Isabella', 'Ramirez', 'isabella.ramirez@qorders.com', '+1987654328', '2022-11-05', 4.60, 1800.00, 'Flexible', 1, NULL, 'Energetic and enthusiastic.', '2024-11-15 18:56:29', '2024-11-15 18:56:29');

--
-- Índices para tablas volcadas
--

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

--
-- Indices de la tabla `Tickets`
--
ALTER TABLE `Tickets`
  ADD PRIMARY KEY (`ticket_id`),
  ADD UNIQUE KEY `ticket_uuid` (`ticket_uuid`);

--
-- Indices de la tabla `Waiter`
--
ALTER TABLE `Waiter`
  ADD PRIMARY KEY (`waiter_id`),
  ADD UNIQUE KEY `waiter_uuid` (`waiter_uuid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Booking`
--
ALTER TABLE `Booking`
  MODIFY `booking_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Booking_Waiter`
--
ALTER TABLE `Booking_Waiter`
  MODIFY `booking_waiter_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Customer`
--
ALTER TABLE `Customer`
  MODIFY `customer_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Feedback`
--
ALTER TABLE `Feedback`
  MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Manager`
--
ALTER TABLE `Manager`
  MODIFY `manager_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `NGO`
--
ALTER TABLE `NGO`
  MODIFY `ngo_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `Orders`
--
ALTER TABLE `Orders`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Orders_Products`
--
ALTER TABLE `Orders_Products`
  MODIFY `order_product_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Products`
--
ALTER TABLE `Products`
  MODIFY `product_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT de la tabla `Room`
--
ALTER TABLE `Room`
  MODIFY `room_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `Room_Shift`
--
ALTER TABLE `Room_Shift`
  MODIFY `room_shift_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Shift`
--
ALTER TABLE `Shift`
  MODIFY `shift_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Tickets`
--
ALTER TABLE `Tickets`
  MODIFY `ticket_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Waiter`
--
ALTER TABLE `Waiter`
  MODIFY `waiter_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
