<!--


function doServerRequest(URL, DivName, spinner){

   var http_request = false;
   if (window.XMLHttpRequest) { // Mozilla, Safari,...
        http_request = new XMLHttpRequest();
        //if (http_request.overrideMimeType) {
        //    http_request.overrideMimeType('application/xml');
        //}
    }else if (window.ActiveXObject) { // IE
        try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
        }catch (e) {
            try {
                http_request = new ActiveXObject("Microsoft.XMLHTTP");
            }catch (e) {
            }
        }
    }

    if (!http_request) {
        return false;
    }

    http_request.onreadystatechange = function() { 
                                        if(http_request.readyState == 4){
                                            processContents(http_request, DivName); 
                                        }
                                      };

    if(DivName != ""){
        var elems = document.getElementById(DivName);
        elems.style.display = 'block';
        if(spinner == null){
            spinner = "/images/spinner.gif";
        }
        elems.innerHTML = "<br /><p><img src='" + spinner + "' /></p><br /> <br />";
    }

    var splitArray = URL.split('?');
    URL = splitArray[0];
    var params = splitArray[1];
    http_request.open('POST', URL, true);
    var contentType = "application/x-www-form-urlencoded; charset=UTF-8";
    http_request.setRequestHeader("Content-Type", contentType);
    http_request.send(params);
};

function processContents(http_request, PageElement) {
    if (http_request.readyState == 4) {
        try{
            if (http_request.status == 200) {
                var TextResponse = http_request.responseText; 
                //alert("1 TextResponse: " + TextResponse);
                if(PageElement != ""){
                    var elems = document.getElementById(PageElement);
                    elems.innerHTML = TextResponse;
                }
            }else {
                alert('There was a problem with the request, http status: ' + http_request.status);
            }
        }catch(e){
            if (http_request.status == 200) {
                var TextResponse = http_request.responseText; 
                //alert("2 TextResponse: " + TextResponse);
                if(PageElement != ""){
                    var elems = document.getElementById(PageElement);
                    elems.innerHTML = TextResponse;
                }
            }else {
                alert('There was a problem with the request, http status: ' + http_request.status);
            }
        }
    }else{
        alert('ready state failure, ready state: ' + http_request.readyState);
    }
};

var variable = 0;
function doServerRequestReturnToJS(url, params, func){
   var http_request = false;
   if (window.XMLHttpRequest) { // Mozilla, Safari,...
        http_request = new XMLHttpRequest();
        //if (http_request.overrideMimeType) {
        //    http_request.overrideMimeType('application/xml');
        //}
    }else if (window.ActiveXObject) { // IE
        try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
        }catch (e) {
            try {
                http_request = new ActiveXObject("Microsoft.XMLHTTP");
            }catch (e) {
            }
        }
    }

    if (!http_request) {
        return false;
    }

    http_request.onreadystatechange = function() { 
                                        if(http_request.readyState == 4){
                                            var TextResponse = http_request.responseText; 
                                            variable = TextResponse
                                            func(); 
                                        }
                                      };

    http_request.open('POST', url, true);

    http_request.send(params);
};

                       
//////////////////////////////////////////////////////
//
// Show hide pop over divs
// 

var PopOver = 0;

function showPopOver(divID) {
    if(PopOver == 0){
        var div = document.getElementById(divID);
        div.style.display = '';  
        PopOver = 1;
    }   
}

function hidePopOver(divID) {
    document.getElementById(divID).style.display = 'none';  
    PopOver = 0;
}

                       
//////////////////////////////////////////////////////
//
//  Other stuff
// 
function closeWindow_ParentReload(){
    window.opener.location.reload(true);
    self.close();
}

function openWindow(theURL,winName,features) { 
  window.open(theURL,winName,features);
}

function closeWindow (){
    self.close();
}

function setColour(id, value){   
    document.getElementById(id).style.background = value;
}

function submitDeleteAdvert(AdvertID){
    var formID = "DeleteAdvert" + AdvertID;
    var confirmation = confirm('Are you sure you want to delete this advert?');
    if(confirmation == true){
        document.getElementById(formID).submit();
    }
}

function switchAdServerTab(divID){

    document.getElementById('AvailableAdvertsTab').style.display = "none";
    document.getElementById('AdServerNavLI_AvailableAdvertsTab').className = "tabsFirst";

    document.getElementById('AddAdvertTab').style.display = "none";
    document.getElementById('AdServerNavLI_AddAdvertTab').className = "tabs";

    document.getElementById('AdPlacementTab').style.display = "none";
    document.getElementById('AdServerNavLI_AdPlacementTab').className = "tabs";

    document.getElementById('AdImpressionsReportsTab').style.display = "none";
    document.getElementById('AdServerNavLI_AdImpressionsReportsTab').className = "tabsLast";

    if(divID == "AvailableAdvertsTab"){
        document.getElementById('AvailableAdvertsTab').style.display = "block";
        document.getElementById('AdServerNavLI_AvailableAdvertsTab').className = "tabsFirstOn";
    }else if (divID == "AddAdvertTab") {
        document.getElementById('AddAdvertTab').style.display = "block";
        document.getElementById('AdServerNavLI_AddAdvertTab').className = "tabsOn";
    }else if (divID == "AdPlacementTab") {
        document.getElementById('AdPlacementTab').style.display = "block";
        document.getElementById('AdServerNavLI_AdPlacementTab').className = "tabsOn";
    }else if (divID == "AdImpressionsReportsTab") {
        document.getElementById('AdImpressionsReportsTab').style.display = "block";
        document.getElementById('AdServerNavLI_AdImpressionsReportsTab').className = "tabsLastOn";
    }else{
        alert("Something is awry! switchAdServerTab(" + divID + ")");
    }

}


function changeClass(className, elem){
    elem.className = className;
}




//-->
