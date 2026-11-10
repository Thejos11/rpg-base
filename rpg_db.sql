-- =====================================================================
-- Base de datos del Simulador de Batalla RPG (Unidad 5.2 - JDBC y MVC)
-- =====================================================================
-- Motor: MySQL 8.0 o superior (compatible con MariaDB 10.5+)
-- Uso desde la raiz del repositorio:
--   mysql -u root -p < rpg_db.sql
--
-- Nota sobre arquitectura (Q-06):
-- El simulador principal funciona de forma autonoma mediante persistencia
-- de archivos binarios y de texto (partidas/partida.dat y partidas/log_combate.txt).
-- Este script corresponde al modulo complementario de persistencia relacional
-- de la Unidad 5.2 (JDBC/MVC).
--
-- El script es idempotente: se puede ejecutar varias veces sin errores
-- ni duplicados. Crea la base, la tabla `heroes`, datos de ejemplo y
-- deja listas las consultas de verificacion.
--
-- Las credenciales del juego NO van aqui: copia config.example.txt como
-- config.txt y completa url, usuario y clave (config.txt esta en .gitignore).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS rpg_grupal_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE rpg_grupal_db;

-- ---------------------------------------------------------------------
-- Tabla de heroes
--   nombre  : maximo 15 caracteres (igual que Personaje.LARGO_MAXIMO_NOMBRE)
--   tipo    : GUERRERO o MAGO (los unicos valores que acepta HeroeController)
--   nivel   : minimo 1 (igual que la validacion de Personaje.setNivel)
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- Datos de ejemplo: INSERT IGNORE evita duplicados si el script se
-- ejecuta de nuevo (uq_heroes_nombre rechaza nombres repetidos).
-- ---------------------------------------------------------------------
INSERT IGNORE INTO heroes (nombre, tipo, vida_maxima, nivel) VALUES
    ('Thor',      'GUERRERO', 120, 1),
    ('Merlin',    'MAGO',      80, 2),
    ('Aquiles',   'GUERRERO', 110, 3),
    ('Circe',     'MAGO',      90, 1),
    ('Beowulf',   'GUERRERO', 130, 5);

-- ---------------------------------------------------------------------
-- Consultas de verificacion (se muestran al ejecutar el script)
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS total_heroes FROM heroes;
SELECT id, nombre, tipo, vida_maxima, nivel FROM heroes ORDER BY id;
SELECT tipo, COUNT(*) AS cantidad, ROUND(AVG(nivel), 1) AS nivel_promedio
    FROM heroes GROUP BY tipo;
