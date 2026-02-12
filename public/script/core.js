const route = window.location.pathname;
const params = new URLSearchParams(window.location.search);



document.addEventListener('DOMContentLoaded', () => {
    const inputFotos = document.getElementById('inputFotos');
    const previewContainer = document.getElementById('preview-container');

    if (inputFotos) {
        inputFotos.addEventListener('change', function() {
            previewContainer.innerHTML = '';
            if (this.files.length > 5) {
                alert("Você só pode selecionar no máximo 5 imagens.");
                this.value = "";
                return;
            }
            if (this.files) {
                Array.from(this.files).forEach(file => {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const imgDiv = document.createElement('div');
                        imgDiv.className = 'preview-item';
                        imgDiv.style = "width: 80px; height: 80px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden;";
                        imgDiv.innerHTML = `<img src="${e.target.result}" title="${file.name}" style="width: 100%; height: 100%; object-fit: cover;">`;
                        previewContainer.appendChild(imgDiv);
                    }
                    reader.readAsDataURL(file);
                });
            }
        });
    }
});



async function logout(){
    let objeto = new URLSearchParams();
    objeto.append('tipo','logout');
    minha_resposta = await send_to_php(objeto);
    if(minha_resposta['status'] !== 'ERROR') {
        alert(`Desconectado de ${minha_resposta['username']}.`);
        localStorage.removeItem('username')
        window.location.assign(window.location.origin + `/home`);
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



async function prepara_login_de_usuario() {
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
            window.location.assign(window.location.origin + `/item`);

        } catch (error) {
            alert("Erro na requisição de inserção de fotos:", error);
        }
    } else {
        alert(mensagem['error']);
    }
}



async function cadastro_de_anuncio(nome, descricao, tipo, valor, itemId, enderecoOrdem) {
    let objeto = new URLSearchParams();
    objeto.append('tipo', 'cadastro_de_anuncio');
    objeto.append('nome', nome);
    objeto.append('descricao', descricao);
    objeto.append('tipo_anuncio', tipo);
    objeto.append('valor', valor);
    objeto.append('item_id', itemId);
    objeto.append('endereco_ordem', enderecoOrdem);

    const minha_resposta = await send_to_php(objeto);

    if (minha_resposta['status'] === 'ERROR') {
        return minha_resposta['error'];
    } else {
        return 'OK';
    }
}



async function prepara_cadastro_de_anuncio() {
    const nome      = document.getElementById('inputNome').value;
    const descricao = document.getElementById('inputDescricao').value;
    const tipo      = document.getElementById('inputTipo').value;
    const itemId    = document.getElementById('inputItem').value;
    const endereco  = document.getElementById('inputEndereco').value;
    const rawValor  = document.getElementById('inputValor').value;

    if (!nome || !tipo || !itemId || !endereco) {
        alert("Preencha todos os campos, incluindo o endereço.");
        return;
    }
    let valorLimpo = "0.00";
    if (tipo !== 'Troca' && rawValor) {
        valorLimpo = rawValor.replace("R$ ", "").replace(/\./g, "").replace(",", ".");
    }
    const resultado = await cadastro_de_anuncio(nome, descricao, tipo, valorLimpo, itemId, endereco);

    if (resultado === 'OK') {
        alert("Anúncio cadastrado com sucesso!");
        window.location.assign(window.location.origin + "/anuncio");
    } else {
        alert("Erro ao cadastrar: " + resultado);
    }
}



async function cadastro_de_endereco(dados) {
    let objeto = new URLSearchParams();
    objeto.append('tipo', 'cadastro_de_endereco');
    objeto.append('pais', dados.pais);
    objeto.append('cep', dados.cep);
    objeto.append('estado', dados.estado);
    objeto.append('cidade', dados.cidade);
    objeto.append('bairro', dados.bairro);
    objeto.append('logradouro', dados.logradouro);
    objeto.append('numero', dados.numero);
    objeto.append('complemento', dados.complemento);

    const minha_resposta = await send_to_php(objeto);

    if (minha_resposta['status'] === 'ERROR') {
        return minha_resposta['error'];
    } else {
        return 'OK';
    }
}



