.import "global.js" as Global

function addTemplate(templateName) {
    console.debug("Ajout du template : " + templateName);
    Global.g_parameter.Templates["" + templateName].name = templateName;
    Global.g_parameter.Templates["" + templateName].active = true;
}

function removeTemplate(templateName) {
    console.debug("Désactivation du template : " + templateName);
    Global.g_parameter.Templates["" + templateName].active = false;
}

function editTemplate(templateName) {
    console.debug("Edition du template : " + templateName);

    showActiveTemplate();
}


function showActiveTemplate() {
    console.debug("Tachatte");
    Global.g_parameter.Templates.forEach(
        function(e, k) {
            console.debug("Template : " + k + " name:" + e.name + " active:" + e.active)
        }
    )
}
