/**
 * Cyklop scripts file
 */

function openFile(file) {
    var component = Qt.createComponent(file);
    if (component.status == Component.Ready){
        console.log(file+" ready!");
        Globals.pageStack.push(component);
    }else {
        console.log("error open file "+file);
    }
}

function replaceFile(file) {
    var component = Qt.createComponent(file);
    if (component.status == Component.Ready){
        console.log(file+" ready!");
        Globals.pageStack.replace(component);
    }else {
        console.log("error open file "+file);
    }
}

function languageName(locale) {
    if(locale.substr(0,2) == "en") return "English";
    if(locale.substr(0,2) == "pl") return "Polski";
}
