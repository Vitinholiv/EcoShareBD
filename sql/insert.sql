/* Preencher tabela de documentos */
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (1, 'CPF');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (2, 'CNI');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (3, 'BI_GW');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (4, 'BI_MZ');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (5, 'BI_AO');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (6, 'BI_ST');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (7, 'DIP');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (8, 'CC');
INSERT INTO usuario_doc_tipo (id, usuario_doc_tipo_nome) VALUES (9, 'CI');



/* Preencher tabela de status de item */
INSERT INTO item_status (id, item_status) VALUES (1, "Livre");
INSERT INTO item_status (id, item_status) VALUES (2, "Manutenção");
INSERT INTO item_status (id, item_status) VALUES (3, "Indisponível");
INSERT INTO item_status (id, item_status) VALUES (4, "Emprestado");



/* Preencher tabela de usuario */
/* Observação - Na prática, passaríamos a senha por uma função chamada password_hash do php para não guardarmos explicitamente a senha e compararíamos
se uma senha gerou um hash com password verify (que é o comportamento da aplicação). Como esses hashes não são inversíveis e dependem de parâmetros
internos do php, esses usuários abaixo não necessariamente serão válidos caso tente executar uma nova instância da aplicação localmente. Na verdade,
você nem tem como saber a senha a princípio então só cadastre novos usuários. */
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('482.915.307-22', 1, 'ricardo.oliveira@gmail.com', 'ricardo_oliveira88', 'Ricardo Oliveira', '$2y$12$eI9ZKbW.mP7.C2/3O7z8ueYfD1N9UvL6A2kXW1sQhZ5mN.R0Y9P7S');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('159.348.620-11', 1, 'ana.beatriz.silva@outlook.com', 'anabeatriz_2024', 'Ana Beatriz Silva', '$2y$12$K8mN1vP2oQ3rS4tU5vW6xY7z8A9B0C1D2E3F4G5H6I7J8K9L0M1N2');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('123456789CD395', 4, 'marcos.vinicius@yahoo.com.br', 'marcos_vini_93', 'Marcos Vinícius Souza', '$2y$12$jW9S8R7Q6P5O4N3M2L1K0J9I8H7G6F5E4D3C2B1A0Z9Y8X7W6V5U4');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('934.102.558-47', 1, 'luciana.pereira@ecoshare.com', 'lu_pereira_eco', 'Luciana Pereira', '$2y$12$L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7D8E9F0G1H2I3J4K5L');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('1386843', 5, 'felipe.santos@gmail.com', 'felipe_santos_sp', 'Felipe dos Santos', '$2y$12$bX7vR2wP9zL1mK0jN4hG8fD5sA3qW2eR1tY0uI9oP8aS7dF6gH5jK');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('506.127.839-14', 1, 'fernanda.lima@uol.com.br', 'fernanda_lima_85', 'Fernanda Lima', '$2y$12$rE4wQ3tY2uU1iI0oO9pP8aS7dF6gH5jK4lL3kK2jJ1hH0gG9fF8dD7');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('89355573 2 ZE4', 6, 'caio.rodrigues@hotmail.com', 'caio_rod_99', 'Caio Rodrigues', '$2y$12$vC9xB8nN7mB6vC5xZ4aA3sS2dD1fF0gG8hH7jJ6kK5lL4mMnN3bB2v');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('624.037.159-92', 1, 'patricia.melo@gmail.com', 'patricia_melo_rio', 'Patrícia Melo', '$2y$12$qW1eR2tY3uI4oO5pP6aS7dF8gH9jK0lL1zZ2xX3cC4vV5bB6nN7mM8q');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('9993345', 5, 'bruno.alves@ecoshare.com', 'bruno_alves_dev', 'Bruno Alves', '$2y$12$zX9cV8bB7nN6mM5aA4sS3dD2fF1gG0hH1jJ2kK3lL4pPoOiIuUyYtTr');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('219.573.840-76', 1, 'juliana.costa@yahoo.com', 'jucosta_77', 'Juliana Costa', '$2y$12$mN0bB9vV8cC7xX6zZ5aA4sS3dD2fF1gG0hH9jJ8kK7lL6oOpP5iIuU');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('13531153 1 ZA3', 6, 'thiago.ferreira@gmail.com', 'thiago_fer_2026', 'Thiago Ferreira', '$2y$12$aS1dD2fF3gG4hH5jJ6kK7lL8zZ9xX0cC1vV2bB3nN4mM5qQwWeErRtT');
INSERT INTO usuario (usuario_doc, usuario_doc_tipo_id, email, username, nome, senha) VALUES ('957.361.402-18', 1, 'camila.barros@uol.com.br', 'camila_barros_sc', 'Camila Barros', '$2y$12$pP0oO9iI8uU7yY6tTrR5eE4wW3qQ2aA1sS2dD3fF4gG5hH6jJ7kK8l');



