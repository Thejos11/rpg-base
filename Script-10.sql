-- =====================================================================
-- Script-10.sql - Base de datos para Simulador de Batalla RPG (rpg-base)
-- =====================================================================
-- Este script vincula la base de datos MySQL con el proyecto Java 'rpg-base'.
-- Motor recomendado: MySQL 8.0+ / MariaDB 10.5+
--
-- Datos de conexion configurados en config.txt:
--   db.url=jdbc:mysql://localhost:3306/rpg_grupal_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
--   db.user=root
--   db.password=12345
--
-- El script es idempotente (se puede ejecutar varias veces sin duplicar datos).
-- =====================================================================

-- 1. Crear la base de datos del proyecto RPG
CREATE DATABASE IF NOT EXISTS rpg_grupal_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE rpg_grupal_db;

-- 2. Crear la tabla de heroes esperada por HeroeDAOImpl.java de rpg-base
-- Restricciones de integracion:
--   - nombre: maximo 15 caracteres (validador de Personaje) y unico
--   - tipo: GUERRERO o MAGO
--   - vida_maxima: mayor a 0
--   - nivel: entero >= 1 (regla de progresion de Personaje.setNivel)
CREATE TABLE IF NOT EXISTS heroes (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(15) NOT NULL,
    tipo ENUM('GUERRERO', 'MAGO') NOT NULL,
    vida_maxima INT NOT NULL,
    nivel INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    CONSTRAINT uq_heroes_nombre UNIQUE (nombre),
    CONSTRAINT ck_heroes_vida CHECK (vida_maxima > 0),
    CONSTRAINT ck_heroes_nivel CHECK (nivel >= 1)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- 3. Cargar datos de prueba iniciales (INSERT IGNORE evita duplicados)
INSERT IGNORE INTO heroes (nombre, tipo, vida_maxima, nivel) VALUES
    ('Thor',      'GUERRERO', 120, 1),
    ('Merlin',    'MAGO',      80, 2),
    ('Aquiles',   'GUERRERO', 110, 3),
    ('Circe',     'MAGO',      90, 1),
    ('Beowulf',   'GUERRERO', 130, 5);

-- 4. Consultas de verificacion para ejecutar en DBeaver
SELECT COUNT(*) AS total_heroes FROM heroes;
SELECT id, nombre, tipo, vida_maxima, nivel FROM heroes ORDER BY id;
SELECT tipo, COUNT(*) AS cantidad, ROUND(AVG(nivel), 1) AS nivel_promedio
    FROM heroes GROUP BY tipo;
