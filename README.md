Para la base de datos [medicamentos.sql](https://github.com/user-attachments/files/24969690/medicamentos.sql)
-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-01-2026 a las 17:18:22
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `medicamentos_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medicamentos`
--

CREATE TABLE `medicamentos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `nombre_comercial` varchar(100) DEFAULT NULL,
  `dosis` text DEFAULT NULL,
  `indicaciones` text DEFAULT NULL,
  `contraindicaciones` text DEFAULT NULL,
  `efectos_secundarios` text DEFAULT NULL,
  `presentaciones` text DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `medicamentos`
--

INSERT INTO `medicamentos` (`id`, `nombre`, `nombre_comercial`, `dosis`, `indicaciones`, `contraindicaciones`, `efectos_secundarios`, `presentaciones`, `categoria`) VALUES
(1, 'paracetamol', 'Paracetamol', '500-1000 mg cada 6-8 horas', 'Fiebre y dolor leve a moderado', 'Hepatopatía, alcoholismo, hipersensibilidad', 'Náuseas, daño hepático en sobredosis', 'Tabletas, suspensión, supositorios', 'Analgésico, Antipirético'),
(2, 'ibuprofeno', 'Ibuprofeno', '400-600 mg cada 8 horas', 'Dolor, inflamación, fiebre', 'Úlcera gástrica, asma, insuficiencia renal', 'Gastritis, náuseas, mareos', 'Tabletas, gel, suspensión', 'Antiinflamatorio no esteroideo'),
(3, 'amoxicilina', 'Amoxicilina', '500 mg cada 8 horas', 'Infecciones bacterianas', 'Hipersensibilidad a penicilinas', 'Diarrea, náuseas, erupciones cutáneas', 'Cápsulas, suspensión, inyectable', 'Antibiótico'),
(4, 'omeprazol', 'Omeprazol', '20-40 mg al día', 'Acidez, úlcera gástrica, reflujo', 'Hipersensibilidad, cáncer gástrico', 'Dolor de cabeza, diarrea, náuseas', 'Cápsulas, polvo para suspensión', 'Inhibidor de bomba de protones'),
(5, 'loratadina', 'Loratadina', '10 mg al día', 'Alergias, rinitis, urticaria', 'Hipersensibilidad, lactancia', 'Somnolencia, dolor de cabeza, sequedad bucal', 'Tabletas, jarabe', 'Antihistamínico'),
(6, 'metformina', 'Metformina', '500-1000 mg cada 12 horas', 'Diabetes tipo 2', 'Insuficiencia renal, acidosis láctica', 'Diarrea, náuseas, dolor abdominal', 'Tabletas, solución oral', 'Antidiabético'),
(7, 'atorvastatina', 'Atorvastatina', '10-80 mg al día', 'Colesterol alto, prevención de eventos cardiovasculares', 'Enfermedad hepática, embarazo', 'Dolor muscular, náuseas, estreñimiento', 'Tabletas', 'Estatinas'),
(8, 'salbutamol', 'Salbutamol', '100-200 mcg cada 4-6 horas', 'Asma, broncoespasmo', 'Hipersensibilidad, taquicardia', 'Temblor, taquicardia, nerviosismo', 'Inhalador, solución para nebulizar', 'Broncodilatador'),
(9, 'losartan', 'Losartan', '50-100 mg al día', 'Hipertensión, protección renal en diabetes', 'Embarazo, hipersensibilidad', 'Mareos, hipotensión, hiperkalemia', 'Tabletas', 'Antihipertensivo'),
(10, 'diazepam', 'Diazepam', '2-10 mg cada 6-12 horas', 'Ansiedad, espasmos musculares, abstinencia alcohólica', 'Glaucoma, insuficiencia respiratoria, dependencia', 'Somnolencia, mareos, dependencia', 'Tabletas, inyectable, gel', 'Ansiolítico');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `medicamentos`
--
ALTER TABLE `medicamentos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `medicamentos`
--
ALTER TABLE `medicamentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
