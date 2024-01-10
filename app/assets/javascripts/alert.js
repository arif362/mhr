var ALERT_TITLE = "Oops!";
var ALERT_BUTTON_TEXT = "Ok";
var ALERT_ACCEPT_TEXT = "Yes";

if (document.getElementById) {
    window.alert = function (txt) {
        createCustomAlert(txt);
    };

    //window.confirm = function (txt, func) {
    //    createCustomAlert(txt, function (_isContinue) {
    //        if (_isContinue) {
    //            location.href = _href;
    //        }
    //    });
    //}
}

function createCustomAlert(txt, func) {
    d = document;

    if (d.getElementById("modalContainer")) return;

    mObj = d.getElementsByTagName("body")[0].appendChild(d.createElement("div"));
    mObj.id = "modalContainer";
    mObj.style.height = d.documentElement.scrollHeight + "px";

    alertObj = mObj.appendChild(d.createElement("div"));
    alertObj.id = "alertBox";
    if (d.all && !window.opera) alertObj.style.top = document.documentElement.scrollTop + "px";
    alertObj.style.left = (d.documentElement.scrollWidth - alertObj.offsetWidth) / 2 + "px";
    alertObj.style.visiblity = "visible";

    h1 = alertObj.appendChild(d.createElement("h1"));
    h1.appendChild(d.createTextNode(ALERT_TITLE));

    msg = alertObj.appendChild(d.createElement("p"));
    //msg.appendChild(d.createTextNode(txt));
    msg.innerHTML = txt;

    btn = alertObj.appendChild(d.createElement("a"));
    btn.id = "closeBtn";
    btn.appendChild(d.createTextNode(ALERT_BUTTON_TEXT));
    btn.href = "#";
    btn.focus();
    btn.onclick = function () {
        removeCustomAlert();
        return false;
    };

    //btn = alertObj.appendChild(d.createElement("a"));
    //btn.id = "acceptBtn";
    //btn.appendChild(d.createTextNode(ALERT_ACCEPT_TEXT));
    //btn.href = "#";
    //btn.focus();
    //btn.onclick = function () {
    //    return true;
    //    //removeCustomAlert();
    //    //func(true);
    //};

    alertObj.style.display = "block";

}

function removeCustomAlert() {
    document.getElementsByTagName("body")[0].removeChild(document.getElementById("modalContainer"));
}