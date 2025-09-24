-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2025 at 11:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `budget_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `budgets`
--

CREATE TABLE `budgets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currencies` varchar(3) NOT NULL,
  `type` enum('income','expense') NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `budgets`
--

INSERT INTO `budgets` (`id`, `user_id`, `category_id`, `name`, `amount`, `currencies`, `type`, `date`) VALUES
(2, 2, 1, 'coucou', 140.00, '', 'income', '2025-07-27 20:11:01'),
(6, 2, 1, 'jaw jaw', 200.00, '', 'income', '2025-07-27 20:44:21'),
(7, 2, 2, 'bal3a', 50.75, '', 'expense', '2025-07-27 20:50:42'),
(8, 2, 2, 'torh fifa', 50.75, '', 'expense', '2025-07-27 20:50:55'),
(18, 2, 1, 'aaa', 333.00, '', 'expense', '2025-09-24 00:17:07'),
(19, 2, 2, 'ddd', 224.00, '', 'income', '2025-09-24 00:44:35'),
(20, 2, 1, 'spotify', 10.00, '', 'expense', '2025-09-24 00:57:21'),
(21, 2, 2, 'BAL3A', 1000.00, '', 'income', '2025-09-24 00:58:37'),
(22, 2, 4, 'dar', 22.00, '', 'income', '2025-09-24 19:35:13'),
(23, 2, 2, 'AAABBB', 1111.00, '', 'expense', '2025-09-24 19:35:46'),
(24, 2, 2, 'manda', 10000.00, '', 'income', '2025-09-24 19:48:40'),
(25, 2, 4, 'masrouf', 222.00, '', 'expense', '2025-09-24 19:49:15'),
(26, 2, 4, 'flous', 300.00, '', 'income', '2025-09-24 19:49:44'),
(27, 2, 1, 'ffff', 333.00, '', 'expense', '2025-09-24 19:50:08'),
(28, 2, 4, 'zzz', 1000.00, '', 'income', '2025-09-24 20:42:36'),
(29, 2, 7, 'gggggg', 500.00, '', 'expense', '2025-09-24 20:43:14');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `budget` decimal(10,0) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `budget`, `description`) VALUES
(1, 'Essen & Trinken', 2111, 'Monatliches Einkommen'),
(2, 'Einkaufen', 300, 'Wocheneinkauf'),
(4, 'Wohnen', 200, NULL),
(5, 'Transport', 500, NULL),
(6, 'Fahrzeuge', 1000, NULL),
(7, 'Kultur & Unterhaltung', 1000, NULL),
(8, 'Kommunikation , PC', 1000, NULL),
(10, 'Finanzaufwand', 2111, NULL),
(11, 'Investitionen', 200, NULL),
(12, 'Einkommen', 500, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE `currencies` (
  `id` int(11) NOT NULL,
  `code` varchar(3) NOT NULL,
  `name` varchar(50) NOT NULL,
  `exchange_rate` decimal(10,6) DEFAULT 1.000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `currencies`
--

INSERT INTO `currencies` (`id`, `code`, `name`, `exchange_rate`) VALUES
(1, 'USD', 'US Dollar', 1.000000),
(2, 'EUR', 'Euro', 0.850000),
(3, 'GBP', 'British Pound', 0.750000),
(4, 'JPY', 'Japanese Yen', 110.000000);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `created_at`) VALUES
(1, 'testuser@example.com', '$2y$10$Wchc.36U963PFkXsrk.ZsO7..05TqsbgUxXMbhus8HLk37pPO.KYm', '2025-07-27 17:59:03'),
(2, 'test@example.com', '$2y$10$xncaOUl6N11I0JZqeRKMleQOzoSvgSsE5XdysPfHL4Ygz9H.sGD7S', '2025-07-27 19:51:06'),
(3, 'foufou@gmail.com', '$2y$10$xncaOUl6N11I0JZqeRKMleQOzoSvgSsE5XdysPfHL4Ygz9H.sGD7S', '2025-09-23 16:35:06');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `budgets`
--
ALTER TABLE `budgets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `budgets`
--
ALTER TABLE `budgets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `budgets`
--
ALTER TABLE `budgets`
  ADD CONSTRAINT `budgets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `budgets_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
