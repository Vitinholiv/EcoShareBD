<?php
	# Requisições Get - Acesso à páginas
	if ($_SERVER['REQUEST_METHOD'] === 'GET'){
		$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
		switch ($path) {
        case '/':
            require 'page_main.php';
            break;
		case '/request':
            require 'page_main.php';
            break;
		case '/item':
			require 'page_item.php';
			break;
        default:
            http_response_code(404);
            echo "Página não encontrada.";
            break;
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
					$sql = "INSERT INTO usuario (usuario_doc_tipo_id, usuario_doc, email, username, nome, senha) VALUES ($_tipo_documento,'$_documento','$_email','$_username','$_nome','$_senha')";
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