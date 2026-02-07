<!DOCTYPE html>
<html lang="pt-br">
<head>
    <!-- Padrão -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Título</title>
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
            <img id="logo" src="/public/res/Template_logo.png" alt="Logo" onclick="window.location.assign(window.location.origin + `/`)">
        </div>
        <div id="headerMiddle">
            <p id="pageTitle">TÍTULO</p>
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
                    <button class="menuButton" onclick="Redrect_main();">Página Inicial</button>
                </li>
            </ul>
        </div>
    </nav>
    <!-- Conteúdo -->
    <div id="content">

        <!-- Botão -->

        <div class="form-container">
            <h2>Gerador de Inserção SQL</h2>
            
            <input type="text" id="inputUser" placeholder="Usuário">
            <input type="text" id="inputEmail" placeholder="Email">
            <input type="text" id="inputSenha" placeholder="Senha">
            <input type="text" id="inputNome" placeholder="Nome">
            <input type="text" id="inputDoc" placeholder="Número do documento">
            <input type="text" id="inputDocType" placeholder="Tipo de documento">

            <button type="button" onclick="prepara_cadastro_de_usuario()">Registrar usuário</button>
            <!-- cadastro_de_usuario('usuariodet','nome do infeliz','emaildoinfeliz@gmail.com','07045312305',1,'senhasegura333'); -->

        </div>



    </div>
    </div>
    <!-- Footer -->
    <footer id="footer">
        <p class="footerText">Título.</p>
        <p class="footerText">Contato: titulo@subtitulo.com</p>
    </footer>
</body>
</html>