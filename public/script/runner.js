const route = window.location.pathname;
const params = new URLSearchParams(window.location.search);

switch (route) {
	case "/": {
		let objQt = new URLSearchParams();
	    objQt.append('data', `1`);
        let url = '/routes.php';
        await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: objQt
        })
        .then(res => {
            if (!res.ok) {
                console.log("Erro na conexão com a URL");
            }
            return res.json();
        })
        .catch(err => console.log(`ERRO NO FETCH: ${err}`));
        break;
    }
}