/* Preencher tabela de cupom */
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (3, 1);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (6, 1);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (7, 1);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (9, 1);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (12, 1);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (1, 2);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (3, 2);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (4, 2);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (11, 2);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (3, 3);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (11, 3);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (9, 3);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (7, 4);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (6, 4);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (4, 4);
INSERT INTO cupom (usuario_id, sorteio_id) VALUES (5, 4);



/* Preencher tabela de telefones */
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 1, "+55 11 98244-1057");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 2, "+55 21 97412-8832");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 4, "+55 31 99501-4421");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 6, "+55 41 98822-3091");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 8, "+55 51 99233-0055");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 10, "+55 61 98115-7742");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 12, "+55 71 99604-1289");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 3, "+258 84 123 4567");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 5, "+244 923 000 111");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 9, "+244 912 555 999");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 7, "+239 990 1234");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (1, 11, "+239 985 4321");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (2, 1, "+55 11 91022-3344");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (2, 3, "+258 82 987 6543");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (2, 7, "+239 904 4455");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (2, 12, "+55 71 98144-5566");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (3, 7, "+239 991 2233"); 
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (3, 12, "+55 71 97000-1122");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (4, 12, "+55 71 99122-3344");
INSERT INTO usuario_telefone (telefone_id, usuario_id, telefone) VALUES (5, 12, "+55 71 98255-6677");



/* Preencher tabela de formas de pagamento */
INSERT INTO forma_pagamento (forma) VALUES ("Cartão de Crédito");
INSERT INTO forma_pagamento (forma) VALUES ("Cartão de Débito");
INSERT INTO forma_pagamento (forma) VALUES ("PIX");
INSERT INTO forma_pagamento (forma) VALUES ("Boleto Bancário");
INSERT INTO forma_pagamento (forma) VALUES ("Dinheiro");
INSERT INTO forma_pagamento (forma) VALUES ("Transferência Bancária");
INSERT INTO forma_pagamento (forma) VALUES ("Carteira Digital");
INSERT INTO forma_pagamento (forma) VALUES ("PayPal");
INSERT INTO forma_pagamento (forma) VALUES ("Multicaixa");
INSERT INTO forma_pagamento (forma) VALUES ("M-Pesa");
INSERT INTO forma_pagamento (forma) VALUES ("Ecoins");



/* Preencher tabela de tipos de anuncio */
INSERT INTO anuncio_tipo (tipo) VALUES ("Venda");
INSERT INTO anuncio_tipo (tipo) VALUES ("Troca");
INSERT INTO anuncio_tipo (tipo) VALUES ("Empréstimo");



/* Preencher tabela de status de atendimento */
INSERT INTO atendimento_status (status) VALUES ("Encerrado");
INSERT INTO atendimento_status (status) VALUES ("Aberto");
INSERT INTO atendimento_status (status) VALUES ("Em Processo");



/* Preencher tabelas dos itens novos */
START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Marreta 2kg', 'Marreta com cabo de fibra de vidro de alta resistência.', 1);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 15);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Jogo de Chaves Fenda/Philips', 'Conjunto com 6 peças imantadas.', 1);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 50);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Nível de Bolha 30cm', 'Estrutura em alumínio com 3 bolhas de precisão.', 1);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 20);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Trena Métrica 5m', 'Trena com trava de segurança e fita em aço.', 1);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 100);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Carregador Rápido USB-C', 'Carregador de parede 20W compatível com diversos modelos.', 2);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 45);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Mouse Sem Fio Eco', 'Mouse óptico recarregável via USB.', 2);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 30);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Cabo HDMI 2.0', 'Cabo blindado de 2 metros para resolução 4K.', 2);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 60);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('PowerBank 10000mAh', 'Bateria externa compacta com duas saídas USB.', 2);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 12);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Kit de Lâmpadas LED', 'Caixa com 5 lâmpadas LED 9W branco frio.', 4);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 25);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Filtro de Barro Moderno', 'Filtro tradicional com design renovado e 2 velas.', 4);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 5);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Composteira Doméstica', 'Sistema de 3 baldes para compostagem urbana.', 4);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 8);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Sabão Ecológico Líquido', 'Frasco de 1 litro biodegradável.', 4);
INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 40);
COMMIT;



