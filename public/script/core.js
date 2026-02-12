const route = window.location.pathname;
const params = new URLSearchParams(window.location.search);



async function logout(){
    let objeto = new URLSearchParams();
    objeto.append('tipo','logout');
    minha_resposta = await send_to_php(objeto);
    if(minha_resposta['status'] !== 'ERROR'){
        alert(`Desconectado de ${minha_resposta['username']}.`);
        localStorage.removeItem('username')
        window.location.pathname = '/login';
    } else {
        alert(minha_resposta['error']);
    }
}



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



async function prepara_cadastro_de_usuario() {
    let username = document.getElementById('inputUser').value;
    let email    = document.getElementById('inputEmail').value;
    let senha    = document.getElementById('inputSenha').value;
    let nome     = document.getElementById('inputNome').value;
    let doc      = document.getElementById('inputDoc').value;
    let docType  = document.getElementById('inputDocType').value;

    const mensagem = await cadastro_de_usuario(username, nome, email, doc, docType, senha);

    if (mensagem === 'Cadastro feito com sucesso.'){
        await login_de_usuario(username, senha);

        //alert(mensagem);
        window.location.assign(window.location.origin + `/home`);

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

    if(minha_resposta['status'] == 'ERROR') {
        return minha_resposta['error'];
    } else {
        localStorage.setItem('username', username);
        return 'Login feito com sucesso.';
    }
}



async function prepara_login_de_usuario(params) {
    let username = document.getElementById('inputUser').value;
    let senha    = document.getElementById('inputSenha').value;

    const mensagem = await login_de_usuario(username, senha);

    if (mensagem === 'Login feito com sucesso.') {
        document.getElementById('inputUser').value = '';
        document.getElementById('inputSenha').value = '';
        alert(mensagem);
        window.location.assign(window.location.origin + `/home`);
    } else {
        alert(mensagem);
    }
}



async function cadastro_de_item(descricao, nome, tipo){
    let objeto = new URLSearchParams();
    objeto.append('tipo','cadastro_de_item');

    objeto.append('descricao',descricao);
    objeto.append('nome',nome);
    objeto.append('tipo_item',tipo);

    minha_resposta = await send_to_php(objeto);
   
    if(minha_resposta['status'] == 'ERROR'){
        return minha_resposta;
    } else {
        return {'status': 'OK', 'msg': 'Cadastro feito com sucesso.', 'id': minha_resposta['id']};
    }
}


async function prepara_cadastro_de_item() {
    let tipo       = document.getElementById('inputItemType').value
    let descricao  = document.getElementById('inputDescricao').value;
    let nome       = document.getElementById('inputNome').value;
    let inputFotos = document.getElementById('inputFotos');

    // Validação dos campos
    if (inputFotos.files.length === 0) {
        alert("Selecione pelo menos uma imagem do seu item.");
        return;
    }

    let formData = new FormData();
    formData.append('tipo', 'validacao_de_foto');
    for (let i = 0; i < inputFotos.files.length; i++) {
        formData.append('fotos[]', inputFotos.files[i]);
    }

    let arquivos, hashValidade;
    try {
        const res = await fetch('index.php', {
            method: 'POST',
            body: formData
        });
        if (!res.ok) {
            const errorText = await res.text();
            alert(`Erro ${res.status} (${res.statusText}): ${errorText || 'Sem detalhes adicionais'}`);
            return;
        }
        let result = await res.json();

        if (result['status'] !== 'OK') {
            alert("Erro: " + result['error']);
            return;
        }
        hashValidade = result['hash'];
        arquivos = result['arquivos_validos'];
    } catch (error) {
        console.error("Erro na validação das fotos:", error);
    }

    const mensagem = await cadastro_de_item(descricao, nome, tipo);

    if (mensagem['status'] === 'OK'){
        let imgData = new FormData();
        imgData.append('tipo','insercao_de_foto');
        imgData.append('hash',hashValidade);
        imgData.append('id',mensagem['id']);
        for(let i = 0; i < inputFotos.files.length; i++){
            const arquivoAtual = inputFotos.files[i];
            if (arquivos.includes(arquivoAtual.name)) {
                imgData.append('fotos[]', arquivoAtual);
            }
        }
        try {
            const res = await fetch('index.php', {
                method: 'POST',
                body: imgData
            });
            if (!res.ok) {
                const errorText = await res.text();
                alert(`Erro ${res.status} (${res.statusText}): ${errorText || 'Sem detalhes adicionais'}`);
                return;
            }
            let result = await res.json();
            if (result['status'] !== 'OK') {
                alert("Erro: " + result['error']);
                return;
            }
            alert("Item cadastrado com sucesso.")
            document.getElementById('inputDescricao').value = '';
            document.getElementById('inputNome').value = '';
            document.getElementById('inputItemType').value = '';
        } catch (error) {
            alert("Erro na requisição de inserção de fotos:", error);
        }
    } else {
        alert(mensagem['error']);
    }
}


async function send_to_php(objc) {
    // Função que envia requests genéricas pro PHP. Lá dentro, faz limpeza dos campos e retorna um .json com o que vc quer. Isso vira um objeto js
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



document.addEventListener('click', function(event) {
    const container = document.getElementById('userContainer');
    const dropdown = document.getElementById('userDropdown');
    const trigger = document.getElementById('userTrigger');
    const logicMenu = document.getElementById('logicMenu');

    if (trigger.contains(event.target)) {
        dropdown.classList.toggle('active');

        if (dropdown.classList.contains('active')) {
            logicMenu.checked = false;
        }
    } 

    else if (!container.contains(event.target)) {
        dropdown.classList.remove('active');
    }
    
    if (event.target.id === 'logicMenu' && event.target.checked) {
        dropdown.classList.remove('active');
    }
});



document.addEventListener('DOMContentLoaded', () => {
    const nomeDoUsuario = localStorage.getItem('username');
    const label = document.querySelector('.user-name-label');

    if (label) { 
        if (nomeDoUsuario && nomeDoUsuario !== "undefined") {
            label.textContent = `Olá, ${nomeDoUsuario}`;
        } else {
            label.textContent = "Olá!"; 
        }
    }
});