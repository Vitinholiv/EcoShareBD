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

		# Controle de Requisição
		if(isset($_POST['tipo'])){
			$tipo = $_POST['tipo'];
			if($tipo === 'cadastro_de_usuario'){

				$_username = secure_usuario_username($_POST['username']);
				$_senha = secure_usuario_senha($_POST['senha']);
				$_email = secure_usuario_email($_POST['email']);
				$_documento = secure_usuario_doc($_POST['documento']);
				$_tipo_documento = secure_usuario_doc_tipo($_POST['tipo_documento']);
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
					$sql = "SELECT u.nome as nome, u.senha as senha, u.email as email, u.username as username, u.usuario_doc as documento, u.usuario_doc_tipo_id as tipo_documento FROM usuario as u WHERE u.username = '$_username' LIMIT 1;";
					$res = send_sql_selection($sql);
					if($res['status'] == 'ERROR'){
						echo json_encode($res);
					} else if(count($res['data']) === 0){
						echo json_encode(['status' => 'ERROR', 'error' => 'Dados de login incorretos.']);
					} else {
						$nome           = $res['data'][0]['nome'];
						$senha          = $res['data'][0]['senha'];
						$email          = $res['data'][0]['email'];
						$username       = $res['data'][0]['username'];
						$documento      = $res['data'][0]['documento'];
						$tipo_documento = $res['data'][0]['tipo_documento'];
						if(password_verify($_senha,$senha)){
							$_SESSION['nome']            = $res['data'][0]['nome'];
							$_SESSION['username']        = $res['data'][0]['username'];
							$_SESSION['email']           = $res['data'][0]['email'];
							$_SESSION['documento']       = $res['data'][0]['documento'];
							$_SESSION['tipo_documento']  = $res['data'][0]['tipo_documento'];
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

				$_foto = secure_item_foto($_POST['foto']);
				$_descricao = secure_item_descricao($_POST['descricao']);
				$_nome = secure_item_nome($_POST['nome']);
				$_usuario_id = secure_item_usuario_id($_POST['usuario_id']);

				$arr = [$_foto,$_descricao,$_nome,$_usuario_id];
				$res_check = check_errors($arr);

				if($res_check['status'] == 'OK'){
					$sql = "INSERT INTO item (foto, descricao, nome, usuario_id) VALUES ('$_foto','$_descricao','$_nome',$_usuario_id)";
					$res = send_sql_insertion($sql);
					echo json_encode($res);
				} else {
					echo json_encode($res_check);
				}

			} else {
				echo json_encode(['status' => 'ERROR', 'error' => 'Bad request']);
			}
		}
	}
?>