/* Preencher tabelas dos itens usados */
START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Furadeira de Impacto', 'Usada poucas vezes, mandril de 1/2 polegada.', 1);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Escada de Alumínio 5 Degraus', 'Marcas de uso de tinta, mas estrutura impecável.', 3);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Monitor 21 Polegadas', 'Tela com pequeno arranhão no canto.', 5);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Teclado Mecânico RGB', 'Switch azul, faltando a tecla CapsLock.', 2);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Bicicleta Aro 26', 'Pneus gastos, mas funcionando perfeitamente.', 7);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Furadeira de Bancada', 'Equipamento antigo, muito robusto.', 9);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Lixadeira Orbital', 'Perfeita para marcenaria amadora.', 11);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Caixa de Som Bluetooth', 'Bateria dura cerca de 2 horas.', 12);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Ventilador de Torre', 'Faz um pouco de ruído na velocidade 3.', 6);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Mesa de Escritório', 'Em madeira MDF, 120cm x 60cm.', 8);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Cadeira de Praia', 'Um pouco desbotada pelo sol.', 10);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Carrinho de Mão', 'Ideal para jardinagem.', 1);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Aparador de Grama', 'Elétrico, 110V.', 4);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Modem Roteador Wi-Fi', 'Modelo antigo, mas funcional.', 2);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Microondas 20L', 'Botão de ligar precisa de pressão.', 5);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Máquina de Costura', 'Herança de família, funcionando bem.', 7);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Violão Acústico', 'Faltando a corda MI aguda.', 9);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;

START TRANSACTION;
INSERT INTO item (nome, descricao, usuario_id) VALUES ('Prancha de Surf 6.0', 'Com alguns tecos reparados.', 11);
INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
COMMIT;



/* Preencher tabela de anúncio */
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (1, 1, 85.50, 'Marreta 2kg nova, cabo de fibra.', 1, '2026-02-10');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (1, 4, 25.00, 'Trena métrica de alta precisão.', 1, '2026-02-10');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (2, 5, 49.90, 'Carregador USB-C 20W original.', 1, '2026-02-11');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (2, 8, 120.00, 'PowerBank 10000mAh para emergências.', 1, '2026-02-11');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (2, 26, 0.00, 'Modem antigo funcionando. Para quem precisar sair do sufoco!', 1, '2026-02-11');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (7, 17, 350.00, 'Bicicleta aro 26. Aceito ferramentas de jardinagem na troca.', 2, '2026-02-08');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (11, 30, 600.00, 'Prancha 6.0. Troco por monitor ou teclado mecânico.', 2, '2026-02-09');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (5, 15, 200.00, 'Monitor 21 polegadas usado. Aberto a propostas de troca.', 2, '2026-02-09');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (3, 14, 15.00, 'Aluguel diário de escada de alumínio para reformas.', 3, '2026-02-05');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (4, 25, 20.00, 'Aparador de grama elétrico disponível para fim de semana.', 3, '2026-02-07');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (1, 13, 30.00, 'Furadeira de impacto para serviços rápidos (diária).', 3, '2026-02-11');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio) 
VALUES (12, 20, 45.00, 'Caixa de som Bluetooth usada. Som limpo.', 1, '2026-02-10');
INSERT INTO anuncio (usuario_id, item_id, valor_anuncio, descricao, tipo, data_anuncio)
VALUES (8, 22, 150.00, 'Mesa de escritório MDF em ótimo estado.', 1, '2026-02-06');



/* Preencher tabelas de registro de venda, troca e empréstimo */
START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (8, 1, 2, '2025-12-20', 3, 50.00);
INSERT INTO registro_venda (registro_id) VALUES (LAST_INSERT_ID());
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (10, 2, 5, '2025-12-28', 3, 49.90);
INSERT INTO registro_venda (registro_id) VALUES (LAST_INSERT_ID());
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (12, 2, 8, '2026-01-05', 2, 110.00);
INSERT INTO registro_venda (registro_id) VALUES (LAST_INSERT_ID());
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (3, 7, 17, '2026-01-12', 5, 0.00); 
INSERT INTO registro_troca (registro_id, item_trocado_id) VALUES (LAST_INSERT_ID(), 13);
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (9, 11, 30, '2026-01-18', 5, 0.00);
INSERT INTO registro_troca (registro_id, item_trocado_id) VALUES (LAST_INSERT_ID(), 29);
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (5, 3, 14, '2026-01-10', 4, 15.00);
INSERT INTO registro_emprestimo (registro_id, data_previsao_devolucao, data_devolucao) 
VALUES (LAST_INSERT_ID(), '2026-01-15', '2026-01-14');
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (1, 4, 25, '2026-01-20', 11, 20.00);
INSERT INTO registro_emprestimo (registro_id, data_previsao_devolucao, data_devolucao) 
VALUES (LAST_INSERT_ID(), '2026-01-22', '2026-01-22');
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (9, 2, 26, '2026-01-15', 9, 0.00);
INSERT INTO registro_venda (registro_id) VALUES (LAST_INSERT_ID());
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (6, 1, 4, '2026-01-28', 3, 25.00);
INSERT INTO registro_venda (registro_id) VALUES (LAST_INSERT_ID());
COMMIT;

