-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Libros
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Libros
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Libros` DEFAULT CHARACTER SET utf8 ;
USE `Libros` ;

-- -----------------------------------------------------
-- Table `Libros`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Libros`.`usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Libros`.`libros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Libros`.`libros` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(255) NOT NULL,
  `num_paginas` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Libros`.`favoritos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Libros`.`favoritos` (
  `libro_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  PRIMARY KEY (`libro_id`, `usuario_id`),
  INDEX `fk_libros_has_usuarios_usuarios1_idx` (`usuario_id` ASC) VISIBLE,
  INDEX `fk_libros_has_usuarios_libros_idx` (`libro_id` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


USE libros;


-- Consulta: crea 5 usuarios diferentes: Jane Austen, Emily Dickinson, Fyodor Dostoevsky, William Shakespeare, Lau Tzu
INSERT INTO usuarios (name)
VALUES 
('Jane Austen'),
('Emily Dickinson'),
('Fyodor Dostoevsky'),
('William Shakespeare'),
('Lau Tzu');

-- Consulta: crea 5 libros con los siguientes nombres: C Sharp, Java, Python, PHP, Ruby
INSERT INTO libros (titulo, num_paginas)
VALUES 
('C Sharp', 500),
('Java',600),
('Python',800),
('PHP',300),
('Ruby',200);
-- Consulta: cambia el nombre del libro de C Sharp a C#
UPDATE  libros SET titulo = 'C#' WHERE id = 1;

-- Consulta: cambia el nombre del cuarto usuario a Bill
UPDATE  usuarios SET name = 'Bill' WHERE id = 4;

-- Consulta: haz que el primer usuario marque como favorito los 2 primeros libros
INSERT INTO favoritos (libro_id, usuario_id)
VALUES ((SELECT id FROM libros ORDER BY id LIMIT 1), 1),
       ((SELECT id FROM libros ORDER BY id LIMIT 1, 1), 1);

-- Consulta: haz que el segundo usuario marque como favorito los primeros 3 libros
INSERT INTO favoritos (libro_id, usuario_id)
VALUES ((SELECT id FROM libros ORDER BY id LIMIT 1), 2),
       ((SELECT id FROM libros ORDER BY id LIMIT 1, 1), 2),
       ((SELECT id FROM libros ORDER BY id LIMIT 2, 1), 2);
       
-- Consulta: haz que el tercer usuario marque como favorito los 4 primeros libros
INSERT INTO favoritos (libro_id, usuario_id)
VALUES ((SELECT id FROM libros ORDER BY id LIMIT 1), 3),
       ((SELECT id FROM libros ORDER BY id LIMIT 1, 1), 3),
       ((SELECT id FROM libros ORDER BY id LIMIT 2, 1), 3),
       ((SELECT id FROM libros ORDER BY id LIMIT 3, 1), 3);
       
-- Consulta: Haz que el cuarto usuario marque como favorito todos los libros
INSERT INTO favoritos (libro_id, usuario_id)
SELECT id, 4 FROM libros;
       
-- Consulta: recupera todos los usuarios que marcaron como favorito el tercer libro
SELECT name FROM usuarios, favoritos WHERE usuarios.id = favoritos.usuario_id and favoritos.libro_id = 3;

-- Consulta: elimina el primer usuario de los favoritos del tercer libro
DELETE FROM favoritos WHERE usuario_id = 1 and libro_id = 3;

-- Consulta: Haz que el quinto usuario marque como favorito el segundo libro
INSERT INTO favoritos (libro_id, usuario_id)
VALUES ((SELECT id FROM libros ORDER BY id LIMIT 1, 1), 5);

-- Encuentra todos los libros que el tercer usuario marcó como favoritos
SELECT titulo, usuario_id FROM  libros, favoritos WHERE libros.id= favoritos.libro_id and favoritos.usuario_id = 3;

-- Consulta: encuentra todos los usuarios que marcaron como favorito el quinto libro
SELECT id, name, libro_id FROM  usuarios, favoritos WHERE usuarios.id= favoritos.usuario_id and favoritos.libro_id = 5;
