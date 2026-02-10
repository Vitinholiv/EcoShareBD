
-- ## Login

SELECT * FROM usuario WHERE username = '$_username' AND senha = '$_senha';

-- ## Cadastro de usuário

INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('$_usuario_doc', $_usuario_doc_tipo_id , '$_email' , '$_username' , '$_nome' , '$_senha' );

-- ## Nota média de um usuario

SELECT AVG(nota) AS NOTA_MEDIA FROM avaliacao_usuario WHERE usuario_id2 = $_usuario_id_logado;

-- ############################### Minhas conta

-- ## Endereços de um usuário

-- Busca Total
SELECT * FROM enderecos WHERE usuario_id = $_usuario_id_logado ORDER BY endereco_id ASC;

-- Busca por CEP
SELECT * FROM endereco WHERE CEP = '$_CEP_buscado' ORDER BY endereco_id ASC;

-- Criar novo endereço
INSERT INTO endereco (usuario_id, CEP, pais, estado,cidade, bairro, logradouro, complemento, numero) 
VALUES ($_usuario_id_logado, '$_CEP' ,  '$_pais' , ' $_estado' ,'$_cidade',  '$_bairro' ,  '$_logradouro' ,  '$_complemento' ,  $_numero)

-- Excluir endereco
DELETE FROM endereco WHERE endereco_id = $endereco_id_atual

-- ## Telefones de um usuario

--  Busca Total

SELECT * FROM usuario_telefone WHERE usuario_id = $_usuario_id_logado ORDER BY telefone_id ASC; 

-- Criar novo telefone

INSERT INTO usuario_telefone (usuario_id, telefone) VALUES ($_usuario_id_logado, '$_telefone');

-- Excluir telefone 

DELETE FROM usuario_telefone WHERE telefone_id = $telefone_id_atual;

-- ## Cupons

-- Histórico de cupons

SELECT * FROM cupon WHERE usuario_id = $_usuario_id_logado;

-- Busca de cupons por Sorteio

SELECT * FROM cupon WHERE usuario_id = $_usuario_id_logado AND sorteio_id = $_sorteio_id;

-- ## Avaliações de um usuário

-- Todas as avaliações

SELECT * FROM avaliacao_usuario WHERE usuario2_id = $_usuario_id_logado ORDER BY data_avaliacao DESC;

-- Dar like em uma avaliação

UPDATE avaliacao_usuario SET likes = likes + 1  WHERE id = $_id_avaliazao_atual;

-- ## Dados pessoais

-- Exibir

SELECT nome, usuario_doc FROM usuario WHERE id = $_usuario_id_logado;

-- ############################### itens

-- # Exibir todos os itens usados

SELECT i.id, i.descricao, i.nome, s.item_status FROM item as i JOIN item_usado AS u ON i.id = u.item_id JOIN item_status as s ON u.item_status_id = s.id WHERE usuario_id = $_usuario_id_logado;

-- Alterar nome

UPDATE item SET nome = '$_novo_nome' WHERE id = $_id_item_atual;

-- Alterar descrição

UPDATE item SET descricao = '$_nova_descricao' WHERE id = $_id_item_atual;

-- Alterar Stauts, lembrando que status é numérico

UPDATE item_usado set item_status = $_novo_status WHERE id = $_id_item_atual

-- Cadastrar item usado

START TRANSACTION;

INSERT INTO item (descricao, nome, usuario_id) VALUES ('$_item_desc', '$_item_nome', $_usuario_id_logado);

INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), $_item_status);

COMMIT;


-- # Exibir todos os itens novos

SELECT i.id, i.descricao, i.nome, n.estoque FROM item as i JOIN item_novo AS n ON i.id = n.item_id WHERE usuario_id = $_usuario_id_logado;

-- Alterar estoque, lembrando que status é numérico

UPDATE item_novo set estoque = $_novo_estoque WHERE id = $_id_item_atual

-- Cadastrar item novo

START TRANSACTION;

INSERT INTO item (descricao, nome, usuario_id) VALUES ('$_item_desc', '$_item_nome', $_usuario_id_logado);

INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), $_item_estoque);

COMMIT;

-- Exibir anuncios de um item

SELECT t.tipo, a.valor_anuncio, a.descricao, a.data_anuncio FROM anuncio as a JOIN anuncio_tipo as t ON a.tipo = t.anuncio_tipo_id WHERE a.item_id = $_item_id_atual;

-- Exibir registros de emprestimo de um item

SELECT r.usuario_id, e.data_previsao, e.data_entregue, r.data_registro, r.valor_registro, f.forma FROM registro as r
 JOIN registro_emprestimo as e ON r.id = e.registro_id 
 JOIN formas_pagamento as f ON r.forma_pagamento_id = f.id 
 JOIN anuncio as anun ON r.anuncio_id = anun.id WHERE anun.iten_id = $_id_item_atual;

-- Exibir registros de venda de um item

