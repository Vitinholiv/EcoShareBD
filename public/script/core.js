const route = window.location.pathname;
const params = new URLSearchParams(window.location.search);

function redirect(path){
    if (path.includes('?')) {
        window.location.href = window.location.origin + '/' + path;
    } else {
        window.location.href = window.location.origin + '/' + path.replace(/^\//, '');
    }
}

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
        redirect('home');
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

        redirect('home');
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
        redirect('home');
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
            redirect('item');

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
        redirect('anuncio');
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
        redirect('endereco');
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

    if (trigger && trigger.contains(event.target)) {
        dropdown.classList.toggle('active');
        if (dropdown.classList.contains('active') && logicMenu) {
            logicMenu.checked = false;
        }
    } 
    else if (container && !container.contains(event.target)) {
        if (dropdown) dropdown.classList.remove('active');
    }
    
    if (event.target.id === 'logicMenu' && event.target.checked) {
        if (dropdown) dropdown.classList.remove('active');
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
                ${item.descricao}
                <div class="modalGallery" style="margin-top: 20px;">
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



async function excluirAnuncio(id) {
    if (!confirm("Tem certeza que deseja apagar este anúncio? Esta ação não pode ser desfeita.")) return;

    let params = new URLSearchParams();
    params.append('tipo', 'excluir_anuncio');
    params.append('id', id);

    const res = await send_to_php(params);
    if (res.status === 'OK') {
        alert("Anúncio removido com sucesso.");
        location.reload();
    } else {
        alert("Erro ao excluir: " + res.error);
    }
}



async function carregarFeedHome(termoBusca = null) {
    const content = document.getElementById('content');
    if (!content) return;

    if (termoBusca === null) {
        const urlParams = new URLSearchParams(window.location.search);
        termoBusca = urlParams.get('q') || '';
        const searchInput = document.getElementById('mainSearch');
        if(searchInput && termoBusca) searchInput.value = termoBusca;
    }

    content.innerHTML = `<h2 style="margin: 20px 0 -25px 0;">${termoBusca ? 'Resultados para: ' + termoBusca : 'Explorar Ofertas'}</h2>`;
    const grid = document.createElement('div');
    grid.className = 'anuncio-grid';
    content.appendChild(grid);

    let params = new URLSearchParams();
    params.append('tipo', 'buscar_anuncios_feed');
    params.append('busca', termoBusca);

    const res = await send_to_php(params);

    if (res.status === 'OK' && res.data.length > 0) {
        for (const ad of res.data) {
            const card = document.createElement('div');
            card.className = 'anuncio-card';
            
            const valor = (ad.tipo_nome === 'Troca') 
                ? "Troca" 
                : (ad.valor_anuncio > 0 
                    ? `R$ ${parseFloat(ad.valor_anuncio).toLocaleString('pt-BR', {minimumFractionDigits: 2})}`
                    : "Doação");

            const fotoRes = await send_to_php(new URLSearchParams(`tipo=listar_fotos_item&id=${ad.item_id}`));
            const fotoUrl = (fotoRes.status === 'OK' && fotoRes.fotos.length > 0)
                ? `/public/items/i${ad.item_id}/${fotoRes.fotos[0]}`
                : '/public/res/logo.png';

            card.innerHTML = `
                <div class="card-img" style="background-image: url('${fotoUrl}'); height: 160px; background-size: cover; background-position: center; border-radius: 8px 8px 0 0;"></div>
                <div class="card-info" style="padding: 15px;">
                    <span style="font-size: 10px; text-transform: uppercase; color: var(--header-c); font-weight: bold;">${ad.tipo_nome}</span>
                    <h3 style="margin: 5px 0; font-size: 1.1rem; color: #333; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${ad.ad_nome}</h3>
                    <p style="font-size: 1.2rem; font-weight: bold; color: #2e7d32; margin: 0;">${valor}</p>
                    <small style="color: #777;">${ad.cidade} - ${ad.estado}</small>
                </div>
            `;
            
            card.onclick = () => verDetalhes_Feed(ad);
            grid.appendChild(card);
        }
    } else {
        grid.innerHTML = `<p style="grid-column: 1/-1; text-align: center; color: #999; padding: 40px;">Nenhum anúncio encontrado para sua busca.</p>`;
    }
}



function realizarBusca() {
    const input = document.getElementById('mainSearch');
    if (!input) return;
    const termoOriginal = input.value;
    const termoLimpo = termoOriginal.replace(/[^a-zA-Z0-9\u00C0-\u00FF\s]/g, '');
    if (window.location.pathname !== '/home' && window.location.pathname !== '/') {
        redirect(`home?q=${encodeURIComponent(termoLimpo)}`);
    } else {
        carregarFeedHome(termoLimpo);
    }
}



async function aceitarProposta(id) {
    // Busca as formas de pagamento para o select
    let resPag = await send_to_php(new URLSearchParams("tipo=listar_formas_pagamento"));
    let opcoesPag = '';
    if (resPag.status === 'OK') {
        resPag.data.forEach(f => opcoesPag += `<option value="${f.id}">${f.forma}</option>`);
    }

    const overlay = document.createElement('div');
    overlay.id = 'modalAceite';
    Object.assign(overlay.style, {
        position: 'fixed', top: '0', left: '0', width: '100vw', height: '100vh',
        backgroundColor: 'rgba(0, 0, 0, 0.8)', display: 'flex', justifyContent: 'center',
        alignItems: 'center', zIndex: '5000', backdropFilter: 'blur(5px)'
    });

    overlay.innerHTML = `
        <div style="background: white; width: 90%; max-width: 400px; border-radius: 20px; overflow: hidden; font-family: 'Prompt';">
            <div style="background: #2e7d32; color: white; padding: 20px; font-weight: bold;">
                Finalizar Negócio
            </div>
            <div style="padding: 20px;">
                <label>Forma de Pagamento Final:</label>
                <select id="finalPagamento" style="width: 100%; padding: 10px; margin: 10px 0 20px 0; border-radius: 8px; border: 1px solid #ddd;">
                    ${opcoesPag}
                </select>

                <div id="containerDataEmprestimo" style="display:none;">
                    <label>Data de Devolução Prevista:</label>
                    <input type="date" id="finalDataDevolucao" style="width: 100%; padding: 10px; margin: 10px 0 20px 0; border-radius: 8px; border: 1px solid #ddd;">
                </div>

                <div style="display: flex; gap: 10px;">
                    <button onclick="document.getElementById('modalAceite').remove()" style="flex: 1; padding: 12px; border-radius: 8px; border: 1px solid #ccc; cursor: pointer;">Cancelar</button>
                    <button id="btnConfirmarAceite" style="flex: 1; padding: 12px; border-radius: 8px; border: none; background: #2e7d32; color: white; font-weight: bold; cursor: pointer;">Confirmar</button>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(overlay);

    // Lógica para mostrar data apenas se for empréstimo (verificamos isso via PHP ou pelo texto da página)
    // Aqui vamos buscar um dado rápido para saber o tipo de anúncio
    let info = await send_to_php(new URLSearchParams(`tipo=verificar_tipo_proposta&id=${id}`));
    if(info.tipo_anuncio == 3) { // 3 = Empréstimo
        document.getElementById('containerDataEmprestimo').style.display = 'block';
    }

    document.getElementById('btnConfirmarAceite').onclick = async () => {
        const pagId = document.getElementById('finalPagamento').value;
        const dataDev = document.getElementById('finalDataDevolucao').value;

        let p = new URLSearchParams();
        p.append('tipo', 'confirmar_aceite_proposta');
        p.append('proposta_id', id);
        p.append('forma_pagamento_id', pagId);
        p.append('data_devolucao', dataDev);

        const res = await send_to_php(p);
        if(res.status === 'OK') {
            alert("Negócio fechado e registro gerado!");
            location.reload();
        } else {
            alert("Erro: " + res.error);
        }
    };
}



async function verDetalhes_Feed(ad) {
    const exibicaoPreco = (ad.tipo_nome === 'Troca') ? "Troca" : `R$ ${parseFloat(ad.valor_anuncio).toLocaleString('pt-BR', {minimumFractionDigits: 2})}`;
    const modalData = {
        id: ad.item_id,
        nome: ad.ad_nome,
        descricao: `
            <div style="margin-bottom: 10px; line-height: 1.6;">
                <div style="margin-bottom: 10px;">${ad.ad_descricao || 'Sem descrição detalhada.'}</div>
                <div style="margin-bottom: 15px; padding: 10px; background: #f9f9f9; border-radius: 8px; border-left: 4px solid var(--header-c);">
                    <strong>Descrição do Item:</strong><br>
                    ${ad.item_descricao || 'Sem detalhes do item.'}
                </div>
                <div style="margin-bottom: 10px;"><strong>Valor:</strong> ${exibicaoPreco}</div>
                <div style="margin-bottom: 10px;"><strong>Vendedor:</strong> ${ad.vendedor_nome}</div>
                <div style="margin-bottom: 10px;"><strong>Localização:</strong> ${ad.cidade} - ${ad.estado}, ${ad.pais}</div>
                <div style="margin-top: 15px; border-top: 1px solid #eee; padding-top: 10px;">
                    <p><strong>E-mail:</strong> ${ad.vendedor_email}</p>
                    <p><strong>Telefone:</strong> ${ad.vendedor_telefone || 'Não informado'}</p>
                </div>
                <button onclick='abrirPopupNegociar(${JSON.stringify(ad).replace(/'/g, "&apos;")})' 
                        style="width: 100%; margin-top: 15px; background: #1a4a31; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: bold; cursor: pointer;">
                    Negociar
                </button>
            </div>
        `,
        status_nome: ad.tipo_nome
    };
    renderizarModal(modalData);
}



async function verDetalhes_IN(id) {
    let params = new URLSearchParams();
    params.append('tipo', 'obter_detalhes_item');
    params.append('id', id);
    params.append('contexto', 'Novo');

    const res = await send_to_php(params);
    if (res.status === 'OK') {
        const item = res.data[0];
        const itemParaModal = {
            id: item.id,
            nome: item.nome,
            descricao: `
                <div style="margin-bottom: 10px; line-height: 1.6;">
                    <p style="margin: 10px 0;"><strong>Descrição:</strong> ${item.descricao}</p>
                    <p style="margin: 10px 0;"><strong>Tipo:</strong> <span style="color: var(--header-c); font-weight: bold;">Novo</span></p>
                    <p><strong>Estoque:</strong> ${item.estoque}</p>
                </div>
            `
        };
        renderizarModal(itemParaModal);
    }
}



async function verDetalhes_IU(id) {
    let params = new URLSearchParams();
    params.append('tipo', 'obter_detalhes_item');
    params.append('id', id);
    params.append('contexto', 'Usado');

    const res = await send_to_php(params);
    if (res.status === 'OK') {
        const item = res.data[0];
        const itemParaModal = {
            id: item.id,
            nome: item.nome,
            descricao: `
                <div style="margin-bottom: 10px; line-height: 1.6;">
                    <p style="margin: 10px 0;"><strong>Descrição:</strong> ${item.descricao}</p>
                    <p style="margin: 10px 0;"><strong>Tipo:</strong> <span style="color: var(--header-c); font-weight: bold;">Usado</span></p>
                    <p><strong>Condição:</strong> ${item.status_nome}</p>
                </div>
            `
        };
        renderizarModal(itemParaModal);
    }
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
            descricao: `
                <div style="margin-bottom: 10px; line-height: 1.6;">
                    <div style="margin-bottom: 10px;">${ad.descricao}</div>
                    <div style="margin-bottom: 15px; padding: 10px; background: #f9f9f9; border-radius: 8px; border-left: 4px solid var(--header-c);">
                        <strong>Descrição do Item:</strong><br>
                        ${ad.item_descricao || 'Sem detalhes do item.'}
                    </div>
                    <div style="margin-bottom: 10px;"><strong>Item:</strong> ${ad.item_nome}</div>
                    <div style="margin-top: 15px; border-top: 1px solid #eee; padding-top: 10px;">
                        <div style="margin-top: 10px;"><strong>Local de Retirada:</strong></div>
                        <div>${ad.logradouro}, ${ad.numero} - ${ad.bairro}</div>
                        <div>${ad.cidade} / ${ad.pais || ''}</div>
                    </div>
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