START TRANSACTION;
INSERT INTO registro (usuario_id, usuario_provedor_id, item_id, data_registro, forma_pagamento_id, valor_registro)
VALUES (7, 2, 6, '2026-02-01', 3, 35.00);
INSERT INTO registro_venda (registro_id) VALUES (LAST_INSERT_ID());
COMMIT;



/* Preencher tabela de atendimento */
INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao, registro_id) 
VALUES ("R20260211001", 3, 1, "Dúvida sobre o prazo de entrega da marreta.", 1);

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao, registro_id) 
VALUES ("R20260211002", 5, 3, "Solicitação de extensão do prazo de empréstimo da escada.", 5);

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao, registro_id) 
VALUES ("R20260211003", 10, 1, "Confirmação de recebimento do carregador USB-C.", 3);

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao, registro_id) 
VALUES ("R20260211004", 12, 2, "Relato de item (PowerBank) com avaria na caixa.", 4);

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao, registro_id) 
VALUES ("R20260211005", 9, 3, "Dificuldade em processar o pagamento via Multicaixa.", 6);

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao) 
VALUES ("G20260211006", 7, 1, "Dúvida sobre como cadastrar um novo item para troca.");

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao) 
VALUES ("G20260211007", 1, 2, "Problema ao tentar carregar fotos no perfil de vendedor.");

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao) 
VALUES ("G20260211008", 4, 3, "Denúncia de perfil suspeito tentando contato externo.");

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao) 
VALUES ("G20260211009", 11, 1, "Elogio ao sistema de Ecoins da plataforma.");

INSERT INTO atendimento (protocolo, usuario_id, atendimento_status_id, descricao) 
VALUES ("G20260211010", 8, 2, "Pedido de alteração de e-mail de cadastro.");



/* Preencher tabela de manutenções */
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (13, '2026-01-05', 'https://cdn.ecoshare.com/reports/maint_furadeira_13_20260105.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (24, '2026-01-12', 'https://cdn.ecoshare.com/reports/maint_carrinho_24_20260112.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (15, '2025-12-20', 'https://storage.reparostech.com.br/v2/laudo_monitor_15.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (26, '2026-01-08', 'https://storage.reparostech.com.br/v2/config_roteador_26.html');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (25, '2026-01-15', 'https://docs.jardimcasa.com/servicos/aparador_25_rev.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (27, '2026-02-02', 'https://docs.jardimcasa.com/servicos/microondas_27_final.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (17, '2025-12-10', 'https://bikeshop.com.br/revisoes/bike_17_dez25.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (28, '2026-01-20', 'https://costura.cia/laudos/maquina_28_jan.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (29, '2026-01-25', 'https://luthieria.com/certificados/violao_29_restauro.pdf');
INSERT INTO manutencao (item_id, data_manutencao, laudo) 
VALUES (30, '2026-02-01', 'https://surf-repair.com/vouchers/prancha_30_resina.pdf');



/* Preencher tabela de endereço */
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 1, '79002-010', 'Brasil', 'MS', 'Campo Grande', 'Centro', 'Rua 14 de Julho', 'Apt 402', '1500');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (2, 1, '79060-000', 'Brasil', 'MS', 'Campo Grande', 'Vila Olinda', 'Av. Guaicurus', 'Depósito', '450');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 2, '20040-002', 'Brasil', 'RJ', 'Rio de Janeiro', 'Centro', 'Av. Rio Branco', 'Bloco B', '100');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 3, '1100', 'Moçambique', 'Maputo', 'Maputo', 'Polana Cimento', 'Av. Julius Nyerere', 'Próximo ao Hotel', '123');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 4, '30140-071', 'Brasil', 'MG', 'Belo Horizonte', 'Savassi', 'Rua Sergipe', NULL, '800');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 5, '0000', 'Angola', 'Luanda', 'Luanda', 'Maianga', 'Rua Amílcar Cabral', 'Edifício Kilamba', '44');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 6, '80010-000', 'Brasil', 'PR', 'Curitiba', 'Centro', 'Rua XV de Novembro', NULL, '200');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 7, '0000', 'São Tomé e Príncipe', 'Água Grande', 'São Tomé', 'Quinta de Santo António', NULL, '15');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (2, 7, '0000', 'São Tomé e Príncipe', 'Lobata', 'Guadalupe', 'Centro', 'Estrada Nacional', 'Casa Amarela', 'SN');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 8, '22041-001', 'Brasil', 'RJ', 'Rio de Janeiro', 'Copacabana', 'Rua Figueiredo de Magalhães', 'Fundos', '50');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 9, '0000', 'Angola', 'Benguela', 'Benguela', 'Centro', 'Rua de Benguela', NULL, '102');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 10, '01310-100', 'Brasil', 'SP', 'São Paulo', 'Bela Vista', 'Av. Paulista', 'Cj 51', '1000');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 11, '0000', 'São Tomé e Príncipe', 'Mé-Zóchi', 'Trindade', 'Bairro Central', NULL, '7');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (1, 12, '40015-000', 'Brasil', 'BA', 'Salvador', 'Comércio', 'Rua da Bélgica', 'Sala 201', '10');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)
VALUES (2, 12, '41830-000', 'Brasil', 'BA', 'Salvador', 'Pituba', 'Av. Manoel Dias da Silva', 'Residencial', '1500');
INSERT INTO endereco (endereco_id, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero)



