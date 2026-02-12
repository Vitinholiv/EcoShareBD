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
    <script src="/public/script/navigation.js?v=1.0"></script>
    
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
                    <li><button onclick="redirect('home')">Meus pedidos</button></li>
                    <li><button onclick="redirect('item')">Meus anúncios*</button></li>
                    <li><button onclick="redirect('home')">Meus atendimentos</button></li>
                    <li><button onclick="redirect('home')">Meus endereços</button></li>
                    <li><button onclick="redirect('home')">Conta</button></li>
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
            <input type="file" id="inputFotos" accept=".png" multiple>
            <select id="inputItemType" name="item_type" class="form-select">
                <option value="" selected disabled>Selecione o tipo do item...</option>
                <option value="Novo"> Novo </option>
                <option value="Usado"> Usado </option>
            </select>            
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