async function abrirPopupNegociar(ad) {
    fecharModal();
    
    // Busca os dois tipos de itens para garantir que a lista seja populada
    let resUsados = await send_to_php(new URLSearchParams("tipo=buscar_itens_usados_do_usuario"));
    let resNovos = await send_to_php(new URLSearchParams("tipo=buscar_itens_novos_do_usuario"));
    
    let opcoesItens = '<option value="">Selecione um item (opcional)</option>';
    
    if (resUsados.status === 'OK') {
        resUsados.data.forEach(i => opcoesItens += `<option value="${i.id}">${i.nome} (Usado)</option>`);
    }
    if (resNovos.status === 'OK') {
        resNovos.data.forEach(i => opcoesItens += `<option value="${i.id}">${i.nome} (Novo)</option>`);
    }

    const overlay = document.createElement('div');
    overlay.id = 'modalOverlay';
    Object.assign(overlay.style, {
        position: 'fixed', top: '0', left: '0', width: '100vw', height: '100vh',
        backgroundColor: 'rgba(0, 0, 0, 0.8)', display: 'flex', justifyContent: 'center',
        alignItems: 'center', zIndex: '4000', backdropFilter: 'blur(5px)'
    });

    overlay.innerHTML = `
        <div class="modalContainer" style="background: white; width: 90%; max-width: 500px; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
            <div style="background: #2e4d2e; color: white; padding: 20px; display: flex; justify-content: space-between;">
                <h2 style="margin: 0; font-size: 1.2rem;">Enviar Proposta para ${ad.ad_nome || ad.nome}</h2>
                <span class="closeBtn" onclick="fecharModal()" style="cursor: pointer; font-size: 25px;">&times;</span>
            </div>
            <div style="padding: 25px; font-family: 'Prompt';">
                <label>Sua mensagem:</label>
                <textarea id="propTexto" style="width: 100%; height: 80px; margin-bottom: 15px; border-radius: 8px; border: 1px solid #ddd; padding: 10px;"></textarea>
                
                <label>Valor em R$:</label>
                <input type="text" id="propValor" placeholder="R$ 0,00" style="width: 100%; margin-bottom: 15px; padding: 10px; border-radius: 8px; border: 1px solid #ddd;">

                ${ad.tipo_nome === 'Troca' ? `
                    <label>Oferecer Item na Troca:</label>
                    <select id="propItem" style="width: 100%; margin-bottom: 15px; padding: 10px; border-radius: 8px; border: 1px solid #ddd;">
                        ${opcoesItens}
                    </select>
                ` : ''}

                <button onclick="confirmarProposta(${ad.id})" style="width: 100%; background: #76a05d; color: white; border: none; padding: 15px; border-radius: 12px; font-weight: bold; cursor: pointer;">
                    Confirmar Envio
                </button>
            </div>
        </div>
    `;
    document.body.appendChild(overlay);

    const propValor = document.getElementById('propValor');
    if (propValor) {
        propValor.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            const limiteCentavos = 100000000000;
            if (parseInt(value) > limiteCentavos) value = limiteCentavos.toString();
            
            value = (value / 100).toFixed(2);
            if (value === "0.00" && e.target.value.length < 3) {
                e.target.value = '';
                return;
            }
            let formatted = value.replace(".", ",");
            formatted = formatted.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.");
            e.target.value = 'R$ ' + formatted;
        });

        propValor.addEventListener('click', function() {
            if (this.value.length > 0) {
                this.setSelectionRange(this.value.length, this.value.length);
            }
        });
    }
}



