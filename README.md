# GUIA DE USO

O projeto deve ser executado localmente, seguem os passos necessários:

1. Faça o login root (máximo privilégio necessário) no MySQL e execute o programa `final.sql`,

2. Será criado um usuário `eco_app_service` que perde alguns privilégios de super-usuário do usuário root, faça login com esse usuário (senha disponível em `env.php`) e execute `USE DATABASE ecosharedb;` (o mysql deve estar ativo durante todo o processo de uso da aplicação),

3. Popule o banco executando o programa `insert.sql`,

4. Na pasta que os arquivos se encontram execute `php -S localhost:8000` ou equivalente,

5. Execute o programa `page_home.php`,

6. Por fim, acesse `localhost:8000` no seu navegador.

# NOTA

- O projeto é apenas uma implementação de um sistema hipotético, os dados não são reais e algumas práticas de programação foram ignoradas apenas por simplicidade (como o env).
