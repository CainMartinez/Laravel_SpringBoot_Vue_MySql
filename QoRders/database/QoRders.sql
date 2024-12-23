-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: mysql_container
-- Tiempo de generación: 11-12-2024 a las 22:55:58
-- Versión del servidor: 8.0.40
-- Versión de PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;

SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;
/*!40101 SET NAMES utf8mb4 */
;

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
    `status` enum(
        'Pending',
        'Confirmed',
        'InProgress',
        'Completed'
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
    `notes` text,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Booking_Waiter`
--

CREATE TABLE `Booking_Waiter` (
    `booking_waiter_id` int NOT NULL,
    `booking_waiter_uuid` char(36) NOT NULL,
    `booking_id` int NOT NULL,
    `waiter_id` int NOT NULL,
    `role` enum('Lead', 'Support') DEFAULT 'Support',
    `notes` text,
    `assigned_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Customer`
--

INSERT INTO
    `Customer` (
        `customer_id`,
        `customer_uuid`,
        `first_name`,
        `last_name`,
        `age`,
        `address`,
        `email`,
        `phone_number`,
        `password`,
        `avatar_url`,
        `bio`,
        `has_coupon`,
        `loyalty_points`,
        `is_active`,
        `is_seated`,
        `refresh_token`,
        `created_at`,
        `updated_at`
    )
VALUES (
        21,
        '394e3a53-3c2c-4132-9b10-4a757a4efac4',
        'Yolanda',
        'Yolanda',
        NULL,
        NULL,
        'yomogan@gmail.com',
        NULL,
        '$argon2id$v=19$m=4096,t=3,p=1$LlZawwwdCHzz1ztxqNBNQg$eXlXClwlNahzjzpE8iP8GWOcY2tcohFIPZstJ0HHm1Q',
        'https://i.pravatar.cc/150?u=Yolanda',
        NULL,
        0,
        0,
        1,
        0,
        NULL,
        '2024-12-11 22:38:47',
        '2024-12-11 22:38:47'
    );

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Donations`
--

CREATE TABLE `Donations` (
    `donation_id` int NOT NULL,
    `customer_username` varchar(255) NOT NULL,
    `quantity` decimal(10, 2) NOT NULL,
    `ngo_slug` varchar(255) NOT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
    `salary` decimal(10, 2) DEFAULT '3000.00',
    `is_active` tinyint(1) DEFAULT '1',
    `bio` text,
    `avatar_url` text,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Manager`
--

INSERT INTO
    `Manager` (
        `manager_id`,
        `manager_uuid`,
        `firstName`,
        `lastName`,
        `email`,
        `password`,
        `phone_number`,
        `address`,
        `salary`,
        `is_active`,
        `bio`,
        `avatar_url`,
        `created_at`,
        `updated_at`
    )
VALUES (
        4,
        '5a7dc3c4-0c4f-4e58-9d6d-9891001e29e2',
        'Yolanda',
        'Yolanda',
        'yomogan@gmail.com',
        '$argon2i$v=19$m=65536,t=4,p=2$MHNlajQzSm5sdUpJbnVqeQ$HlSX+aeCSSju7FSADXNbivXApitNpty4BeduU8mou1c',
        NULL,
        NULL,
        3000.00,
        1,
        NULL,
        'https://i.pravatar.cc/300?u=de76af6dc1a4d90e3d02c61e013d0175',
        '2024-12-11 22:39:37',
        '2024-12-11 22:39:37'
    );

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
    `total_donations` decimal(10, 2) DEFAULT '0.00',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `NGO`
--

INSERT INTO
    `NGO` (
        `ngo_id`,
        `ngo_uuid`,
        `ngo_name`,
        `ngo_slug`,
        `description`,
        `country`,
        `email`,
        `phone_number`,
        `website_url`,
        `logo_url`,
        `image_url`,
        `description_img_url`,
        `is_active`,
        `total_donations`,
        `created_at`,
        `updated_at`
    )
VALUES (
        1,
        'bfe0dd93-a383-11ef-a437-0242ac140002',
        'Sakura Foundation',
        'Sakura_Foundation_123456',
        'La Sakura Foundation está dedicada a preservar el patrimonio cultural japonés y apoyar a las comunidades desfavorecidas. Fundada en 1995, ha trabajado incansablemente para promover la educación y la cultura japonesa en todo el mundo.; La fundación organiza eventos culturales, talleres educativos y programas de intercambio para jóvenes. Además, proporciona becas a estudiantes de bajos recursos para que puedan continuar sus estudios. Su misión es crear un puente entre Japón y el resto del mundo, fomentando el entendimiento y la cooperación internacional.',
        'Japón',
        'contact@sakurafoundation.jp',
        '+81345678901',
        'https://www.sakurafoundation.jp',
        '/src/assets/ngos/SakuraFoundation_01.webp',
        '/src/assets/ngos/SakuraFoundation_03.webp',
        '/src/assets/ngos/SakuraFoundation_02.webp',
        1,
        1500.00,
        '2024-11-15 18:59:32',
        '2024-11-15 18:59:32'
    ),
    (
        2,
        'bfe0e287-a383-11ef-a437-0242ac140002',
        'Helping Hands India',
        'Helping_Hands_India_375839',
        'Helping Hands India se centra en la educación y la atención médica para niños desfavorecidos en India. Desde su creación en 2001, ha impactado positivamente en la vida de miles de niños.; La organización ofrece programas de tutoría, clínicas móviles y campañas de concienciación sobre la salud. También colabora con escuelas locales para mejorar la infraestructura educativa y proporcionar materiales de estudio. Su objetivo es romper el ciclo de pobreza a través de la educación y la salud.',
        'India',
        'info@helpinghands.in',
        '+911234567890',
        'https://www.helpinghandsindia.org',
        '/src/assets/ngos/HelpingHandsIndia_01.webp',
        '/src/assets/ngos/HelpingHandsIndia_03.webp',
        '/src/assets/ngos/HelpingHandsIndia_02.webp',
        1,
        2400.00,
        '2024-11-15 18:59:32',
        '2024-11-15 18:59:32'
    ),
    (
        3,
        'bfe0e439-a383-11ef-a437-0242ac140002',
        'Solidaridad Española',
        'Solidaridad_Española_740284',
        'Solidaridad Española promueve la inclusión social y proporciona ayuda a comunidades marginadas en España. Desde su fundación en 1987, ha trabajado en proyectos de integración y apoyo social.; La organización ofrece servicios de asesoramiento legal, apoyo psicológico y programas de formación laboral. También organiza actividades recreativas y culturales para fomentar la cohesión social. Su misión es construir una sociedad más justa e inclusiva.',
        'España',
        'solidaridad@espanola.es',
        '+34912345678',
        'https://www.solidaridadespanola.org',
        '/src/assets/ngos/SolidaridadEspanyola_01.webp',
        '/src/assets/ngos/SolidaridadEspanyola_03.webp',
        '/src/assets/ngos/SolidaridadEspanyola_02.webp',
        1,
        1800.00,
        '2024-11-15 18:59:32',
        '2024-11-15 18:59:32'
    ),
    (
        4,
        'bfe0e52b-a383-11ef-a437-0242ac140002',
        'Amici della Vita',
        'Amici_della_Vita_982023',
        'Amici della Vita apoya a familias y niños necesitados, enfocándose en la educación y la atención médica en Italia. Desde 1990, ha proporcionado recursos esenciales a comunidades vulnerables.; La organización gestiona centros comunitarios, clínicas de salud y programas de apoyo escolar. También trabaja en la sensibilización sobre la importancia de la educación y la salud. Su visión es garantizar que todos los niños tengan acceso a una vida digna y saludable.',
        'Italia',
        'info@amicivita.it',
        '+390123456789',
        'https://www.amicidellavita.it',
        '/src/assets/ngos/AmiciDellaVita_01.webp',
        '/src/assets/ngos/AmiciDellaVita_03.webp',
        '/src/assets/ngos/AmiciDellaVita_02.webp',
        1,
        2000.00,
        '2024-11-15 18:59:32',
        '2024-11-15 18:59:32'
    ),
    (
        5,
        'bfe0e635-a383-11ef-a437-0242ac140002',
        'Manos Unidas México',
        'Manos_Unidas_México_954623',
        'Manos Unidas México proporciona apoyo para programas de desarrollo rural y educación en México. Desde su creación en 1998, ha trabajado para mejorar la calidad de vida en comunidades rurales.; La organización implementa proyectos de agricultura sostenible, acceso a agua potable y educación básica. También colabora con gobiernos locales y otras ONGs para maximizar el impacto de sus programas. Su misión es empoderar a las comunidades rurales para que puedan alcanzar un desarrollo sostenible.',
        'México',
        'contacto@manosunidas.mx',
        '+525512345678',
        'https://www.manosunidasmexico.org',
        '/src/assets/ngos/ManosUnidasMexico_01.webp',
        '/src/assets/ngos/ManosUnidasMexico_03.webp',
        '/src/assets/ngos/ManosUnidasMexico_02.webp',
        1,
        2300.00,
        '2024-11-15 18:59:32',
        '2024-11-15 18:59:32'
    ),
    (
        6,
        'bfe0e6dd-a383-11ef-a437-0242ac140002',
        'Hope for Türkiye',
        'Hope_for_Türkiye_468134',
        'Hope for Türkiye ofrece ayuda en casos de desastre y apoya proyectos de reconstrucción comunitaria en Turquía. Desde su fundación en 2005, ha sido un pilar en la respuesta a emergencias.; La organización proporciona refugio, alimentos y atención médica a las víctimas de desastres naturales. También trabaja en proyectos de reconstrucción y desarrollo comunitario a largo plazo. Su objetivo es ayudar a las comunidades a recuperarse y reconstruir sus vidas después de una crisis.',
        'Turquía',
        'support@hopeforturkiye.tr',
        '+905312345678',
        'https://www.hopeforturkiye.org',
        '/src/assets/ngos/HopeForTurkikye_01.webp',
        '/src/assets/ngos/HopeForTurkikye_03.webp',
        '/src/assets/ngos/HopeForTurkikye_02.webp',
        1,
        2200.00,
        '2024-11-15 18:59:32',
        '2024-11-15 18:59:32'
    );

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Orders`
--

CREATE TABLE `Orders` (
    `order_id` int NOT NULL,
    `order_uuid` char(36) NOT NULL,
    `booking_id` int NOT NULL,
    `is_active` tinyint(1) DEFAULT '1',
    `order_status` enum(
        'Waiting',
        'Assigned',
        'Delivered'
    ) NOT NULL DEFAULT 'Waiting',
    `payment_status` enum('Paid', 'Unpaid') NOT NULL DEFAULT 'Unpaid',
    `total_amount` decimal(10, 2) NOT NULL,
    `notes` text,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
    `is_delivered` BOOLEAN DEFAULT FALSE,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
    `unit_price` decimal(10, 2) NOT NULL,
    `allergens` text,
    `stock` int DEFAULT '0',
    `image_url` text,
    `product_type` enum(
        'Starter',
        'Main Course',
        'Dessert',
        'Drink',
        'Other'
    ) NOT NULL,
    `origin` varchar(100) NOT NULL,
    `is_active` tinyint(1) DEFAULT '1',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Products`
--

INSERT INTO
    `Products` (
        `product_id`,
        `product_uuid`,
        `product_name`,
        `product_slug`,
        `description`,
        `unit_price`,
        `allergens`,
        `stock`,
        `image_url`,
        `product_type`,
        `origin`,
        `is_active`,
        `created_at`,
        `updated_at`
    )
VALUES (
        1,
        'e35412ac-a383-11ef-a437-0242ac140002',
        'Croquetas de Jamón',
        'Croquetas_de_Jamón_258103',
        'Deliciosas croquetas caseras rellenas de jamón serrano.',
        5.50,
        'Gluten, Lactosa',
        100,
        '/src/assets/products/spain/CroquetasDeJamon.webp',
        'Starter',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        2,
        'e3541600-a383-11ef-a437-0242ac140002',
        'Tortilla Española',
        'Tortilla_Española_161382',
        'Clásica tortilla de patatas con cebolla caramelizada.',
        4.50,
        'Huevo',
        50,
        '/src/assets/products/spain/TortillaEspanola.webp',
        'Starter',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        3,
        'e35416be-a383-11ef-a437-0242ac140002',
        'Pan con Tomate',
        'Pan_con_Tomate_190974',
        'Rebanadas de pan crujiente con tomate rallado y aceite de oliva.',
        3.00,
        'Gluten',
        150,
        '/src/assets/products/spain/PanConTomate.webp',
        'Starter',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        4,
        'e3541704-a383-11ef-a437-0242ac140002',
        'Gambas al Ajillo',
        'Gambas_al_Ajillo_469576',
        'Gambas salteadas con ajo, aceite de oliva y guindilla.',
        7.00,
        'Mariscos',
        30,
        '/src/assets/products/spain/GambasAlAjillo.webp',
        'Starter',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        5,
        'e354173c-a383-11ef-a437-0242ac140002',
        'Pimientos de Padrón',
        'Pimientos_de_Padrón_662718',
        'Pimientos verdes pequeños fritos, algunos picantes.',
        5.00,
        NULL,
        80,
        '/src/assets/products/spain/PimientosDePadron.webp',
        'Starter',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        6,
        'e35417c3-a383-11ef-a437-0242ac140002',
        'Paella Valenciana',
        'Paella_Valenciana_448734',
        'Tradicional paella con pollo, conejo, y verduras frescas.',
        15.00,
        'Gluten, Mariscos',
        40,
        '/src/assets/products/spain/PaellaValenciana.webp',
        'Main Course',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        7,
        'e3541801-a383-11ef-a437-0242ac140002',
        'Cocido Madrileño',
        'Cocido_Madrileño_758697',
        'Guiso tradicional con garbanzos, carne y embutidos.',
        12.00,
        NULL,
        25,
        '/src/assets/products/spain/CocidoMadrileno.webp',
        'Main Course',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        8,
        'e354183a-a383-11ef-a437-0242ac140002',
        'Fabada Asturiana',
        'Fabada_Asturiana_166836',
        'Plato típico asturiano con fabes, chorizo, y morcilla.',
        13.50,
        NULL,
        20,
        '/src/assets/products/spain/FabadaAsturiana.webp',
        'Main Course',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        9,
        'e35418a3-a383-11ef-a437-0242ac140002',
        'Bacalao al Pil-Pil',
        'Bacalao_al_Pil-Pil_517100',
        'Bacalao cocinado en una salsa de ajo, aceite de oliva y guindilla.',
        14.00,
        'Pescado',
        30,
        '/src/assets/products/spain/BacalaoAlPilPil.webp',
        'Main Course',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        10,
        'e35418d8-a383-11ef-a437-0242ac140002',
        'Pollo al Chilindrón',
        'Pollo_al_Chilindrón_013665',
        'Pollo cocido en salsa de pimientos, tomate y jamón.',
        11.00,
        NULL,
        50,
        '/src/assets/products/spain/PolloAlChilindron.webp',
        'Main Course',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        11,
        'e354190a-a383-11ef-a437-0242ac140002',
        'Tarta de Santiago',
        'Tarta_de_Santiago_536333',
        'Tarta de almendras con azúcar glas y un toque de limón.',
        5.00,
        'Frutos Secos, Huevo',
        60,
        '/src/assets/products/spain/TartaDeSantiago.webp',
        'Dessert',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        12,
        'e3541956-a383-11ef-a437-0242ac140002',
        'Flan Casero',
        'Flan_Casero_115207',
        'Flan de huevo y leche con caramelo líquido.',
        4.00,
        'Lactosa, Huevo',
        80,
        '/src/assets/products/spain/FlanCasero.webp',
        'Dessert',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        13,
        'e35419d2-a383-11ef-a437-0242ac140002',
        'Churros con Chocolate',
        'Churros_con_Chocolate_823226',
        'Churros crujientes acompañados de chocolate caliente.',
        6.00,
        'Gluten',
        100,
        '/src/assets/products/spain/ChurrosConChocolate.webp',
        'Dessert',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        14,
        'e3541a13-a383-11ef-a437-0242ac140002',
        'Natillas',
        'Natillas_053910',
        'Postre cremoso con leche, huevo y canela.',
        3.50,
        'Lactosa, Huevo',
        70,
        '/src/assets/products/spain/Natillas.webp',
        'Dessert',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        15,
        'e3541a42-a383-11ef-a437-0242ac140002',
        'Arroz con Leche',
        'Arroz_con_Leche_188108',
        'Arroz cocido en leche con canela y ralladura de limón.',
        4.50,
        'Lactosa',
        50,
        '/src/assets/products/spain/ArrozConLeche.webp',
        'Dessert',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        16,
        'e3541a9e-a383-11ef-a437-0242ac140002',
        'Sangría',
        'Sangría_697570',
        'Refrescante mezcla de vino tinto, frutas y soda.',
        7.00,
        'Sulfitos',
        30,
        '/src/assets/products/spain/Sangria.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        17,
        'e3541add-a383-11ef-a437-0242ac140002',
        'Cerveza Artesanal',
        'Cerveza_Artesanal_847397',
        'Cerveza española elaborada artesanalmente.',
        5.00,
        'Gluten, Sulfitos',
        100,
        '/src/assets/products/spain/CervezaArtesanal.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        18,
        'e3541b09-a383-11ef-a437-0242ac140002',
        'Tinto de Verano',
        'Tinto_de_Verano_489230',
        'Bebida refrescante de vino tinto con gaseosa.',
        6.00,
        'Sulfitos',
        40,
        '/src/assets/products/spain/TintoDeVerano.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        19,
        'e3541b74-a383-11ef-a437-0242ac140002',
        'Sidra',
        'Sidra_597649',
        'Sidra asturiana de manzana.',
        3.50,
        NULL,
        200,
        '/src/assets/products/spain/Sidra.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        20,
        'e3541bb1-a383-11ef-a437-0242ac140002',
        'Cava',
        'Cava_628159',
        'Vino espumoso catalán ideal para celebraciones.',
        10.00,
        'Sulfitos',
        20,
        '/src/assets/products/spain/Cava.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 19:00:32',
        '2024-11-15 19:00:32'
    ),
    (
        21,
        '149c39a0-a396-11ef-a437-0242ac140002',
        'Edamame',
        'Edamame_291334',
        'Judías de soja al vapor con sal marina.',
        4.50,
        'Soja',
        100,
        '/src/assets/products/japan/Edamame.webp',
        'Starter',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        22,
        '149c3e1c-a396-11ef-a437-0242ac140002',
        'Gyozas',
        'Gyozas_191918',
        'Empanadillas japonesas rellenas de carne y verduras.',
        6.50,
        'Gluten',
        80,
        '/src/assets/products/japan/Gyozas.webp',
        'Starter',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        23,
        '149c3ea5-a396-11ef-a437-0242ac140002',
        'Sunomono',
        'Sunomono_527815',
        'Ensalada japonesa de pepino con vinagre de arroz.',
        5.00,
        NULL,
        70,
        '/src/assets/products/japan/Sunomono.webp',
        'Starter',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        24,
        '149c3eef-a396-11ef-a437-0242ac140002',
        'Takoyaki',
        'Takoyaki_522903',
        'Bolas de masa rellenas de pulpo, con salsa takoyaki y copos de bonito.',
        7.00,
        'Gluten, Mariscos',
        50,
        '/src/assets/products/japan/Takoyaki.webp',
        'Starter',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        25,
        '149c3f49-a396-11ef-a437-0242ac140002',
        'Agedashi Tofu',
        'Agedashi_Tofu_640037',
        'Tofu frito servido con caldo dashi.',
        6.00,
        'Soja, Gluten',
        60,
        '/src/assets/products/japan/AgedashiTofu.webp',
        'Starter',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        26,
        '149c3f8c-a396-11ef-a437-0242ac140002',
        'Sushi Variado',
        'Sushi_Variado_881366',
        'Selección de nigiri, maki y sashimi fresco.',
        18.00,
        'Pescado, Soja, Gluten',
        30,
        '/src/assets/products/japan/SushiVariado.webp',
        'Main Course',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        27,
        '149c4033-a396-11ef-a437-0242ac140002',
        'Ramen',
        'Ramen_117235',
        'Sopa de fideos con caldo de cerdo, huevo y cebolleta.',
        12.00,
        'Gluten, Huevo',
        40,
        '/src/assets/products/japan/Ramen.webp',
        'Main Course',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        28,
        '149c4074-a396-11ef-a437-0242ac140002',
        'Katsu Curry',
        'Katsu_Curry_198201',
        'Cerdo empanado servido con curry japonés y arroz.',
        14.00,
        'Gluten',
        30,
        '/src/assets/products/japan/KatsuCurry.webp',
        'Main Course',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        29,
        '149c40aa-a396-11ef-a437-0242ac140002',
        'Okonomiyaki',
        'Okonomiyaki_085069',
        'Tortilla japonesa con col, carne y salsa okonomiyaki.',
        10.00,
        'Gluten, Huevo',
        50,
        '/src/assets/products/japan/Okonomiyaki.webp',
        'Main Course',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        30,
        '149c40db-a396-11ef-a437-0242ac140002',
        'Unagi Don',
        'Unagi_Don_859285',
        'Anguila a la parrilla servida sobre arroz.',
        16.00,
        'Pescado, Soja',
        25,
        '/src/assets/products/japan/UnagiDon.webp',
        'Main Course',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        31,
        '149c410c-a396-11ef-a437-0242ac140002',
        'Mochi',
        'Mochi_644538',
        'Dulces de arroz glutinoso rellenos de helado.',
        5.00,
        'Soja',
        70,
        '/src/assets/products/japan/Mochi.webp',
        'Dessert',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        32,
        '149c4144-a396-11ef-a437-0242ac140002',
        'Dorayaki',
        'Dorayaki_491684',
        'Tortitas rellenas de crema de judía roja.',
        4.50,
        'Gluten',
        80,
        '/src/assets/products/japan/Dorayaki.webp',
        'Dessert',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        33,
        '149c4176-a396-11ef-a437-0242ac140002',
        'Matcha Ice Cream',
        'Matcha_Ice_Cream_675058',
        'Helado de té verde matcha.',
        6.00,
        'Lactosa',
        50,
        '/src/assets/products/japan/MatchaIceCream.webp',
        'Dessert',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        34,
        '149c41af-a396-11ef-a437-0242ac140002',
        'Anmitsu',
        'Anmitsu_596536',
        'Postre de gelatina agar con frutas y jarabe dulce.',
        7.00,
        NULL,
        40,
        '/src/assets/products/japan/Anmitsu.webp',
        'Dessert',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        35,
        '149c41e4-a396-11ef-a437-0242ac140002',
        'Taiyaki',
        'Taiyaki_122373',
        'Pastel en forma de pez relleno de crema de judía roja.',
        5.50,
        'Gluten',
        60,
        '/src/assets/products/japan/Taiyaki.webp',
        'Dessert',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        36,
        '149c4219-a396-11ef-a437-0242ac140002',
        'Sake',
        'Sake_339717',
        'Bebida alcohólica tradicional de arroz fermentado.',
        10.00,
        NULL,
        30,
        '/src/assets/products/japan/Sake.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        37,
        '149c4275-a396-11ef-a437-0242ac140002',
        'Té Verde',
        'Té_Verde_080732',
        'Infusión tradicional japonesa, servida caliente.',
        3.50,
        NULL,
        100,
        '/src/assets/products/japan/TeVerde.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        38,
        '149c42e5-a396-11ef-a437-0242ac140002',
        'Ramune',
        'Ramune_819440',
        'Refresco japonés con un toque dulce y burbujeante.',
        4.00,
        NULL,
        80,
        '/src/assets/products/japan/Ramune.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        39,
        '149c4352-a396-11ef-a437-0242ac140002',
        'Shochu',
        'Shochu_533163',
        'Bebida alcohólica destilada, típica en Japón.',
        8.00,
        NULL,
        20,
        '/src/assets/products/japan/Shochu.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        40,
        '149c438e-a396-11ef-a437-0242ac140002',
        'Umeshu',
        'Umeshu_612413',
        'Licor dulce japonés elaborado con ciruelas.',
        9.00,
        NULL,
        25,
        '/src/assets/products/japan/Umeshu.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:10:45',
        '2024-11-15 21:10:45'
    ),
    (
        41,
        '240f80df-a396-11ef-a437-0242ac140002',
        'Guacamole con Totopos',
        'Guacamole_con_Totopos_521933',
        'Crema de aguacate servida con totopos crujientes.',
        5.50,
        NULL,
        100,
        '/src/assets/products/mexico/GuacamoleConTotopos.webp',
        'Starter',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        42,
        '240f841a-a396-11ef-a437-0242ac140002',
        'Sopes',
        'Sopes_916282',
        'Pequeñas bases de maíz con frijoles, carne y queso.',
        6.00,
        'Gluten, Lactosa',
        80,
        '/src/assets/products/mexico/Sopes.webp',
        'Starter',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        43,
        '240f84a4-a396-11ef-a437-0242ac140002',
        'Tostadas de Tinga',
        'Tostadas_de_Tinga_624830',
        'Tostadas de maíz cubiertas con tinga de pollo.',
        7.00,
        'Gluten',
        70,
        '/src/assets/products/mexico/TostadasDeTinga.webp',
        'Starter',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        44,
        '240f84f1-a396-11ef-a437-0242ac140002',
        'Quesadillas',
        'Quesadillas_015572',
        'Tortillas de maíz rellenas de queso derretido.',
        5.00,
        'Lactosa, Gluten',
        90,
        '/src/assets/products/mexico/Quesadillas.webp',
        'Starter',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        45,
        '240f8598-a396-11ef-a437-0242ac140002',
        'Ceviche Mexicano',
        'Ceviche_Mexicano_207682',
        'Mariscos frescos marinados con limón, tomate y cilantro.',
        8.00,
        'Mariscos',
        50,
        '/src/assets/products/mexico/CevicheMexicano.webp',
        'Starter',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        46,
        '240f85e2-a396-11ef-a437-0242ac140002',
        'Tacos al Pastor',
        'Tacos_al_Pastor_509978',
        'Tacos de cerdo adobado servidos con piña y cilantro.',
        10.00,
        'Gluten',
        100,
        '/src/assets/products/mexico/TacosAlPastor.webp',
        'Main Course',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        47,
        '240f8621-a396-11ef-a437-0242ac140002',
        'Enchiladas Verdes',
        'Enchiladas_Verdes_674418',
        'Tortillas rellenas de pollo bañadas en salsa verde.',
        11.50,
        'Gluten, Lactosa',
        80,
        '/src/assets/products/mexico/EnchiladasVerdes.webp',
        'Main Course',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        48,
        '240f865e-a396-11ef-a437-0242ac140002',
        'Pozole Rojo',
        'Pozole_Rojo_428890',
        'Sopa tradicional con maíz, carne de cerdo y chile.',
        12.00,
        NULL,
        60,
        '/src/assets/products/mexico/PozoleRojo.webp',
        'Main Course',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        49,
        '240f86fa-a396-11ef-a437-0242ac140002',
        'Chiles en Nogada',
        'Chiles_en_Nogada_372947',
        'Pimientos rellenos de carne y frutas, cubiertos con salsa de nuez.',
        14.00,
        'Frutos Secos, Lactosa',
        40,
        '/src/assets/products/mexico/ChilesEnNogada.webp',
        'Main Course',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        50,
        '240fde8a-a396-11ef-a437-0242ac140002',
        'Mole Poblano',
        'Mole_Poblano_182690',
        'Pollo cubierto con mole de chiles, especias y chocolate.',
        13.50,
        'Frutos Secos',
        50,
        '/src/assets/products/mexico/MolePoblano.webp',
        'Main Course',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        51,
        '240fdeef-a396-11ef-a437-0242ac140002',
        'Flan Napolitano',
        'Flan_Napolitano_116927',
        'Postre cremoso de leche, huevos y caramelo.',
        4.50,
        'Lactosa, Huevo',
        80,
        '/src/assets/products/mexico/FlanNapolitano.webp',
        'Dessert',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        52,
        '240fdf34-a396-11ef-a437-0242ac140002',
        'Arroz con Leche',
        'Arroz_con_Leche_203478',
        'Arroz cocido en leche con canela y azúcar.',
        4.00,
        'Lactosa',
        100,
        '/src/assets/products/mexico/ArrozConLeche.webp',
        'Dessert',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        53,
        '240fdfcd-a396-11ef-a437-0242ac140002',
        'Buñuelos',
        'Buñuelos_890233',
        'Postres fritos espolvoreados con azúcar y canela.',
        3.50,
        'Gluten',
        90,
        '/src/assets/products/mexico/Bunuelos.webp',
        'Dessert',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        54,
        '240fe00b-a396-11ef-a437-0242ac140002',
        'Tres Leches',
        'Tres_Leches_177952',
        'Bizcocho empapado en tres tipos de leche.',
        5.00,
        'Lactosa, Gluten',
        70,
        '/src/assets/products/mexico/TresLeches.webp',
        'Dessert',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        55,
        '240fe042-a396-11ef-a437-0242ac140002',
        'Capirotada',
        'Capirotada_612493',
        'Postre tradicional de pan, miel, frutas y queso.',
        4.50,
        'Lactosa, Gluten',
        50,
        '/src/assets/products/mexico/Capirotada.webp',
        'Dessert',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        56,
        '240fe07b-a396-11ef-a437-0242ac140002',
        'Agua de Horchata',
        'Agua_de_Horchata_417680',
        'Bebida dulce hecha de arroz, leche y canela.',
        3.00,
        'Lactosa',
        100,
        '/src/assets/products/mexico/AguaDeHorchata.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        57,
        '240fe0b1-a396-11ef-a437-0242ac140002',
        'Margarita',
        'Margarita_832109',
        'Cóctel clásico de tequila, lima y sal.',
        8.00,
        NULL,
        50,
        '/src/assets/products/mexico/Margarita.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        58,
        '240fe0e8-a396-11ef-a437-0242ac140002',
        'Tequila',
        'Tequila_728963',
        'Licor tradicional destilado de agave.',
        10.00,
        NULL,
        60,
        '/src/assets/products/mexico/Tequila.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        59,
        '240fe120-a396-11ef-a437-0242ac140002',
        'Michelada',
        'Michelada_934620',
        'Cerveza preparada con limón, salsas y especias.',
        6.50,
        'Gluten',
        70,
        '/src/assets/products/mexico/Michelada.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        60,
        '240fe15e-a396-11ef-a437-0242ac140002',
        'Champurrado',
        'Champurrado_654871',
        'Bebida caliente de chocolate y masa de maíz.',
        4.50,
        'Lactosa',
        80,
        '/src/assets/products/mexico/Champurrado.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:11:11',
        '2024-11-15 21:11:11'
    ),
    (
        61,
        '38d20a17-a396-11ef-a437-0242ac140002',
        'Bruschetta',
        'Bruschetta_149683',
        'Rebanadas de pan tostado con tomate, albahaca y aceite de oliva.',
        4.50,
        'Gluten',
        100,
        '/src/assets/products/italy/Bruschetta.webp',
        'Starter',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        62,
        '38d20e7a-a396-11ef-a437-0242ac140002',
        'Carpaccio de Ternera',
        'Carpaccio_de_Ternera_861273',
        'Láminas finas de ternera cruda con rúcula, parmesano y aceite de oliva.',
        7.00,
        'Lactosa',
        60,
        '/src/assets/products/italy/CarpaccioDeTernera.webp',
        'Starter',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        63,
        '38d20f24-a396-11ef-a437-0242ac140002',
        'Caprese',
        'Caprese_502367',
        'Ensalada de tomate, mozzarella fresca y albahaca.',
        6.00,
        'Lactosa',
        80,
        '/src/assets/products/italy/Caprese.webp',
        'Starter',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        64,
        '38d20f71-a396-11ef-a437-0242ac140002',
        'Arancini',
        'Arancini_490712',
        'Bolas de arroz rellenas de queso y fritas.',
        5.50,
        'Gluten, Lactosa',
        70,
        '/src/assets/products/italy/Arancini.webp',
        'Starter',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        65,
        '38d20fba-a396-11ef-a437-0242ac140002',
        'Antipasto',
        'Antipasto_194235',
        'Selección de embutidos, quesos y aceitunas.',
        8.00,
        'Lactosa',
        50,
        '/src/assets/products/italy/Antipasto.webp',
        'Starter',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        66,
        '38d20ff8-a396-11ef-a437-0242ac140002',
        'Pizza Margherita',
        'Pizza_Margherita_745612',
        'Pizza clásica con tomate, mozzarella y albahaca.',
        10.00,
        'Gluten, Lactosa',
        100,
        '/src/assets/products/italy/PizzaMargherita.webp',
        'Main Course',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        67,
        '38d21037-a396-11ef-a437-0242ac140002',
        'Spaghetti Carbonara',
        'Spaghetti_Carbonara_839410',
        'Pasta con salsa de huevo, panceta y queso pecorino.',
        11.50,
        'Gluten, Lactosa',
        80,
        '/src/assets/products/italy/SpaghettiCarbonara.webp',
        'Main Course',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        68,
        '38d21073-a396-11ef-a437-0242ac140002',
        'Lasagna',
        'Lasagna_638902',
        'Capa de pasta, carne y bechamel horneada con queso.',
        12.00,
        'Gluten, Lactosa',
        70,
        '/src/assets/products/italy/Lasagna.webp',
        'Main Course',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        69,
        '38d210dc-a396-11ef-a437-0242ac140002',
        'Risotto de Setas',
        'Risotto_de_Setas_019834',
        'Arroz cremoso cocinado con setas y parmesano.',
        13.00,
        'Lactosa',
        50,
        '/src/assets/products/italy/RisottoDeSetas.webp',
        'Main Course',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        70,
        '38d2115b-a396-11ef-a437-0242ac140002',
        'Pollo a la Parmesana',
        'Pollo_a_la_Parmesana_674523',
        'Pechuga de pollo empanada con salsa de tomate y queso.',
        14.00,
        'Gluten, Lactosa',
        40,
        '/src/assets/products/italy/PolloALaParmesana.webp',
        'Main Course',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        71,
        '38d211e6-a396-11ef-a437-0242ac140002',
        'Tiramisú',
        'Tiramisú_378924',
        'Postre de capas de bizcocho, café y crema de mascarpone.',
        5.50,
        'Lactosa, Gluten',
        70,
        '/src/assets/products/italy/Tiramisu.webp',
        'Dessert',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        72,
        '38d2135e-a396-11ef-a437-0242ac140002',
        'Panna Cotta',
        'Panna_Cotta_590834',
        'Postre cremoso de nata con coulis de frutas.',
        4.50,
        'Lactosa',
        80,
        '/src/assets/products/italy/PannaCotta.webp',
        'Dessert',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        73,
        '38d213bd-a396-11ef-a437-0242ac140002',
        'Cannoli',
        'Cannoli_284762',
        'Rollo de masa crujiente relleno de ricotta y fruta confitada.',
        5.00,
        'Lactosa, Gluten',
        60,
        '/src/assets/products/italy/Cannoli.webp',
        'Dessert',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        74,
        '38d21474-a396-11ef-a437-0242ac140002',
        'Gelato de Pistacho',
        'Gelato_de_Pistacho_481905',
        'Helado artesanal de pistacho.',
        6.00,
        'Lactosa, Frutos Secos',
        50,
        '/src/assets/products/italy/GelatoDePistacho.webp',
        'Dessert',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        75,
        '38d214b1-a396-11ef-a437-0242ac140002',
        'Zabaglione',
        'Zabaglione_193847',
        'Crema de yema de huevo con vino Marsala.',
        5.00,
        'Huevo, Alcohol',
        40,
        '/src/assets/products/italy/Zabaglione.webp',
        'Dessert',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        76,
        '38d214ec-a396-11ef-a437-0242ac140002',
        'Espresso',
        'Espresso_283649',
        'Café concentrado italiano.',
        2.50,
        NULL,
        100,
        '/src/assets/products/italy/Espresso.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        77,
        '38d21530-a396-11ef-a437-0242ac140002',
        'Cappuccino',
        'Cappuccino_940273',
        'Café con leche y espuma de leche.',
        3.50,
        'Lactosa',
        90,
        '/src/assets/products/italy/Cappuccino.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        78,
        '38d2156c-a396-11ef-a437-0242ac140002',
        'Aperol Spritz',
        'Aperol_Spritz_620934',
        'Cóctel refrescante de Aperol, prosecco y soda.',
        7.00,
        'Alcohol',
        60,
        '/src/assets/products/italy/AperolSpritz.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        79,
        '38d215a0-a396-11ef-a437-0242ac140002',
        'Prosecco',
        'Prosecco_834720',
        'Vino espumoso seco típico italiano.',
        9.00,
        'Sulfitos',
        50,
        '/src/assets/products/italy/Prosecco.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        80,
        '38d215d5-a396-11ef-a437-0242ac140002',
        'Limoncello',
        'Limoncello_479023',
        'Licor dulce de limón.',
        8.00,
        'Alcohol',
        40,
        '/src/assets/products/italy/Limoncello.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:11:46',
        '2024-11-15 21:11:46'
    ),
    (
        81,
        '483a138d-a396-11ef-a437-0242ac140002',
        'Hummus',
        'Hummus_746102',
        'Puré de garbanzos con tahini, ajo, y aceite de oliva.',
        4.50,
        'Sésamo',
        100,
        '/src/assets/products/turkey/Hummus.webp',
        'Starter',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        82,
        '483a1731-a396-11ef-a437-0242ac140002',
        'Dolma',
        'Dolma_529387',
        'Hojas de parra rellenas de arroz y especias.',
        5.50,
        NULL,
        80,
        '/src/assets/products/turkey/Dolma.webp',
        'Starter',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        83,
        '483a17c3-a396-11ef-a437-0242ac140002',
        'Ezme',
        'Ezme_684930',
        'Ensalada picante de tomate, pimiento y especias.',
        4.00,
        NULL,
        90,
        '/src/assets/products/turkey/Ezme.webp',
        'Starter',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        84,
        '483a181d-a396-11ef-a437-0242ac140002',
        'Lahmacun',
        'Lahmacun_138620',
        'Pizza turca con carne picada y especias.',
        6.00,
        'Gluten',
        70,
        '/src/assets/products/turkey/Lahmacun.webp',
        'Starter',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        85,
        '483a18be-a396-11ef-a437-0242ac140002',
        'Sigara Börek',
        'Sigara_Börek_843562',
        'Rollos fritos de masa rellenos de queso feta.',
        5.00,
        'Gluten, Lactosa',
        100,
        '/src/assets/products/turkey/SigaraBorek.webp',
        'Starter',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        86,
        '483a85b2-a396-11ef-a437-0242ac140002',
        'Kebab de Cordero',
        'Kebab_de__Cordero_908412',
        'Cordero marinado y asado al estilo tradicional.',
        12.50,
        NULL,
        60,
        '/src/assets/products/turkey/KebabDeCordero.webp',
        'Main Course',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        87,
        '483a8650-a396-11ef-a437-0242ac140002',
        'Manti',
        'Manti_264953',
        'Raviolis turcos rellenos de carne, servidos con yogur y especias.',
        11.00,
        'Gluten, Lactosa',
        70,
        '/src/assets/products/turkey/Manti.webp',
        'Main Course',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        88,
        '483a86a9-a396-11ef-a437-0242ac140002',
        'Pide',
        'Pide_742618',
        'Barca de pan turco rellena de queso y carne.',
        10.00,
        'Gluten, Lactosa',
        80,
        '/src/assets/products/turkey/Pide.webp',
        'Main Course',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        89,
        '483a86e9-a396-11ef-a437-0242ac140002',
        'Kuru Fasulye',
        'Kuru_Fasulye_563901',
        'Guiso de alubias blancas con tomate y carne.',
        9.50,
        NULL,
        90,
        '/src/assets/products/turkey/KuruFasulye.webp',
        'Main Course',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        90,
        '483a872d-a396-11ef-a437-0242ac140002',
        'Imam Bayildi',
        'Imam_Bayildi_380621',
        'Berenjenas rellenas de tomate, cebolla y ajo.',
        8.50,
        NULL,
        100,
        '/src/assets/products/turkey/ImamBayildi.webp',
        'Main Course',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        91,
        '483a8766-a396-11ef-a437-0242ac140002',
        'Baklava',
        'Baklava_764092',
        'Capas de masa filo con nueces y miel.',
        5.50,
        'Frutos Secos, Gluten',
        100,
        '/src/assets/products/turkey/Baklava.webp',
        'Dessert',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        92,
        '483a87ad-a396-11ef-a437-0242ac140002',
        'Künefe',
        'Künefe_582416',
        'Postre caliente de masa filo con queso y almíbar.',
        6.00,
        'Lactosa, Gluten',
        80,
        '/src/assets/products/turkey/Kunefe.webp',
        'Dessert',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        93,
        '483a87ee-a396-11ef-a437-0242ac140002',
        'Lokum',
        'Lokum_946283',
        'Dulces turcos de gelatina con sabores variados.',
        4.50,
        NULL,
        90,
        '/src/assets/products/turkey/Lokum.webp',
        'Dessert',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        94,
        '483a88a8-a396-11ef-a437-0242ac140002',
        'Sütlaç',
        'Sütlaç_105372',
        'Arroz con leche al estilo turco, con canela.',
        4.00,
        'Lactosa',
        70,
        '/src/assets/products/turkey/Sutlac.webp',
        'Dessert',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        95,
        '483a88ec-a396-11ef-a437-0242ac140002',
        'Revani',
        'Revani_498307',
        'Bizcocho de sémola bañado en almíbar.',
        4.50,
        'Gluten',
        90,
        '/src/assets/products/turkey/Revani.webp',
        'Dessert',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        96,
        '483a8920-a396-11ef-a437-0242ac140002',
        'Ayran',
        'Ayran_634821',
        'Bebida refrescante de yogur, agua y sal.',
        3.00,
        'Lactosa',
        100,
        '/src/assets/products/turkey/Ayran.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        97,
        '483a8955-a396-11ef-a437-0242ac140002',
        'Té Turco',
        'Té_Turco_371820',
        'Té negro fuerte, servido en vasos pequeños.',
        2.50,
        NULL,
        120,
        '/src/assets/products/turkey/TeTurco.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        98,
        '483a8988-a396-11ef-a437-0242ac140002',
        'Café Turco',
        'Café_Turco_285940',
        'Café preparado al estilo tradicional con posos.',
        3.50,
        NULL,
        100,
        '/src/assets/products/turkey/CafeTurco.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        99,
        '483a89bf-a396-11ef-a437-0242ac140002',
        'Raki',
        'Raki_419075',
        'Bebida alcohólica anisada, típica de Turquía.',
        7.00,
        'Alcohol',
        50,
        '/src/assets/products/turkey/Raki.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        100,
        '483a89f4-a396-11ef-a437-0242ac140002',
        'Salgam',
        'Salgam_983201',
        'Bebida de nabo fermentado, ligeramente ácida.',
        3.50,
        NULL,
        70,
        '/src/assets/products/turkey/Salgam.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:12:12',
        '2024-11-15 21:12:12'
    ),
    (
        101,
        '63e1eca9-a396-11ef-a437-0242ac140002',
        'Samosas',
        'Samosas_482901',
        'Empanadillas fritas rellenas de patata, guisantes y especias.',
        4.50,
        'Gluten',
        100,
        '/src/assets/products/india/Samosas.webp',
        'Starter',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        102,
        '63e1f01c-a396-11ef-a437-0242ac140002',
        'Pakoras',
        'Pakoras_620938',
        'Verduras rebozadas y fritas en harina de garbanzo.',
        5.00,
        'Gluten',
        80,
        '/src/assets/products/india/Pakoras.webp',
        'Starter',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        103,
        '63e1f099-a396-11ef-a437-0242ac140002',
        'Pani Puri',
        'Pani_Puri_839274',
        'Bolitas crujientes rellenas de agua especiada y chutneys.',
        6.00,
        'Gluten',
        70,
        '/src/assets/products/india/PaniPuri.webp',
        'Starter',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        104,
        '63e1f0e4-a396-11ef-a437-0242ac140002',
        'Aloo Tikki',
        'Aloo_Tikki_920374',
        'Croquetas de patata especiadas.',
        4.00,
        NULL,
        90,
        '/src/assets/products/india/AlooTikki.webp',
        'Starter',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        105,
        '63e1f133-a396-11ef-a437-0242ac140002',
        'Dhokla',
        'Dhokla_293847',
        'Pastelito salado hecho con harina de garbanzo.',
        5.50,
        NULL,
        70,
        '/src/assets/products/india/Dhokla.webp',
        'Starter',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        106,
        '63e1f175-a396-11ef-a437-0242ac140002',
        'Pollo Tikka Masala',
        'Pollo_Tikka_Masala_574829',
        'Pollo cocinado en una cremosa salsa de tomate y especias.',
        12.00,
        'Lactosa',
        80,
        '/src/assets/products/india/PolloTikkaMasala.webp',
        'Main Course',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        107,
        '63e1f1b9-a396-11ef-a437-0242ac140002',
        'Biryani',
        'Biryani_621948',
        'Arroz especiado con cordero, pollo o vegetales.',
        11.50,
        'Frutos Secos',
        60,
        '/src/assets/products/india/Biryani.webp',
        'Main Course',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        108,
        '63e1f1f9-a396-11ef-a437-0242ac140002',
        'Paneer Butter Masala',
        'Paneer_Butter_Masala_748930',
        'Queso fresco cocinado en una salsa de tomate y mantequilla.',
        10.00,
        'Lactosa',
        70,
        '/src/assets/products/india/PaneerButterMasala.webp',
        'Main Course',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        109,
        '63e1f233-a396-11ef-a437-0242ac140002',
        'Chana Masala',
        'Chana_Masala_284760',
        'Curry de garbanzos cocinado con cebolla y especias.',
        9.50,
        NULL,
        90,
        '/src/assets/products/india/ChanaMasala.webp',
        'Main Course',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        110,
        '63e1f26f-a396-11ef-a437-0242ac140002',
        'Rogan Josh',
        'Rogan_Josh_934812',
        'Curry de cordero con yogur y especias.',
        13.00,
        'Lactosa',
        50,
        '/src/assets/products/india/RoganJosh.webp',
        'Main Course',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        111,
        '63e1f2cd-a396-11ef-a437-0242ac140002',
        'Gulab Jamun',
        'Gulab_Jamun_452367',
        'Bolas de masa fritas empapadas en almíbar.',
        4.50,
        'Lactosa',
        80,
        '/src/assets/products/india/GulabJamun.webp',
        'Dessert',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        112,
        '63e1f30b-a396-11ef-a437-0242ac140002',
        'Rasgulla',
        'Rasgulla_291830',
        'Bolas de queso en almíbar ligero.',
        5.00,
        'Lactosa',
        70,
        '/src/assets/products/india/Rasgulla.webp',
        'Dessert',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        113,
        '63e1f346-a396-11ef-a437-0242ac140002',
        'Kulfi',
        'Kulfi_873924',
        'Helado tradicional indio de cardamomo y pistacho.',
        6.00,
        'Lactosa, Frutos Secos',
        60,
        '/src/assets/products/india/Kulfi.webp',
        'Dessert',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        114,
        '63e1f38f-a396-11ef-a437-0242ac140002',
        'Ladoo',
        'Ladoo_483027',
        'Dulce hecho de harina de garbanzo, ghee y azúcar.',
        4.00,
        'Lactosa',
        90,
        '/src/assets/products/india/Ladoo.webp',
        'Dessert',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        115,
        '63e1f3c7-a396-11ef-a437-0242ac140002',
        'Kheer',
        'Kheer_927634',
        'Arroz con leche especiado con cardamomo.',
        4.50,
        'Lactosa',
        70,
        '/src/assets/products/india/Kheer.webp',
        'Dessert',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        116,
        '63e1f4f3-a396-11ef-a437-0242ac140002',
        'Lassi',
        'Lassi_738495',
        'Bebida a base de yogur con sabores dulces o salados.',
        3.50,
        'Lactosa',
        100,
        '/src/assets/products/india/Lassi.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        117,
        '63e1f541-a396-11ef-a437-0242ac140002',
        'Masala Chai',
        'Masala_Chai_184920',
        'Té negro con especias, leche y azúcar.',
        3.00,
        'Lactosa',
        120,
        '/src/assets/products/india/MasalaChai.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        118,
        '63e1f577-a396-11ef-a437-0242ac140002',
        'Thandai',
        'Thandai_409283',
        'Bebida fría hecha con leche, almendras y especias.',
        5.00,
        'Lactosa, Frutos Secos',
        80,
        '/src/assets/products/india/Thandai.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        119,
        '63e1f5ab-a396-11ef-a437-0242ac140002',
        'Nimbu Pani',
        'Nimbu_Pani_738462',
        'Limonada especiada con sal negra.',
        3.50,
        NULL,
        150,
        '/src/assets/products/india/NimbuPani.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        120,
        '63e1f5e3-a396-11ef-a437-0242ac140002',
        'Filter Coffee',
        'Filter_Coffee_602394',
        'Café tradicional del sur de la India.',
        4.00,
        'Lactosa',
        70,
        '/src/assets/products/india/FilterCoffee.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:12:58',
        '2024-11-15 21:12:58'
    ),
    (
        121,
        '6f96d9e8-a396-11ef-a437-0242ac140002',
        'Agua Mineral',
        'Agua_Mineral_294615',
        'Agua embotellada pura y refrescante.',
        1.50,
        NULL,
        500,
        '/src/assets/products/genericas/AguaMineral.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        122,
        '6f96ddac-a396-11ef-a437-0242ac140002',
        'Coca-Cola',
        'Coca-Cola_758203',
        'Refresco clásico con gas.',
        2.00,
        NULL,
        400,
        '/src/assets/products/genericas/CocaCola.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        123,
        '6f96de3d-a396-11ef-a437-0242ac140002',
        'Fanta Naranja',
        'Fanta_Naranja_183592',
        'Refresco de naranja con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaNaranja.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        124,
        '6f96de8b-a396-11ef-a437-0242ac140002',
        'Fanta Limón',
        'Fanta_Limón_473829',
        'Refresco de limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaLimon.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        125,
        '6f96ded5-a396-11ef-a437-0242ac140002',
        'Sprite',
        'Sprite_840276',
        'Refresco de lima-limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/Sprite.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        126,
        '6f96df58-a396-11ef-a437-0242ac140002',
        'Tónica',
        'Tónica_526748',
        'Refresco amargo con burbujas, ideal para combinados.',
        2.50,
        NULL,
        200,
        '/src/assets/products/genericas/Tonica.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        127,
        'zz96ddac-a396-11ef-a437-0242ac140002',
        'Coca-Cola',
        'Coca-Cola_758203',
        'Refresco clásico con gas.',
        2.00,
        NULL,
        400,
        '/src/assets/products/genericas/CocaCola.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        128,
        'z196de3d-a396-11ef-a437-0242ac140002',
        'Fanta Naranja',
        'Fanta_Naranja_183592',
        'Refresco de naranja con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaNaranja.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        129,
        'z296de8b-a396-11ef-a437-0242ac140002',
        'Fanta Limón',
        'Fanta_Limón_473829',
        'Refresco de limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaLimon.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        130,
        'z396ded5-a396-11ef-a437-0242ac140002',
        'Sprite',
        'Sprite_840276',
        'Refresco de lima-limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/Sprite.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        131,
        'z496df58-a396-11ef-a437-0242ac140002',
        'Tónica',
        'Tónica_526748',
        'Refresco amargo con burbujas, ideal para combinados.',
        2.50,
        NULL,
        200,
        '/src/assets/products/genericas/Tonica.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        132,
        'z596ddac-a396-11ef-a437-0242ac140002',
        'Coca-Cola',
        'Coca-Cola_758203',
        'Refresco clásico con gas.',
        2.00,
        NULL,
        400,
        '/src/assets/products/genericas/CocaCola.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        133,
        'z696de3d-a396-11ef-a437-0242ac140002',
        'Fanta Naranja',
        'Fanta_Naranja_183592',
        'Refresco de naranja con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaNaranja.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        134,
        'z796de8b-a396-11ef-a437-0242ac140002',
        'Fanta Limón',
        'Fanta_Limón_473829',
        'Refresco de limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaLimon.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        135,
        'z896ded5-a396-11ef-a437-0242ac140002',
        'Sprite',
        'Sprite_840276',
        'Refresco de lima-limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/Sprite.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        136,
        'z996df58-a396-11ef-a437-0242ac140002',
        'Tónica',
        'Tónica_526748',
        'Refresco amargo con burbujas, ideal para combinados.',
        2.50,
        NULL,
        200,
        '/src/assets/products/genericas/Tonica.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        137,
        'xx96ddac-a396-11ef-a437-0242ac140002',
        'Coca-Cola',
        'Coca-Cola_758203',
        'Refresco clásico con gas.',
        2.00,
        NULL,
        400,
        '/src/assets/products/genericas/CocaCola.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        138,
        'x196de3d-a396-11ef-a437-0242ac140002',
        'Fanta Naranja',
        'Fanta_Naranja_183592',
        'Refresco de naranja con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaNaranja.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        139,
        'x296de8b-a396-11ef-a437-0242ac140002',
        'Fanta Limón',
        'Fanta_Limón_473829',
        'Refresco de limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaLimon.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        140,
        'x396ded5-a396-11ef-a437-0242ac140002',
        'Sprite',
        'Sprite_840276',
        'Refresco de lima-limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/Sprite.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        141,
        'x496df58-a396-11ef-a437-0242ac140002',
        'Tónica',
        'Tónica_526748',
        'Refresco amargo con burbujas, ideal para combinados.',
        2.50,
        NULL,
        200,
        '/src/assets/products/genericas/Tonica.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        142,
        'x596ddac-a396-11ef-a437-0242ac140002',
        'Coca-Cola',
        'Coca-Cola_758203',
        'Refresco clásico con gas.',
        2.00,
        NULL,
        400,
        '/src/assets/products/genericas/CocaCola.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        143,
        'x696de3d-a396-11ef-a437-0242ac140002',
        'Fanta Naranja',
        'Fanta_Naranja_183592',
        'Refresco de naranja con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaNaranja.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        144,
        'x796de8b-a396-11ef-a437-0242ac140002',
        'Fanta Limón',
        'Fanta_Limón_473829',
        'Refresco de limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaLimon.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        145,
        'x896ded5-a396-11ef-a437-0242ac140002',
        'Sprite',
        'Sprite_840276',
        'Refresco de lima-limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/Sprite.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        146,
        'x996df58-a396-11ef-a437-0242ac140002',
        'Tónica',
        'Tónica_526748',
        'Refresco amargo con burbujas, ideal para combinados.',
        2.50,
        NULL,
        200,
        '/src/assets/products/genericas/Tonica.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        147,
        'cc96ddac-a396-11ef-a437-0242ac140002',
        'Coca-Cola',
        'Coca-Cola_758203',
        'Refresco clásico con gas.',
        2.00,
        NULL,
        400,
        '/src/assets/products/genericas/CocaCola.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        148,
        'c196de3d-a396-11ef-a437-0242ac140002',
        'Fanta Naranja',
        'Fanta_Naranja_183592',
        'Refresco de naranja con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaNaranja.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        149,
        'c296de8b-a396-11ef-a437-0242ac140002',
        'Fanta Limón',
        'Fanta_Limón_473829',
        'Refresco de limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/FantaLimon.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        150,
        'c396ded5-a396-11ef-a437-0242ac140002',
        'Sprite',
        'Sprite_840276',
        'Refresco de lima-limón con gas.',
        2.00,
        NULL,
        300,
        '/src/assets/products/genericas/Sprite.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        151,
        'c496df58-a396-11ef-a437-0242ac140002',
        'Tónica',
        'Tónica_526748',
        'Refresco amargo con burbujas, ideal para combinados.',
        2.50,
        NULL,
        200,
        '/src/assets/products/genericas/Tonica.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        152,
        'c593df9c-a396-11ef-a437-0242ac140002',
        'Agua con gas',
        'Agua_con_gas_912847',
        'Agua con gas refrescante sacada directamene del Monte Fuji.',
        2.50,
        NULL,
        300,
        '/src/assets/products/genericas/AguaConGas.webp',
        'Drink',
        'Japón',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        153,
        '6f96df9c-a396-11ef-a437-0242ac140002',
        'Batido de chocolate',
        'Batido_de_chocolate_912847',
        'Bebida de chocolate con una cobertura de nata y virutas de chocolate, cacao de origen turco.',
        2.50,
        NULL,
        300,
        '/src/assets/products/genericas/BatidoDeChocolate.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        154,
        '6f96dfdc-a396-11ef-a437-0242ac140002',
        'Jugo de manzana',
        'Jugo_de_manzana_473502',
        'Jugo de Manzana natural de los mejores manzanos mediterraneos italianos.',
        2.50,
        NULL,
        300,
        '/src/assets/products/genericas/JugoDeManzana.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        155,
        '6f96e018-a396-11ef-a437-0242ac140002',
        'Jugo de naranja',
        'Jugo_de_naranja_847260',
        'Jugo de naranja natural exprimido con auténticas narajas de Valencia.',
        3.00,
        NULL,
        200,
        '/src/assets/products/genericas/JugoDeNaranja.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        156,
        'c696d9e8-a396-11ef-a437-0242ac140002',
        'Agua Mineral',
        'Agua_Mineral_294615',
        'Agua embotellada pura y refrescante.',
        1.50,
        NULL,
        500,
        '/src/assets/products/genericas/AguaMineral.webp',
        'Drink',
        'Italia',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        157,
        'c796d9e8-a396-11ef-a437-0242ac140002',
        'Agua Mineral',
        'Agua_Mineral_294615',
        'Agua embotellada pura y refrescante.',
        1.50,
        NULL,
        500,
        '/src/assets/products/genericas/AguaMineral.webp',
        'Drink',
        'España',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        158,
        'c896d9e8-a396-11ef-a437-0242ac140002',
        'Agua Mineral',
        'Agua_Mineral_294615',
        'Agua embotellada pura y refrescante.',
        1.50,
        NULL,
        500,
        '/src/assets/products/genericas/AguaMineral.webp',
        'Drink',
        'Turquía',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        159,
        'c996d9e8-a396-11ef-a437-0242ac140002',
        'Agua Mineral',
        'Agua_Mineral_294615',
        'Agua embotellada pura y refrescante.',
        1.50,
        NULL,
        500,
        '/src/assets/products/genericas/AguaMineral.webp',
        'Drink',
        'India',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    ),
    (
        160,
        'vv96d9e8-a396-11ef-a437-0242ac140002',
        'Agua Mineral',
        'Agua_Mineral_294615',
        'Agua embotellada pura y refrescante.',
        1.50,
        NULL,
        500,
        '/src/assets/products/genericas/AguaMineral.webp',
        'Drink',
        'México',
        1,
        '2024-11-15 21:13:18',
        '2024-11-15 21:13:18'
    );

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
    `average_rating` decimal(3, 2) DEFAULT '0.00',
    `image_url` text,
    `is_active` tinyint(1) DEFAULT '1',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `ngo_id` int NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Room`
--

INSERT INTO
    `Room` (
        `room_id`,
        `room_uuid`,
        `room_name`,
        `room_slug`,
        `description`,
        `theme`,
        `max_capacity`,
        `total_bookings`,
        `average_rating`,
        `image_url`,
        `is_active`,
        `created_at`,
        `updated_at`,
        `ngo_id`
    )
VALUES (
        1,
        '0abbb126-a39b-11ef-a437-0242ac140002',
        'Jardín de los Cerezos',
        'Jardin_de_los_Cerezos_781230',
        'Una sala inspirada en los paisajes japoneses, con decoración de cerezos en flor y detalles tradicionales.',
        'Japón',
        30,
        0,
        0.00,
        '/src/assets/rooms/japan.webp',
        1,
        '2024-11-15 21:46:16',
        '2024-11-15 21:46:16',
        1
    ),
    (
        2,
        '0abbbfde-a39b-11ef-a437-0242ac140002',
        'Palacio de los Maharajás',
        'Palacio_de_los_Maharajas_871237',
        'Una sala con elementos decorativos indios, desde alfombras hasta lámparas tradicionales.',
        'India',
        30,
        0,
        0.00,
        '/src/assets/rooms/india.webp',
        1,
        '2024-11-15 21:46:16',
        '2024-11-15 21:46:16',
        2
    ),
    (
        3,
        '0abbc1b6-a39b-11ef-a437-0242ac140002',
        'Taberna Española',
        'Taberna_Espanola_612342',
        'Un espacio acogedor con motivos tradicionales españoles, como azulejos y jamones colgados.',
        'España',
        30,
        0,
        0.00,
        '/src/assets/rooms/spain.webp',
        1,
        '2024-11-15 21:46:16',
        '2024-11-15 21:46:16',
        3
    ),
    (
        4,
        '0abbc27b-a39b-11ef-a437-0242ac140002',
        'Villa Toscana',
        'Villa_Toscana_891243',
        'Sala que evoca la tranquilidad y belleza de los viñedos italianos, con una decoración elegante.',
        'Italia',
        30,
        0,
        0.00,
        '/src/assets/rooms/italy.webp',
        1,
        '2024-11-15 21:46:16',
        '2024-11-15 21:46:16',
        4
    ),
    (
        5,
        '0abbc32a-a39b-11ef-a437-0242ac140002',
        'Hacienda Mexicana',
        'Hacienda_Mexicana_612384',
        'Sala inspirada en las haciendas tradicionales mexicanas, con colores vivos y detalles coloniales.',
        'México',
        30,
        0,
        0.00,
        '/src/assets/rooms/mexico.webp',
        1,
        '2024-11-15 21:46:16',
        '2024-11-15 21:46:16',
        5
    ),
    (
        6,
        '0abbc48f-a39b-11ef-a437-0242ac140002',
        'Salón del Bósforo',
        'Salon_del_Bosforo_781234',
        'Sala con decoración otomana y vistas simuladas del estrecho del Bósforo.',
        'Turquía',
        30,
        0,
        0.00,
        '/src/assets/rooms/turkey.webp',
        1,
        '2024-11-15 21:46:16',
        '2024-11-15 21:46:16',
        6
    );

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
    `total_revenue` decimal(10, 2) DEFAULT '0.00',
    `status` enum('Active', 'Closed', 'Pending') NOT NULL DEFAULT 'Pending',
    `is_active` tinyint(1) DEFAULT '1',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Room_Shift`
--

INSERT INTO
    `Room_Shift` (
        `room_shift_id`,
        `room_shift_uuid`,
        `room_id`,
        `shift_id`,
        `reserved_capacity`,
        `total_revenue`,
        `status`,
        `is_active`,
        `created_at`,
        `updated_at`
    )
VALUES (
        1,
        '3ba12f5d-b7f1-11ef-9c5f-0242ac120004',
        1,
        1,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        2,
        '3ba13024-b7f1-11ef-9c5f-0242ac120004',
        1,
        2,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        3,
        '3ba1307e-b7f1-11ef-9c5f-0242ac120004',
        1,
        3,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        4,
        '3ba130a1-b7f1-11ef-9c5f-0242ac120004',
        1,
        4,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        5,
        '3ba130b6-b7f1-11ef-9c5f-0242ac120004',
        1,
        5,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        6,
        '3ba130cb-b7f1-11ef-9c5f-0242ac120004',
        1,
        6,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        7,
        '3ba130e1-b7f1-11ef-9c5f-0242ac120004',
        1,
        7,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        8,
        '3ba130f6-b7f1-11ef-9c5f-0242ac120004',
        1,
        8,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        9,
        '3ba1310b-b7f1-11ef-9c5f-0242ac120004',
        1,
        9,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        10,
        '3ba1311e-b7f1-11ef-9c5f-0242ac120004',
        1,
        10,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        11,
        '3ba13132-b7f1-11ef-9c5f-0242ac120004',
        1,
        11,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        12,
        '3ba13159-b7f1-11ef-9c5f-0242ac120004',
        1,
        12,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        13,
        '3ba1316d-b7f1-11ef-9c5f-0242ac120004',
        1,
        13,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        14,
        '3ba13181-b7f1-11ef-9c5f-0242ac120004',
        1,
        14,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        15,
        '3ba13196-b7f1-11ef-9c5f-0242ac120004',
        1,
        15,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        16,
        '3ba131ac-b7f1-11ef-9c5f-0242ac120004',
        1,
        16,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        17,
        '3ba131c4-b7f1-11ef-9c5f-0242ac120004',
        1,
        17,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        18,
        '3ba131db-b7f1-11ef-9c5f-0242ac120004',
        1,
        18,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        19,
        '3ba131ef-b7f1-11ef-9c5f-0242ac120004',
        1,
        19,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        20,
        '3ba13204-b7f1-11ef-9c5f-0242ac120004',
        1,
        20,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        21,
        '3ba13218-b7f1-11ef-9c5f-0242ac120004',
        1,
        21,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        22,
        '3ba1322c-b7f1-11ef-9c5f-0242ac120004',
        1,
        22,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        23,
        '3ba13240-b7f1-11ef-9c5f-0242ac120004',
        1,
        23,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        24,
        '3ba13254-b7f1-11ef-9c5f-0242ac120004',
        1,
        24,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        25,
        '3ba13267-b7f1-11ef-9c5f-0242ac120004',
        1,
        25,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        26,
        '3ba1327a-b7f1-11ef-9c5f-0242ac120004',
        1,
        26,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        27,
        '3ba1328e-b7f1-11ef-9c5f-0242ac120004',
        1,
        27,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        28,
        '3ba132a1-b7f1-11ef-9c5f-0242ac120004',
        1,
        28,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        29,
        '3ba132b8-b7f1-11ef-9c5f-0242ac120004',
        1,
        29,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        30,
        '3ba132d4-b7f1-11ef-9c5f-0242ac120004',
        1,
        30,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        31,
        '3ba132ed-b7f1-11ef-9c5f-0242ac120004',
        1,
        31,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        32,
        '3ba13303-b7f1-11ef-9c5f-0242ac120004',
        1,
        32,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        33,
        '3ba13316-b7f1-11ef-9c5f-0242ac120004',
        1,
        33,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        34,
        '3ba1332a-b7f1-11ef-9c5f-0242ac120004',
        1,
        34,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        35,
        '3ba1333e-b7f1-11ef-9c5f-0242ac120004',
        1,
        35,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        36,
        '3ba13351-b7f1-11ef-9c5f-0242ac120004',
        1,
        36,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        37,
        '3ba13365-b7f1-11ef-9c5f-0242ac120004',
        1,
        37,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        38,
        '3ba13378-b7f1-11ef-9c5f-0242ac120004',
        1,
        38,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        39,
        '3ba1338c-b7f1-11ef-9c5f-0242ac120004',
        1,
        39,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        40,
        '3ba133a0-b7f1-11ef-9c5f-0242ac120004',
        1,
        40,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        41,
        '3ba133b3-b7f1-11ef-9c5f-0242ac120004',
        1,
        41,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        42,
        '3ba133c6-b7f1-11ef-9c5f-0242ac120004',
        1,
        42,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        43,
        '3ba133d9-b7f1-11ef-9c5f-0242ac120004',
        1,
        43,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        44,
        '3ba133ed-b7f1-11ef-9c5f-0242ac120004',
        1,
        44,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        45,
        '3ba13400-b7f1-11ef-9c5f-0242ac120004',
        1,
        45,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        46,
        '3ba13413-b7f1-11ef-9c5f-0242ac120004',
        1,
        46,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        47,
        '3ba13426-b7f1-11ef-9c5f-0242ac120004',
        1,
        47,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        48,
        '3ba13439-b7f1-11ef-9c5f-0242ac120004',
        1,
        48,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        49,
        '3ba1344b-b7f1-11ef-9c5f-0242ac120004',
        1,
        49,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        50,
        '3ba1345e-b7f1-11ef-9c5f-0242ac120004',
        1,
        50,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        51,
        '3ba13471-b7f1-11ef-9c5f-0242ac120004',
        1,
        51,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        52,
        '3ba13484-b7f1-11ef-9c5f-0242ac120004',
        1,
        52,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        53,
        '3ba13497-b7f1-11ef-9c5f-0242ac120004',
        1,
        53,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        54,
        '3ba134aa-b7f1-11ef-9c5f-0242ac120004',
        1,
        54,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        55,
        '3ba134bd-b7f1-11ef-9c5f-0242ac120004',
        1,
        55,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        56,
        '3ba134d0-b7f1-11ef-9c5f-0242ac120004',
        1,
        56,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        57,
        '3ba134e3-b7f1-11ef-9c5f-0242ac120004',
        1,
        57,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        58,
        '3ba134f9-b7f1-11ef-9c5f-0242ac120004',
        1,
        58,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        59,
        '3ba1350b-b7f1-11ef-9c5f-0242ac120004',
        1,
        59,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        60,
        '3ba1351e-b7f1-11ef-9c5f-0242ac120004',
        1,
        60,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        61,
        '3ba13531-b7f1-11ef-9c5f-0242ac120004',
        1,
        61,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        62,
        '3ba13544-b7f1-11ef-9c5f-0242ac120004',
        1,
        62,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        63,
        '3ba1600b-b7f1-11ef-9c5f-0242ac120004',
        2,
        1,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        64,
        '3ba16076-b7f1-11ef-9c5f-0242ac120004',
        2,
        2,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        65,
        '3ba16092-b7f1-11ef-9c5f-0242ac120004',
        2,
        3,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        66,
        '3ba160a6-b7f1-11ef-9c5f-0242ac120004',
        2,
        4,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        67,
        '3ba160ba-b7f1-11ef-9c5f-0242ac120004',
        2,
        5,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        68,
        '3ba160cf-b7f1-11ef-9c5f-0242ac120004',
        2,
        6,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        69,
        '3ba160e3-b7f1-11ef-9c5f-0242ac120004',
        2,
        7,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        70,
        '3ba160f5-b7f1-11ef-9c5f-0242ac120004',
        2,
        8,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        71,
        '3ba16108-b7f1-11ef-9c5f-0242ac120004',
        2,
        9,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        72,
        '3ba1611b-b7f1-11ef-9c5f-0242ac120004',
        2,
        10,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        73,
        '3ba1612f-b7f1-11ef-9c5f-0242ac120004',
        2,
        11,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        74,
        '3ba16141-b7f1-11ef-9c5f-0242ac120004',
        2,
        12,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        75,
        '3ba16154-b7f1-11ef-9c5f-0242ac120004',
        2,
        13,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        76,
        '3ba16167-b7f1-11ef-9c5f-0242ac120004',
        2,
        14,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        77,
        '3ba1617a-b7f1-11ef-9c5f-0242ac120004',
        2,
        15,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        78,
        '3ba1618f-b7f1-11ef-9c5f-0242ac120004',
        2,
        16,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        79,
        '3ba161a3-b7f1-11ef-9c5f-0242ac120004',
        2,
        17,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        80,
        '3ba161b6-b7f1-11ef-9c5f-0242ac120004',
        2,
        18,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        81,
        '3ba161c9-b7f1-11ef-9c5f-0242ac120004',
        2,
        19,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        82,
        '3ba161db-b7f1-11ef-9c5f-0242ac120004',
        2,
        20,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        83,
        '3ba161ee-b7f1-11ef-9c5f-0242ac120004',
        2,
        21,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        84,
        '3ba16201-b7f1-11ef-9c5f-0242ac120004',
        2,
        22,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        85,
        '3ba16214-b7f1-11ef-9c5f-0242ac120004',
        2,
        23,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        86,
        '3ba16226-b7f1-11ef-9c5f-0242ac120004',
        2,
        24,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        87,
        '3ba16238-b7f1-11ef-9c5f-0242ac120004',
        2,
        25,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        88,
        '3ba1624b-b7f1-11ef-9c5f-0242ac120004',
        2,
        26,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        89,
        '3ba1625e-b7f1-11ef-9c5f-0242ac120004',
        2,
        27,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        90,
        '3ba16271-b7f1-11ef-9c5f-0242ac120004',
        2,
        28,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        91,
        '3ba16283-b7f1-11ef-9c5f-0242ac120004',
        2,
        29,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        92,
        '3ba1629c-b7f1-11ef-9c5f-0242ac120004',
        2,
        30,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        93,
        '3ba162af-b7f1-11ef-9c5f-0242ac120004',
        2,
        31,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        94,
        '3ba162c0-b7f1-11ef-9c5f-0242ac120004',
        2,
        32,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        95,
        '3ba162d2-b7f1-11ef-9c5f-0242ac120004',
        2,
        33,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        96,
        '3ba162e2-b7f1-11ef-9c5f-0242ac120004',
        2,
        34,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        97,
        '3ba162f3-b7f1-11ef-9c5f-0242ac120004',
        2,
        35,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        98,
        '3ba16305-b7f1-11ef-9c5f-0242ac120004',
        2,
        36,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        99,
        '3ba16316-b7f1-11ef-9c5f-0242ac120004',
        2,
        37,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        100,
        '3ba16327-b7f1-11ef-9c5f-0242ac120004',
        2,
        38,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        101,
        '3ba16338-b7f1-11ef-9c5f-0242ac120004',
        2,
        39,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        102,
        '3ba16349-b7f1-11ef-9c5f-0242ac120004',
        2,
        40,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        103,
        '3ba1635a-b7f1-11ef-9c5f-0242ac120004',
        2,
        41,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        104,
        '3ba1636b-b7f1-11ef-9c5f-0242ac120004',
        2,
        42,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        105,
        '3ba1637d-b7f1-11ef-9c5f-0242ac120004',
        2,
        43,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        106,
        '3ba1638e-b7f1-11ef-9c5f-0242ac120004',
        2,
        44,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        107,
        '3ba1639f-b7f1-11ef-9c5f-0242ac120004',
        2,
        45,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        108,
        '3ba163b0-b7f1-11ef-9c5f-0242ac120004',
        2,
        46,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        109,
        '3ba163c1-b7f1-11ef-9c5f-0242ac120004',
        2,
        47,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        110,
        '3ba163d2-b7f1-11ef-9c5f-0242ac120004',
        2,
        48,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        111,
        '3ba163e3-b7f1-11ef-9c5f-0242ac120004',
        2,
        49,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        112,
        '3ba163f4-b7f1-11ef-9c5f-0242ac120004',
        2,
        50,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        113,
        '3ba16405-b7f1-11ef-9c5f-0242ac120004',
        2,
        51,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        114,
        '3ba16416-b7f1-11ef-9c5f-0242ac120004',
        2,
        52,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        115,
        '3ba16427-b7f1-11ef-9c5f-0242ac120004',
        2,
        53,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        116,
        '3ba16437-b7f1-11ef-9c5f-0242ac120004',
        2,
        54,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        117,
        '3ba16448-b7f1-11ef-9c5f-0242ac120004',
        2,
        55,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        118,
        '3ba16459-b7f1-11ef-9c5f-0242ac120004',
        2,
        56,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        119,
        '3ba1646a-b7f1-11ef-9c5f-0242ac120004',
        2,
        57,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        120,
        '3ba16481-b7f1-11ef-9c5f-0242ac120004',
        2,
        58,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        121,
        '3ba16492-b7f1-11ef-9c5f-0242ac120004',
        2,
        59,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        122,
        '3ba164a4-b7f1-11ef-9c5f-0242ac120004',
        2,
        60,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        123,
        '3ba164b5-b7f1-11ef-9c5f-0242ac120004',
        2,
        61,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        124,
        '3ba164c7-b7f1-11ef-9c5f-0242ac120004',
        2,
        62,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        125,
        '3ba1a268-b7f1-11ef-9c5f-0242ac120004',
        3,
        1,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        126,
        '3ba1a2e4-b7f1-11ef-9c5f-0242ac120004',
        3,
        2,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        127,
        '3ba1a304-b7f1-11ef-9c5f-0242ac120004',
        3,
        3,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        128,
        '3ba1a31c-b7f1-11ef-9c5f-0242ac120004',
        3,
        4,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        129,
        '3ba1a333-b7f1-11ef-9c5f-0242ac120004',
        3,
        5,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        130,
        '3ba1a346-b7f1-11ef-9c5f-0242ac120004',
        3,
        6,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        131,
        '3ba1a35b-b7f1-11ef-9c5f-0242ac120004',
        3,
        7,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        132,
        '3ba1a36e-b7f1-11ef-9c5f-0242ac120004',
        3,
        8,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        133,
        '3ba1a3a3-b7f1-11ef-9c5f-0242ac120004',
        3,
        9,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        134,
        '3ba1a3b9-b7f1-11ef-9c5f-0242ac120004',
        3,
        10,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        135,
        '3ba1a3cd-b7f1-11ef-9c5f-0242ac120004',
        3,
        11,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        136,
        '3ba1a3e5-b7f1-11ef-9c5f-0242ac120004',
        3,
        12,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        137,
        '3ba1a3f9-b7f1-11ef-9c5f-0242ac120004',
        3,
        13,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        138,
        '3ba1a40d-b7f1-11ef-9c5f-0242ac120004',
        3,
        14,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        139,
        '3ba1a422-b7f1-11ef-9c5f-0242ac120004',
        3,
        15,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        140,
        '3ba1a437-b7f1-11ef-9c5f-0242ac120004',
        3,
        16,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        141,
        '3ba1a449-b7f1-11ef-9c5f-0242ac120004',
        3,
        17,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        142,
        '3ba1a45c-b7f1-11ef-9c5f-0242ac120004',
        3,
        18,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        143,
        '3ba1a46f-b7f1-11ef-9c5f-0242ac120004',
        3,
        19,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        144,
        '3ba1a482-b7f1-11ef-9c5f-0242ac120004',
        3,
        20,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        145,
        '3ba1a495-b7f1-11ef-9c5f-0242ac120004',
        3,
        21,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        146,
        '3ba1a4a7-b7f1-11ef-9c5f-0242ac120004',
        3,
        22,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        147,
        '3ba1a4ba-b7f1-11ef-9c5f-0242ac120004',
        3,
        23,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        148,
        '3ba1a4cd-b7f1-11ef-9c5f-0242ac120004',
        3,
        24,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        149,
        '3ba1a4e1-b7f1-11ef-9c5f-0242ac120004',
        3,
        25,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        150,
        '3ba1a4f5-b7f1-11ef-9c5f-0242ac120004',
        3,
        26,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        151,
        '3ba1a507-b7f1-11ef-9c5f-0242ac120004',
        3,
        27,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        152,
        '3ba1a519-b7f1-11ef-9c5f-0242ac120004',
        3,
        28,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        153,
        '3ba1a529-b7f1-11ef-9c5f-0242ac120004',
        3,
        29,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        154,
        '3ba1a53c-b7f1-11ef-9c5f-0242ac120004',
        3,
        30,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        155,
        '3ba1a54d-b7f1-11ef-9c5f-0242ac120004',
        3,
        31,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        156,
        '3ba1a55f-b7f1-11ef-9c5f-0242ac120004',
        3,
        32,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        157,
        '3ba1a56f-b7f1-11ef-9c5f-0242ac120004',
        3,
        33,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        158,
        '3ba1a581-b7f1-11ef-9c5f-0242ac120004',
        3,
        34,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        159,
        '3ba1a592-b7f1-11ef-9c5f-0242ac120004',
        3,
        35,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        160,
        '3ba1a5a3-b7f1-11ef-9c5f-0242ac120004',
        3,
        36,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        161,
        '3ba1b8c7-b7f1-11ef-9c5f-0242ac120004',
        3,
        37,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        162,
        '3ba1b8ee-b7f1-11ef-9c5f-0242ac120004',
        3,
        38,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        163,
        '3ba1b903-b7f1-11ef-9c5f-0242ac120004',
        3,
        39,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        164,
        '3ba1b917-b7f1-11ef-9c5f-0242ac120004',
        3,
        40,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        165,
        '3ba1b92b-b7f1-11ef-9c5f-0242ac120004',
        3,
        41,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        166,
        '3ba1b93e-b7f1-11ef-9c5f-0242ac120004',
        3,
        42,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        167,
        '3ba1b951-b7f1-11ef-9c5f-0242ac120004',
        3,
        43,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        168,
        '3ba1b965-b7f1-11ef-9c5f-0242ac120004',
        3,
        44,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        169,
        '3ba1b977-b7f1-11ef-9c5f-0242ac120004',
        3,
        45,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        170,
        '3ba1b98b-b7f1-11ef-9c5f-0242ac120004',
        3,
        46,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        171,
        '3ba1b99d-b7f1-11ef-9c5f-0242ac120004',
        3,
        47,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        172,
        '3ba1b9b0-b7f1-11ef-9c5f-0242ac120004',
        3,
        48,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        173,
        '3ba1b9c2-b7f1-11ef-9c5f-0242ac120004',
        3,
        49,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        174,
        '3ba1b9d5-b7f1-11ef-9c5f-0242ac120004',
        3,
        50,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        175,
        '3ba1b9e9-b7f1-11ef-9c5f-0242ac120004',
        3,
        51,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        176,
        '3ba1b9fc-b7f1-11ef-9c5f-0242ac120004',
        3,
        52,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        177,
        '3ba1ba0f-b7f1-11ef-9c5f-0242ac120004',
        3,
        53,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        178,
        '3ba1ba22-b7f1-11ef-9c5f-0242ac120004',
        3,
        54,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        179,
        '3ba1ba35-b7f1-11ef-9c5f-0242ac120004',
        3,
        55,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        180,
        '3ba1ba48-b7f1-11ef-9c5f-0242ac120004',
        3,
        56,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        181,
        '3ba1ba5a-b7f1-11ef-9c5f-0242ac120004',
        3,
        57,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        182,
        '3ba1ba70-b7f1-11ef-9c5f-0242ac120004',
        3,
        58,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        183,
        '3ba1ba83-b7f1-11ef-9c5f-0242ac120004',
        3,
        59,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        184,
        '3ba1ba96-b7f1-11ef-9c5f-0242ac120004',
        3,
        60,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        185,
        '3ba1baaa-b7f1-11ef-9c5f-0242ac120004',
        3,
        61,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        186,
        '3ba1babc-b7f1-11ef-9c5f-0242ac120004',
        3,
        62,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        187,
        '3ba26de4-b7f1-11ef-9c5f-0242ac120004',
        4,
        1,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        188,
        '3ba26e46-b7f1-11ef-9c5f-0242ac120004',
        4,
        2,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        189,
        '3ba26e5f-b7f1-11ef-9c5f-0242ac120004',
        4,
        3,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        190,
        '3ba26e73-b7f1-11ef-9c5f-0242ac120004',
        4,
        4,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        191,
        '3ba26e86-b7f1-11ef-9c5f-0242ac120004',
        4,
        5,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        192,
        '3ba26e99-b7f1-11ef-9c5f-0242ac120004',
        4,
        6,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        193,
        '3ba26eaf-b7f1-11ef-9c5f-0242ac120004',
        4,
        7,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        194,
        '3ba26ec2-b7f1-11ef-9c5f-0242ac120004',
        4,
        8,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        195,
        '3ba26ed4-b7f1-11ef-9c5f-0242ac120004',
        4,
        9,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        196,
        '3ba26ee7-b7f1-11ef-9c5f-0242ac120004',
        4,
        10,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        197,
        '3ba26efa-b7f1-11ef-9c5f-0242ac120004',
        4,
        11,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        198,
        '3ba26f0c-b7f1-11ef-9c5f-0242ac120004',
        4,
        12,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        199,
        '3ba26f20-b7f1-11ef-9c5f-0242ac120004',
        4,
        13,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        200,
        '3ba26f31-b7f1-11ef-9c5f-0242ac120004',
        4,
        14,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        201,
        '3ba26f44-b7f1-11ef-9c5f-0242ac120004',
        4,
        15,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        202,
        '3ba26f57-b7f1-11ef-9c5f-0242ac120004',
        4,
        16,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        203,
        '3ba26f69-b7f1-11ef-9c5f-0242ac120004',
        4,
        17,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        204,
        '3ba26f7c-b7f1-11ef-9c5f-0242ac120004',
        4,
        18,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        205,
        '3ba26f8e-b7f1-11ef-9c5f-0242ac120004',
        4,
        19,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        206,
        '3ba26f9f-b7f1-11ef-9c5f-0242ac120004',
        4,
        20,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        207,
        '3ba26fb1-b7f1-11ef-9c5f-0242ac120004',
        4,
        21,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        208,
        '3ba26fc4-b7f1-11ef-9c5f-0242ac120004',
        4,
        22,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        209,
        '3ba26fd6-b7f1-11ef-9c5f-0242ac120004',
        4,
        23,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        210,
        '3ba26fe8-b7f1-11ef-9c5f-0242ac120004',
        4,
        24,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        211,
        '3ba26ff9-b7f1-11ef-9c5f-0242ac120004',
        4,
        25,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        212,
        '3ba27066-b7f1-11ef-9c5f-0242ac120004',
        4,
        26,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        213,
        '3ba27083-b7f1-11ef-9c5f-0242ac120004',
        4,
        27,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        214,
        '3ba27097-b7f1-11ef-9c5f-0242ac120004',
        4,
        28,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        215,
        '3ba270ab-b7f1-11ef-9c5f-0242ac120004',
        4,
        29,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        216,
        '3ba270bf-b7f1-11ef-9c5f-0242ac120004',
        4,
        30,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        217,
        '3ba270cf-b7f1-11ef-9c5f-0242ac120004',
        4,
        31,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        218,
        '3ba270df-b7f1-11ef-9c5f-0242ac120004',
        4,
        32,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        219,
        '3ba270f0-b7f1-11ef-9c5f-0242ac120004',
        4,
        33,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        220,
        '3ba27101-b7f1-11ef-9c5f-0242ac120004',
        4,
        34,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        221,
        '3ba27111-b7f1-11ef-9c5f-0242ac120004',
        4,
        35,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        222,
        '3ba27121-b7f1-11ef-9c5f-0242ac120004',
        4,
        36,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        223,
        '3ba27132-b7f1-11ef-9c5f-0242ac120004',
        4,
        37,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        224,
        '3ba27141-b7f1-11ef-9c5f-0242ac120004',
        4,
        38,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        225,
        '3ba27152-b7f1-11ef-9c5f-0242ac120004',
        4,
        39,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        226,
        '3ba27162-b7f1-11ef-9c5f-0242ac120004',
        4,
        40,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        227,
        '3ba27172-b7f1-11ef-9c5f-0242ac120004',
        4,
        41,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        228,
        '3ba27182-b7f1-11ef-9c5f-0242ac120004',
        4,
        42,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        229,
        '3ba27192-b7f1-11ef-9c5f-0242ac120004',
        4,
        43,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        230,
        '3ba271a2-b7f1-11ef-9c5f-0242ac120004',
        4,
        44,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        231,
        '3ba271b2-b7f1-11ef-9c5f-0242ac120004',
        4,
        45,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        232,
        '3ba271c3-b7f1-11ef-9c5f-0242ac120004',
        4,
        46,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        233,
        '3ba271d2-b7f1-11ef-9c5f-0242ac120004',
        4,
        47,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        234,
        '3ba271e3-b7f1-11ef-9c5f-0242ac120004',
        4,
        48,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        235,
        '3ba271f3-b7f1-11ef-9c5f-0242ac120004',
        4,
        49,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        236,
        '3ba27203-b7f1-11ef-9c5f-0242ac120004',
        4,
        50,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        237,
        '3ba27213-b7f1-11ef-9c5f-0242ac120004',
        4,
        51,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        238,
        '3ba27222-b7f1-11ef-9c5f-0242ac120004',
        4,
        52,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        239,
        '3ba27232-b7f1-11ef-9c5f-0242ac120004',
        4,
        53,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        240,
        '3ba29db9-b7f1-11ef-9c5f-0242ac120004',
        4,
        54,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        241,
        '3ba29df2-b7f1-11ef-9c5f-0242ac120004',
        4,
        55,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        242,
        '3ba29e0d-b7f1-11ef-9c5f-0242ac120004',
        4,
        56,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        243,
        '3ba29e23-b7f1-11ef-9c5f-0242ac120004',
        4,
        57,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        244,
        '3ba29e3e-b7f1-11ef-9c5f-0242ac120004',
        4,
        58,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        245,
        '3ba29e53-b7f1-11ef-9c5f-0242ac120004',
        4,
        59,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        246,
        '3ba29e66-b7f1-11ef-9c5f-0242ac120004',
        4,
        60,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        247,
        '3ba29e7a-b7f1-11ef-9c5f-0242ac120004',
        4,
        61,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        248,
        '3ba29e8d-b7f1-11ef-9c5f-0242ac120004',
        4,
        62,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        249,
        '3ba2c93f-b7f1-11ef-9c5f-0242ac120004',
        5,
        1,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        250,
        '3ba2c99f-b7f1-11ef-9c5f-0242ac120004',
        5,
        2,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        251,
        '3ba2c9b8-b7f1-11ef-9c5f-0242ac120004',
        5,
        3,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        252,
        '3ba2c9cc-b7f1-11ef-9c5f-0242ac120004',
        5,
        4,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        253,
        '3ba2c9df-b7f1-11ef-9c5f-0242ac120004',
        5,
        5,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        254,
        '3ba2c9f3-b7f1-11ef-9c5f-0242ac120004',
        5,
        6,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        255,
        '3ba2ca06-b7f1-11ef-9c5f-0242ac120004',
        5,
        7,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        256,
        '3ba2ca18-b7f1-11ef-9c5f-0242ac120004',
        5,
        8,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        257,
        '3ba2ca2c-b7f1-11ef-9c5f-0242ac120004',
        5,
        9,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        258,
        '3ba2ca3f-b7f1-11ef-9c5f-0242ac120004',
        5,
        10,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        259,
        '3ba2ca51-b7f1-11ef-9c5f-0242ac120004',
        5,
        11,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        260,
        '3ba2ca62-b7f1-11ef-9c5f-0242ac120004',
        5,
        12,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        261,
        '3ba2ca75-b7f1-11ef-9c5f-0242ac120004',
        5,
        13,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        262,
        '3ba2ca86-b7f1-11ef-9c5f-0242ac120004',
        5,
        14,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        263,
        '3ba2ca99-b7f1-11ef-9c5f-0242ac120004',
        5,
        15,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        264,
        '3ba2caad-b7f1-11ef-9c5f-0242ac120004',
        5,
        16,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        265,
        '3ba2cabf-b7f1-11ef-9c5f-0242ac120004',
        5,
        17,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        266,
        '3ba2cad1-b7f1-11ef-9c5f-0242ac120004',
        5,
        18,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        267,
        '3ba2cae4-b7f1-11ef-9c5f-0242ac120004',
        5,
        19,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        268,
        '3ba2caf6-b7f1-11ef-9c5f-0242ac120004',
        5,
        20,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        269,
        '3ba2cb07-b7f1-11ef-9c5f-0242ac120004',
        5,
        21,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        270,
        '3ba2cb1a-b7f1-11ef-9c5f-0242ac120004',
        5,
        22,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        271,
        '3ba2cb2c-b7f1-11ef-9c5f-0242ac120004',
        5,
        23,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        272,
        '3ba2cb3d-b7f1-11ef-9c5f-0242ac120004',
        5,
        24,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        273,
        '3ba2cb50-b7f1-11ef-9c5f-0242ac120004',
        5,
        25,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        274,
        '3ba2cb63-b7f1-11ef-9c5f-0242ac120004',
        5,
        26,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        275,
        '3ba2cb76-b7f1-11ef-9c5f-0242ac120004',
        5,
        27,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        276,
        '3ba2cb87-b7f1-11ef-9c5f-0242ac120004',
        5,
        28,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        277,
        '3ba2cb9a-b7f1-11ef-9c5f-0242ac120004',
        5,
        29,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        278,
        '3ba2cbad-b7f1-11ef-9c5f-0242ac120004',
        5,
        30,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        279,
        '3ba2cbc0-b7f1-11ef-9c5f-0242ac120004',
        5,
        31,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        280,
        '3ba2cbd2-b7f1-11ef-9c5f-0242ac120004',
        5,
        32,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        281,
        '3ba2cbe4-b7f1-11ef-9c5f-0242ac120004',
        5,
        33,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        282,
        '3ba2cbf6-b7f1-11ef-9c5f-0242ac120004',
        5,
        34,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        283,
        '3ba2cc09-b7f1-11ef-9c5f-0242ac120004',
        5,
        35,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        284,
        '3ba2cc1d-b7f1-11ef-9c5f-0242ac120004',
        5,
        36,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        285,
        '3ba2cc2f-b7f1-11ef-9c5f-0242ac120004',
        5,
        37,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        286,
        '3ba2cc40-b7f1-11ef-9c5f-0242ac120004',
        5,
        38,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        287,
        '3ba2cc50-b7f1-11ef-9c5f-0242ac120004',
        5,
        39,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        288,
        '3ba2cc60-b7f1-11ef-9c5f-0242ac120004',
        5,
        40,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        289,
        '3ba2cc71-b7f1-11ef-9c5f-0242ac120004',
        5,
        41,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        290,
        '3ba2cc82-b7f1-11ef-9c5f-0242ac120004',
        5,
        42,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        291,
        '3ba2cc93-b7f1-11ef-9c5f-0242ac120004',
        5,
        43,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        292,
        '3ba2cca3-b7f1-11ef-9c5f-0242ac120004',
        5,
        44,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        293,
        '3ba2ccb4-b7f1-11ef-9c5f-0242ac120004',
        5,
        45,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        294,
        '3ba2ccc4-b7f1-11ef-9c5f-0242ac120004',
        5,
        46,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        295,
        '3ba2ccd4-b7f1-11ef-9c5f-0242ac120004',
        5,
        47,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        296,
        '3ba2cce5-b7f1-11ef-9c5f-0242ac120004',
        5,
        48,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        297,
        '3ba2ccf5-b7f1-11ef-9c5f-0242ac120004',
        5,
        49,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        298,
        '3ba2cd05-b7f1-11ef-9c5f-0242ac120004',
        5,
        50,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        299,
        '3ba2cd16-b7f1-11ef-9c5f-0242ac120004',
        5,
        51,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        300,
        '3ba2cd26-b7f1-11ef-9c5f-0242ac120004',
        5,
        52,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        301,
        '3ba2cd36-b7f1-11ef-9c5f-0242ac120004',
        5,
        53,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        302,
        '3ba2cd47-b7f1-11ef-9c5f-0242ac120004',
        5,
        54,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        303,
        '3ba2cd58-b7f1-11ef-9c5f-0242ac120004',
        5,
        55,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        304,
        '3ba2cd68-b7f1-11ef-9c5f-0242ac120004',
        5,
        56,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        305,
        '3ba2cd78-b7f1-11ef-9c5f-0242ac120004',
        5,
        57,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        306,
        '3ba2cd8b-b7f1-11ef-9c5f-0242ac120004',
        5,
        58,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        307,
        '3ba2cd9c-b7f1-11ef-9c5f-0242ac120004',
        5,
        59,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        308,
        '3ba2cdad-b7f1-11ef-9c5f-0242ac120004',
        5,
        60,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        309,
        '3ba2cdbd-b7f1-11ef-9c5f-0242ac120004',
        5,
        61,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        310,
        '3ba2cdce-b7f1-11ef-9c5f-0242ac120004',
        5,
        62,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        311,
        '3ba308c1-b7f1-11ef-9c5f-0242ac120004',
        6,
        1,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        312,
        '3ba3091a-b7f1-11ef-9c5f-0242ac120004',
        6,
        2,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        313,
        '3ba30932-b7f1-11ef-9c5f-0242ac120004',
        6,
        3,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        314,
        '3ba30946-b7f1-11ef-9c5f-0242ac120004',
        6,
        4,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        315,
        '3ba3095a-b7f1-11ef-9c5f-0242ac120004',
        6,
        5,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        316,
        '3ba3096c-b7f1-11ef-9c5f-0242ac120004',
        6,
        6,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        317,
        '3ba3097e-b7f1-11ef-9c5f-0242ac120004',
        6,
        7,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        318,
        '3ba30990-b7f1-11ef-9c5f-0242ac120004',
        6,
        8,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        319,
        '3ba309a3-b7f1-11ef-9c5f-0242ac120004',
        6,
        9,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        320,
        '3ba309b9-b7f1-11ef-9c5f-0242ac120004',
        6,
        10,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        321,
        '3ba309cd-b7f1-11ef-9c5f-0242ac120004',
        6,
        11,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        322,
        '3ba309de-b7f1-11ef-9c5f-0242ac120004',
        6,
        12,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        323,
        '3ba309f0-b7f1-11ef-9c5f-0242ac120004',
        6,
        13,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        324,
        '3ba30a02-b7f1-11ef-9c5f-0242ac120004',
        6,
        14,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        325,
        '3ba30a14-b7f1-11ef-9c5f-0242ac120004',
        6,
        15,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        326,
        '3ba30a27-b7f1-11ef-9c5f-0242ac120004',
        6,
        16,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        327,
        '3ba30a39-b7f1-11ef-9c5f-0242ac120004',
        6,
        17,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        328,
        '3ba30a4b-b7f1-11ef-9c5f-0242ac120004',
        6,
        18,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        329,
        '3ba30a5d-b7f1-11ef-9c5f-0242ac120004',
        6,
        19,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        330,
        '3ba30a6e-b7f1-11ef-9c5f-0242ac120004',
        6,
        20,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        331,
        '3ba30a80-b7f1-11ef-9c5f-0242ac120004',
        6,
        21,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        332,
        '3ba30a92-b7f1-11ef-9c5f-0242ac120004',
        6,
        22,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        333,
        '3ba30aa4-b7f1-11ef-9c5f-0242ac120004',
        6,
        23,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        334,
        '3ba30ab6-b7f1-11ef-9c5f-0242ac120004',
        6,
        24,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        335,
        '3ba30ac7-b7f1-11ef-9c5f-0242ac120004',
        6,
        25,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        336,
        '3ba30ad9-b7f1-11ef-9c5f-0242ac120004',
        6,
        26,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        337,
        '3ba30aea-b7f1-11ef-9c5f-0242ac120004',
        6,
        27,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        338,
        '3ba30afc-b7f1-11ef-9c5f-0242ac120004',
        6,
        28,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        339,
        '3ba30b0d-b7f1-11ef-9c5f-0242ac120004',
        6,
        29,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        340,
        '3ba30b20-b7f1-11ef-9c5f-0242ac120004',
        6,
        30,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        341,
        '3ba30b32-b7f1-11ef-9c5f-0242ac120004',
        6,
        31,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        342,
        '3ba30b45-b7f1-11ef-9c5f-0242ac120004',
        6,
        32,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        343,
        '3ba30b57-b7f1-11ef-9c5f-0242ac120004',
        6,
        33,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        344,
        '3ba30b69-b7f1-11ef-9c5f-0242ac120004',
        6,
        34,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        345,
        '3ba30b7c-b7f1-11ef-9c5f-0242ac120004',
        6,
        35,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        346,
        '3ba30b8f-b7f1-11ef-9c5f-0242ac120004',
        6,
        36,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        347,
        '3ba30ba0-b7f1-11ef-9c5f-0242ac120004',
        6,
        37,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        348,
        '3ba30bb0-b7f1-11ef-9c5f-0242ac120004',
        6,
        38,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        349,
        '3ba30bc0-b7f1-11ef-9c5f-0242ac120004',
        6,
        39,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        350,
        '3ba30bd1-b7f1-11ef-9c5f-0242ac120004',
        6,
        40,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        351,
        '3ba30be2-b7f1-11ef-9c5f-0242ac120004',
        6,
        41,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        352,
        '3ba30bf1-b7f1-11ef-9c5f-0242ac120004',
        6,
        42,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        353,
        '3ba30c01-b7f1-11ef-9c5f-0242ac120004',
        6,
        43,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        354,
        '3ba30c12-b7f1-11ef-9c5f-0242ac120004',
        6,
        44,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        355,
        '3ba30c22-b7f1-11ef-9c5f-0242ac120004',
        6,
        45,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        356,
        '3ba30c32-b7f1-11ef-9c5f-0242ac120004',
        6,
        46,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        357,
        '3ba30c42-b7f1-11ef-9c5f-0242ac120004',
        6,
        47,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        358,
        '3ba30c8c-b7f1-11ef-9c5f-0242ac120004',
        6,
        48,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        359,
        '3ba30ca0-b7f1-11ef-9c5f-0242ac120004',
        6,
        49,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        360,
        '3ba30cb1-b7f1-11ef-9c5f-0242ac120004',
        6,
        50,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        361,
        '3ba30cc1-b7f1-11ef-9c5f-0242ac120004',
        6,
        51,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        362,
        '3ba30cd1-b7f1-11ef-9c5f-0242ac120004',
        6,
        52,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        363,
        '3ba30ce2-b7f1-11ef-9c5f-0242ac120004',
        6,
        53,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        364,
        '3ba30cf2-b7f1-11ef-9c5f-0242ac120004',
        6,
        54,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        365,
        '3ba30d01-b7f1-11ef-9c5f-0242ac120004',
        6,
        55,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        366,
        '3ba30d11-b7f1-11ef-9c5f-0242ac120004',
        6,
        56,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        367,
        '3ba30d22-b7f1-11ef-9c5f-0242ac120004',
        6,
        57,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        368,
        '3ba30d34-b7f1-11ef-9c5f-0242ac120004',
        6,
        58,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        369,
        '3ba30d45-b7f1-11ef-9c5f-0242ac120004',
        6,
        59,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        370,
        '3ba30d56-b7f1-11ef-9c5f-0242ac120004',
        6,
        60,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        371,
        '3ba30d66-b7f1-11ef-9c5f-0242ac120004',
        6,
        61,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    ),
    (
        372,
        '3ba30d76-b7f1-11ef-9c5f-0242ac120004',
        6,
        62,
        0,
        0.00,
        'Pending',
        1,
        '2024-12-11 18:53:38',
        '2024-12-11 18:53:38'
    );

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Shift`
--

CREATE TABLE `Shift` (
    `shift_id` int NOT NULL,
    `shift_uuid` char(36) NOT NULL,
    `shift_date` date NOT NULL,
    `shift_type` enum('Lunch', 'Dinner') NOT NULL,
    `total_revenue` decimal(10, 2) DEFAULT '0.00',
    `is_active` tinyint(1) DEFAULT '1'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Shift`
--

INSERT INTO
    `Shift` (
        `shift_id`,
        `shift_uuid`,
        `shift_date`,
        `shift_type`,
        `total_revenue`,
        `is_active`
    )
VALUES (
        1,
        '3ba47d2c-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-01',
        'Lunch',
        0.00,
        1
    ),
    (
        2,
        '3ba47d95-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-01',
        'Dinner',
        0.00,
        1
    ),
    (
        3,
        '3ba47dde-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-02',
        'Lunch',
        0.00,
        1
    ),
    (
        4,
        '3ba47df6-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-02',
        'Dinner',
        0.00,
        1
    ),
    (
        5,
        '3ba47e08-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-03',
        'Lunch',
        0.00,
        1
    ),
    (
        6,
        '3ba47e1b-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-03',
        'Dinner',
        0.00,
        1
    ),
    (
        7,
        '3ba47e2d-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-04',
        'Lunch',
        0.00,
        1
    ),
    (
        8,
        '3ba47e67-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-04',
        'Dinner',
        0.00,
        1
    ),
    (
        9,
        '3ba47e79-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-05',
        'Lunch',
        0.00,
        1
    ),
    (
        10,
        '3ba47e8a-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-05',
        'Dinner',
        0.00,
        1
    ),
    (
        11,
        '3ba47e9b-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-06',
        'Lunch',
        0.00,
        1
    ),
    (
        12,
        '3ba47eab-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-06',
        'Dinner',
        0.00,
        1
    ),
    (
        13,
        '3ba47ebe-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-07',
        'Lunch',
        0.00,
        1
    ),
    (
        14,
        '3ba47ece-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-07',
        'Dinner',
        0.00,
        1
    ),
    (
        15,
        '3ba47edf-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-08',
        'Lunch',
        0.00,
        1
    ),
    (
        16,
        '3ba47eef-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-08',
        'Dinner',
        0.00,
        1
    ),
    (
        17,
        '3ba47f00-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-09',
        'Lunch',
        0.00,
        1
    ),
    (
        18,
        '3ba47f12-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-09',
        'Dinner',
        0.00,
        1
    ),
    (
        19,
        '3ba47f23-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-10',
        'Lunch',
        0.00,
        1
    ),
    (
        20,
        '3ba47f33-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-10',
        'Dinner',
        0.00,
        1
    ),
    (
        21,
        '3ba47f47-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-11',
        'Lunch',
        0.00,
        1
    ),
    (
        22,
        '3ba47f58-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-11',
        'Dinner',
        0.00,
        1
    ),
    (
        23,
        '3ba47f68-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-12',
        'Lunch',
        0.00,
        1
    ),
    (
        24,
        '3ba47f79-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-12',
        'Dinner',
        0.00,
        1
    ),
    (
        25,
        '3ba47f8a-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-13',
        'Lunch',
        0.00,
        1
    ),
    (
        26,
        '3ba47f9c-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-13',
        'Dinner',
        0.00,
        1
    ),
    (
        27,
        '3ba47faf-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-14',
        'Lunch',
        0.00,
        1
    ),
    (
        28,
        '3ba47fc0-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-14',
        'Dinner',
        0.00,
        1
    ),
    (
        29,
        '3ba47fcf-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-15',
        'Lunch',
        0.00,
        1
    ),
    (
        30,
        '3ba47fdf-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-15',
        'Dinner',
        0.00,
        1
    ),
    (
        31,
        '3ba47fee-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-16',
        'Lunch',
        0.00,
        1
    ),
    (
        32,
        '3ba47ffd-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-16',
        'Dinner',
        0.00,
        1
    ),
    (
        33,
        '3ba4800c-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-17',
        'Lunch',
        0.00,
        1
    ),
    (
        34,
        '3ba4801c-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-17',
        'Dinner',
        0.00,
        1
    ),
    (
        35,
        '3ba4802b-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-18',
        'Lunch',
        0.00,
        1
    ),
    (
        36,
        '3ba4803a-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-18',
        'Dinner',
        0.00,
        1
    ),
    (
        37,
        '3ba48049-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-19',
        'Lunch',
        0.00,
        1
    ),
    (
        38,
        '3ba48058-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-19',
        'Dinner',
        0.00,
        1
    ),
    (
        39,
        '3ba48067-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-20',
        'Lunch',
        0.00,
        1
    ),
    (
        40,
        '3ba48076-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-20',
        'Dinner',
        0.00,
        1
    ),
    (
        41,
        '3ba48087-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-21',
        'Lunch',
        0.00,
        1
    ),
    (
        42,
        '3ba48096-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-21',
        'Dinner',
        0.00,
        1
    ),
    (
        43,
        '3ba480a5-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-22',
        'Lunch',
        0.00,
        1
    ),
    (
        44,
        '3ba480b4-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-22',
        'Dinner',
        0.00,
        1
    ),
    (
        45,
        '3ba480c3-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-23',
        'Lunch',
        0.00,
        1
    ),
    (
        46,
        '3ba480d2-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-23',
        'Dinner',
        0.00,
        1
    ),
    (
        47,
        '3ba480e1-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-24',
        'Lunch',
        0.00,
        1
    ),
    (
        48,
        '3ba480f0-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-24',
        'Dinner',
        0.00,
        1
    ),
    (
        49,
        '3ba480ff-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-25',
        'Lunch',
        0.00,
        1
    ),
    (
        50,
        '3ba4810e-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-25',
        'Dinner',
        0.00,
        1
    ),
    (
        51,
        '3ba4811d-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-26',
        'Lunch',
        0.00,
        1
    ),
    (
        52,
        '3ba4812c-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-26',
        'Dinner',
        0.00,
        1
    ),
    (
        53,
        '3ba4813b-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-27',
        'Lunch',
        0.00,
        1
    ),
    (
        54,
        '3ba4814a-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-27',
        'Dinner',
        0.00,
        1
    ),
    (
        55,
        '3ba48158-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-28',
        'Lunch',
        0.00,
        1
    ),
    (
        56,
        '3ba48167-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-28',
        'Dinner',
        0.00,
        1
    ),
    (
        57,
        '3ba48176-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-29',
        'Lunch',
        0.00,
        1
    ),
    (
        58,
        '3ba48184-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-29',
        'Dinner',
        0.00,
        1
    ),
    (
        59,
        '3ba48193-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-30',
        'Lunch',
        0.00,
        1
    ),
    (
        60,
        '3ba481a3-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-30',
        'Dinner',
        0.00,
        1
    ),
    (
        61,
        '3ba481b2-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-31',
        'Lunch',
        0.00,
        1
    ),
    (
        62,
        '3ba481c1-b7f1-11ef-9c5f-0242ac120004',
        '2024-12-31',
        'Dinner',
        0.00,
        1
    );

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Tickets`
--

CREATE TABLE `Tickets` (
    `ticket_id` int NOT NULL,
    `ticket_uuid` char(36) NOT NULL,
    `booking_id` int NOT NULL,
    `total_amount` decimal(10, 2) NOT NULL,
    `amount_to_pay` decimal(10, 2) NOT NULL,
    `donated_amount` decimal(10, 2) NOT NULL,
    `payment_status` enum('Paid', 'Pending', 'Partial') NOT NULL DEFAULT 'Pending',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

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
    `average_rating` decimal(3, 2) DEFAULT '0.00',
    `salary` decimal(10, 2) DEFAULT '1000.00',
    `shift_disponibility` enum('Lunch', 'Dinner', 'Flexible') NOT NULL DEFAULT 'Flexible',
    `is_active` tinyint(1) DEFAULT '1',
    `avatar_url` text,
    `bio` text,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Waiter`
--

INSERT INTO
    `Waiter` (
        `waiter_id`,
        `waiter_uuid`,
        `room_id`,
        `firstName`,
        `lastName`,
        `email`,
        `password`,
        `phone_number`,
        `hire_date`,
        `average_rating`,
        `salary`,
        `shift_disponibility`,
        `is_active`,
        `avatar_url`,
        `bio`,
        `created_at`,
        `updated_at`
    )
VALUES (
        31,
        'a0b846e9-37c8-4003-8cba-a8fdd26eb421',
        1,
        'Yolanda',
        'Yolanda',
        'yomogan@gmail.com',
        '$argon2i$v=19$m=65536,t=4,p=2$NHQxbmZGNlFtMGpPcHFoMQ$5ibTak/21NOtA/xFducdEjTxWZaENlAeNlJJ7j7jzrQ',
        NULL,
        '2024-12-11',
        0.00,
        1000.00,
        'Flexible',
        1,
        'https://i.pravatar.cc/300?u=c064c3f90164e2848de12c6df5060e29',
        NULL,
        '2024-12-11 22:39:17',
        '2024-12-11 22:39:17'
    );

--
-- Estructura de tabla para la tabla `Waiter`
--
CREATE TABLE `QR` (
    `id` INT NOT NULL,
    `booking_id` INT NOT NULL,
    `url` VARCHAR(500) NOT NULL,
    `status` ENUM(
        'Generated',
        'Printed',
        'In_progress',
        'Expired'
    ) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--
-- Índices para tablas volcadas
--
--
-- Indices de la tabla `QR`
--
ALTER TABLE `QR` ADD PRIMARY KEY (`id`);
--
-- Indices de la tabla `Blacklist`
--
ALTER TABLE `Blacklist` ADD PRIMARY KEY (`id`);

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
ALTER TABLE `Donations` ADD PRIMARY KEY (`donation_id`);

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
-- AUTO_INCREMENT de la tabla `QR`
--
ALTER TABLE `QR` MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Blacklist`
--
ALTER TABLE `Blacklist` MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

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
MODIFY `customer_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 22;

--
-- AUTO_INCREMENT de la tabla `Donations`
--
ALTER TABLE `Donations`
MODIFY `donation_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Feedback`
--
ALTER TABLE `Feedback`
MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Manager`
--
ALTER TABLE `Manager`
MODIFY `manager_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 5;

--
-- AUTO_INCREMENT de la tabla `NGO`
--
ALTER TABLE `NGO`
MODIFY `ngo_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 7;

--
-- AUTO_INCREMENT de la tabla `Orders`
--
ALTER TABLE `Orders` MODIFY `order_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Orders_Products`
--
ALTER TABLE `Orders_Products`
MODIFY `order_product_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Products`
--
ALTER TABLE `Products`
MODIFY `product_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 161;

--
-- AUTO_INCREMENT de la tabla `Room`
--
ALTER TABLE `Room`
MODIFY `room_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 7;

--
-- AUTO_INCREMENT de la tabla `Room_Shift`
--
ALTER TABLE `Room_Shift`
MODIFY `room_shift_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 373;

--
-- AUTO_INCREMENT de la tabla `Shift`
--
ALTER TABLE `Shift`
MODIFY `shift_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 63;

--
-- AUTO_INCREMENT de la tabla `Tickets`
--
ALTER TABLE `Tickets` MODIFY `ticket_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Waiter`
--
ALTER TABLE `Waiter`
MODIFY `waiter_id` int NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 32;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
;