/* Preencher tabela de avaliação de usuário */
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (3, 1, 'Vendedor muito atencioso, a marreta chegou impecável.', 5, 2, '2025-12-20');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (8, 1, 'Entrega rápida e produto conforme o anúncio.', 5, 1, '2025-12-26');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (10, 2, 'O mouse é ótimo, mas a embalagem veio um pouco amassada.', 4, 0, '2026-01-05');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (12, 2, 'Excelente vendedora de eletrônicos, recomendo!', 5, 5, '2026-01-10');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (5, 3, 'O empréstimo da escada ajudou muito na minha reforma. Marcos é gente boa.', 5, 3, '2026-01-15');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (9, 11, 'Troca realizada com sucesso. A prancha está ótima.', 5, 1, '2026-01-25');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (1, 4, 'Luciana foi super pontual na entrega do aparador de grama.', 5, 2, '2026-01-28');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (6, 1, 'Demorou um pouco para responder o chat, mas o produto é bom.', 3, 0, '2026-02-05');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (7, 2, 'O cabo HDMI funciona, mas é bem curto.', 4, 1, '2026-02-08');
INSERT INTO avaliacao_usuario (usuario1_id, usuario2_id, descricao, nota, likes, data_avaliacao)
VALUES (11, 4, 'Kit de lâmpadas muito bom e econômico.', 5, 0, '2026-02-10');



/* Preencher tabela de avaliação de item */
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (3, 1, 'Ferramenta robusta, aguentou o trabalho pesado na obra.', 5, 4, '2025-12-22');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (8, 2, 'As chaves são imantadas mesmo, facilita muito.', 5, 2, '2025-12-28');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (10, 5, 'Carrega o celular bem rápido, não esquenta muito.', 5, 1, '2026-01-07');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (12, 8, 'Powerbank salva vidas, carrega meu celular 3 vezes.', 5, 6, '2026-01-12');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (9, 26, 'Roteador simples, mas o sinal pega na casa toda.', 4, 0, '2026-01-20');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (5, 14, 'Escada bem firme, mesmo sendo usada.', 5, 1, '2026-01-16');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (3, 17, 'A bike precisa de uma lubrificada na corrente, mas o quadro é ótimo.', 4, 2, '2026-01-14');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (9, 30, 'Prancha com flutuação animal, muito boa de remada.', 5, 3, '2026-01-30');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (1, 25, 'Corta a grama muito bem, motor forte.', 5, 1, '2026-01-26');
INSERT INTO avaliacao_item (usuario_id, item_id, descricao, nota, likes, data_avaliacao)
VALUES (5, 27, 'Microondas esquenta rápido, apesar do barulho.', 4, 0, '2026-02-09');



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