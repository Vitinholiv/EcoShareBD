DROP DATABASE  ecoShareDB;
CREATE DATABASE ecoShareDB;
USE ecoShareDB;

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

FLUSH TABLES;
FLUSH PRIVILEGES;

-- 1. MEU PERFIL
CREATE OR REPLACE VIEW view_perfil_proprio AS
SELECT 
    id, usuario_doc_tipo_id, usuario_doc, email, username, nome, senha 
FROM usuario 
WHERE username = SUBSTRING_INDEX(USER(), '@', 1);

-- 2. MEUS ENDEREÇOS
CREATE OR REPLACE VIEW view_meus_enderecos AS
SELECT e.* FROM endereco e
INNER JOIN usuario u ON e.usuario_id = u.id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- 3. MEUS TELEFONES
CREATE OR REPLACE VIEW view_meus_telefones AS
SELECT ut.* FROM usuario_telefone ut
INNER JOIN usuario u ON ut.usuario_id = u.id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- 4. MEUS ITENS (INVENTÁRIO)
CREATE OR REPLACE VIEW view_meus_itens AS
SELECT i.* FROM item i
INNER JOIN usuario u ON i.usuario_id = u.id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- 5. MEUS ANÚNCIOS
CREATE OR REPLACE VIEW view_meus_anuncios AS
SELECT a.* FROM anuncio a
INNER JOIN usuario u ON a.usuario_id = u.id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- 6. MINHAS PROPOSTAS (FEITAS POR MIM)
CREATE OR REPLACE VIEW view_minhas_propostas AS
SELECT p.* FROM proposta p
INNER JOIN usuario u ON p.usuario_id = u.id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- 7. MINHAS AVALIAÇÕES 
CREATE OR REPLACE VIEW view_minhas_avaliacoes_item AS
SELECT ai.* FROM avaliacao_item ai
INNER JOIN usuario u ON ai.usuario_id = u.id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

CREATE OR REPLACE VIEW view_minhas_avaliacoes_usuario AS
SELECT au.* FROM avaliacao_usuario au
INNER JOIN usuario u ON au.usuario1_id = u.id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);


-- 8. MEUS REGISTROS (VENDAS/TROCAS/EMPRÉSTIMOS)
CREATE OR REPLACE VIEW view_meus_registros AS
SELECT r.* FROM registro r
INNER JOIN usuario u ON 
    (u.usuario_doc = r.doc_cliente AND u.usuario_doc_tipo_id = r.doc_tipo_cliente)
    OR 
    (u.usuario_doc = r.doc_provedor AND u.usuario_doc_tipo_id = r.doc_tipo_provedor)
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- 9. MINHAS TROCAS ESPECÍFICAS
CREATE OR REPLACE VIEW view_minhas_trocas AS
SELECT rt.*, r.data_registro 
FROM registro_troca rt
INNER JOIN registro r ON rt.registro_id = r.id
INNER JOIN usuario u ON 
    (u.usuario_doc = r.doc_cliente AND u.usuario_doc_tipo_id = r.doc_tipo_cliente)
    OR 
    (u.usuario_doc = r.doc_provedor AND u.usuario_doc_tipo_id = r.doc_tipo_provedor)
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- VIEW ADMINISTRATIVA (PARA MODERADORES/ADMINS)
CREATE OR REPLACE VIEW view_controle_usuarios_admin AS
SELECT 
    u.id,
    u.nome,
    u.username,
    u.email,
    u.usuario_doc,
    (SELECT COUNT(*) FROM item WHERE usuario_id = u.id) as qtd_itens,
    (SELECT COUNT(*) FROM anuncio WHERE usuario_id = u.id) as qtd_anuncios
FROM usuario u;

-- ROLES
DROP ROLE IF EXISTS 'role_admin';
DROP ROLE IF EXISTS 'role_moderador';
DROP ROLE IF EXISTS 'role_user';

CREATE ROLE 'role_admin';
CREATE ROLE 'role_moderador';
CREATE ROLE 'role_user';

FLUSH PRIVILEGES;

-- NÍVEL 1: USER_APP (Acesso apenas às Views)
GRANT SELECT ON ecoShareDB.view_perfil_proprio TO 'role_user';
GRANT SELECT ON ecoShareDB.view_meus_itens TO 'role_user';
GRANT SELECT ON ecoShareDB.view_meus_enderecos TO 'role_user';
GRANT SELECT ON ecoShareDB.view_meus_registros TO 'role_user';
GRANT SELECT ON ecoShareDB.view_meus_telefones TO 'role_user';
GRANT SELECT ON ecoShareDB.view_minhas_avaliacoes_item TO 'role_user';
GRANT SELECT ON ecoShareDB.view_minhas_avaliacoes_usuario TO 'role_user';
GRANT SELECT ON ecoShareDB.view_minhas_trocas TO 'role_user';
GRANT SELECT ON ecoShareDB.view_minhas_propostas TO 'role_user';

-- Views que todos os usuários tem acesso
GRANT SELECT ON ecoShareDB.view_desempenho_vendas TO 'role_user';
GRANT SELECT ON ecoShareDB.view_itens_populares TO 'role_user';
GRANT SELECT ON ecoShareDB.view_ranking_reputacao TO 'role_user';



-- MODERADOR e APLICAÇÃO
GRANT SELECT, INSERT, UPDATE, DELETE ON `ecoShareDB`.* TO 'role_moderador';
GRANT SELECT ON ecoShareDB.view_controle_usuarios_admin TO 'role_moderador';