async function prepara_cadastro_de_endereco() {
    const dados = {
        pais:        document.getElementById('inputPais').value,
        cep:         document.getElementById('inputCEP').value,
        estado:      document.getElementById('inputEstado').value,
        cidade:      document.getElementById('inputCidade').value,
        bairro:      document.getElementById('inputBairro').value,
        logradouro:  document.getElementById('inputLogradouro').value,
        numero:      document.getElementById('inputNumero').value,
        complemento: document.getElementById('inputComplemento').value
    };

    if (!dados.pais || !dados.cep || !dados.cidade || !dados.logradouro || !dados.bairro) {
        alert("Por favor, preencha os campos obrigatórios (País, CEP, Cidade, Bairro e Logradouro).");
        return;
    }
    const resultado = await cadastro_de_endereco(dados);

    if (resultado === 'OK') {
        alert("Endereço cadastrado com sucesso!");
        window.location.assign(window.location.origin + "/endereco");
    } else {
        alert("Erro ao cadastrar: " + resultado);
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



async function carregarImagens(itemId) {
    const placeholder = document.getElementById('imgPlaceholder');
    let params = new URLSearchParams();
    params.append('tipo', 'listar_fotos_item');
    params.append('id', itemId);

    const res = await send_to_php(params);

    if (res.status === 'OK' && res.fotos.length > 0) {
        placeholder.innerHTML = ''; 
        res.fotos.forEach(foto => {
            const img = document.createElement('img');
            img.src = `public/items/i${itemId}/${foto}`;
            
            Object.assign(img.style, {
                width: '120px',
                height: '120px',
                objectFit: 'cover',
                borderRadius: '10px',
                border: '2px solid #eee',
                cursor: 'pointer',
                transition: 'transform 0.2s'
            });

            img.onmouseover = () => img.style.transform = 'scale(1.05)';
            img.onmouseout = () => img.style.transform = 'scale(1)';
            img.onclick = () => window.open(img.src, '_blank');
            
            placeholder.appendChild(img);
        });
    } else {
        placeholder.innerHTML = '<p style="color: #666; font-style: italic;">Nenhuma imagem disponível para este item.</p>';
    }
}



async function abrirPopupDetalhes(id, tipoContexto) {
    let params = new URLSearchParams();
    params.append('tipo', 'obter_detalhes_item');
    params.append('id', id);
    params.append('contexto', tipoContexto);

    const res = await send_to_php(params);

    if (res.status === 'OK') {
        const item = res.data[0];
        renderizarModal(item);
    } else {
        alert("Erro ao carregar detalhes: " + res.error);
    }
}



function renderizarModal(item) {
    const overlay = document.createElement('div');
    overlay.id = 'modalOverlay';
    Object.assign(overlay.style, {
        position: 'fixed', top: '0', left: '0', width: '100vw', height: '100vh',
        backgroundColor: 'rgba(0, 0, 0, 0.8)', display: 'flex', justifyContent: 'center',
        alignItems: 'center', zIndex: '3000', backdropFilter: 'blur(5px)'
    });

    overlay.innerHTML = `
        <div class="modalContainer" style="background: white; width: 85%; max-width: 700px; min-width: 300px; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5); animation: modalFadeIn 0.3s ease;">
            <div class="modalHeader" style="background: var(--header-c); color: white; padding: 20px; display: flex; justify-content: space-between; align-items: center;">
                <h2 style="margin: 0; font-size: 1.5rem;">${item.nome}</h2>
                <span class="closeBtn" onclick="fecharModal()" style="cursor: pointer; font-size: 30px; font-weight: bold;">&times;</span>
            </div>
            <div class="modalBody" style="padding: 25px; font-family: 'Prompt'; color: #333; max-height: 80vh; overflow-y: auto;">
                <div class="modalInfo" style="margin-bottom: 20px; line-height: 1.6;">
                    <p style="margin: 10px 0;"><strong>Descrição:</strong> ${item.descricao}</p>
                    <p style="margin: 10px 0;"><strong>Tipo:</strong> <span style="color: var(--header-c); font-weight: bold;">${item.estoque !== undefined ? 'Novo' : 'Usado'}</span></p>
                    ${item.estoque !== undefined ? `<p><strong>Estoque:</strong> ${item.estoque}</p>` : ''}
                    ${item.status_nome ? `<p><strong>Condição:</strong> ${item.status_nome}</p>` : ''}
                </div>
                <div class="modalGallery">
                    <p><strong>Galeria de Imagens:</strong></p>
                    <div id="imgPlaceholder" style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px; justify-content: flex-start;">
                        <p style="font-size: 14px; color: #999;">Buscando fotos...</p>
                    </div>
                </div>
            </div>
        </div>
    `;

    document.body.appendChild(overlay);
    document.body.style.overflow = 'hidden';
    carregarImagens(item.id);
}



function fecharModal() {
    const modal = document.getElementById('modalOverlay');
    if (modal) {
        modal.remove();
        document.body.style.overflow = 'auto';
    }
}



async function verDetalhes_IN(id) {
    await abrirPopupDetalhes(id, 'Novo');
}



async function verDetalhes_IU(id) {
    await abrirPopupDetalhes(id, 'Usado');
}



async function verDetalhes_Anuncio(id) {
    let params = new URLSearchParams();
    params.append('tipo', 'obter_detalhes_anuncio');
    params.append('id', id);

    const res = await send_to_php(params);

    if (res.status === 'OK') {
        const ad = res.data[0];
        
        const adParaModal = {
            id: ad.item_id,
            nome: ad.nome,
            descricao: `${ad.descricao}
                <div style="margin-bottom: 10px;"><strong>Item:</strong> ${ad.item_nome}</div>
                <div style="margin-top: 15px; border-top: 1px solid #eee; pt-10px;">
                    <div style="margin-top: 10px;"><strong>Local de Retirada:</strong></div>
                    <div>${ad.logradouro}, ${ad.numero} - ${ad.bairro}</div>
                    <div>${ad.cidade} / ${ad.pais || ''}</div>
                </div>
            `,
            status_nome: ad.tipo_nome
        };

        if (ad.item_descricao && ad.item_descricao.toLowerCase().includes('novo')) {
            adParaModal.estoque = "Disponível"; 
        }

        renderizarModal(adParaModal);
    } else {
        alert("Erro ao carregar detalhes do anúncio.");
    }
}



window.onclick = function(event) {
    const overlay = document.getElementById('modalOverlay');
    if (event.target == overlay) fecharModal();
}


document.addEventListener('DOMContentLoaded', () => {
    switch (route) {
        case "/home": {
            document.title = `EcoShare - Home`;
            break;
        }
        case "/login": {
            document.title = `EcoShare - Login`;
            break;
        }
        case "/cadastro": {
            document.title = `EcoShare - Cadastro`;
            break;
        }
        case "/item": {
            document.title = `EcoShare - Gerenciar Itens`;
            let content = document.getElementById('content');
            let itemList = document.createElement('div');
            itemList.classList.add('itemList');
            itemList.innerHTML += `<h2>Lista de Itens</h2>`;

            let itensNovos; let itensUsados;
            (async () => {
                let usados = new URLSearchParams();
                usados.append('tipo', 'buscar_itens_usados_do_usuario');
                itensUsados = await send_to_php(usados);

                let novos = new URLSearchParams();
                novos.append('tipo', 'buscar_itens_novos_do_usuario');
                itensNovos = await send_to_php(novos);

                if(itensNovos.status === 'OK' && itensUsados.status === 'OK' && itensNovos.data.length+itensUsados.data.length > 0){
                    for(let i = 0; i < itensNovos.data.length; i++){
                        let item = itensNovos.data[i];
                        itemList.innerHTML += `
                        <div class="itemBox">
                            <div class="itemUnitA">${item.nome}</div>
                            <button class="itemUnitB" onclick="verDetalhes_IN(${item.id})">Ver Detalhes</button>
                            <!--button class="itemUnitB" onclick="editarDetalhes_IN(${item.id})">Editar Detalhes</button-->
                        </div>`;
                    }
                    for(let i = 0; i < itensUsados.data.length; i++){
                        let item = itensUsados.data[i];
                        itemList.innerHTML += `
                        <div class="itemBox">
                            <div class="itemUnitA">${item.nome}</div>
                            <button class="itemUnitB" onclick="verDetalhes_IU(${item.id})">Ver Detalhes</button>
                            <!--button class="itemUnitB" onclick="editarDetalhes_IU(${item.id})">Editar Detalhes</button-->
                        </div>`;
                    }
                    document.getElementById('content').prepend(itemList);
                }
            })();
            break;
        }
        case "/anuncio": {
            document.title = `EcoShare - Gerenciar Anúncios`;
            let content = document.getElementById('content');
            let anuncioList = document.createElement('div');
            anuncioList.classList.add('itemList');
            anuncioList.innerHTML += `<h2>Meus Anúncios Ativos</h2>`;

            (async () => {
                let paramsAnuncio = new URLSearchParams();
                paramsAnuncio.append('tipo', 'listar_anuncios_usuario');
                let resAnuncios = await send_to_php(paramsAnuncio);
                console.log(resAnuncios);

                if (resAnuncios.status === 'OK' && resAnuncios.data.length > 0) {
                    resAnuncios.data.forEach(anuncio => {
                        let valorFormatado = (anuncio.valor_anuncio > 0) 
                            ? `R$ ${parseFloat(anuncio.valor_anuncio).toLocaleString('pt-BR', {minimumFractionDigits: 2})}` 
                            : "Sem Valor";

                        anuncioList.innerHTML += `
                        <div class="itemBox">
                            <div class="itemUnitA">
                                <span style="color: var(--header-c); font-weight: bold;">[${anuncio.tipo_nome}]&nbsp;</span> 
                                <strong>${anuncio.nome}</strong>&nbsp;-&nbsp;${valorFormatado}
                                <br>
                                <small style="color: #666;">&nbsp;-&nbsp;Publicado em: ${anuncio.data_anuncio}</small>
                            </div>
                            <button class="itemUnitB" onclick="verDetalhes_Anuncio(${anuncio.id})">Ver Detalhes</button>
                        </div>`;
                    });
                    content.prepend(anuncioList);
                }

                let novos = new URLSearchParams();
                novos.append('tipo', 'buscar_itens_novos_do_usuario');
                let resNovos = await send_to_php(novos);

                let usados = new URLSearchParams();
                usados.append('tipo', 'buscar_itens_usados_do_usuario');
                let resUsados = await send_to_php(usados);

                const inputItem = document.getElementById('inputItem');
                const popularItens = (res) => {
                    if (res.status === 'OK') {
                        res.data.forEach(item => {
                            let opt = document.createElement('option');
                            opt.value = item.id;
                            opt.innerHTML = item.nome;
                            inputItem.appendChild(opt);
                        });
                    }
                };
                popularItens(resNovos);
                popularItens(resUsados);

                let paramsEnd = new URLSearchParams();
                paramsEnd.append('tipo', 'listar_enderecos_usuario');
                let resEnd = await send_to_php(paramsEnd);

                const inputEndereco = document.getElementById('inputEndereco');
                if (resEnd.status === 'OK' && resEnd.data.length > 0) {
                    resEnd.data.forEach(end => {
                        let opt = document.createElement('option');
                        opt.value = end.endereco_ordem; 
                        opt.innerHTML = `${end.logradouro}, ${end.numero} - ${end.bairro}`;
                        inputEndereco.appendChild(opt);
                    });
                }
            })();
            break;
        }
        case "/endereco": {
            document.title = `EcoShare - Gerenciar Endereços`;
            let content = document.getElementById('content');
            let enderecoList = document.createElement('div');
            enderecoList.classList.add('itemList');
            enderecoList.innerHTML = `<h2>Meus Endereços</h2>`;

            (async () => {
                let params = new URLSearchParams();
                params.append('tipo', 'listar_enderecos_usuario');
                let res = await send_to_php(params);
                if (res.status === 'OK' && res.data.length > 0) {
                    res.data.forEach(end => {
                        enderecoList.innerHTML += `
                        <div class="itemBox">
                            <div class="itemUnitA">
                                <strong>Endereço ${end.endereco_ordem}:&nbsp;</strong> ${end.logradouro}, ${end.numero}, ${end.bairro}. ${end.complemento}. ${end.cidade} - ${end.estado} - ${end.pais}
                            </div>
                        </div>`;
                    });
                    content.prepend(enderecoList);
                }
            })();
            break;
        }
    }
});