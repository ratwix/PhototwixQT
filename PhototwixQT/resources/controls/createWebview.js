var needDestroy = false;
var component;
var profileObject;
var count = 0;

//create a new profile for each call with new storage : no user data is saved

function createprofileViewObjects() {
    var tmpDestroy;

    count++;

    if (needDestroy) {
        tmpDestroy = profileObject;
    }

    component = Qt.createComponent("MyWebEngineProfile.qml");
    profileObject = component.createObject(applicationRoot, {"storage": "default" + count});
    if (profileObject == null) {
        // Error Handling
        console.log("Error creating WebView");
    } else {
        if (needDestroy) {
            tmpDestroy.destroy();
        }

        needDestroy = true;
    }
}