async function confirmarProposta(idAnuncio) {
    const texto = document.getElementById('propTexto').value;
    const rawValor = document.getElementById('propValor').value;
    const itemSelect = document.getElementById('propItem');
    const itemId = itemSelect ? itemSelect.value : '';

    if (!texto) {
        alert("Escreva uma proposta.");
        return;
    }

    let valorLimpo = "0.00";
    if (rawValor) {
        valorLimpo = rawValor.replace("R$ ", "").replace(/\./g, "").replace(",", ".");
    }

    let p = new URLSearchParams();
    p.append('tipo', 'enviar_proposta');
    p.append('anuncio_id', idAnuncio);
    p.append('proposta', texto);
    p.append('valor', valorLimpo);
    p.append('item_id', itemId);

    const res = await send_to_php(p);
    if (res.status === 'OK') {
        alert("Proposta enviada com sucesso!");
        fecharModal();
    } else {
        alert("Erro ao enviar: " + res.error);
    }
}



function verDetalhesProposta(p) {
    const tituloModal = p.proponente_nome ? `Proposta de ${p.proponente_nome}` : `Proposta para ${p.vendedor_nome}`;
    const rotuloUsuario = p.proponente_nome ? "Interessado" : "Vendedor";
    const nomeUsuario = p.proponente_nome || p.vendedor_nome;

    const modalData = {
        id: p.item_oferecido_id,
        nome: tituloModal,
        descricao: `
            <div style="margin-bottom: 10px; line-height: 1.6;">
                <p><strong>Anúncio:</strong> ${p.anuncio_nome}</p>
                <p><strong>${rotuloUsuario}:</strong> ${nomeUsuario}</p>
                <p><strong>Mensagem:</strong> ${p.texto_proposta}</p>
                <p><strong>Valor Oferecido:</strong> ${p.valor && p.valor !== "0.00" ? 'R$ ' + parseFloat(p.valor).toLocaleString('pt-BR', {minimumFractionDigits: 2}) : 'Nenhum'}</p>
                <p><strong>Item Oferecido na Troca:</strong> ${p.item_ofertado_nome || 'Nenhum'}</p>
                <hr style="border:0; border-top:1px solid #eee; margin:15px 0;">
                <small style="color: #888;">Data do envio: ${p.data_proposta}</small>
            </div>
        `
    };
    renderizarModal(modalData);
}



