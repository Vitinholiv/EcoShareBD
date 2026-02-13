DROP DATABASE  ecoShareDB;
CREATE DATABASE ecoShareDB;
USE ecoShareDB;

-- ### Gerenciamento de usuários

DROP TABLE IF EXISTS `ecoShareDB`.`usuario_doc_tipo`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`usuario_doc_tipo` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `usuario_doc_tipo_nome` VARCHAR(10) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS `ecoShareDB`.`usuario`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`usuario` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `usuario_doc_tipo_id` INT NOT NULL,
    FOREIGN KEY (`usuario_doc_tipo_id`)
    REFERENCES `ecoShareDB`.`usuario_doc_tipo` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

    `usuario_doc` VARCHAR(40) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `username` VARCHAR(40) NOT NULL UNIQUE,
    `nome` VARCHAR(100) NOT NULL,
    `senha` VARCHAR(100) NOT NULL,

    CONSTRAINT `validar_documento` CHECK (`usuario_doc` REGEXP '^[A-Za-z0-9. /-]+$'),
    CONSTRAINT `validar_email` CHECK (`email` LIKE '%@%')
);

DROP TABLE IF EXISTS `ecoShareDb`.`cupom`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`cupom` (
    `codigo` INT PRIMARY KEY AUTO_INCREMENT,
    `usuario_id` INT NOT NULL,
    FOREIGN KEY (`usuario_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    `sorteio_id` INT NOT NULL
);


DROP TABLE IF EXISTS `ecoShareDB`.`usuario_telefone`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`usuario_telefone` (
    `telefone_ordem` INT NOT NULL,
    `usuario_id` INT NOT NULL,
    PRIMARY KEY (`telefone_ordem`, `usuario_id`),
    FOREIGN KEY (`usuario_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    `telefone` VARCHAR(40) UNIQUE NOT NULL,

    CONSTRAINT `validar_telefone` CHECK (`telefone` REGEXP '^\\+[0-9]+ [0-9 ]+$')
);

DROP TABLE IF EXISTS `ecoShareDB`.`endereco`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`endereco` (
    `endereco_ordem` INT NOT NULL,
    `usuario_id` INT NOT NULL,
    PRIMARY KEY (`endereco_ordem`, `usuario_id`),
    FOREIGN KEY (`usuario_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    `CEP` VARCHAR(30) NOT NULL,
    `pais` VARCHAR(45) NOT NULL,
    `estado` VARCHAR(45) NULL,
    `cidade` VARCHAR(45) NOT NULL,
    `bairro` VARCHAR(100) NOT NULL,
    `logradouro` VARCHAR(250) NOT NULL,
    `complemento` VARCHAR(100) NULL,
    `numero` INT NULL
);


DROP TABLE IF EXISTS `ecoShareDB`.`avaliacao_usuario`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`avaliacao_usuario` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `usuario1_id` INT NULL,
    `usuario2_id` INT NOT NULL,
    FOREIGN KEY (`usuario1_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
    FOREIGN KEY (`usuario2_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    `descricao` VARCHAR(200) NULL,
    `nota` INT NOT NULL,
    `likes` INT NULL DEFAULT 0,
    `data_avaliacao` DATE NOT NULL,

    CONSTRAINT `validar_likes_usuario` CHECK (`likes` >= 0),
    CONSTRAINT `validar_nota_usuario` CHECK (`nota` >= 0 AND `nota` <= 5)
);

-- ### Gerenciamento de item

DROP TABLE IF EXISTS `ecoShareDB`.`item_status`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`item_status` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `item_status` VARCHAR(30) NOT NULL UNIQUE
);


DROP TABLE IF EXISTS `ecoShareDB`.`item`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`item` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `usuario_id` INT NOT NULL,
    FOREIGN KEY (`usuario_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    `descricao` TEXT NOT NULL,
    `nome` VARCHAR(200) NOT NULL
);


DROP TABLE IF EXISTS `ecoShareDB`.`item_legado`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`item_legado` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `descricao` TEXT NOT NULL,
    `nome` VARCHAR(200) NOT NULL,
    `item_id` INT NOT NULL
);

-- Trigger para preencher a tabela item_legado

DELIMITER //

CREATE TRIGGER `tg_item_before_update`
BEFORE UPDATE ON `ecoShareDB`.`item`
FOR EACH ROW
BEGIN
    INSERT INTO `ecoShareDB`.`item_legado` 
    (nome, descricao, item_id )
    VALUES 
    (OLD.nome, OLD.descricao, OLD.id);
END//

CREATE TRIGGER `tg_item_before_insert`
BEFORE INSERT ON `ecoShareDB`.`item`
FOR EACH ROW
BEGIN
    INSERT INTO `ecoShareDB`.`item_legado` 
    (nome, descricao, item_id )
    VALUES 
    (NEW.nome, NEW.descricao, NEW.id);
END//


DELIMITER ;

DROP TABLE IF EXISTS `ecoShareDB`.`item_novo`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`item_novo` (
    `item_id` INT PRIMARY KEY,
    FOREIGN KEY (`item_id`)
    REFERENCES `ecoShareDB`.`item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    `estoque` INT NOT NULL DEFAULT 1,

    CONSTRAINT `validar_estoque` CHECK (`estoque` >= 0)
);

DROP TABLE IF EXISTS `ecoShareDB`.`item_usado`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`item_usado` (
    `item_id` INT PRIMARY KEY,
    FOREIGN KEY (`item_id`)
    REFERENCES `ecoShareDB`.`item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    `item_status_id` INT NOT NULL,
    FOREIGN KEY (`item_status_id`)
    REFERENCES `ecoShareDB`.`item_status` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `ecoShareDB`.`manutencao`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`manutencao` (
    `manutencao_id` INT NOT NULL,
    `item_id` INT NOT NULL,
    PRIMARY KEY (`manutencao_id`, `item_id`),
    FOREIGN KEY (`item_id`)
    REFERENCES `ecoShareDB`.`item_usado` (`item_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    `data_manutencao` DATE NOT NULL,
    `laudo` VARCHAR(120) NULL
);

DROP TABLE IF EXISTS `ecoShareDB`.`avaliacao_item`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`avaliacao_item` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `usuario_id` INT NULL,
    `item_id` INT NOT NULL,
    FOREIGN KEY (`usuario_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
    FOREIGN KEY (`item_id`)
    REFERENCES `ecoShareDB`.`item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    `descricao` VARCHAR(200) NULL,
    `nota` INT NOT NULL,
    `likes` INT NULL DEFAULT 0,
    `data_avaliacao` DATE NOT NULL,

    CONSTRAINT `validar_likes_item` CHECK (`likes` >= 0),
    CONSTRAINT `validar_nota_item` CHECK (`nota` >= 0 AND `nota` <= 5)
);

DROP TABLE IF EXISTS `ecoShareDB`.`validacao_foto`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`validacao_foto` (
    `hash` VARCHAR(60)
);

-- ### Gerenciamento de anuncios e Registros

DROP TABLE IF EXISTS `ecoShareDB`.`forma_pagamento`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`forma_pagamento` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `forma` VARCHAR(60) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS `ecoShareDB`.`anuncio_tipo`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`anuncio_tipo` (
    `anuncio_tipo_id` INT PRIMARY KEY AUTO_INCREMENT,
    `tipo` VARCHAR(40) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS `ecoShareDB`.`atendimento_status`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`atendimento_status` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `status` VARCHAR(60) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS `ecoShareDB`.`registro`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`registro` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,

    `doc_tipo_provedor` INT NOT NULL,
    `doc_provedor` VARCHAR(40) NOT NULL,

    `doc_tipo_cliente` INT NOT NULL,
    `doc_cliente` VARCHAR(40) NOT NULL,

    `item_legado_id` INT NOT NULL,
    `forma_pagamento_id` INT NOT NULL,
    `data_registro` DATE NOT NULL,
    `valor_registro` DECIMAL(16,2) NULL,

    FOREIGN KEY (`item_legado_id`) REFERENCES `ecoShareDB`.`item_legado` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT

);


DROP TABLE IF EXISTS `ecoShareDB`.`atendimento`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`atendimento` (
    `protocolo` VARCHAR(100) PRIMARY KEY,
    `atendimento_status_id` INT NOT NULL,
    FOREIGN KEY (`atendimento_status_id`)
    REFERENCES `ecoShareDB`.`atendimento_status` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    `usuario_id` INT NOT NULL,
    FOREIGN KEY (`usuario_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    `registro_id` INT NULL,
    FOREIGN KEY (`registro_id`)
    REFERENCES `ecoShareDB`.`registro` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

    `descricao` TEXT NOT NULL
);

DROP TABLE IF EXISTS `ecoShareDB`.`anuncio`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`anuncio` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `usuario_id` INT NOT NULL,
    `tipo` INT NOT NULL,
    `item_id` INT NOT NULL,
    `endereco_ordem` INT NOT NULL,
    `nome` VARCHAR(200) NOT NULL,
    `valor_anuncio` DECIMAL(16,2) NULL,
    `descricao` TEXT NOT NULL,
    `data_anuncio` DATE NOT NULL,

    FOREIGN KEY (`usuario_id`)
    REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    FOREIGN KEY (`item_id`)
    REFERENCES `ecoShareDB`.`item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (`usuario_id`, `endereco_ordem`)
    REFERENCES `ecoShareDB`.`endereco` (`usuario_id`, `endereco_ordem`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (`tipo`)
    REFERENCES `ecoShareDB`.`anuncio_tipo` (`anuncio_tipo_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `ecoShareDB`.`proposta`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`proposta` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `anuncio_id` INT NOT NULL,
    `usuario_id` INT NOT NULL,
    `valor` DECIMAL(16,2) NULL,
    `texto_proposta` TEXT NOT NULL,
    `item_oferecido_id` INT NULL,
    `data_proposta` DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (`anuncio_id`) REFERENCES `ecoShareDB`.`anuncio` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (`usuario_id`) REFERENCES `ecoShareDB`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (`item_oferecido_id`) REFERENCES `ecoShareDB`.`item` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `ecoShareDB`.`registro_troca`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`registro_troca` (
    `registro_id` INT PRIMARY KEY,
    FOREIGN KEY (`registro_id`)
    REFERENCES `ecoShareDB`.`registro` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    `item_legado_id` INT NOT NULL,

    FOREIGN KEY (`item_legado_id`) REFERENCES `ecoShareDB`.`item_legado` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);

DROP TABLE IF EXISTS `ecoShareDB`.`registro_venda`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`registro_venda` (
    `registro_id` INT PRIMARY KEY,
    FOREIGN KEY (`registro_id`)
    REFERENCES `ecoShareDB`.`registro` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `ecoShareDB`.`registro_emprestimo`;
CREATE TABLE IF NOT EXISTS `ecoShareDB`.`registro_emprestimo` (
    `registro_id` INT PRIMARY KEY,
    `data_previsao` DATE NOT NULL,
    `data_entregue` DATE NULL,

    FOREIGN KEY (`registro_id`)
    REFERENCES `ecoShareDB`.`registro` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

DELIMITER //

CREATE TRIGGER `tg_limpar_anuncios_pos_transferencia`
AFTER UPDATE ON `item`
FOR EACH ROW
BEGIN
    IF OLD.usuario_id <> NEW.usuario_id THEN
        DELETE FROM `anuncio` 
        WHERE `item_id` = OLD.id 
        AND `usuario_id` = OLD.usuario_id;
    END IF;
END//

DELIMITER ;