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
            <button class="btn-secondary" onclick="redirect('login')">Login</button>
        </div>
    </nav>
    <!-- Conteúdo -->
    <div id="content">
        <div class="form-container">
            <h2>Cadastro de Usuário</h2>
            <input type="text" id="inputNome" placeholder="Nome">
            <div class="document-row">
                <select id="inputDocType" name="pais_documento" class="doc-select">
                <option value="" selected disabled>Documento...</option>
                <option value="CPF">Brasil (CPF)</option>
                <option value="CNPJ">Brasil (CNPJ)</option>
                <option value="BI_AO">Angola (Bilhete de Identidade)</option>
                <option value="CNI">Cabo Verde (CNI)</option>
                <option value="DIP">Guiné Equatorial (DIP)</option>
                <option value="BI_GW">Guiné-Bissau (Bilhete de Identidade)</option>
                <option value="BI_MZ">Moçambique (Bilhete de Identidade)</option>
                <option value="CC">Portugal (Cartão de Cidadão)</option>
                <option value="BI_ST">São Tomé e Príncipe (Bilhete de Identidade)</option>
                <option value="CI">Timor-Leste (Cartão de Identidade)</option>
                </select>
                <input type="text" id="inputDoc" placeholder="Número do documento" class="doc-input">
            </div>
            <input type="text" id="inputEmail" placeholder="Email">
            <input type="text" id="inputUser" placeholder="Usuário">
            <input type="password" id="inputSenha" placeholder="Senha" autocomplete="off">
            <button type="button" onclick="prepara_cadastro_de_usuario()">Registrar</button>
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

    <script>
        const placeholders = {
            'CPF':   'Ex: 000.000.000-00',
            'CNPJ':  'Ex: 00.000.000/0000-00',
            'BI_AO': 'Ex: 000000000LA000',
            'CNI':   'Ex: 0000000',
            'DIP':   'Ex: 00000000',
            'BI_GW': 'Ex: 0000000',
            'BI_MZ': 'Ex: 000000000000A',
            'CC':    'Ex: 00000000 0 ZZ0',
            'BI_ST': 'Ex: 0000000',
            'CI':    'Ex: 000000000'
        };

        const selectDoc = document.getElementById('inputDocType');
        const inputNum = document.getElementById('inputDoc');

        selectDoc.addEventListener('change', function() {
            inputNum.placeholder = placeholders[this.value] || "Digite o número do documento";
            inputNum.value = "";
            inputNum.focus();
        });

        inputNum.addEventListener('input', function(e) {
            let type = selectDoc.value;
            let cursor = e.target.selectionStart;
            let oldLength = e.target.value.length;
            let raw = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
            let formatted = "";

           if (type === 'CPF') {
                let v = raw.replace(/\D/g, '').substring(0, 11);
                if (v.length > 9) {
                    formatted = v.replace(/^(\d{3})(\d{3})(\d{3})(\d{1,2})$/, '$1.$2.$3-$4');
                } else if (v.length > 6) {
                    formatted = v.replace(/^(\d{3})(\d{3})(\d{1,3})$/, '$1.$2.$3');
                } else if (v.length > 3) {
                    formatted = v.replace(/^(\d{3})(\d{1,3})$/, '$1.$2');
                } else {
                    formatted = v;
                }
            } else if (type === 'CNPJ') {
                let v = raw.replace(/\D/g, '').substring(0, 14);
                if (v.length > 12) {
                    formatted = v.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{1,2})$/, '$1.$2.$3/$4-$5');
                } else if (v.length > 8) {
                    formatted = v.replace(/^(\d{2})(\d{3})(\d{3})(\d{1,4})$/, '$1.$2.$3/$4');
                } else if (v.length > 5) {
                    formatted = v.replace(/^(\d{2})(\d{3})(\d{1,3})$/, '$1.$2.$3');
                } else if (v.length > 2) {
                    formatted = v.replace(/^(\d{2})(\d{1,3})$/, '$1.$2');
                } else {
                    formatted = v;
                }
            } else if (type === 'CC') {
                let v = raw.substring(0, 12);
                let part1 = v.substring(0, 8).replace(/[^0-9]/g, '');
                let part2 = v.substring(8, 9).replace(/[^0-9]/g, '');
                let part3 = v.substring(9, 11).replace(/[^A-Z]/g, '');
                let part4 = v.substring(11, 12).replace(/[^0-9]/g, '');
                
                formatted = part1;
                if (part1.length === 8 && (part2 || part3 || part4)) {
                    formatted += " " + part2;
                } else {
                    formatted += part2;
                }

                if (part2.length === 1 && (part3 || part4)) {
                    formatted += " " + part3;
                } else {
                    formatted += part3;
                }
                
                formatted += part4;
            } else {
                formatted = raw.substring(0,16);
            }

            e.target.value = formatted;
            let diff = formatted.length - oldLength;
            if (diff > 0 && (formatted[cursor-1] === '.' || formatted[cursor-1] === '-' || formatted[cursor-1] === ' ')) {
                cursor++;
            }
            e.target.setSelectionRange(cursor, cursor);
        });
    </script>
</body>
</html>