SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema xtremo
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `xtremo` ;
CREATE SCHEMA IF NOT EXISTS `xtremo` DEFAULT CHARACTER SET utf8 ;

USE `xtremo` ;

-- -----------------------------------------------------
-- Table `xtremo`.`tipo_plataforma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`tipo_plataforma` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`tipo_plataforma` (
  `id_tipo_plataforma` INT NOT NULL,
  `tipo` VARCHAR(40) NULL,
  PRIMARY KEY (`id_tipo_plataforma`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `xtremo`.`mensagem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`mensagem` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`mensagem` (
  `id_mensagem` INT NOT NULL,
  `data_envio` VARCHAR(45) NULL,
  `id_episodio` INT NULL,
  PRIMARY KEY (`id_mensagem`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `xtremo`.`anunciante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`anunciante` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`anunciante` (
  `id_anunciante` INT NOT NULL,
  `nome_empresa` VARCHAR(100) NULL DEFAULT NULL,
  `segmento_mercado` VARCHAR(50) NULL DEFAULT NULL,
  `contato_comercial` VARCHAR(100) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `orcamento_mensal` DECIMAL(10,2) NULL DEFAULT NULL,
  `ativo` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_anunciante`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`tipo_anuncio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`tipo_anuncio` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`tipo_anuncio` (
  `id_tipo_anuncio` INT NOT NULL,
  `nome` VARCHAR(50) NULL DEFAULT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `duracao_segundos` INT NULL DEFAULT NULL,
  `preco_base` DECIMAL(8,2) NULL DEFAULT NULL,
  PRIMARY KEY (`id_tipo_anuncio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`anuncio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`anuncio` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`anuncio` (
  `id_anuncio` INT NOT NULL,
  `id_anunciante` INT NULL DEFAULT NULL,
  `id_tipo_anuncio` INT NULL DEFAULT NULL,
  `script_leitura` TEXT NULL DEFAULT NULL,
  `url_banner` VARCHAR(200) NULL DEFAULT NULL,
  `call_to_action` VARCHAR(200) NULL DEFAULT NULL,
  `codigo_desconto` VARCHAR(20) NULL DEFAULT NULL,
  `valor_por_mencao` DECIMAL(8,2) NULL DEFAULT NULL,
  `ativo` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_anuncio`),
  INDEX `id_anunciante` (`id_anunciante` ASC) VISIBLE,
  INDEX `id_tipo_anuncio` (`id_tipo_anuncio` ASC) VISIBLE,
  CONSTRAINT `anuncio_ibfk_1`
    FOREIGN KEY (`id_anunciante`)
    REFERENCES `xtremo`.`anunciante` (`id_anunciante`),
  CONSTRAINT `anuncio_ibfk_2`
    FOREIGN KEY (`id_tipo_anuncio`)
    REFERENCES `xtremo`.`tipo_anuncio` (`id_tipo_anuncio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`podcast`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`podcast` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`podcast` (
  `id_podcast` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `categoria` VARCHAR(50) NULL DEFAULT NULL,
  `idioma` VARCHAR(20) NULL DEFAULT 'Português',
  `explicito` TINYINT(1) NULL DEFAULT '0',
  `data_criacao` DATE NULL DEFAULT NULL,
  `ativo` TINYINT(1) NULL DEFAULT '1',
  `website` VARCHAR(200) NULL DEFAULT NULL,
  `email_contato` VARCHAR(100) NULL DEFAULT NULL,
  `logo_url` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`id_podcast`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`episodio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`episodio` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`episodio` (
  `id_episodio` INT NOT NULL,
  `id_podcast` INT NULL DEFAULT NULL,
  `numero_episodio` INT NULL DEFAULT NULL,
  `titulo` VARCHAR(200) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `data_gravacao` DATETIME NULL DEFAULT NULL,
  `duracao_minutos` INT NULL DEFAULT NULL,
  `publico` TINYINT(1) NULL DEFAULT '1',
  `temporada` INT NULL DEFAULT '1',
  `thumbnail_url` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`id_episodio`),
  UNIQUE INDEX `unique_episode` (`id_podcast` ASC, `numero_episodio` ASC) VISIBLE,
  CONSTRAINT `episodio_ibfk_1`
    FOREIGN KEY (`id_podcast`)
    REFERENCES `xtremo`.`podcast` (`id_podcast`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`anuncio_episodio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`anuncio_episodio` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`anuncio_episodio` (
  `id_anuncio_episodio` INT NOT NULL,
  `id_episodio` INT NULL DEFAULT NULL,
  `id_anuncio` INT NULL DEFAULT NULL,
  `momento_leitura` DATETIME NULL DEFAULT NULL,
  `ouvintes_momento` INT NULL DEFAULT NULL,
  `valor_pago` DECIMAL(8,2) NULL DEFAULT NULL,
  `lido_completo` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_anuncio_episodio`),
  INDEX `id_episodio` (`id_episodio` ASC) VISIBLE,
  INDEX `id_anuncio` (`id_anuncio` ASC) VISIBLE,
  CONSTRAINT `anuncio_episodio_ibfk_1`
    FOREIGN KEY (`id_episodio`)
    REFERENCES `xtremo`.`episodio` (`id_episodio`),
  CONSTRAINT `anuncio_episodio_ibfk_2`
    FOREIGN KEY (`id_anuncio`)
    REFERENCES `xtremo`.`anuncio` (`id_anuncio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`convidado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`convidado` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`convidado` (
  `id_convidado` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `profissao` VARCHAR(100) NULL DEFAULT NULL,
  `empresa` VARCHAR(100) NULL DEFAULT NULL,
  `biografia` TEXT NULL DEFAULT NULL,
  `contato_email` VARCHAR(100) NULL DEFAULT NULL,
  `redes_sociais` JSON NULL DEFAULT NULL,
  `cache` DECIMAL(8,2) NULL DEFAULT NULL,
  `blocklisted` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id_convidado`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`episodio_convidado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`episodio_convidado` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`episodio_convidado` (
  `id_episodio_convidado` INT NOT NULL,
  `id_episodio` INT NULL DEFAULT NULL,
  `id_convidado` INT NULL DEFAULT NULL,
  `confirmado` TINYINT(1) NULL DEFAULT '0',
  `presente` TINYINT(1) NULL DEFAULT '0',
  `tempo_participacao_minutos` INT NULL DEFAULT NULL,
  `avaliacao_performance` ENUM('Ruim', 'Regular', 'Boa', 'Excelente') NULL DEFAULT NULL,
  PRIMARY KEY (`id_episodio_convidado`),
  INDEX `id_episodio` (`id_episodio` ASC) VISIBLE,
  INDEX `id_convidado` (`id_convidado` ASC) VISIBLE,
  CONSTRAINT `episodio_convidado_ibfk_1`
    FOREIGN KEY (`id_episodio`)
    REFERENCES `xtremo`.`episodio` (`id_episodio`),
  CONSTRAINT `episodio_convidado_ibfk_2`
    FOREIGN KEY (`id_convidado`)
    REFERENCES `xtremo`.`convidado` (`id_convidado`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`plataforma_distribuicao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`plataforma_distribuicao` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`plataforma_distribuicao` (
  `id_plataforma` INT NOT NULL,
  `nome` VARCHAR(50) NOT NULL,
  `taxa_plataforma` DECIMAL(5,2) NULL DEFAULT NULL,
  `limite_ouvintes` INT NULL DEFAULT NULL,
  `permite_monetizacao` TINYINT(1) NULL DEFAULT '1',
  `api_key` VARCHAR(100) NULL DEFAULT NULL,
  `ativa` TINYINT(1) NULL DEFAULT '1',
  `id_tipo_plataforma` INT NOT NULL,
  PRIMARY KEY (`id_plataforma`),
  INDEX `fk_plataforma_distribuicao_tipo_plataforma1_idx` (`id_tipo_plataforma` ASC) VISIBLE,
  CONSTRAINT `fk_plataforma_distribuicao_tipo_plataforma1`
    FOREIGN KEY (`id_tipo_plataforma`)
    REFERENCES `xtremo`.`tipo_plataforma` (`id_tipo_plataforma`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`episodio_plataforma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`episodio_plataforma` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`episodio_plataforma` (
  `id_episodio_plataforma` INT NOT NULL,
  `id_episodio` INT NULL DEFAULT NULL,
  `id_plataforma` INT NULL DEFAULT NULL,
  `url_stream` VARCHAR(300) NULL DEFAULT NULL,
  `ouvintes_pico` INT NULL DEFAULT NULL,
  `receita_plataforma` DECIMAL(8,2) NULL DEFAULT '0.00',
  `chat_ativo` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id_episodio_plataforma`),
  INDEX `id_episodio` (`id_episodio` ASC) VISIBLE,
  INDEX `id_plataforma` (`id_plataforma` ASC) VISIBLE,
  CONSTRAINT `episodio_plataforma_ibfk_1`
    FOREIGN KEY (`id_episodio`)
    REFERENCES `xtremo`.`episodio` (`id_episodio`),
  CONSTRAINT `episodio_plataforma_ibfk_2`
    FOREIGN KEY (`id_plataforma`)
    REFERENCES `xtremo`.`plataforma_distribuicao` (`id_plataforma`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`topico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`topico` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`topico` (
  `id_topico` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `trending` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id_topico`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`episodio_topico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`episodio_topico` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`episodio_topico` (
  `id_episodio_topico` INT NOT NULL,
  `id_episodio` INT NULL DEFAULT NULL,
  `id_topico` INT NULL DEFAULT NULL,
  `tempo_inicio_minutos` INT NULL DEFAULT NULL,
  `tempo_fim_minutos` INT NULL DEFAULT NULL,
  `topico_principal` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id_episodio_topico`),
  INDEX `id_episodio` (`id_episodio` ASC) VISIBLE,
  INDEX `id_topico` (`id_topico` ASC) VISIBLE,
  CONSTRAINT `episodio_topico_ibfk_1`
    FOREIGN KEY (`id_episodio`)
    REFERENCES `xtremo`.`episodio` (`id_episodio`),
  CONSTRAINT `episodio_topico_ibfk_2`
    FOREIGN KEY (`id_topico`)
    REFERENCES `xtremo`.`topico` (`id_topico`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`host`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`host` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`host` (
  `id_host` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `biografia` TEXT NULL DEFAULT NULL,
  `especialidade` VARCHAR(100) NULL DEFAULT NULL,
  `twitter` VARCHAR(50) NULL DEFAULT NULL,
  `instagram` VARCHAR(50) NULL DEFAULT NULL,
  `linkedin` VARCHAR(100) NULL DEFAULT NULL,
  `cache_por_episodio` DECIMAL(8,2) NULL DEFAULT NULL,
  `host_principal` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id_host`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `xtremo`.`podcast_host`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `xtremo`.`podcast_host` ;

CREATE TABLE IF NOT EXISTS `xtremo`.`podcast_host` (
  `id_podcast_host` INT NOT NULL,
  `id_podcast` INT NULL DEFAULT NULL,
  `id_host` INT NULL DEFAULT NULL,
  `data_inicio` DATE NULL DEFAULT NULL,
  `data_fim` DATE NULL DEFAULT NULL,
  `papel` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id_podcast_host`),
  INDEX `id_podcast` (`id_podcast` ASC) VISIBLE,
  INDEX `id_host` (`id_host` ASC) VISIBLE,
  CONSTRAINT `podcast_host_ibfk_1`
    FOREIGN KEY (`id_podcast`)
    REFERENCES `xtremo`.`podcast` (`id_podcast`),
  CONSTRAINT `podcast_host_ibfk_2`
    FOREIGN KEY (`id_host`)
    REFERENCES `xtremo`.`host` (`id_host`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
