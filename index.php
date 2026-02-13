<?php
	session_start();
	require_once 'functions.php';

	# Requisições Get - Acesso à páginas
	if ($_SERVER['REQUEST_METHOD'] === 'GET'){
		$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
		switch ($path) {
			case '/login':
				if (isset($_SESSION['username'])) {
					header("Location: /home");
					exit;
				}
				require 'page_off_login.php';
				break;
			case '/cadastro':
				if (isset($_SESSION['username'])) {
					header("Location: /home");
					exit;
				}
				require 'page_off_cadastro.php';
				break;
			case '/item':
				if (!isset($_SESSION['username'])) {
					header("Location: /login");
					exit;
				}
				require 'page_item.php';
				break;
			case '/anuncio':
				if (!isset($_SESSION['username'])) {
					header("Location: /login");
					exit;
				}
				require 'page_anuncio.php';
				break;
			case '/endereco':
				if (!isset($_SESSION['username'])) {
					header("Location: /login");
					exit;
				}
				require 'page_endereco.php';
				break;
			case '/home':
				if (!isset($_SESSION['username'])) {
					header("Location: /login");
					exit;
				}
				require 'page_home.php';
				break;
			default:
				header("Location: /home");
				exit;
		}

	# Requisições Post - Envios intencionais de informação
	} else if($_SERVER['REQUEST_METHOD'] === 'POST'){

		# Definir API como pública e que retorna um Json
		header("Access-Control-Allow-Origin: *");
		header("Content-Type: application/json");
        require_once 'functions.php';

		if(!isset($_SESSION['username'])){
			$tipo = $_POST['tipo'];
			if(!isset($_POST['tipo']) || !($tipo === 'cadastro_de_usuario' || $tipo === 'login_de_usuario')){
				echo json_encode(['status' => 'ERROR', 'error' => 'Requisição inválida: Faça login primeiro.']);
				exit;
			}
		}

		# Controle de Requisição
		if(isset($_POST['tipo'])){
			$tipo = $_POST['tipo'];
			if($tipo === 'cadastro_de_usuario'){

				$_username = secure_usuario_username($_POST['username']);
				$_senha = secure_usuario_senha($_POST['senha']);
				$_email = secure_usuario_email($_POST['email']);
				$_tipo_documento = secure_usuario_doc_tipo($_POST['tipo_documento']);
				$_documento = secure_usuario_doc($_POST['documento'],$_POST['tipo_documento']);
				$_nome = secure_usuario_nome($_POST['nome']);

				$arr = [$_username,$_senha,$_email,$_documento,$_tipo_documento,$_nome];
				$res_check = check_errors($arr);
				if($res_check['status'] == 'OK'){
					$sql = "INSERT INTO usuario (usuario_doc_tipo_id, usuario_doc, email, username, nome, senha) VALUES ($_tipo_documento,'$_documento','$_email','$_username','$_nome','$_senha');";
					$res = send_sql_insertion($sql);
					echo json_encode($res);
				} else {
					echo json_encode($res_check);
				}

			} else if($tipo === 'login_de_usuario'){

				$_username = secure_usuario_username($_POST['username']);
				$_senha = secure_usuario_senha($_POST['senha'],false);

				$arr = [$_username,$_senha];
				$res_check = check_errors($arr);
				if($res_check['status'] == 'OK'){
					$sql = "SELECT u.id as id, u.nome as nome, u.senha as senha, u.email as email, u.username as username, u.usuario_doc as documento, u.usuario_doc_tipo_id as tipo_documento FROM usuario as u WHERE u.username = '$_username' LIMIT 1;";
					$res = send_sql_selection($sql);
					if($res['status'] == 'ERROR'){
						echo json_encode($res);
					} else if(count($res['data']) === 0){
						echo json_encode(['status' => 'ERROR', 'error' => 'Dados de login incorretos.']);
					} else {
						$id             = $res['data'][0]['id'];
						$nome           = $res['data'][0]['nome'];
						$senha          = $res['data'][0]['senha'];
						$email          = $res['data'][0]['email'];
						$username       = $res['data'][0]['username'];
						$documento      = $res['data'][0]['documento'];
						$tipo_documento = $res['data'][0]['tipo_documento'];
						if(password_verify($_senha,$senha)){
							$_SESSION['id']              = $id;
							$_SESSION['nome']            = $nome;
							$_SESSION['username']        = $username;
							$_SESSION['email']           = $email;
							$_SESSION['documento']       = $documento;
							$_SESSION['tipo_documento']  = $tipo_documento;
							echo json_encode(['status' => 'OK']);
						} else {
							echo json_encode(['status' => 'ERROR', 'error' => 'Dados de login incorretose.']);
						}
					}
				} else {
					echo json_encode($res_check);
				}

			} else if($tipo === 'logout'){

				if(isset($_SESSION['username'])){
					$unm = $_SESSION['username'];
					unset($_SESSION['id']);
					unset($_SESSION['nome']);
					unset($_SESSION['username']);
					unset($_SESSION['email']);
					unset($_SESSION['documento']);
					unset($_SESSION['tipo_documento']);
					echo json_encode(['status' => 'OK', 'username' => $unm]);
				} else {
					echo json_encode(['status' => 'ERROR', 'error' => 'Usuário não logado.']);
				}

			} else if($tipo === 'cadastro_de_item'){

				$_descricao = secure_item_descricao($_POST['descricao']);
				$_nome = secure_item_nome($_POST['nome']);
				$_usuario_id = $_SESSION['id'];
				$_tipo_item = secure_item_tipo($_POST['tipo_item']);

				$arr = [$_descricao,$_nome,$_tipo_item];
				$res_check = check_errors($arr);

				if($res_check['status'] == 'OK'){
					$sql = "";
					if($_tipo_item === 'Novo'){
						$sql = "START TRANSACTION;
						INSERT INTO item (descricao, nome, usuario_id) VALUES ('$_descricao', '$_nome', $_usuario_id);
						INSERT INTO item_novo (item_id, estoque) VALUES (LAST_INSERT_ID(), 1);
						COMMIT;";
					} else {
						$sql = "START TRANSACTION;
						INSERT INTO item (descricao, nome, usuario_id) VALUES ('$_descricao', '$_nome', $_usuario_id);
						INSERT INTO item_usado (item_id, item_status_id) VALUES (LAST_INSERT_ID(), 1);
						COMMIT;";
					}
					$res = send_sql_transaction($sql);
					echo json_encode($res);
				} else {
					echo json_encode($res_check);
				}

			} else if($tipo === 'insercao_de_foto'){

				if (isset($_POST['hash']) && isset($_POST['id']) && isset($_FILES['fotos']) && is_array($_FILES['fotos'])) {
					$hs = $_POST['hash']; $idv = $_POST['id'];
					$sqlv = "SELECT * FROM validacao_foto WHERE hash = '$hs';";
					$res = send_sql_selection($sqlv);
					if($res['status'] != 'OK'){
						echo json_encode($res);
					} else if(count($res['data']) == 0){
						echo json_encode(['status' => 'ERROR', 'error' => 'Hash de verificação inválido.']);
					} else {
						$dsql = "DELETE FROM validacao_foto WHERE hash = '$hs';";
						$deletion = send_sql_insertion($dsql);
						if($deletion['status'] != 'OK'){
							echo json_encode(value: $res);
						} else {
							$diretorio = "public/items/i" . $idv;
							if (is_dir($diretorio)) {
								echo json_encode(['status' => 'ERROR', 'error' => 'Não foi possível inserir as fotos do item']);
							} else {
								if (mkdir($diretorio, 0777, true)) {
									$erros_upload = [];
									foreach ($_FILES['fotos']['tmp_name'] as $index => $tmpName) {
										if ($_FILES['fotos']['error'][$index] === UPLOAD_ERR_OK) {
											$nomeOriginal = $_FILES['fotos']['name'][$index];
											$nomeLimpo = preg_replace('/[^a-zA-Z0-9._-]/', '', $nomeOriginal);
											$caminhoFinal = $diretorio . '/' . $nomeLimpo;
											if (!move_uploaded_file($tmpName, $caminhoFinal)) {
												$erros_upload[] = "Falha ao mover: $nomeOriginal";
											}
										}
									}
									if (empty($erros_upload)) {
										echo json_encode(['status' => 'OK']);
									} else {
										echo json_encode(['status' => 'ERROR', 'error' => 'Erro parcial no upload', 'detalhes' => $erros_upload]);
									}
								} else {
									echo json_encode(['status' => 'ERROR', 'error' => 'Falha ao criar o diretório no servidor.']);
								}
							}
						}
					}
				} else {
					echo json_encode(['status' => 'ERROR', 'error' => 'Dados de cadastro inválidos.']);
				}

			} else if($tipo === 'validacao_de_foto'){

				if (isset($_FILES['fotos']) && is_array($_FILES['fotos'])) {
					$dsql = "DELETE FROM validacao_foto;";
					$deletion = send_sql_insertion($dsql);
					if($deletion['status'] != 'OK'){
						echo json_encode(value: $res);
					}

					$reais = verificar_fotos_reais($_FILES['fotos']);
					if(isset($reais['val']) && is_array($reais['val']) && count($reais['val']) > 0){
						echo json_encode(['status' => 'OK','arquivos_validos' => $reais['validos'],'hash' => $reais['hash']]);
					} else {
						echo json_encode(['status' => 'ERROR', 'error' => 'Nenhum arquivo válido enviado.']);
					}
				} else {
					echo json_encode(['status' => 'ERROR', 'error' => 'Nenhum arquivo enviado.']);
				}

			} else if($tipo === 'buscar_itens_novos_do_usuario'){
				
				$id = $_SESSION['id'];
				$sql = "SELECT item.id, item.nome FROM item_novo JOIN item ON item.id = item_novo.item_id WHERE item.usuario_id = $id";
				$res = send_sql_selection($sql);
				echo json_encode($res);
				
			} else if($tipo === 'buscar_itens_usados_do_usuario'){

				$id = $_SESSION['id'];
				$sql = "SELECT item.id, item.nome FROM item_usado JOIN item ON item.id = item_usado.item_id WHERE item.usuario_id = $id";
				$res = send_sql_selection($sql);
				echo json_encode($res);
				
			} else if($tipo === 'obter_detalhes_item'){

				if(!isset($_POST['contexto']) || !isset($_POST['id'])){
					echo json_encode(['status' => 'ERROR', 'error' => 'Dados do item não definidos.']);
				} else {
					$id_item = $_POST['id'];
					$contexto = $_POST['contexto'];

					if($contexto === 'Novo'){
						$sql = "SELECT i.id, i.nome, i.descricao, n.estoque 
								FROM item i 
								JOIN item_novo n ON i.id = n.item_id 
								WHERE i.id = $id_item LIMIT 1";
					} else {
						$sql = "SELECT i.id, i.nome, i.descricao, s.item_status as status_nome 
								FROM item i 
								JOIN item_usado u ON i.id = u.item_id 
								JOIN item_status s ON u.item_status_id = s.id 
								WHERE i.id = $id_item LIMIT 1";
					}
					$res = send_sql_selection($sql);
					
					if($res['status'] === 'OK' && count($res['data']) === 0) {
						echo json_encode(['status' => 'ERROR', 'error' => 'Item não encontrado no banco.']);
					} else {
						echo json_encode($res);
					}
				}

			} else if($tipo === 'listar_fotos_item'){

				if(!isset($_POST['id'])){
					echo json_encode(['status' => 'ERROR', 'error' => 'Dados do item não definidos.']);
				} else {
					$id = $_POST['id'];
					$diretorio = "public/items/i" . $id;
					$fotos = [];

					if (is_dir($diretorio)) {
						$arquivos = scandir($diretorio);
						foreach ($arquivos as $arquivo) {
							if (in_array(pathinfo($arquivo, PATHINFO_EXTENSION), ['png', 'jpg', 'jpeg'])) {
								$fotos[] = $arquivo;
							}
						}
						echo json_encode(['status' => 'OK', 'fotos' => $fotos]);
					} else {
						echo json_encode(['status' => 'ERROR', 'error' => 'Diretório não encontrado', 'fotos' => []]);
					}
				}

			} else if ($tipo === 'listar_enderecos_usuario') {

				$user_id = $_SESSION['id'];
				$sql = "SELECT endereco_ordem, CEP, cidade, bairro, logradouro, numero, pais, estado, complemento
						FROM endereco 
						WHERE usuario_id = $user_id 
						ORDER BY endereco_ordem ASC";
						
				$res = send_sql_selection($sql);
				echo json_encode($res);

			} else if($tipo === 'cadastro_de_anuncio'){

				$_descricao = secure_anuncio_descricao($_POST['descricao']);
				$_nome = secure_anuncio_nome($_POST['nome']);
				$_usuario_id = $_SESSION['id'];
				$_tipo_anuncio = secure_anuncio_tipo($_POST['tipo_anuncio']);
				$_valor = secure_anuncio_valor($_POST['valor']);
				$_item_id = secure_anuncio_item_id($_POST['item_id']);
				$_endereco_ordem = secure_anuncio_endereco_ordem($_POST['endereco_ordem']);

				$arr = [$_descricao,$_nome,$_tipo_anuncio,$_valor,$_item_id,$_endereco_ordem];
				$res_check = check_errors($arr);

				if($res_check['status'] == 'OK'){
					$descricao_completa = $_descricao;

					$sql = "INSERT INTO anuncio (usuario_id, nome, tipo, item_id, endereco_ordem, valor_anuncio, descricao, data_anuncio) 
							VALUES ($_usuario_id, '$_nome', $_tipo_anuncio, $_item_id, $_endereco_ordem, $_valor, '$descricao_completa', CURDATE());";
					
					$res = send_sql_insertion($sql);
					echo json_encode($res);
				} else {
					echo json_encode($res_check);
				}

			} else if($tipo === 'cadastro_de_endereco'){

				$_pais        = secure_endereco_pais($_POST['pais']);
				$_cep         = secure_endereco_cep($_POST['cep']);
				$_estado      = secure_endereco_estado($_POST['estado']);
				$_cidade      = secure_endereco_cidade($_POST['cidade']);
				$_bairro      = secure_endereco_bairro($_POST['bairro']);
				$_logradouro  = secure_endereco_logradouro($_POST['logradouro']);
				$_numero      = secure_endereco_numero($_POST['numero']);
				$_complemento = secure_endereco_complemento($_POST['complemento']);
				$_usuario_id  = $_SESSION['id'];

				$arr = [$_pais, $_cep, $_cidade, $_bairro, $_logradouro];
				$res_check = check_errors($arr);

				if($res_check['status'] == 'OK'){
					$sql_ordem = "SELECT IFNULL(MAX(endereco_ordem), 0) + 1 as proxima_ordem FROM endereco WHERE usuario_id = $_usuario_id";
					$res_ordem = send_sql_selection($sql_ordem);
					
					if($res_ordem['status'] == 'OK'){
						$proxima_ordem = $res_ordem['data'][0]['proxima_ordem'];
						$val_numero = ($_numero !== null) ? $_numero : "NULL";
						$val_complemento = ($_complemento !== null) ? "'$_complemento'" : "NULL";
						$val_estado = ($_estado !== null) ? "'$_estado'" : "NULL";

						$sql = "INSERT INTO endereco (endereco_ordem, usuario_id, CEP, pais, estado, cidade, bairro, logradouro, complemento, numero) 
								VALUES ($proxima_ordem, $_usuario_id, '$_cep', '$_pais', $val_estado, '$_cidade', '$_bairro', '$_logradouro', $val_complemento, $val_numero);";
						
						$res = send_sql_insertion($sql);
						echo json_encode($res);
					} else {
						echo json_encode($res_ordem);
					}
				}
			} else if ($tipo === 'listar_anuncios_usuario') {

				$user_id = $_SESSION['id'];
				$sql = "SELECT a.id, a.nome, a.valor_anuncio, a.descricao, a.data_anuncio, t.tipo as tipo_nome, i.nome as item_nome
						FROM anuncio a
						JOIN anuncio_tipo t ON a.tipo = t.anuncio_tipo_id
						JOIN item i ON a.item_id = i.id
						WHERE a.usuario_id = $user_id
						ORDER BY a.data_anuncio DESC";
						
				$res = send_sql_selection($sql);
				echo json_encode($res);
				
			} else if($tipo === 'obter_detalhes_anuncio'){

				$id_anuncio = $_POST['id'];
				$sql = "SELECT a.*, t.tipo as tipo_nome, i.nome as item_nome, i.descricao as item_descricao,
							e.logradouro, e.numero, e.bairro, e.cidade, e.pais
						FROM anuncio a
						JOIN anuncio_tipo t ON a.tipo = t.anuncio_tipo_id
						JOIN item i ON a.item_id = i.id
						JOIN endereco e ON a.usuario_id = e.usuario_id AND a.endereco_ordem = e.endereco_ordem
						WHERE a.id = $id_anuncio LIMIT 1";
						
				$res = send_sql_selection($sql);
				echo json_encode($res);

			} else if ($tipo === 'buscar_anuncios_feed') {
				$meu_id = $_SESSION['id'];
				
				$sql = "SELECT a.id, a.nome as ad_nome, a.valor_anuncio, a.descricao as ad_descricao, t.tipo as tipo_nome, 
					i.id as item_id, i.descricao as item_descricao, u.nome as vendedor_nome, u.email as vendedor_email,
					e.cidade, e.estado, e.pais,
					(SELECT telefone FROM usuario_telefone WHERE usuario_id = u.id ORDER BY telefone_ordem ASC LIMIT 1) as vendedor_telefone
				FROM anuncio a
				JOIN item i ON a.item_id = i.id
				JOIN usuario u ON a.usuario_id = u.id
				JOIN anuncio_tipo t ON a.tipo = t.anuncio_tipo_id
				JOIN endereco e ON a.usuario_id = e.usuario_id AND a.endereco_ordem = e.endereco_ordem
				WHERE a.usuario_id != $meu_id
				ORDER BY a.data_anuncio DESC";

				$res = send_sql_selection($sql);
				echo json_encode($res);
			} else {
				echo json_encode(['status' => 'ERROR', 'error' => 'Requisição inválida.']);
			}
		}
	}
?>