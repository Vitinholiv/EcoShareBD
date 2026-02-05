const route = window.location.pathname;
const params = new URLSearchParams(window.location.search);

switch (route) {
	case "/request": {
		run_sql();
        break;
    }
}

async function run_sql(){
    let objRequest = new URLSearchParams();
    let sqlStr = params.get('sql');
    if(sqlStr !== null){
        objRequest.append('sql', `${sqlStr}`);
        objRequest.append('tipo','consulta');

        let url = '/index.php';
        let response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: objRequest
        })
        .then(res => {
            if (!res.ok) {
                console.log("Erro na conexão com a URL");
            }
            return res.json();
        })
        .catch(err => console.log(`ERRO NO FETCH: ${err}`));

        console.log(response['text'])
    }
}