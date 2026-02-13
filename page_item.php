<!DOCTYPE html>
<html lang="pt-br">
<head>
    <!-- Padrão -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EcoShare</title>
    <meta name="theme-color" content="#bbbbbb"/>
    
    <!-- CSS e Scripts -->
    <link rel="stylesheet" type="text/css" href="/public/css/main.css?v=1.0">
    <script src="/public/script/core.js?v=1.0"></script>
    
    <!-- Fontes -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;700&family=Nova+Square&family=Prompt:wght@200;400&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <nav id="header">
        <div id="headerLeft" onclick="window.location.assign(window.location.origin + '/')" style="cursor:pointer;">
            <img id="logo" src="/public/res/logo.png" alt="Logo">
            <p id="pageTitle">EcoShare</p>
        </div>
        <div id="headerMiddle">
            <div class="search-container">
                <input type="text" id="mainSearch" placeholder="O que você procura?" 
                onkeydown="if(event.key === 'Enter') realizarBusca()"
                style="background: transparent; border: none; color: white; outline: none; width: 100%; font-family: 'Prompt';">
                <button onclick="realizarBusca()">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="white">
                        <path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                    </svg>
                </button>
            </div>
        </div>
        <div id="headerRight">
            <div class="user-container" id="userContainer">
                <div class="user-icon-trigger" id="userTrigger">

                    <span class="user-name-label">Olá, Usuário</span>
                    
                    <svg viewBox="0 0 24 24" fill="currentColor" width="32" height="32">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </div>
                <ul id="userDropdown" class="user-dropdown-list">

                    <li><button onclick="redirect('home')">Início</button></li>
                    <li><button onclick="redirect('endereco')">Meus Endereços</button></li>
                    <li><button onclick="redirect('item')">Meus Itens</button></li>
                    <li><button onclick="redirect('anuncio')">Meus Anúncios</button></li>
                    <li><button onclick="redirect('proposta')">Minhas Propostas</button></li>
                    <li><button onclick="redirect('registro')">Meus Registros</button></li>
                    <li class="divider"></li>

                    <li><button class="logout-btn" onclick="logout()">Sair</button></li>
                </ul>
            </div>
        </div>
    </nav>
    <!-- Conteúdo -->
    <div id="content">
        <div class="form-container">
            <h2>Cadastrar Novo Item</h2>
            <input type="text" id="inputNome" placeholder="Nome do Item">
            <input type="text" id="inputDescricao" placeholder="Descrição">
            <select id="inputItemType" name="item_type" class="form-select">
                <option value="" selected disabled>Selecione o tipo do item...</option>
                <option value="Novo"> Novo </option>
                <option value="Usado"> Usado </option>
            </select>
            <label for="inputFotos" class="custom-file-upload">
                <span class="upload-icon">📷</span>
                <span class="upload-text">Clique para selecionar fotos</span>
                <input type="file" id="inputFotos" accept=".png" multiple>
            </label>
            <div id="preview-container" style="display: flex; gap: 10px; margin-top: 10px; flex-wrap: wrap;"></div>
            <button type="button" onclick="prepara_cadastro_de_item()">Cadastrar</button>
        </div>
    </div>
    <!-- Footer -->
    <footer id="footer">
        <div class="footer-content">
            <p class="footer-brand">EcoShare</p>
            <div class="footer-info">
                <p>Contato: <span>contato@ecoshare.com</span></p>
                <p>&copy; 2026 EcoShare - Todos os direitos reservados.</p>
            </div>
        </div>
    </footer>
</body>
</html>