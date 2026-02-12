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
            <input id="logicMenu" type="checkbox" placeholder="." />
            <label id="labelMenu" for="logicMenu">
                <div class="visualMenu" id="line1"></div>
                <div class="visualMenu" id="line2"></div>
                <div class="visualMenu" id="line3"></div>
            </label>
            <ul id="menuList">
                <li class="menuElement">
                    <button class="menuButton" onclick="redirect('home');">Início</button>
                </li>
                <li class="menuElement">
                    <button class="menuButton" onclick="redirect('item');">Cadastro de Item</button>
                </li>
                <li class="menuElement">
                    <button class="menuButton" onclick="logout();">Logout</button>
                </li>
            </ul>
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