SELECT r.usuario_id, r.data_registro, v.qtd, r.valor_registro, f.forma FROM registro as r
 JOIN registro_venda as e ON r.id = v.registro_id 
 JOIN formas_pagamento as f ON r.forma_pagamento_id = f.id 
 JOIN anuncio as anun ON r.anuncio_id = anun.id WHERE anun.iten_id = $_id_item_atual;

-- Exibir registros de troca de um item

SELECT r.usuario_id, r.data_registro, t.iten_recebido, r.valor_registro, f.forma FROM registro as r
 JOIN registro_troca as t ON r.id = t.registro_id 
 JOIN formas_pagamento as f ON r.forma_pagamento_id = f.id 
 JOIN anuncio as anun ON r.anuncio_id = anun.id WHERE anun.iten_id = $_id_item_atual;

-- ## Manutenções

-- Exibir manutenções

SELECT * FROM manutencao WHERE item_id = $_id_item_atual;

-- Adicionar manutenção

INSERT INTO manutencao (item_id, data_manutencao, laudo) VALUES ($_id_item_atual, '$_data_manutencao', '$_laudo');

-- ############################### anuncios

-- Anuncios por pessoa

SELECT a.iten_id, t.tipo, a.valor_anuncio, a.descricao, a.tipo, a.data_anuncio FROM anuncio as a 
JOIN anuncio_tipo as t ON a.tipo = t.anuncio_tipo_id WHERE a.usuario_id = $_usuario_id_logado;

-- Criar anúncio

INSERT INTO anuncio (usuario_id, iten_id, valor_anuncio, descricao, tipo, data_anuncio)
VALUES ($_usuario_id_logado, $_item_id, $_valor_anuncio, '$_item_desc', $_anuncio_tipo, '$_anuncio_data');

-- Deletar anuncio

DELETE FROM anuncio WHERE anuncio_id = $_anuncio_id_atual;

-- ############################### registros

-- ## Registros por pessoa

-- Exibir registros de emprestimo por pessoa

SELECT r.usuario_id, e.data_previsao, e.data_entregue, r.data_registro, r.valor_registro, f.forma FROM registro as r
 JOIN registro_emprestimo as e ON r.id = e.registro_id 
 JOIN formas_pagamento as f ON r.forma_pagamento_id = f.id 
 JOIN anuncio as anun ON r.anuncio_id = anun.id WHERE r.usuario_id = $_usuario_id_logado;

-- Exibir registros de venda  por pessoa

SELECT r.usuario_id, r.data_registro, v.qtd, r.valor_registro, f.forma FROM registro as r
 JOIN registro_venda as e ON r.id = v.registro_id 
 JOIN formas_pagamento as f ON r.forma_pagamento_id = f.id 
 JOIN anuncio as anun ON r.anuncio_id = anun.id WHERE r.usuario_id = $_usuario_id_logado;

-- Exibir registros de troca por pessoa

SELECT r.usuario_id, r.data_registro, t.iten_recebido, r.valor_registro, f.forma FROM registro as r
 JOIN registro_troca as t ON r.id = t.registro_id 
 JOIN formas_pagamento as f ON r.forma_pagamento_id = f.id 
 JOIN anuncio as anun ON r.anuncio_id = anun.id WHERE r.usuario_id = $_usuario_id_logado;

-- Gerar avaliação de item - Aqui a pessoa clica no registro e puxa o id do item e o id do comprador

INSERT INTO avaliacao_item (usuario1_id, item_id, descricao, nota, data_avaliacao)
 VALUES ($_usuario_id_logado, $_id_item_atual, '$_descricao', $_nota, '$_data_avaliacao')

 -- Gerar avaliação de pessoa 

INSERT INTO avaliacao_usuario (usuario1_id, $usuario2_id, descricao, nota, data_avaliacao)
 VALUES ($_usuario_id_logado, $_usuario2_id, '$_descricao', $_nota, '$_data_avaliacao')

-- ########################## Feed

-- Busca geral, facilmente adaptável a novas buscas

SELECT 
    a.id AS id_anuncio,
    i.nome AS nome_item,
    a.valor_anuncio,
    a.descricao,
    e.bairro,
    e.estado,
    e.cidade,
    u.nome AS nome_vendedor,
    COALESCE(av.media_nota, 0) AS reputacao_vendedor
FROM anuncio a
JOIN item i ON a.iten_id = i.id
JOIN usuario u ON a.usuario_id = u.id
JOIN endereco e ON u.id = e.usuario_id

LEFT JOIN (
    SELECT usuario2_id, AVG(nota) AS media_nota 
    FROM avaliacao_usuario 
    GROUP BY usuario2_id
) av ON u.id = av.usuario2_id
WHERE 
    i.nome LIKE '$_nome_buscado'      
    AND a.valor_anuncio BETWEEN $_valor_min AND $__valor_max
    AND e.bairro = '$_bairro'        
ORDER BY 
    reputacao_vendedor DESC;       