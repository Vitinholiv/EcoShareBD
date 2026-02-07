<?php
	require_once 'env.php';
  
	# Cria conexão com o BD
	$dbHost = DB_HOST;
	$dbUser = DB_USER;
	$dbPassword = DB_PASSWORD;
	$dbName = DB_NAME;

	mysqli_report(MYSQLI_REPORT_OFF);
	$connection = new mysqli($dbHost, $dbUser, $dbPassword, $dbName);

	if ($connection->connect_error) {
		die("Erro na conexão com o banco de dados: " . $connection->connect_error);
	}
	global $connection;

	# Funções de Segurança

	function check_errors($arr){
		foreach($arr as $el){
			if(is_array($el) && isset($el['status']) && $el['status'] == 'ERROR'){
				return $el;
			} else if(is_array($el)){
				return ['status' => 'ERROR', 'error' => "Instrução desconhecida"];
			}
		}
		return ['status' => 'OK'];
	}

	function send_sql_insertion($sql){
		global $connection;
		$result = $connection->query($sql);

		if($result == false){
			return ['status' => 'ERROR', 'error' => $connection->error];
		} else {
			return ['status' => 'OK'];
		}
	}

	# Secures do Cadastro de items

	function secure_item_foto($v){
		return $v;
	}

	function secure_item_descricao($v){
		return $v;
	}

	function secure_item_nome($v){
		return $v;
	}

	function secure_item_usuario_id($v){
		return $v;
	}

	//Remove espaços no início e fim da entrada.
	function limpar_geral($v) {
		return htmlspecialchars(strip_tags(trim($v)), ENT_QUOTES, 'UTF-8');
	}

	function secure_usuario_username($v){
		// Padrão username: sem espaços, apenas letras latinas, números e underlines.
		$v = limpar_geral($v);

		if (empty($v)) {
			return ['status' => 'ERROR', 'error' => "O campo usuário não pode estar vazio."];
		}
		
		$padrao = '/[^a-zA-Z0-9_]/';

		if(!preg_match($padrao, $v)) {
			return $v;
		}

		return ['status' => 'ERROR', 'error' => "Nome inválido. Use apenas letras, números e underlines, sem espaços."];

	}

	// Padrão senha: Pelo menos 8 caracteres, sem demais regras (Exemplo: 'A senha deve ter pelo menos um caractere numérico e pelo menos um símbolo').
	function secure_usuario_senha($v){
		if (strlen($v) < 8) {
			return ['status' => 'ERROR', 'error' => "A senha precisa de no mínimo 8 caracteres."];
		}
		// Criptografa para o banco
		return password_hash($v, PASSWORD_DEFAULT);
	}

	//--------- PENDENTE ---------
	function secure_usuario_doc($v){
		return $v;
	}

	//--------- PENDENTE ---------
 	function secure_usuario_doc_tipo($v){
		return $v;
	}

	function secure_usuario_nome($v){
		//Padrão nome: letras latinas, acentos e espaços.
		$v = limpar_geral($v);

		if (empty($v)) {
			return ['status' => 'ERROR', 'error' => "O campo nome não pode estar vazio."];
		}

		$padrao = '/[^a-zA-ZáàâãéèêíïóôõöúçñÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ\s]/u';

		if(!preg_match($padrao, $v)) {
			return $v;
		}

		return ['status' => 'ERROR', 'error' => "Nome inválido. Use apenas letras e acentos."];

	}

	function secure_usuario_email($v){
		// Remove tudo que não for número (limpa pontos e traços).
		$v = filter_var(trim($v), FILTER_SANITIZE_EMAIL);

		if (!filter_var($v, FILTER_VALIDATE_EMAIL)) {
			return ['status' => 'ERROR', 'error' => "E-mail inválido."];
		}
		return $v; ;
	}
?>