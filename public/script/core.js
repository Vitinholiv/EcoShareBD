const route = window.location.pathname;
const params = new URLSearchParams(window.location.search);

async function cadastro_de_usuario(username, nome, email, documento, tipo_documento, senha){
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
        return minha_resposta['error'];
    } else {
        return 'Cadastro feito com sucesso.';
    }
}



async function prepara_cadastro_de_usuario(params) {
    let username = document.getElementById('inputUser').value;
    let email    = document.getElementById('inputEmail').value;
    let senha    = document.getElementById('inputSenha').value;
    let nome     = document.getElementById('inputNome').value;
    let doc      = document.getElementById('inputDoc').value;
    let docType  = document.getElementById('inputDocType').value;

    const mensagem = await cadastro_de_usuario(username, nome, email, doc, docType, senha);

    if (mensagem === 'Cadastro feito com sucesso.'){
        document.getElementById('inputUser').value = '';
        document.getElementById('inputEmail').value = '';
        document.getElementById('inputSenha').value = '';
        document.getElementById('inputNome').value = '';
        document.getElementById('inputDoc').value = '';
        document.getElementById('inputDocType').value = '';
    }
    alert(mensagem);
}



async function login_de_usuario(username, senha){
    let objeto = new URLSearchParams();
    objeto.append('tipo','login_de_usuario');
    objeto.append('username',username);
    objeto.append('senha',senha);

    minha_resposta = await send_to_php(objeto);

    if(minha_resposta['status'] == 'ERROR'){
        return minha_resposta['error'];
    } else {
        return 'Login feito com sucesso.';
    }
}



async function prepara_login_de_usuario(params) {
    let username = document.getElementById('inputUser').value;
    let senha    = document.getElementById('inputSenha').value;

    const mensagem = await login_de_usuario(username, senha);

    if (mensagem === 'Login feito com sucesso.'){
        document.getElementById('inputUser').value = '';
        document.getElementById('inputSenha').value = '';
        alert(mensagem);
        window.location.assign(window.location.origin + `/home`);
    } else {
        alert(mensagem);
    }
}



async function cadastro_de_item(foto, descricao, nome, usuario_id){
    let objeto = new URLSearchParams();
    objeto.append('tipo','cadastro_de_item');

    objeto.append('foto',foto);
    objeto.append('descricao',descricao);
    objeto.append('nome',nome);
    objeto.append('usuario_id',usuario_id);

    minha_resposta = await send_to_php(objeto);

    mensagem = ""
    if(minha_resposta['status'] == 'ERROR'){
        console.log(minha_resposta['error']);
        mensagem = minha_resposta['error']
    } else {
        console.log('Cadastro feito com sucesso.');
        mensagem = 'Cadastro feito com sucesso.'
    }
    return mensagem
}



async function prepara_cadastro_de_item(params) {
    let foto       = document.getElementById('inputFoto').value;
    let descricao  = document.getElementById('inputDescricao').value;
    let nome       = document.getElementById('inputNome').value;
    let usuario_id = document.getElementById('inputUsuario_id').value;

    const mensagem = await cadastro_de_item(foto, descricao, nome, usuario_id);

    if (mensagem === 'Cadastro feito com sucesso.'){
        document.getElementById('inputFoto').value = '';
        document.getElementById('inputDescricao').value = '';
        document.getElementById('inputNome').value = '';
        document.getElementById('inputUsuario_id').value = '';
    }
    alert(mensagem);
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
            const errorText = await res.text(); 
            return { 
                'status': 'ERROR', 
                'error': `Erro ${res.status} (${res.statusText}): ${errorText || 'Sem detalhes adicionais'}`
            };
        }
        return await res.json();
    } catch (error) {
        return { 'status': 'ERROR', 'error': `Erro interno do PHP no processamento dos dados - ${error}` };
    }
}