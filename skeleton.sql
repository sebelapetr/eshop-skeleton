-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) NOT NULL,
  `category_label` varchar(255) NOT NULL,
  `description` text,
  `visible` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_label` (`category_label`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `categories` (`id`, `category_name`, `category_label`, `description`, `visible`) VALUES
(1,	'Kategorie 1',	'kategorie-1',	'Lorem ipsum',	1),
(2,	'Pdkategorie 1',	'podkategorie-1',	'Lorem ipsum',	1),
(3,	'Pod podkategorie 3',	'pod-podkategorie-3',	'Lorem ipsum',	1);

DROP TABLE IF EXISTS `category_parents`;
CREATE TABLE `category_parents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` int(11) NOT NULL,
  `parent` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category` (`category`),
  KEY `parent` (`parent`),
  CONSTRAINT `category_parents_ibfk_1` FOREIGN KEY (`category`) REFERENCES `categories` (`id`),
  CONSTRAINT `category_parents_ibfk_2` FOREIGN KEY (`parent`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `category_parents` (`id`, `category`, `parent`) VALUES
(1,	1,	NULL),
(2,	2,	1),
(3,	3,	2);

DROP TABLE IF EXISTS `newsletters`;
CREATE TABLE `newsletters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  `allowed` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `surname` varchar(255) NOT NULL,
  `telephone` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `street` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `psc` varchar(255) NOT NULL,
  `note` text,
  `company` varchar(255) DEFAULT NULL,
  `ico` varchar(255) DEFAULT NULL,
  `dic` varchar(255) DEFAULT NULL,
  `delivery_name` varchar(255) DEFAULT NULL,
  `delivery_surname` varchar(255) DEFAULT NULL,
  `delivery_company` varchar(255) DEFAULT NULL,
  `delivery_street` varchar(255) DEFAULT NULL,
  `delivery_city` varchar(255) DEFAULT NULL,
  `delivery_psc` varchar(255) DEFAULT NULL,
  `newsletter` varchar(255) DEFAULT NULL,
  `total_price` float NOT NULL,
  `total_price_vat` float NOT NULL,
  `created_at` datetime NOT NULL,
  `state` int(11) NOT NULL,
  `variable_symbol` int(11) DEFAULT NULL,
  `invoice` varchar(255) DEFAULT NULL,
  `type_payment` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `orders` (`id`, `name`, `surname`, `telephone`, `email`, `street`, `city`, `psc`, `note`, `company`, `ico`, `dic`, `delivery_name`, `delivery_surname`, `delivery_company`, `delivery_street`, `delivery_city`, `delivery_psc`, `newsletter`, `total_price`, `total_price_vat`, `created_at`, `state`, `variable_symbol`, `invoice`, `type_payment`) VALUES
(1,	'petrsebel@seznam.cz',	'Surname',	'605200686',	'petrsebel@seznam.cz',	'Ulice 1231',	'Jedovnice',	'67906',	'',	'Petr Šebela',	'123',	'',	'',	'',	'',	'',	'',	'',	'1',	0,	0,	'2019-09-12 16:55:25',	0,	NULL,	NULL,	2),
(2,	'petrsebel@seznam.cz',	'Surname',	'605200686',	'petrsebel@seznam.cz',	'Ulice 1231',	'Jedovnice',	'67906',	'',	'Petr Šebela',	'123',	'',	'',	'',	'',	'',	'',	'',	'1',	0,	0,	'2019-09-12 16:57:15',	0,	NULL,	NULL,	2),
(3,	'petrsebel@seznam.cz',	'Surname',	'605200686',	'petrsebel@seznam.cz',	'Ulice 1231',	'Jedovnice',	'67906',	'',	'Petr Šebela',	'123',	'',	'',	'',	'',	'',	'',	'',	'1',	0,	0,	'2019-09-12 16:57:26',	0,	NULL,	NULL,	2),
(4,	'petrsebel@seznam.cz',	'Surname',	'605200686',	'petrsebel@seznam.cz',	'Ulice 1231',	'Jedovnice',	'67906',	'',	'Petr Šebela',	'123',	'',	'',	'',	'',	'',	'',	'',	'1',	1,	1,	'2019-09-12 16:57:38',	0,	NULL,	NULL,	2);

DROP TABLE IF EXISTS `orders_items`;
CREATE TABLE `orders_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` float NOT NULL,
  `price_vat` float NOT NULL,
  `quantity` int(11) NOT NULL,
  `vat` int(11) NOT NULL,
  `product` int(11) DEFAULT NULL,
  `order` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `category_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order` (`order`),
  KEY `product` (`product`),
  CONSTRAINT `orders_items_ibfk_4` FOREIGN KEY (`order`) REFERENCES `orders` (`id`),
  CONSTRAINT `orders_items_ibfk_5` FOREIGN KEY (`product`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `orders_items` (`id`, `type`, `name`, `price`, `price_vat`, `quantity`, `vat`, `product`, `order`, `created_at`, `category_type`) VALUES
(1,	1,	'Produkt 2',	1,	1,	1,	0,	2,	4,	NULL,	NULL),
(2,	2,	'Osobní odběr na pobočce v Brně',	0,	0,	1,	21,	NULL,	4,	NULL,	NULL),
(3,	3,	'Platba převodem na účet',	0,	0,	1,	21,	NULL,	4,	NULL,	NULL);

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) NOT NULL,
  `brand_name` varchar(255) DEFAULT NULL,
  `vendor_internal_id` int(11) DEFAULT NULL,
  `vendor_name` varchar(255) DEFAULT NULL,
  `ean` varchar(255) DEFAULT NULL,
  `catalog_price` float DEFAULT NULL,
  `catalog_price_vat` float DEFAULT NULL,
  `client_price` float DEFAULT NULL,
  `client_price_vat` float DEFAULT NULL,
  `retail_price` int(11) DEFAULT NULL,
  `vat` int(11) DEFAULT NULL,
  `in_stock` int(11) DEFAULT NULL,
  `min_stock_level` int(11) DEFAULT NULL,
  `stock_level` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text,
  `weight` int(11) DEFAULT NULL,
  `recept` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `sukl` varchar(255) DEFAULT NULL,
  `pdk_id` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `price_list` varchar(255) DEFAULT NULL,
  `restrictions` varchar(255) DEFAULT NULL,
  `too_order` varchar(255) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `saled` int(11) DEFAULT NULL,
  `available` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category` (`category`),
  FULLTEXT KEY `product_name_2` (`product_name`),
  FULLTEXT KEY `description_2` (`description`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category`) REFERENCES `categories` (`id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `products` (`id`, `product_name`, `brand_name`, `vendor_internal_id`, `vendor_name`, `ean`, `catalog_price`, `catalog_price_vat`, `client_price`, `client_price_vat`, `retail_price`, `vat`, `in_stock`, `min_stock_level`, `stock_level`, `image`, `description`, `weight`, `recept`, `active`, `sukl`, `pdk_id`, `url`, `price_list`, `restrictions`, `too_order`, `category`, `saled`, `available`) VALUES
(1,	'Produkt 1',	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	2,	NULL,	NULL),
(2,	'Produkt 2',	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	2,	NULL,	NULL),
(3,	'Produkt 3',	NULL,	NULL,	NULL,	NULL,	1,	1,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	3,	NULL,	NULL);

DROP TABLE IF EXISTS `quotes`;
CREATE TABLE `quotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `text` text,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `state` int(11) NOT NULL DEFAULT '0',
  `city` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `product` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product` (`product`),
  CONSTRAINT `quotes_ibfk_1` FOREIGN KEY (`product`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_clean` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `type` enum('INTEGER','STRING','BOOLEAN') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2019-09-12 15:03:11
