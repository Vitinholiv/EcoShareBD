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
        <div id="headerLeft">
            <img id="logo" src="/public/res/logo.png" alt="Logo" onclick="window.location.assign(window.location.origin + `/`)">
        </div>
        <div id="headerMiddle">
            <p id="pageTitle">EcoShare</p>
        </div>
        <div id="headerRight">
            <button class="header-btn" onclick="redirect('cadastro')">Cadastro</button>
        </div>
    </nav>
    <!-- Conteúdo -->
    <div id="content">
        <div class="form-container">
            <h2>Login de Usuário</h2>
            <input type="text" id="inputUser" placeholder="Usuário">
            <input type="password" id="inputSenha" placeholder="Senha" autocomplete="off">
            <button type="button" onclick="prepara_login_de_usuario()">Login</button>
        </div>
    </div>
    <!-- Footer -->
    <footer id="footer">
        <p class="footerText">EcoShare.</p>
        <p class="footerText">Contato: contato@ecoshare.com</p>
    </footer>
</body>
</html>