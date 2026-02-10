
-- ## Login

SELECT * FROM usuario WHERE username = '$_username' AND senha = '$_senha';

-- ## Cadastro de usuário

INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('$_usuario_doc', $_usuario_doc_tipo_id , '$_email' , '$_username' , '$_nome' , '$_senha' );

-- ## Nota média de um usuario

SELECT AVG(nota) AS NOTA_MEDIA FROM avaliacao_usuario WHERE usuario_id2 = $_usuario_id_logado;

-- ## Endereços de um usuário

-- Busca Total
SELECT * FROM enderecos WHERE usuario_id = $_usuario_id_logado ORDER BY endereco_id [ASC];

-- Busca por CEP
SELECT * FROM endereco WHERE CEP = '$_CEP_buscado' ORDER BY endereco_id [ASC];

-- Criar novo endereço
INSERT INTO endereco (usuario_id, CEP, pais, estado, bairro, logradouro, complemento, numero) VALUES ($_usuario_id_logado, '$_CEP' ,  '$_pais' , ' $_estado' ,  '$_bairro' ,  '$_logradouro' ,  '$_complemento' ,  $_numero)

-- Excluir endereco
DELETE FROM endereco WHERE endereco_id = $endereco_id_atual

-- ## Telefones de um usuario

--  Busca Total

SELECT * FROM usuario_telefone WHERE usuario_id = $_usuario_id_logado ORDER BY telefone_id [ASC]; 

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
SELECT * FROM avaliacao_usuario WHERE usuario2_id = $_usuario_id_logado;


