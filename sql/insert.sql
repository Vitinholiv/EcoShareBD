INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (1, 'CPF');

INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('000-000-000-99', 1, 'teste@ecoShare', 'TESTE', 'Teste da Silva', 'testedasilva');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('000-000-000-88', 1, 'sigma@ecoShare', 'SIGMA', 'Sigma da Silva', 'sigmarule');

/*
INSERT INTO item ( foto, descricao, nome, usuario_id) VALUES ( 'foto1', 'Makira lixadeira', 'MAKITA LIXADEIRA R2000', 1 );

INSERT INTO endereco (usuario_id, CEP, pais, estado, bairro, logradouro, complemento , numero) VALUES (1, '20220800', 'Brasil', 'RJ', 'Santo Cristo', 'Avenida Professor Pereira Reis', 'apt 456', 49);
INSERT INTO endereco (usuario_id, CEP, pais, estado, bairro, logradouro, complemento , numero) VALUES (1, '20220900', 'Brasil', 'RJ', 'Santo Cristo', 'Avenida Professor Pereira Reis', 'apt 458', 49);

INSERT INTO cupon ( usuario_id, sorteio_id ) VALUES ( 1, 1 );

INSERT INTO usuario_telefone ( usuario_id, telefone ) VALUES ( 1, '55(42)910103030' );

INSERT INTO avaliacao_usuario ( usuario1_id, usuario2_id, descricao, nota, likes) VALUES (1, 2, 'O sigma global moggou o teste', 3, 0 );
INSERT INTO avaliacao_usuario ( usuario1_id, usuario2_id, nota) VALUES (1, 2, 3 );

INSERT INTO avaliacao_item ( usuario1_id, item_id, nota) VALUES (1, 1, 5 );

INSERT INTO item_status (id, item_status) VALUES ( 1, 'Disponível');
INSERT INTO item_status (id, item_status) VALUES ( 2, 'Ocupado');
INSERT INTO item_status (id, item_status) VALUES ( 3, 'Manutenção');

INSERT INTO manutencao (item_id, data)
*/