async function rejeitarProposta(id) {
    if(!confirm("Tem certeza que deseja rejeitar e excluir esta proposta?")) return;
    let res = await send_to_php(new URLSearchParams(`tipo=rejeitar_proposta&id=${id}`));
    if(res.status === 'OK') {
        alert("Proposta removida.");
        location.reload();
    }
}



async function aceitarProposta(id) {
    // 1. Busca as formas de pagamento disponíveis no banco
    let resPag = await send_to_php(new URLSearchParams("tipo=listar_formas_pagamento"));
    let opcoesPag = '';
    if (resPag.status === 'OK') {
        resPag.data.forEach(f => opcoesPag += `<option value="${f.id}">${f.forma}</option>`);
    } else {
        alert("Erro ao carregar formas de pagamento.");
        return;
    }

    // 2. Verifica o tipo do anúncio para saber se precisa pedir data de devolução
    let info = await send_to_php(new URLSearchParams(`tipo=verificar_tipo_proposta&id=${id}`));
    const ehEmprestimo = (info.tipo_anuncio == 3);

    // 3. Cria o Modal de Finalização
    const overlay = document.createElement('div');
    overlay.id = 'modalAceite';
    Object.assign(overlay.style, {
        position: 'fixed', top: '0', left: '0', width: '100vw', height: '100vh',
        backgroundColor: 'rgba(0, 0, 0, 0.8)', display: 'flex', justifyContent: 'center',
        alignItems: 'center', zIndex: '5000', backdropFilter: 'blur(5px)'
    });

    overlay.innerHTML = `
        <div style="background: white; width: 90%; max-width: 400px; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.3);">
            <div style="background: #1a4a31; color: white; padding: 20px; font-weight: bold; font-size: 1.1rem; display: flex; justify-content: space-between;">
                <span>Finalizar Negócio</span>
                <span onclick="document.getElementById('modalAceite').remove()" style="cursor:pointer;">&times;</span>
            </div>
            <div style="padding: 25px; font-family: 'Prompt';">
                <p style="margin-bottom: 20px; color: #555;">Confirme os detalhes finais para gerar o registro da transação.</p>
                
                <label style="display:block; margin-bottom: 5px; font-weight: bold;">Forma de Pagamento:</label>
                <select id="finalPagamento" style="width: 100%; padding: 12px; margin-bottom: 20px; border-radius: 8px; border: 1px solid #ddd;">
                    ${opcoesPag}
                </select>

                <div id="containerDataEmprestimo" style="${ehEmprestimo ? 'display:block;' : 'display:none;'}">
                    <label style="display:block; margin-bottom: 5px; font-weight: bold;">Data de Devolução Prevista:</label>
                    <input type="date" id="finalDataDevolucao" style="width: 100%; padding: 12px; margin-bottom: 20px; border-radius: 8px; border: 1px solid #ddd;">
                </div>

                <div style="display: flex; gap: 10px; margin-top: 10px;">
                    <button onclick="document.getElementById('modalAceite').remove()" style="flex: 1; padding: 12px; border-radius: 8px; border: 1px solid #ccc; background: white; cursor: pointer;">Voltar</button>
                    <button id="btnConfirmarAceite" style="flex: 1; padding: 12px; border-radius: 8px; border: none; background: #2e7d32; color: white; font-weight: bold; cursor: pointer;">Fechar Negócio</button>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(overlay);

    // 4. Ação do botão Confirmar
    document.getElementById('btnConfirmarAceite').onclick = async () => {
        const pagId = document.getElementById('finalPagamento').value;
        const dataDev = document.getElementById('finalDataDevolucao').value;

        if (ehEmprestimo && !dataDev) {
            alert("Por favor, informe a data de devolução prevista.");
            return;
        }

        let p = new URLSearchParams();
        p.append('tipo', 'confirmar_aceite_proposta');
        p.append('proposta_id', id);
        p.append('forma_pagamento_id', pagId);
        p.append('data_devolucao', dataDev);

        const res = await send_to_php(p);
        if(res.status === 'OK') {
            alert("Negócio fechado com sucesso! O anúncio foi removido e o registro histórico foi gerado.");
            location.reload();
        } else {
            alert("Erro ao processar: " + res.error);
        }
    };
}



document.addEventListener('DOMContentLoaded', () => {
    switch (route) {
        case "/home": {
            document.title = `EcoShare - Home`;
            carregarFeedHome();
            break;
        }
        case "/login": {
            document.title = `EcoShare - Login`;
            break;
        }
        case "/cadastro": {
            document.title = `EcoSquare - Cadastro`;
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

                if(itensNovos.status === 'OK' && itensUsados.status === 'OK' && (itensNovos.data.length + itensUsados.data.length) > 0){
                    for(let i = 0; i < itensNovos.data.length; i++){
                        let item = itensNovos.data[i];
                        itemList.innerHTML += `
                        <div class="itemBox">
                            <div class="itemUnitA">${item.nome}</div>
                            <button class="itemUnitB" onclick="verDetalhes_IN(${item.id})">Ver Detalhes</button>
                            </div>`;
                    }
                    for(let i = 0; i < itensUsados.data.length; i++){
                        let item = itensUsados.data[i];
                        itemList.innerHTML += `
                        <div class="itemBox">
                            <div class="itemUnitA">${item.nome}</div>
                            <button class="itemUnitB" onclick="verDetalhes_IU(${item.id})">Ver Detalhes</button>
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
                            <div style="display:flex; gap: 24px; flex: 8; justify-content: flex-end;">
                                <button class="itemUnitB" style="flex: 1;" onclick="verDetalhes_Anuncio(${anuncio.id})">Ver Detalhes</button>
                                <button class="itemUnitB" style="flex: 1; background: #f8d7da; border-color: #f5c6cb;" onclick="excluirAnuncio(${anuncio.id})">Apagar</button>
                            </div>
                        </div>`;
                    });
                    content.prepend(anuncioList);
                }

                let novos = await send_to_php(new URLSearchParams("tipo=buscar_itens_novos_do_usuario"));
                let usados = await send_to_php(new URLSearchParams("tipo=buscar_itens_usados_do_usuario"));

                const inputItem = document.getElementById('inputItem');
                const popularItens = (res) => {
                    if (res && res.status === 'OK' && inputItem) {
                        res.data.forEach(item => {
                            let opt = document.createElement('option');
                            opt.value = item.id;
                            opt.innerHTML = item.nome;
                            inputItem.appendChild(opt);
                        });
                    }
                };
                popularItens(novos);
                popularItens(usados);

                let resEnd = await send_to_php(new URLSearchParams("tipo=listar_enderecos_usuario"));
                const inputEndereco = document.getElementById('inputEndereco');
                if (resEnd.status === 'OK' && resEnd.data.length > 0 && inputEndereco) {
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
        case "/proposta": {
            document.title = `EcoShare - Minhas Propostas`;
            let content = document.getElementById('content');
            content.innerHTML = "";
            const estiloSecao = "margin-bottom: 20px; padding-bottom: 20px;";

            let divRecebidas = document.createElement('div');
            divRecebidas.classList.add('itemList');
            divRecebidas.style = estiloSecao;
            divRecebidas.innerHTML = `<h2>Propostas Recebidas</h2><p style="color:#666; font-size:14px; margin-bottom: 15px;">O que ofereceram nos seus anúncios</p>`;
            content.appendChild(divRecebidas);

            let divFeitas = document.createElement('div');
            divFeitas.classList.add('itemList');
            divFeitas.style = estiloSecao + " margin-top: 40px;"; 
            divFeitas.innerHTML = `<h2>Propostas Feitas</h2><p style="color:#666; font-size:14px; margin-bottom: 15px;">Suas ofertas enviadas para outros vendedores</p>`;
            content.appendChild(divFeitas);

            (async () => {
                let resRec = await send_to_php(new URLSearchParams("tipo=listar_propostas_recebidas"));
                if (resRec.status === 'OK' && resRec.data.length > 0) {
                    resRec.data.forEach(p => {
                        let valorStr = (p.valor && p.valor !== "0.00") ? `R$ ${parseFloat(p.valor).toLocaleString('pt-BR', {minimumFractionDigits: 2})}` : "Troca/A combinar";
                        divRecebidas.innerHTML += `
                        <div class="itemBox" style="margin-bottom: 15px;">
                            <div class="itemUnitA" style="flex: 12;">
                                <strong>${p.proponente_nome}</strong>&nbsp;em&nbsp;<i>${p.anuncio_nome}</i>:&nbsp;${valorStr}
                            </div>
                            <div style="display:flex; gap:24px; flex:10; justify-content: flex-end;">
                                <button class="itemUnitB" style="flex:1;" onclick='verDetalhesProposta(${JSON.stringify(p)})'>Detalhes</button>
                                <button class="itemUnitB" style="flex:1; background:#d4edda;" onclick="aceitarProposta(${p.id})">Aceitar</button>
                                <button class="itemUnitB" style="flex:1; background:#f8d7da;" onclick="rejeitarProposta(${p.id})">Rejeitar</button>
                            </div>
                        </div>`;
                    });
                } else {
                    divRecebidas.innerHTML += "<p style='margin: 20px 0; color:#999;'>Nenhuma proposta recebida até o momento.</p>";
                }

                let resFeitas = await send_to_php(new URLSearchParams("tipo=listar_propostas_feitas"));
                if (resFeitas.status === 'OK' && resFeitas.data.length > 0) {
                    resFeitas.data.forEach(p => {
                        let valorStr = (p.valor && p.valor !== "0.00") ? `R$ ${parseFloat(p.valor).toLocaleString('pt-BR', {minimumFractionDigits: 2})}` : "Troca/A combinar";
                        divFeitas.innerHTML += `
                        <div class="itemBox" style="margin-bottom: 15px;">
                            <div class="itemUnitA" style="flex: 15;">
                                Você ofereceu em&nbsp;<i>${p.anuncio_nome}</i>&nbsp;(Vendedor: ${p.vendedor_nome}):&nbsp;${valorStr}
                            </div>
                            <div style="display:flex; gap:24px; flex:8; justify-content: flex-end;">
                                <button class="itemUnitB" style="flex:1;" onclick='verDetalhesProposta(${JSON.stringify(p)})'>Detalhes</button>
                                <button class="itemUnitB" style="flex:1; background:#f8d7da;" onclick="rejeitarProposta(${p.id})">Cancelar</button>
                            </div>
                        </div>`;
                    });
                } else {
                    divFeitas.innerHTML += "<p style='margin: 20px 0; color:#999;'>Você ainda não fez nenhuma proposta.</p>";
                }
            })();
            break;
        }
        case "/registro": {
            document.title = `EcoShare - Meus Registros`;
            const divVendas = document.getElementById('listaVendas');
            const divCompras = document.getElementById('listaCompras');

            (async () => {
                const fetchAndRender = async (tipo, container) => {
                    let res = await send_to_php(new URLSearchParams(`tipo=${tipo}`));
                    
                    if (res.status === 'OK' && res.data.length > 0) {
                        container.innerHTML = "";
                        res.data.forEach(r => {
                            const classeTipo = tipo.includes('vendas') ? 'tipo-venda' : 'tipo-compra';
                            
                            const valorTexto = parseFloat(r.valor_registro) > 0 
                                ? `R$ ${parseFloat(r.valor_registro).toLocaleString('pt-BR', {minimumFractionDigits: 2})}` 
                                : "Grátis/Troca";

                            const dataObj = new Date(r.data_registro);
                            const dataFormatada = dataObj.toLocaleDateString('pt-BR');

                            let badgeHtml = '';
                            if (r.tipo_transacao === 'Venda') {
                                badgeHtml = `<span style="background:#e8f5e9; color:#2e7d32; padding:4px 8px; border-radius:12px; font-size:0.8rem; font-weight:bold;">💰 Venda</span>`;
                            } else if (r.tipo_transacao === 'Troca') {
                                badgeHtml = `<span style="background:#e3f2fd; color:#1565c0; padding:4px 8px; border-radius:12px; font-size:0.8rem; font-weight:bold;">🔄 Troca</span>`;
                            } else if (r.tipo_transacao === 'Empréstimo') {
                                badgeHtml = `<span style="background:#fff3e0; color:#ef6c00; padding:4px 8px; border-radius:12px; font-size:0.8rem; font-weight:bold;">⏳ Empréstimo</span>`;
                            }

                            container.innerHTML += `
                                <div class="registro-card ${classeTipo}">
                                    <div class="registro-info">
                                        <div style="display:flex; align-items:center; gap:10px; margin-bottom:5px;">
                                            ${badgeHtml}
                                            <h3 style="margin:0;">${r.item_nome}</h3>
                                        </div>
                                        <div class="registro-detalhes">
                                            <span>📅 ${dataFormatada}</span>
                                            <span>💳 ${r.forma_pagamento}</span>
                                        </div>
                                    </div>
                                    <div class="registro-valor">
                                        <span class="subtext">Valor</span>
                                        <span class="valor">${valorTexto}</span>
                                    </div>
                                </div>`;
                        });
                    } else {
                        container.innerHTML = `
                            <div style="text-align:center; padding: 40px; background: #f9f9f9; border-radius: 12px; color: #888;">
                                <p style="margin:0;">Nenhum registro encontrado nesta categoria.</p>
                            </div>`;
                    }
                };

                await fetchAndRender('listar_meus_registros_vendas', divVendas);
                await fetchAndRender('listar_meus_registros_compras', divCompras);
            })();
            break;
        }
    }
});