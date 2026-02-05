<?php
	require_once 'env.php';
  
	# Cria conexão com o BD
	$dbHost = DB_HOST;
	$dbUser = DB_USER;
	$dbPassword = DB_PASSWORD;
	$dbName = DB_NAME;

	$connection = new mysqli($dbHost, $dbUser, $dbPassword, $dbName);

	if ($connection->connect_error) {
		die("Erro na conexão com o banco de dados: " . $connection->connect_error);
	}
	global $connection;

	# Funções

	function result_to_string($result){
		if (!$result instanceof mysqli_result) return " D: ";

		$all_rows = $result->fetch_all(MYSQLI_ASSOC);
		if (empty($all_rows)) return "[]\n";

		$columns = array_keys($all_rows[0]);
		$widths = [];

		foreach ($columns as $col) {
			$widths[$col] = strlen($col);
		}
		foreach ($all_rows as $row) {
			foreach ($row as $col => $value) {
				$len = strlen((string)$value);
				if ($len > $widths[$col]) $widths[$col] = $len;
			}
		}
		$draw_line = function() use ($widths) {
			$line = "+";
			foreach ($widths as $w) $line .= str_repeat("-", $w + 2) . "+";
			return $line . "\n";
		};

		$output = $draw_line();
		$output .= "|";
		foreach ($columns as $col) {
			$output .= " " . str_pad($col, $widths[$col]) . " |";
		}
		$output .= "\n" . $draw_line();
		foreach ($all_rows as $row) {
			$output .= "|";
			foreach ($columns as $col) {
				$output .= " " . str_pad((string)$row[$col], $widths[$col]) . " |";
			}
			$output .= "\n";
		}
		$output .= $draw_line();
		return $output;
	}

	function execute_sql($sql_ln) {
		global $connection;

		$sql = substr($sql_ln, 1, -1);
		$result = $connection->query($sql);
		return result_to_string($result);

		# Lê linhas da consulta e converte em JSON
		/*
		$rows = [];
		if ($result->num_rows >= 0) {
			# $rows[] -> Adiciona no array rows o objeto obtido na próxima linha da consulta
			while ($row = $result->fetch_assoc()) {
				$rows[] = $row;
			}
			$json_result = json_encode($rows);
		}
		*/
	}
?>