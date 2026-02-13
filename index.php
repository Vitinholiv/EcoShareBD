<?php
    session_start();
    require_once 'functions.php';

    if ($_SERVER['REQUEST_METHOD'] === 'GET'){
        $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        switch ($path) {
            case '/login':
                if (isset($_SESSION['username'])) { header("Location: /home"); exit; }
                require 'page_off_login.php';
                break;
            case '/cadastro':
                if (isset($_SESSION['username'])) { header("Location: /home"); exit; }
                require 'page_off_cadastro.php';
                break;
            case '/item':
                if (!isset($_SESSION['username'])) { header("Location: /login"); exit; }
                require 'page_item.php';
                break;
            case '/anuncio':
                if (!isset($_SESSION['username'])) { header("Location: /login"); exit; }
                require 'page_anuncio.php';
                break;
            case '/endereco':
                if (!isset($_SESSION['username'])) { header("Location: /login"); exit; }
                require 'page_endereco.php';
                break;
            case '/home':
                if (!isset($_SESSION['username'])) { header("Location: /login"); exit; }
                require 'page_home.php';
                break;
            case '/proposta':
                if (!isset($_SESSION['username'])) { header("Location: /login"); exit; }
                require 'page_proposta.php';
                break;
            case '/registro':
                if (!isset($_SESSION['username'])) { header("Location: /login"); exit; }
                require 'page_registro.php';
                break;
            default:
                header("Location: /home");
                exit;
        }
    } else if($_SERVER['REQUEST_METHOD'] === 'POST'){

        header("Access-Control-Allow-Origin: *");
        header("Content-Type: application/json");

        if(!isset($_SESSION['username'])){
            $tipo = $_POST['tipo'] ?? '';
            if(!($tipo === 'cadastro_de_usuario' || $tipo === 'login_de_usuario')){
                echo json_encode(['status' => 'ERROR', 'error' => 'Requisição inválida: Faça login primeiro.']);
                exit;
            }
        }

        if(isset($_POST['tipo'])){
            $tipo = $_POST['tipo'];
            $meu_id = (int)($_SESSION['id'] ?? 0);

            if($tipo === 'cadastro_de_usuario'){

                $_tipo_doc_id = secure_usuario_doc_tipo($_POST['tipo_documento']);
                $_doc = secure_usuario_doc($_POST['documento'], $_POST['tipo_documento']);
                $_username = secure_usuario_username($_POST['username']);
                $_senha = secure_usuario_senha($_POST['senha']);
                $_email = secure_usuario_email($_POST['email']);
                $_nome = secure_usuario_nome($_POST['nome']);

                $arr = [$_username, $_senha, $_email, $_doc, $_tipo_doc_id, $_nome];
                $res_check = check_errors($arr);
                
                if($res_check['status'] == 'OK'){
                    $sql_check = "SELECT username, email FROM usuario 
                                  WHERE username = '{$connection->real_escape_string($_username)}' 
                                  OR email = '{$connection->real_escape_string($_email)}' LIMIT 1";
                    
                    $res_dup = send_sql_selection($sql_check);
                    if(count($res_dup['data']) > 0){
                        $existente = $res_dup['data'][0];
                        $msg = ($existente['username'] === $_username) ? "Usuário já existe." : "E-mail já cadastrado.";
                        echo json_encode(['status' => 'ERROR', 'error' => $msg]);
                        exit;
                    }

                    $sql = "INSERT INTO usuario (usuario_doc_tipo_id, usuario_doc, email, username, nome, senha) 
                            VALUES ($_tipo_doc_id,'{$connection->real_escape_string($_doc)}','{$connection->real_escape_string($_email)}','{$connection->real_escape_string($_username)}','{$connection->real_escape_string($_nome)}','$_senha');";
                    echo json_encode(send_sql_insertion($sql));
                } else {
                    echo json_encode($res_check);
                }

            } else if($tipo === 'login_de_usuario'){

                $_username = $connection->real_escape_string(secure_usuario_username($_POST['username']));
                $sql = "SELECT * FROM usuario WHERE username = '$_username' LIMIT 1;";
                $res = send_sql_selection($sql);
                
                $erro_gen = ['status' => 'ERROR', 'error' => 'Usuário ou senha incorretos.'];

                if($res['status'] == 'OK' && count($res['data']) === 1){
                    $u = $res['data'][0];
                    if(password_verify($_POST['senha'], $u['senha'])){
                        $_SESSION['id'] = $u['id'];
                        $_SESSION['nome'] = $u['nome'];
                        $_SESSION['username'] = $u['username'];
                        $_SESSION['email'] = $u['email'];
                        $_SESSION['usuario_doc'] = $u['usuario_doc'];
                        $_SESSION['usuario_doc_tipo'] = $u['usuario_doc_tipo_id'];
                        echo json_encode(['status' => 'OK']);
                    } else { echo json_encode($erro_gen); }
                } else { echo json_encode($erro_gen); }
            
            } else if($tipo === 'logout'){
                $unm = $_SESSION['username'] ?? 'Usuário';
                $unm = $_SESSION['username'] ?? 'Usuário';
                session_destroy();
                echo json_encode(['status' => 'OK', 'username' => $unm]);

            } else if($tipo === 'cadastro_de_item'){
                $_descricao = secure_item_descricao($_POST['descricao']);
                $_nome = secure_item_nome($_POST['nome']);
                $_tipo_item = secure_item_tipo($_POST['tipo_item']);
                $arr = [$_descricao, $_nome, $_tipo_item];
                $res_check = check_errors($arr);

                if($res_check['status'] == 'OK'){
                    $sql_check = "SELECT id FROM item WHERE nome = '{$connection->real_escape_string($_nome)}' AND usuario_id = $meu_id LIMIT 1";
                    $res_dup = send_sql_selection($sql_check);
                    if(count($res_dup['data']) > 0){
                        echo json_encode(['status' => 'ERROR', 'error' => 'Você já possui um item com este nome.']);
                        exit;
                    }
                    $sql = "START TRANSACTION;
                            INSERT INTO item (descricao, nome, usuario_id) VALUES ('{$connection->real_escape_string($_descricao)}', '{$connection->real_escape_string($_nome)}', $meu_id);";
                    if($_tipo_item === 'Novo'){
                        $sql .= "INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 1); COMMIT;";
                    } else {
                        $sql .= "INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1); COMMIT;";
                    }
                    echo json_encode(send_sql_transaction($sql));
                } else {
                    echo json_encode($res_check);
                }

            } else if($tipo === 'reverter_item_por_erro_foto'){
                $id_item = (int)$_POST['id'];
                echo json_encode(send_sql_insertion("DELETE FROM item WHERE id = $id_item AND usuario_id = $meu_id"));

            } else if($tipo === 'insercao_de_foto'){
                if (isset($_POST['hash']) && isset($_POST['id']) && isset($_FILES['fotos'])) {
                    $hs = $connection->real_escape_string($_POST['hash']);
                    $idv = (int)$_POST['id'];
                    $sqlv = "SELECT * FROM validacao_foto WHERE hash = '$hs';";
                    $res = send_sql_selection($sqlv);
                    if($res['status'] == 'OK' && count($res['data']) > 0){
                        send_sql_insertion("DELETE FROM validacao_foto WHERE hash = '$hs';");
                        $diretorio = "public/items/i" . $idv;
                        if (!is_dir($diretorio)) {
                            mkdir($diretorio, 0777, true);
                            foreach ($_FILES['fotos']['tmp_name'] as $index => $tmpName) {
                                if ($_FILES['fotos']['error'][$index] === UPLOAD_ERR_OK) {
                                    $nomeLimpo = preg_replace('/[^a-zA-Z0-9._-]/', '', $_FILES['fotos']['name'][$index]);
                                    move_uploaded_file($tmpName, $diretorio . '/' . $nomeLimpo);
                                }
                            }
                            echo json_encode(['status' => 'OK']);
                        } else { echo json_encode(['status' => 'ERROR', 'error' => 'Diretório já existe']); }
                    } else { echo json_encode(['status' => 'ERROR', 'error' => 'Hash inválido']); }
                }

            } else if($tipo === 'validacao_de_foto'){
                if (isset($_FILES['fotos'])) {
                    send_sql_insertion("DELETE FROM validacao_foto;");
                    $reais = verificar_fotos_reais($_FILES['fotos']);
                    echo json_encode($reais['status'] == 'OK' ? ['status' => 'OK', 'arquivos_validos' => $reais['validos'], 'hash' => $reais['hash']] : $reais);
                }

            } else if($tipo === 'buscar_itens_novos_do_usuario' || $tipo === 'buscar_itens_usados_do_usuario'){
                $tab = ($tipo === 'buscar_itens_novos_do_usuario') ? 'item_novo' : 'item_usado';
                echo json_encode(send_sql_selection("SELECT item.id, item.nome FROM $tab JOIN item ON item.id = $tab.item_id WHERE item.usuario_id = $meu_id"));

            } else if($tipo === 'obter_detalhes_item'){
                $id_item = (int)$_POST['id'];
                $contexto = $_POST['contexto'];
                if($contexto === 'Novo'){
                    $sql = "SELECT i.id, i.nome, i.descricao, n.estoque FROM item i JOIN item_novo n ON i.id = n.item_id WHERE i.id = $id_item LIMIT 1";
                } else {
                    $sql = "SELECT i.id, i.nome, i.descricao, s.item_status as status_nome FROM item i JOIN item_usado u ON i.id = u.item_id JOIN item_status s ON u.item_status_id = s.id WHERE i.id = $id_item LIMIT 1";
                }
                echo json_encode(send_sql_selection($sql));

            } else if($tipo === 'listar_fotos_item'){
                $id = (int)$_POST['id'];
                $diretorio = "public/items/i" . $id;
                $fotos = [];
                if (is_dir($diretorio)) {
                    foreach (scandir($diretorio) as $arquivo) {
                        if (in_array(pathinfo($arquivo, PATHINFO_EXTENSION), ['png', 'jpg', 'jpeg'])) $fotos[] = $arquivo;
                    }
                    echo json_encode(['status' => 'OK', 'fotos' => $fotos]);
                } else { echo json_encode(['status' => 'ERROR', 'fotos' => []]); }

            } else if($tipo === 'listar_enderecos_usuario'){
                echo json_encode(send_sql_selection("SELECT * FROM endereco WHERE usuario_id = $meu_id ORDER BY endereco_ordem ASC"));

            } else if($tipo === 'cadastro_de_endereco'){
                $sql_ordem = "SELECT IFNULL(MAX(endereco_ordem), 0) + 1 as proxima_ordem FROM endereco WHERE usuario_id = $meu_id";
                $res_ordem = send_sql_selection($sql_ordem);
                $prox = $res_ordem['data'][0]['proxima_ordem'];
                $_pais = $connection->real_escape_string(secure_endereco_pais($_POST['pais']));
                $_cep = $connection->real_escape_string(secure_endereco_cep($_POST['cep']));
                $_cidade = $connection->real_escape_string(secure_endereco_cidade($_POST['cidade']));
                $_bairro = $connection->real_escape_string(secure_endereco_bairro($_POST['bairro']));
                $_log = $connection->real_escape_string(secure_endereco_logradouro($_POST['logradouro']));
                $_num = (int)$_POST['numero'] ?: "NULL";
                $_comp = $_POST['complemento'] ? "'".$connection->real_escape_string($_POST['complemento'])."'" : "NULL";
                $_est = $_POST['estado'] ? "'".$connection->real_escape_string($_POST['estado'])."'" : "NULL";
                $sql = "INSERT INTO endereco (endereco_ordem, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero) 
                        VALUES ($prox, $meu_id, '$_cep', '$_pais', $_est, '$_cidade', '$_bairro', '$_log', $_comp, $_num);";
                echo json_encode(send_sql_insertion($sql));

            } else if($tipo === 'cadastro_de_anuncio'){
                $_nom = secure_anuncio_nome($_POST['nome']);
                $_des = secure_anuncio_descricao($_POST['descricao']);
                $_tpo = (int)secure_anuncio_tipo($_POST['tipo_anuncio']);
                $_val = secure_anuncio_valor($_POST['valor']);
                $_itd = (int)secure_anuncio_item_id($_POST['item_id']);
                $_end = (int)secure_anuncio_endereco_ordem($_POST['endereco_ordem']);
                $sql = "INSERT INTO anuncio (usuario_id, nome, tipo, item_id, endereco_ordem, valor_anuncio, descricao, data_anuncio) 
                        VALUES ($meu_id, '{$connection->real_escape_string($_nom)}', $_tpo, $_itd, $_end, $_val, '{$connection->real_escape_string($_des)}', CURDATE());";
                echo json_encode(send_sql_insertion($sql));

            } else if($tipo === 'listar_anuncios_usuario'){
                echo json_encode(send_sql_selection("SELECT a.*, t.tipo as tipo_nome, i.nome as item_nome FROM anuncio a JOIN anuncio_tipo t ON a.tipo = t.anuncio_tipo_id JOIN item i ON a.item_id = i.id WHERE a.usuario_id = $meu_id ORDER BY a.data_anuncio DESC"));

            } else if($tipo === 'excluir_anuncio'){
                $id = (int)$_POST['id'];
                echo json_encode(send_sql_insertion("DELETE FROM anuncio WHERE id = $id AND usuario_id = $meu_id"));

            } else if($tipo === 'obter_detalhes_anuncio'){
                $id = (int)$_POST['id'];
                $sql = "SELECT a.*, t.tipo as tipo_nome, i.nome as item_nome, i.descricao as item_descricao, e.logradouro, e.numero, e.bairro, e.cidade, e.pais FROM anuncio a JOIN anuncio_tipo t ON a.tipo = t.anuncio_tipo_id JOIN item i ON a.item_id = i.id JOIN endereco e ON a.usuario_id = e.usuario_id AND a.endereco_ordem = e.endereco_ordem WHERE a.id = $id LIMIT 1";
                echo json_encode(send_sql_selection($sql));

            } else if($tipo === 'buscar_anuncios_feed'){
                $buscaRaw = $_POST['busca'] ?? '';
                $buscaLimpa = preg_replace('/[^\p{L}\p{N}\s]/u', '', $buscaRaw);
                $busca = $connection->real_escape_string($buscaLimpa);
                $filtro = "";
                
                if (!empty($busca)) {
                    $pals = explode(' ', $busca);
                    $conds = [];
                    foreach ($pals as $p) {
                        if(!empty($p)) {
                            $conds[] = "(a.nome LIKE '%$p%' OR a.descricao LIKE '%$p%')";
                        }
                    }
                    if (!empty($conds)) {
                        $filtro = " AND (" . implode(" OR ", $conds) . ")";
                    }
                }
                
                $sql = "SELECT a.id, a.nome as ad_nome, a.valor_anuncio, a.descricao as ad_descricao, 
                               t.tipo as tipo_nome, i.id as item_id, i.nome as item_nome, 
                               i.descricao as item_descricao, u.nome as vendedor_nome, 
                               u.email as vendedor_email, e.cidade, e.estado, e.pais, 
                               (SELECT telefone FROM usuario_telefone WHERE usuario_id = u.id ORDER BY telefone_ordem ASC LIMIT 1) as vendedor_telefone 
                        FROM anuncio a 
                        JOIN item i ON a.item_id = i.id 
                        JOIN usuario u ON a.usuario_id = u.id 
                        JOIN anuncio_tipo t ON a.tipo = t.anuncio_tipo_id 
                        JOIN endereco e ON a.usuario_id = e.usuario_id AND a.endereco_ordem = e.endereco_ordem 
                        WHERE a.usuario_id != $meu_id $filtro 
                        ORDER BY a.data_anuncio DESC";
                
                echo json_encode(send_sql_selection($sql));

            } else if($tipo === 'enviar_proposta'){

                $_ad_id = (int)$_POST['anuncio_id'];
                $_txt = secure_proposta_texto($_POST['proposta']);
                $_val = secure_proposta_valor($_POST['valor']);
                $_it_id = "NULL";
                if(!empty($_POST['item_id']) && $_POST['item_id'] !== "undefined"){
                    $it_id = (int)$_POST['item_id'];
                    $posse = send_sql_selection("SELECT id FROM item WHERE id = $it_id AND usuario_id = $meu_id");
                    if(count($posse['data']) > 0) $_it_id = $it_id;
                    else { echo json_encode(['status' => 'ERROR', 'error' => 'Item inválido.']); exit; }
                }
                if(is_array($_txt) || is_array($_val)){ echo json_encode($_txt ?: $_val); exit; }
                $sql = "INSERT INTO proposta (anuncio_id, usuario_id, valor, texto_proposta, item_oferecido_id) 
                        VALUES ($_ad_id, $meu_id, $_val, '{$connection->real_escape_string($_txt)}', $_it_id)";
                echo json_encode(send_sql_insertion($sql));

            } else if($tipo === 'listar_propostas_recebidas'){

                $sql = "SELECT p.*, a.nome as anuncio_nome, u.nome as proponente_nome, i.nome as item_ofertado_nome FROM proposta p JOIN anuncio a ON p.anuncio_id = a.id JOIN usuario u ON p.usuario_id = u.id LEFT JOIN item i ON p.item_oferecido_id = i.id WHERE a.usuario_id = $meu_id ORDER BY p.data_proposta DESC";
                echo json_encode(send_sql_selection($sql));

            } else if($tipo === 'listar_propostas_feitas'){

                $sql = "SELECT p.*, a.nome as anuncio_nome, u.nome as vendedor_nome, i.nome as item_ofertado_nome FROM proposta p JOIN anuncio a ON p.anuncio_id = a.id JOIN usuario u ON a.usuario_id = u.id LEFT JOIN item i ON p.item_oferecido_id = i.id WHERE p.usuario_id = $meu_id ORDER BY p.data_proposta DESC";
                echo json_encode(send_sql_selection($sql));

            } else if($tipo === 'rejeitar_proposta'){
                
                $id = (int)$_POST['id'];
                echo json_encode(send_sql_insertion("DELETE p FROM proposta p JOIN anuncio a ON p.anuncio_id = a.id WHERE p.id = $id AND (a.usuario_id = $meu_id OR p.usuario_id = $meu_id)"));

            } else if($tipo === 'listar_formas_pagamento'){

                echo json_encode(send_sql_selection("SELECT * FROM forma_pagamento ORDER BY forma ASC"));

            } else if($tipo === 'verificar_tipo_proposta'){

                $id = (int)$_POST['id'];
                $res = send_sql_selection("SELECT a.tipo FROM proposta p JOIN anuncio a ON p.anuncio_id = a.id WHERE p.id = $id");
                echo json_encode(['tipo_anuncio' => $res['data'][0]['tipo'] ?? 0]);

            } else if($tipo === 'confirmar_aceite_proposta'){

                $pid = (int)$_POST['proposta_id'];
                $fid = (int)$_POST['forma_pagamento_id'];
                $data_dev = $_POST['data_devolucao'] ?: null;

                $sql = "SELECT p.*, a.usuario_id as vend_id, a.tipo as a_tipo, a.item_id as item_id,
                        u_p.usuario_doc as p_doc, u_p.usuario_doc_tipo_id as p_tdoc,
                        u_v.usuario_doc as v_doc, u_v.usuario_doc_tipo_id as v_tdoc
                        FROM proposta p 
                        JOIN anuncio a ON p.anuncio_id = a.id 
                        JOIN usuario u_p ON p.usuario_id = u_p.id
                        JOIN usuario u_v ON a.usuario_id = u_v.id
                        WHERE p.id = $pid AND a.usuario_id = $meu_id";

                $res = send_sql_selection($sql);
                
                if($res['status'] == 'OK' && count($res['data']) > 0){

                    $d = $res['data'][0];
                    $connection->begin_transaction();
                    try {
                        $l_res = send_sql_selection("SELECT id FROM item_legado WHERE item_id = {$d['item_id']} ORDER BY id DESC LIMIT 1");
                        
                        if (empty($l_res['data'])) {
                            $connection->query("INSERT INTO item_legado (nome, descricao, item_id) SELECT nome, descricao, id FROM item WHERE id = {$d['item_id']}");
                            $leg_id = $connection->insert_id;
                        } else {
                            $leg_id = $l_res['data'][0]['id'];
                        }

                        $sql_reg = "INSERT INTO registro (doc_tipo_provedor, doc_provedor, doc_tipo_cliente, doc_cliente, item_legado_id, forma_pagamento_id, data_registro, valor_registro)
                                    VALUES ({$d['v_tdoc']}, '{$d['v_doc']}', {$d['p_tdoc']}, '{$d['p_doc']}', $leg_id, $fid, CURDATE(), {$d['valor']})";
                        
                        if (!$connection->query($sql_reg)) {
                            throw new Exception("Erro ao inserir registro: " . $connection->error);
                        }
                        
                        $reg_id = $connection->insert_id;

                        if($d['a_tipo'] == 1) { 
        
                            $connection->query("INSERT INTO registro_venda (registro_id) VALUES ($reg_id)");
                            $connection->query("UPDATE item SET usuario_id = {$d['usuario_id']} WHERE id = {$d['item_id']}");

                        } else if($d['a_tipo'] == 2) {
                            $l_prop = send_sql_selection("SELECT id FROM item_legado WHERE item_id = {$d['item_oferecido_id']} ORDER BY id DESC LIMIT 1");
                            $leg_prop = $l_prop['data'][0]['id'] ?? 0;
                            
                            if($leg_prop == 0 && !empty($d['item_oferecido_id'])){
                                $connection->query("INSERT INTO item_legado (nome, descricao, item_id) SELECT nome, descricao, id FROM item WHERE id = {$d['item_oferecido_id']}");
                                $leg_prop = $connection->insert_id;
                            }

                            $connection->query("INSERT INTO registro_troca (registro_id, item_legado_id) VALUES ($reg_id, $leg_prop)");

                            $connection->query("UPDATE item SET usuario_id = {$d['usuario_id']} WHERE id = {$d['item_id']}");

                            if(!empty($d['item_oferecido_id'])){
                                $connection->query("UPDATE item SET usuario_id = {$d['vend_id']} WHERE id = {$d['item_oferecido_id']}");
                            }

                        } else {
                            $connection->query("INSERT INTO registro_emprestimo (registro_id, data_previsao) VALUES ($reg_id, '$data_dev')");
                        }

                        $connection->query("DELETE FROM anuncio WHERE id = {$d['anuncio_id']}");

                        $connection->commit();
                        echo json_encode(['status' => 'OK']);

                    } catch (Exception $e) {
                        $connection->rollback();
                        echo json_encode(['status' => 'ERROR', 'error' => $e->getMessage()]);
                    }
                }

            } else if($tipo === 'listar_meus_registros_vendas' || $tipo === 'listar_meus_registros_compras'){
                
                $meu_id = (int)($_SESSION['id'] ?? 0);
                if($meu_id === 0) {
                    echo json_encode(['status' => 'ERROR', 'error' => 'Sessão expirada.']); exit;
                }

                $c_doc = ($tipo === 'listar_meus_registros_vendas') ? 'r.doc_provedor' : 'r.doc_cliente';
                $c_tipo = ($tipo === 'listar_meus_registros_vendas') ? 'r.doc_tipo_provedor' : 'r.doc_tipo_cliente';

                $sql = "SELECT r.*, f.forma as forma_pagamento, il.nome as item_nome 
                        FROM registro r 
                        JOIN usuario u ON (
                            REPLACE(REPLACE($c_doc, '.', ''), '-', '') = REPLACE(REPLACE(u.usuario_doc, '.', ''), '-', '')
                            AND $c_tipo = u.usuario_doc_tipo_id
                        )
                        LEFT JOIN forma_pagamento f ON r.forma_pagamento_id = f.id
                        LEFT JOIN item_legado il ON r.item_legado_id = il.id
                        WHERE u.id = $meu_id
                        ORDER BY r.data_registro DESC";
                        
                echo json_encode(send_sql_selection($sql));

            } else {
                echo json_encode(['status' => 'ERROR', 'error' => 'Proposta não autorizada ou inexistente.']);
            }
        }
    }
?>