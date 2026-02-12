<?php
	require_once 'env.php';
  
	# Conexão com o BD
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
			return ['status' => 'OK', 'id' => $connection->insert_id];
		}
	}

	function send_sql_transaction($sql) {
		global $connection;

		if ($connection->multi_query($sql)) {
			$last_id = null;
			do {
				if ($result = $connection->store_result()) {
					$result->free();
				}
				if ($connection->insert_id) {
					$last_id = $connection->insert_id;
				}
				if (!$connection->more_results()) {
					break;
				}
			} while ($connection->next_result());

			if ($connection->error) {
				return ['status' => 'ERROR', 'error' => $connection->error];
			}
			return ['status' => 'OK', 'id' => $last_id];
		} else {
			return ['status' => 'ERROR', 'error' => $connection->error];
		}
	}

	function send_sql_selection($sql) {
		global $connection;
		$result = $connection->query($sql);

		if ($result === false) {
			return ['status' => 'ERROR', 'error' => $connection->error];
		}

		$rows = [];
		while ($row = $result->fetch_assoc()) {
			$rows[] = $row;
		}
		return ['status' => 'OK', 'data' => $rows];
	}

	function clear_str($s){
		return htmlspecialchars(strip_tags(trim($s)), ENT_QUOTES, 'UTF-8');
	}

	function gerar_hash($tamanho = 30) {
		$data = uniqid('', true); 
		$random = base64_encode(random_bytes(12)); 
		return substr($data . $random, 0, $tamanho);
	}

	function verificar_fotos_reais($arquivos) {
		$validos = [];
		$val_tmp = [];
		$finfo = new finfo(FILEINFO_MIME_TYPE);

		foreach ($arquivos['tmp_name'] as $index => $tmpName) {
        if ($arquivos['error'][$index] === UPLOAD_ERR_OK) {
            $mimeReal = $finfo->file($tmpName);
            if (in_array($mimeReal, ['image/png', 'image/jpeg'])) {
                $validos[] = $arquivos['name'][$index];
                $val_tmp[] = $tmpName;
            }
        }
    }

		if (empty($validos)) {
			return ['status' => 'ERROR', 'val' => []];
		}

		$hashg = gerar_hash(30);
		$sql = "INSERT INTO validacao_foto (hash) VALUES ('$hashg');"; 
		$res = send_sql_insertion($sql);

		if($res['status'] == 'OK'){
			return [
				'status' => 'OK', 
				'validos' => $validos, 
				'hash' => $hashg, 
				'val' => $val_tmp
			];
		} else {
			return ['status' => 'ERROR', 'error' => 'Erro no Banco: ' . $res['error'], 'val' => []];
		}
	}

	# Secure - Cadastro de Usuário
	function secure_usuario_username($v){
		// username: letras, números e _
		$v = clear_str($v);
		if (empty($v)) {
			return ['status' => 'ERROR', 'error' => "O campo usuário não pode estar vazio."];
		}
		$padrao = '/[^a-zA-Z0-9_]/';
		if(!preg_match($padrao, $v)) {
			return $v;
		}
		return ['status' => 'ERROR', 'error' => "Nome de usuário inválido. Use apenas letras, números e underlines, sem espaços."];
	}

	function secure_usuario_senha($v, $willHash = true){
		// Senha: Tudo aceito por causa do hash. Ao menos 8 caracteres.
		if (strlen($v) < 8) {
			return ['status' => 'ERROR', 'error' => "A senha precisa de no mínimo 8 caracteres."];
		}
		if($willHash == true){
			return password_hash($v, PASSWORD_DEFAULT);
		} else {
			return $v;
		}
	}

	function secure_usuario_doc($v,$type) {
		$v = strtoupper(trim($v));
		if (empty($v)) {
			return ['status' => 'ERROR', 'error' => "O documento não pode estar vazio."];
		}

		$id_patterns = [
			'BI_AO' => '/^\d{9}[A-Z]{2}\d{3}$/', //000000000LA000
			'CPF' => '/^(\d{3}\.\d{3}\.\d{3}\-\d{2}|\d{11})$/', //000.000.000-00
			'CNPJ' => '/^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/', //00.000.000/0000-00
			'CNI' => '/^\d{7,9}$/', //0000000
			'BI_GW' => '/^\d{7,8}$/', //0000000
			'DIP' => '/^[A-Z0-9]{8,12}$/', //00000000
			'BI_MZ' => '/^\d{12}[A-Z]$/', //000000000000A
			'CC' => '/^(\d{8}\s\d\s[A-Z]{2}\d|\d{9}[A-Z]{2}\d)$/', //00000000 0 ZZ0
			'BI_ST' => '/^\d{7,8}$/', //0000000
			'CI' => '/^\d{9}$/' //000000000
		];

		if (preg_match($id_patterns[$type], $v)) {
			return $v;
		}
		return ['status' => 'ERROR', 'error' => "O formato do documento não corresponde ao padrão aceito."];
	}

 	function secure_usuario_doc_tipo($v){
		// O tipo do documento deve existir no banco de dados
		$sql = "SELECT id, usuario_doc_tipo_nome as nome FROM usuario_doc_tipo;";
		$res = send_sql_selection($sql);

		if ($res && is_array($res['data'])) {
			foreach ($res['data'] as $row) {
				if(strtoupper($row['nome']) == strtoupper($v)){
					return $row['id'];
				}
			}
		}
		return ['status' => 'ERROR', 'error' => "O tipo do documento não existe."];
	}

	function secure_usuario_nome($v){
		// O nome deve ser composto de caracteres latinos, podendo acentos ou espaços ou apóstrofo
		$v = clear_str($v);
		$v = str_replace(["'", "`", "´"], "’", $v);
		if (empty($v)) {
			return ['status' => 'ERROR', 'error' => "O campo nome não pode estar vazio."];
		}

		$padrao = '/[^a-zA-ZáàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ\s’]/u';
		if(!preg_match($padrao, $v)) {
			return $v;
		}
		return ['status' => 'ERROR', 'error' => "Nome inválido. Use apenas letras, espaços e acentos."];
	}

	function secure_usuario_email($v){
		// Função de convenção segura de email, excluindo adicionalmente aspas
		$v = str_replace(["'",'"'], "", $v);
		$v = filter_var(trim($v), FILTER_SANITIZE_EMAIL);
		if (!filter_var($v, FILTER_VALIDATE_EMAIL)) {
			return ['status' => 'ERROR', 'error' => "E-mail inválido."];
		}
		return $v;
	}

	# Secure - Cadastro de Item
	function secure_item_descricao($v){
		// Basta substituir as aspas para um texto simples não ser uma injeção, juntamente do clear_str para limpar tags html indesejadas.
		$v = str_replace("'", "’", $v);
		$v = clear_str($v);
		if(empty($v)){
			return ['status' => 'ERROR', 'error' => 'O campo descrição não pode estar vazio.']; 
		}
		return $v;
	}

	function secure_item_tipo($v){
		if($v === "Novo" || $v === "Usado") return $v;
		return ['status' => 'ERROR', 'error' => 'O tipo de item é inválido.']; 
	}

	function secure_item_nome($v): array|string{
		// O nome deve ser composto de caracteres latinos, podendo acentos, espaços, apóstrofo e números
		$v = clear_str($v);
		$v = str_replace(["'", "`", "´"], "’", $v);
		if (empty($v)) {
			return ['status' => 'ERROR', 'error' => "O campo nome não pode estar vazio."];
		}

		$padrao = '/[^a-zA-ZáàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ0-9\.\s\-’]/u';
		if(!preg_match($padrao, $v)) {
			return $v;
		}
		return ['status' => 'ERROR', 'error' => "Nome inválido. Use apenas letras, espaços, acentos, separadores e números."];
	}

	# Secure - Cadastro de Anúncio
    function secure_anuncio_descricao($v) {
        $v = str_replace("'", "’", $v);
        $v = clear_str($v);
        if(empty($v)){
            return ['status' => 'ERROR', 'error' => 'A descrição do anúncio não pode estar vazia.']; 
        }
        return $v;
    }

    function secure_anuncio_nome($v) {
		// Aceita letras, números, acentos e caracteres de pontuação básica
        $v = clear_str($v);
        $v = str_replace(["'", "`", "´"], "’", $v);
        if (empty($v)) {
            return ['status' => 'ERROR', 'error' => "O título do anúncio não pode estar vazio."];
        }
        $padrao = '/[^a-zA-ZáàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ0-9\.\!\?\-\s’]/u';
        if(!preg_match($padrao, $v)) {
            return $v;
        }
        return ['status' => 'ERROR', 'error' => "Título do anúncio contém caracteres inválidos."];
    }

    function secure_anuncio_tipo($v) {
		// Busca todos os tipos cadastrados no banco para validar a entrada
		$v = clear_str($v);
		if (empty($v)) {
			return ['status' => 'ERROR', 'error' => 'O tipo de anúncio deve ser selecionado.'];
		}

		$sql = "SELECT anuncio_tipo_id, tipo FROM anuncio_tipo;";
		$res = send_sql_selection($sql);

		if ($res['status'] === 'OK' && is_array($res['data'])) {
			foreach ($res['data'] as $row) {
				if (strcasecmp($row['tipo'], $v) === 0) {
					return $row['anuncio_tipo_id'];
				}
			}
		}
		return ['status' => 'ERROR', 'error' => 'Tipo de anúncio não reconhecido pelo sistema.'];
	}

    function secure_anuncio_valor($v) {
        if ($v === "" || $v === null) return 0.00;
        
        if (is_numeric($v)) {
            $valor = (float)$v;
            if ($valor >= 0) return $valor;
        }
        return ['status' => 'ERROR', 'error' => 'O valor informado é inválido.'];
    }

    function secure_anuncio_item_id($v) {
		// Verifica se o item realmente pertence ao usuário logado
        $id = (int)$v;
        if ($id <= 0) {
            return ['status' => 'ERROR', 'error' => 'Item não selecionado corretamente.'];
        }
        $user_id = $_SESSION['id'];
        $sql = "SELECT id FROM item WHERE id = $id AND usuario_id = $user_id LIMIT 1;";
        $res = send_sql_selection($sql);
        
        if ($res['status'] === 'OK' && count($res['data']) > 0) {
            return $id;
        }
        return ['status' => 'ERROR', 'error' => 'O item selecionado não foi encontrado entre seus itens.'];
    }

    function secure_anuncio_endereco_ordem($v) {
        $ordem = (int)$v;
        if ($ordem <= 0) {
            return ['status' => 'ERROR', 'error' => 'Endereço não selecionado.'];
        }

        $user_id = $_SESSION['id'];
        $sql = "SELECT endereco_ordem FROM endereco WHERE endereco_ordem = $ordem AND usuario_id = $user_id LIMIT 1;";
        $res = send_sql_selection($sql);

        if ($res['status'] === 'OK' && count($res['data']) > 0) {
            return $ordem;
        }
        return ['status' => 'ERROR', 'error' => 'O endereço selecionado é inválido.'];
    }

	function secure_endereco_pais($v) {
        $v = clear_str($v);
        if (empty($v)) {
            return ['status' => 'ERROR', 'error' => "O campo país é obrigatório."];
        }
        $paises = ['Brasil', 'Portugal', 'Angola', 'Moçambique', 'Cabo Verde', 'Guiné-Bissau', 'Guiné Equatorial', 'São Tomé e Príncipe', 'Timor-Leste'];
        
        foreach ($paises as $p) {
            if (strcasecmp($p, $v) === 0) return $p;
        }
        return ['status' => 'ERROR', 'error' => "Nome de país inválido."];
    }

    function secure_endereco_cep($v) {
		// Validação genérica para códigos postais lusófonos (variam de 4 a 8 caracteres)
        $v = preg_replace('/[^0-9A-Z\- ]/', '', strtoupper(trim($v)));
        if (empty($v)) {
            return ['status' => 'ERROR', 'error' => "O código postal/CEP é obrigatório."];
        }
        if (strlen($v) >= 4 && strlen($v) <= 12) {
            return $v;
        }
        return ['status' => 'ERROR', 'error' => "Código Postal/CEP inválido."];
    }

    function secure_endereco_estado($v) {
		// Estado pode ser vazio em alguns países, mas vamos aceitar letras e espaços
        $v = clear_str($v);
        if (empty($v)) return null; 
        if (preg_match('/^[a-zA-ZáàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ\s]{2,50}$/u', $v)) {
            return $v;
        }
        return ['status' => 'ERROR', 'error' => "Estado/Província inválido."];
    }

    function secure_endereco_cidade($v) {
        $v = clear_str($v);
        if (empty($v)) {
            return ['status' => 'ERROR', 'error' => "O campo cidade é obrigatório."];
        }
        if (preg_match('/^[a-zA-ZáàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ\s\-\’]+$/u', $v)) {
            return $v;
        }
        return ['status' => 'ERROR', 'error' => "Nome de cidade inválido."];
    }

    function secure_endereco_bairro($v) {
        $v = clear_str($v);
        if (empty($v)) {
            return ['status' => 'ERROR', 'error' => "O campo bairro/distrito é obrigatório."];
        }
        return $v;
    }

    function secure_endereco_logradouro($v) {
        $v = clear_str($v);
        if (empty($v)) {
            return ['status' => 'ERROR', 'error' => "O campo logradouro (rua) é obrigatório."];
        }
        return $v;
    }

    function secure_endereco_numero($v) {
        if (empty($v)) return null;
        $v = (int)$v;
        if ($v > 0) return $v;
        return ['status' => 'ERROR', 'error' => "Número de residência inválido."];
    }

    function secure_endereco_complemento($v) {
        $v = clear_str($v);
        return empty($v) ? null : $v;
    }