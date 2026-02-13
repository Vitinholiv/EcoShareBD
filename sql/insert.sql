USE ecoShareDB;

INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES 
(1, 'CPF'), (2, 'CNPJ'), (3, 'CNI'), (4, 'BI_GW'), (5, 'BI_MZ'), 
(6, 'BI_AO'), (7, 'BI_ST'), (8, 'DIP'), (9, 'CC'), (10, 'CI');

INSERT INTO item_status (id, item_status) VALUES 
(1, 'Livre'), (2, 'Manutenção'), (3, 'Indisponível'), (4, 'Emprestado');

INSERT INTO forma_pagamento (forma) VALUES 
('Cartão de Crédito'), ('Cartão de Débito'), ('PIX'), ('Boleto Bancário'), 
('Dinheiro'), ('Transferência Bancária'), ('Carteira Digital'), ('PayPal'), 
('Multicaixa'), ('M-Pesa'), ('Ecoins');

INSERT INTO anuncio_tipo (tipo) VALUES ('Venda'), ('Troca'), ('Empréstimo');

INSERT INTO atendimento_status (status) VALUES ('Encerrado'), ('Aberto'), ('Em Processo');

INSERT INTO usuario (id, usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES 
(1, '482.915.307-22', 1, 'ricardo.oliveira@gmail.com', 'ricardo_oliveira88', 'Ricardo Oliveira', 'hash1'),
(2, '159.348.620-11', 1, 'ana.beatriz.silva@outlook.com', 'anabeatriz_2024', 'Ana Beatriz Silva', 'hash2'),
(3, '123456789CD395', 5, 'marcos.vinicius@yahoo.com.br', 'marcos_vini_93', 'Marcos Vinícius Souza', 'hash3'),
(4, '934.102.558-47', 1, 'luciana.pereira@ecoshare.com', 'lu_pereira_eco', 'Luciana Pereira', 'hash4'),
(5, '1386843', 6, 'felipe.santos@gmail.com', 'felipe_santos_sp', 'Felipe dos Santos', 'hash5'),
(6, '506.127.839-14', 1, 'fernanda.lima@uol.com.br', 'fernanda_lima_85', 'Fernanda Lima', 'hash6'),
(7, '89355573 2 ZE4', 7, 'caio.rodrigues@hotmail.com', 'caio_rod_99', 'Caio Rodrigues', 'hash7'),
(8, '624.037.159-92', 1, 'patricia.melo@gmail.com', 'patricia_melo_rio', 'Patrícia Melo', 'hash8'),
(9, '9993345', 6, 'bruno.alves@ecoshare.com', 'bruno_alves_dev', 'Bruno Alves', 'hash9'),
(10, '219.573.840-76', 1, 'juliana.costa@yahoo.com', 'jucosta_77', 'Juliana Costa', 'hash10'),
(11, '13531153 1 ZA3', 7, 'thiago.ferreira@gmail.com', 'thiago_fer_2026', 'Thiago Ferreira', 'hash11'),
(12, '957.361.402-18', 1, 'camila.barros@uol.com.br', 'camila_barros_sc', 'Camila Barros', 'hash12');

INSERT INTO endereco (usuario_id, endereco_ordem, CEP, pais, estado, cidade, bairro, logradouro)
SELECT id, 1, '00000-000', 'Brasil', 'Estado', 'Cidade', 'Bairro', 'Rua Padrão' FROM usuario;

INSERT INTO endereco (usuario_id, endereco_ordem, CEP, pais, estado, cidade, bairro, logradouro) VALUES 
(1, 2, '11111-111', 'Brasil', 'MS', 'Campo Grande', 'Centro', 'Rua Secundária');

INSERT INTO cupom (usuario_id, sorteio_id) VALUES 
(1, 1), (2, 1), (3, 1), (4, 1), (5, 2), (6, 2), (7, 3), (8, 3), (9, 4), (10, 4), (11, 4), (12, 4);

INSERT INTO usuario_telefone (telefone_ordem, usuario_id, telefone) VALUES 
(1, 1, "+55 11 982441057"), (2, 1, "+55 11 910223344"), (1, 2, "+55 21 974128832"), (1, 3, "+258 84 123 4567"), (2, 3, "+258 82 987 6543"), 
(1, 4, "+55 31 995014421"), (1, 5, "+244 923 000 111"), (1, 6, "+55 41 988223091"), (1, 7, "+239 990 1234"), (1, 8, "+55 51 992330055"), 
(1, 9, "+244 912 555 999"), (1, 10, "+55 61 981157742"), (1, 11, "+239 985 4321"), (1, 12, "+55 71 996041289");

INSERT INTO item (id, nome, descricao, usuario_id) VALUES 
(1, 'Marreta 2kg', 'Cabo fibra', 1), (2, 'Jogo Chaves', '6 peças', 1), (3, 'Furadeira', 'Impacto', 1),
(4, 'Bike 26', 'Pneus gastos', 7), (5, 'Monitor 21', 'LED', 5), (6, 'Teclado', 'Mecânico', 2),
(7, 'Mouse', 'Sem fio', 2), (8, 'Carrinho Mão', 'Jardim', 1), (9, 'Trena 5m', 'Aço', 1), (10, 'USB-C', '20W', 2);

INSERT INTO item_novo (item_id, estoque) VALUES (1, 10), (2, 5), (9, 3), (10, 50);

INSERT INTO item_usado (item_id, item_status_id) VALUES (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1);

INSERT INTO item_legado (id, nome, descricao, item_id) VALUES 
(1, 'Legado Marreta', 'Cabo fibra', 1), (2, 'Legado Chaves', '6 peças', 2), (3, 'Legado Furadeira', 'Impacto', 3),
(4, 'Legado Bike', 'Pneus gastos', 4), (5, 'Legado Monitor', 'LED', 5), (6, 'Legado Teclado', 'Mecânico', 6),
(7, 'Legado Mouse', 'Sem fio', 7), (8, 'Legado Carrinho', 'Jardim', 8), (9, 'Legado Trena', 'Aço', 9), (10, 'Legado USB-C', '20W', 10);

INSERT INTO anuncio (id, usuario_id, tipo, item_id, endereco_ordem, nome, valor_anuncio, descricao, data_anuncio) VALUES 
(1, 1, 1, 1, 1, 'Marreta de Ferro 2kg', 80.00, 'Marreta pesada em excelente estado, pouco uso. Cabo de fibra de vidro que absorve impacto.', '2026-02-13'),
(2, 2, 1, 7, 1, 'Mouse Gamer Sem Fio', 40.00, 'Mouse óptico recarregável, alta precisão. Acompanha cabo USB para carregamento.', '2026-02-13'),
(3, 1, 1, 2, 1, 'Kit Chaves Philips/Fenda', 20.00, 'Conjunto com 6 chaves de tamanhos variados. Pontas imantadas para facilitar o trabalho.', '2026-02-13'),
(4, 7, 2, 4, 1, 'Bicicleta Aro 26 Urbana', 0.00, 'Bicicleta revisada. Aceito troca por ferramentas de marcenaria ou itens de jardinagem.', '2026-02-13'),
(5, 5, 2, 5, 1, 'Monitor LED 21 Polegadas', 0.00, 'Monitor funcionando perfeitamente, apenas um pequeno risco na base. Troco por teclado mecânico.', '2026-02-13'),
(6, 1, 3, 3, 2, 'Furadeira de Impacto Profissional', 15.00, 'Disponível para aluguel diário. Mandril de 1/2 polegada, potente para concreto e madeira.', '2026-02-13'),
(7, 2, 1, 6, 1, 'Teclado Mecânico RGB', 100.00, 'Teclado com switches azuis, iluminação customizável. Ideal para jogos e digitação rápida.', '2026-02-13'),
(8, 1, 1, 8, 1, 'Carrinho de Mão Reforçado', 50.00, 'Capacidade para 60 litros. Pneu novo, estrutura sem ferrugem. Ideal para obras ou jardim.', '2026-02-13'),
(9, 1, 1, 9, 1, 'Trena de Aço 5 Metros', 10.00, 'Trena com trava e retorno automático. Escala em milímetros e polegadas.', '2026-02-13'),
(10, 2, 1, 10, 1, 'Cabo USB-C Original', 30.00, 'Cabo de 1.5 metros, suporta carregamento rápido e transferência de dados em alta velocidade.', '2026-02-13');

INSERT INTO proposta (anuncio_id, usuario_id, valor, texto_proposta) VALUES 
(1, 10, 70.00, 'Aceita 70 reais? Busco ainda hoje no centro.'), 
(2, 11, 35.00, 'Consegue fazer por 35? Sou vizinho de bairro.'), 
(3, 12, 15.00, 'Ofereço 15 reais para levar agora.'), 
(4, 1, 0.00, 'Tenho uma furadeira sobrando, aceita trocar pela bike?'), 
(5, 2, 0.00, 'Aceita o meu teclado mecânico no monitor?'),
(6, 3, 10.00, 'Preciso para um serviço rápido no sábado, aceita 10 a diária?'), 
(7, 4, 90.00, 'Pago 90 reais se o switch for original.'), 
(8, 5, 45.00, 'Tenho 45 reais em mãos, aceita?'), 
(9, 6, 8.00, 'Faz por 8 reais para fechar logo?'), 
(10, 7, 25.00, 'Aceita 25 pelo cabo?');

INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 1, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 1, 3, '2026-02-13', 80.00 FROM usuario p, usuario c WHERE p.id = 1 AND c.id = 8;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 2, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 7, 1, '2026-02-13', 40.00 FROM usuario p, usuario c WHERE p.id = 2 AND c.id = 9;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 3, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 2, 2, '2026-02-13', 20.00 FROM usuario p, usuario c WHERE p.id = 1 AND c.id = 10;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 4, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 4, 5, '2026-02-13', 0.00 FROM usuario p, usuario c WHERE p.id = 7 AND c.id = 11;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 5, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 5, 5, '2026-02-13', 0.00 FROM usuario p, usuario c WHERE p.id = 5 AND c.id = 12;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 6, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 3, 4, '2026-02-13', 15.00 FROM usuario p, usuario c WHERE p.id = 1 AND c.id = 2;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 7, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 6, 3, '2026-02-13', 100.00 FROM usuario p, usuario c WHERE p.id = 2 AND c.id = 3;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 8, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 8, 3, '2026-02-13', 50.00 FROM usuario p, usuario c WHERE p.id = 1 AND c.id = 4;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 9, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 9, 3, '2026-02-13', 10.00 FROM usuario p, usuario c WHERE p.id = 1 AND c.id = 5;
INSERT INTO registro (id, doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
SELECT 10, p.usuario_doc_tipo_id, p.usuario_doc, c.usuario_doc_tipo_id, c.usuario_doc, 10, 3, '2026-02-13', 30.00 FROM usuario p, usuario c WHERE p.id = 2 AND c.id = 6;

INSERT INTO registro_venda (registro_id) VALUES (1), (2), (3), (7), (8), (9), (10);
INSERT INTO registro_troca (registro_id, item_legado_id) VALUES (4, 1), (5, 2);
INSERT INTO registro_emprestimo (registro_id, data_previsao) VALUES (6, '2026-02-20');

INSERT INTO manutencao (manutencao_id, item_id, data_manutencao) VALUES 
(1,3,'2026-01-01'), (2,3,'2026-02-01'), (1,4,'2026-01-01'), (1,5,'2026-01-01'), (1,6,'2026-01-01'), 
(1,7,'2026-01-01'), (1,8,'2026-01-01'), (2,4,'2026-02-01'), (2,5,'2026-02-01'), (2,6,'2026-02-01');

INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, nota, data_avaliacao) VALUES 
(2,1,5,NOW()), (3,1,4,NOW()), (4,2,5,NOW()), (5,2,5,NOW()), (6,3,4,NOW()), 
(7,3,5,NOW()), (8,4,5,NOW()), (9,5,4,NOW()), (10,6,5,NOW()), (1,7,5,NOW());

INSERT INTO avaliacao_item (usuario_id, item_id, nota, data_avaliacao) VALUES 
(8,1,5,NOW()), (9,2,4,NOW()), (10,3,5,NOW()), (11,4,5,NOW()), (12,5,4,NOW()), 
(1,6,5,NOW()), (2,7,5,NOW()), (3,8,4,NOW()), (4,9,5,NOW()), (5,10,5,NOW());

INSERT INTO atendimento (protocolo, atendimento_status_id, usuario_id, registro_id, descricao) VALUES 
("P1",1,1,1,"Duvida"), ("P2",1,2,2,"Duvida"), ("P3",1,3,3,"Duvida"), ("P4",1,4,4,"Duvida"), ("P5",1,5,5,"Duvida"), 
("P6",1,6,6,"Duvida"), ("P7",1,7,7,"Duvida"), ("P8",1,8,8,"Duvida"), ("P9",1,9,9,"Duvida"), ("P10",1,10,10,"Duvida");