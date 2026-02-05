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
			if ($tipo === 'consulta') {
				echo json_encode(["text" => execute_sql($_POST['sql'])]);
			} else {
				http_response_code(400);
				echo json_encode(["status" => "BAD REQUEST"]);
			}
		}
	}
?>