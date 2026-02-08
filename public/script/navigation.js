function Redrect_user() {
    window.location.pathname = '/user';
}

function Redrect_main() {
    window.location.pathname = '/';
}

function Redrect_item() {
    window.location.pathname = '/item';
}

function redirect(path){
    window.location.pathname = `/${path}`;
}