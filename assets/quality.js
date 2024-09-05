

var modelViewer = document.getElementById("quality");

function receiveHotspots(name, position, normal){
        let hotspot = document.createElement("button");
        hotspot.classList.add(["hotspot"]);

        console.log(position);
        console.log(normal);

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
        hotspot.setAttribute("hotspot-name", name);

        hotspot.onclick = function () {
            changeHotSpotColors(hotspot.getAttribute("hotspot-name"), true);

            window.qualityChannel.postMessage(JSON.stringify({"type":"hotspot-click","name":name}));
        };
        hotspot.textContent = name;

        hotspot.setAttribute("slot", name);
        hotspot.setAttribute("id", name);
        modelViewer.appendChild(hotspot);

        window.qualityChannel.postMessage(JSON.stringify({"type":"hotspot-create","position":position,"normal":normal,"name":name}));
}

function changeHotSpotColors(selectedHotspotName, rotate) {
    console.log('hotspot name ', selectedHotspotName);

    const allHotspots = document.getElementsByClassName("hotspot");

    console.log('hotspots ', allHotspots);

    for(var hotspot of allHotspots){
        if(hotspot.getAttribute("hotspot-name") == selectedHotspotName){

            hotspot.style.backgroundColor = "orange";
        
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
        }
    }
  }