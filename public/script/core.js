const route = window.location.pathname;
const params = new URLSearchParams(window.location.search);

switch (route) {
	case "/request": {
		run_sql();
        break;
    }
}

// Função que acontece "quando vc aperta um botão" - já tem as informações
async function cadastro_de_usuario(username, nome, email, documento, tipo_documento, senha){
    //cadastro_de_usuario('usuariodet','nome do infeliz','emaildoinfeliz@gmail.com','07045312305',1,'senhasegura333');
    // Nesse objeto vc coloca toda informação necessária pra vc saber oq fazer no PHP.
    let objeto = new URLSearchParams();
    objeto.append('tipo','cadastro_de_usuario');
    objeto.append('username',username);
    objeto.append('email',email);
    objeto.append('documento',documento);
    objeto.append('nome',nome);
    objeto.append('tipo_documento',tipo_documento);
    objeto.append('senha',senha);

    minha_resposta = await send_to_php(objeto);

    if(minha_resposta['status'] == 'ERROR'){
        console.log(minha_resposta['error']);
    } else {
        console.log('Cadastro feito com sucesso.');
    }
}

// Função que envia requests genéricas pro PHP. Lá dentro, faz limpeza dos campos e retorna um .json com o que vc quer. Isso vira um objeto js
async function send_to_php(objc) {
    try {
        let url = '/index.php';
        let res = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: objc
        });
        if (!res.ok) {
            return { 'status': 'ERROR', 'error': 'Erro na conexão com a URL' };
        }
        return await res.json();
    } catch (error) {
        return { 'status': 'ERROR', 'error': `Erro interno do PHP no processamento dos dados - ${error}` };
    }
}

async function run_sql(){
    let objRequest = new URLSearchParams();
    let sqlStr = params.get('sql');
    if(sqlStr !== null){
        objRequest.append('sql', `${sqlStr}`);
        objRequest.append('tipo','consulta');

        let url = '/index.php';
        let response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: objRequest
        })
        .then(res => {
            if (!res.ok) {
                console.log("Erro na conexão com a URL");
            }
            return res.json();
        })
        .catch(err => console.log(`ERRO NO FETCH: ${err}`));

        console.log(response['text'])
    }
}