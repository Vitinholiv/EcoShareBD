/*

# Login

SELECT * FROM usuario WHERE username = '$_username' AND senha = '$_senha';

# Cadastro de usuário

INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ($_usuario_doc, $_usuario_doc_tipo_id , $_email , $_username , $_nome , $_senha )

# Nota média de um usuario

SELECT AVG(nota) AS NOTA_MEDIA FROM avaliacao_usuario WHERE usuario_id2 = $_usuario_id_logado;

## Endereços de um usuário

#Busca por id
SELECT * FROM enderecos WHERE usuario_id = $_usuario_id_logado;

#Busca por CEP
SELECT * FROM enderecos WHERE CEP = $_CEP_buscado;

#Criar novo endereço
INSERT INTO endereco (usuario_id, CEP, pais, estado, bairro, logradouro, complemento, numero) VALUES ($_usuario_id_logado, $_CEP ,  $_pais ,  $_estado ,  $_bairro ,  $_logradouro ,  $_complemento ,  $_numero)

#Excluir endereco
DELETE FROM endereco WHERE endereco_id = $endereco_id_atual

#

*/