-- ADMIN
GRANT ALL PRIVILEGES ON `ecoShareDB`.* TO 'role_admin' WITH GRANT OPTION;

FLUSH PRIVILEGES;

-- CRIAÇÃO DE USUÁRIOS

DROP USER IF EXISTS 'eco_app_service'@'localhost';
CREATE USER 'eco_app_service'@'localhost' IDENTIFIED BY 'senhasupersegura';
GRANT 'role_moderador' TO 'eco_app_service'@'localhost';
SET DEFAULT ROLE 'role_moderador' FOR 'eco_app_service'@'localhost';

DROP USER IF EXISTS 'eco_root_admin'@'localhost';
CREATE USER 'eco_root_admin'@'localhost' IDENTIFIED BY 'senhameiosegura';
GRANT 'role_admin' TO 'eco_root_admin'@'localhost';
SET DEFAULT ROLE 'role_admin' FOR 'eco_root_admin'@'localhost';

DROP USER IF EXISTS 'jorjin'@'localhost';
CREATE USER 'jorjin'@'localhost' IDENTIFIED BY '12345678';
GRANT 'role_user' TO 'jorjin'@'localhost';
SET DEFAULT ROLE 'role_user' FOR 'jorjin'@'localhost';


FLUSH PRIVILEGES;

-- 1. View de Ranking de Reputação (O "EcoScore")
CREATE OR REPLACE VIEW `ecoShareDB`.`view_ranking_reputacao` AS
SELECT 
    u.id AS usuario_id,
    u.username,
    u.nome,
    COUNT(au.id) AS total_avaliacoes,
    COALESCE(ROUND(AVG(au.nota), 1), 0) AS media_nota, 
    COALESCE(SUM(au.likes), 0) AS total_likes_recebidos
FROM 
    `ecoShareDB`.`usuario` u
LEFT JOIN 
    `ecoShareDB`.`avaliacao_usuario` au ON u.id = au.usuario2_id
GROUP BY 
    u.id, u.username, u.nome
ORDER BY 
    media_nota DESC, total_avaliacoes DESC;


-- 2. View de Desempenho de Vendas
CREATE OR REPLACE VIEW `ecoShareDB`.`view_desempenho_vendas` AS
SELECT 
    u.id AS provedor_id,
    u.nome AS provedor_nome,
    COUNT(r.id) AS total_transacoes,
    COALESCE(SUM(r.valor_registro), 0) AS receita_total,
    MAX(r.data_registro) AS ultima_venda
FROM 
    `ecoShareDB`.`usuario` u
JOIN 
    `ecoShareDB`.`registro` r 
    ON u.usuario_doc = r.doc_provedor 
    AND u.usuario_doc_tipo_id = r.doc_tipo_provedor
GROUP BY 
    u.id, u.nome
ORDER BY 
    receita_total DESC;


-- 3. View de Itens Mais Populares
CREATE OR REPLACE VIEW `ecoShareDB`.`view_itens_populares` AS
SELECT 
    i.id AS item_id,
    i.nome AS item_nome,
    u.username AS dono,
    COUNT(ai.id) AS qtd_avaliacoes,
    COALESCE(ROUND(AVG(ai.nota), 1), 0) AS nota_media_item
FROM 
    `ecoShareDB`.`item` i
JOIN 
    `ecoShareDB`.`usuario` u ON i.usuario_id = u.id
JOIN 
    `ecoShareDB`.`avaliacao_item` ai ON i.id = ai.item_id
GROUP BY 
    i.id, i.nome, u.username
HAVING 
    qtd_avaliacoes > 0
ORDER BY 
    nota_media_item DESC;


-- 4. View de Auditoria de Estoque (Novo vs Usado)
CREATE OR REPLACE VIEW `ecoShareDB`.`view_auditoria_estoque` AS
SELECT 
    i.id AS item_id,
    i.nome,
    u.username AS dono,
    CASE 
        WHEN n.item_id IS NOT NULL THEN 'Novo'
        WHEN us.item_id IS NOT NULL THEN 'Usado'
        ELSE 'Indefinido' 
    END AS condicao,
    CASE 
        WHEN n.item_id IS NOT NULL THEN n.estoque
        WHEN us.item_id IS NOT NULL THEN 1 -- Usado é item único
        ELSE 0 
    END AS quantidade_disponivel,
    COALESCE(ist.item_status, 'Novo/N/A') AS estado_conservacao -- Se for novo, não tem status de conservação
FROM 
    `ecoShareDB`.`item` i
JOIN 
    `ecoShareDB`.`usuario` u ON i.usuario_id = u.id
LEFT JOIN 
    `ecoShareDB`.`item_novo` n ON i.id = n.item_id
LEFT JOIN 
    `ecoShareDB`.`item_usado` us ON i.id = us.item_id
LEFT JOIN 
    `ecoShareDB`.`item_status` ist ON us.item_status_id = ist.id;


-- 5. View de Alerta de Moderação (Lista Negra)
CREATE OR REPLACE VIEW `ecoShareDB`.`view_alerta_moderacao` AS
SELECT 
    u.id AS usuario_id,
    u.username,
    u.email,
    COUNT(au.id) AS qtd_avaliacoes_recebidas,
    ROUND(AVG(au.nota), 2) AS media_nota
FROM 
    `ecoShareDB`.`usuario` u
JOIN 
    `ecoShareDB`.`avaliacao_usuario` au ON u.id = au.usuario2_id
GROUP BY 
    u.id, u.username, u.email
HAVING 
    media_nota < 3.0 AND qtd_avaliacoes_recebidas >= 3
ORDER BY 
    media_nota ASC;
