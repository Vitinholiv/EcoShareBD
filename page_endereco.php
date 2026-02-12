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
                    <li><button onclick="redirect('endereco')">Meus Endereços</button></li>
                    <li><button onclick="redirect('item')">Meus Itens</button></li>
                    <li><button onclick="redirect('anuncio')">Meus Anúncios</button></li>
                    <li class="divider"></li>

                    <li><button class="logout-btn" onclick="logout()">Sair</button></li>
                </ul>
            </div>
        </div>
    </nav>
    <!-- Conteúdo -->
    <div id="content">
        <div class="form-container">
            <h2>Cadastrar Novo Endereço</h2>
            
            <div style="display: flex; gap: 10px;">
                <input type="text" id="inputPais" placeholder="País" style="flex: 1;">
                <input type="text" id="inputCEP" placeholder="CEP" style="flex: 1;">
            </div>

            <div style="display: flex; gap: 10px;">
                <input type="text" id="inputEstado" placeholder="Estado (UF)" style="flex: 1;">
                <input type="text" id="inputCidade" placeholder="Cidade" style="flex: 2;">
            </div>

            <input type="text" id="inputBairro" placeholder="Bairro">
            <input type="text" id="inputLogradouro" placeholder="Logradouro (Rua, Av...)">

            <div style="display: flex; gap: 10px;">
                <input type="number" id="inputNumero" placeholder="Nº" style="flex: 1;">
                <input type="text" id="inputComplemento" placeholder="Complemento" style="flex: 2;">
            </div>

            <button type="button" onclick="prepara_cadastro_de_endereco()">Salvar Endereço</button>
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