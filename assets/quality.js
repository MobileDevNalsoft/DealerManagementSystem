

var modelViewer = document.getElementById("quality");

function receiveHotspots(name, position, normal){
        let hotspot = document.createElement("div");

        let pulsatingCircle = document.createElement("div");
        pulsatingCircle.classList.add(["pulsating-circle"]);

        hotspot.appendChild(pulsatingCircle);

        hotspot.classList.add(["hotspot-button"]);

        hotspot.setAttribute(
            "data-position",
            position
        );
        hotspot.id=name;
        hotspot.setAttribute(
            "data-normal",
            normal
        );
        hotspot.setAttribute("data-visibility-attribute", "visible");
        hotspot.setAttribute("id", name);

        hotspot.onclick = function () {
            changeHotSpotColors(hotspot.getAttribute("id"), true);
            window.qualityChannel.postMessage(JSON.stringify({"type":"hotspot-click","name":name}));
        };

        hotspot.setAttribute("slot", name);
        modelViewer.appendChild(hotspot);

        window.qualityChannel.postMessage(JSON.stringify({"type":"hotspot-create","position":position,"normal":normal,"name":name}));
}

function changeHotSpotColors(selectedHotspotName, rotate) {

    const allHotspots = document.getElementsByClassName("hotspot-button");

    for(var hotspot of allHotspots){
        if(hotspot.getAttribute("id") == selectedHotspotName){

            hotspot.style.backgroundColor = "#FFCC80";
            hotspot.firstChild.style.animation="pulse 1.5s ease-in-out infinite";
            if(rotate){
                const normal = hotspot.getAttribute('data-normal');
        
                const normalComponents = normal.split(" ");
            
                const x = parseFloat(normalComponents[0]);
                const y = parseFloat(normalComponents[1]);
                const z = parseFloat(normalComponents[2]);
            
                // for camera orbit rotation when tapped on hotspot or flutter button
                const theta = Math.atan2(x, z);
                const phi = Math.acos(y);
            
                modelViewer.cameraOrbit = `${theta}rad ${phi}rad auto`;
                modelViewer.cameraTarget = '0 0 0';
            }
        }else{
            hotspot.style.backgroundColor = "white";
            hotspot.firstChild.style.animation='';
        }
    }
  }