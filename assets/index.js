var modelViewer = document.getElementById("model");
var hotspotCounter = 0;
let longPressTimer;
modelViewer.addEventListener("touchstart", (event) => {
  longPressTimer = setTimeout(() => {
    console.log(
      "Long press detected on element with ID:",
      event.targetTouches.item(0).clientX
    );
    {
      if (
        modelViewer.surfaceFromPoint(
          event.targetTouches.item(0).clientX,
          event.targetTouches.item(0).clientY
        ) != null
      ) {
        let positionAndNormal = modelViewer.positionAndNormalFromPoint(
          event.targetTouches.item(0).clientX,
          event.targetTouches.item(0).clientY
        );
        let hotspot = document.createElement("button");
        hotspot.classList.add(["hotspot"]);
        hotspotCounter++;
        let s = "hotspot-" + hotspotCounter;
        hotspot.setAttribute(
          "data-position",
          positionAndNormal.position.toString()
        );
        hotspot.id=s;
        hotspot.setAttribute(
          "data-normal",
          positionAndNormal.normal.toString()
        );
        hotspot.setAttribute("data-visibility-attribute", "visible");
        hotspot.onclick = function () {
          hotspot.style.backgroundColor="orange";
          
          window.flutterChannel.postMessage(JSON.stringify({"type":"hotspot-click","name":s}));
        };
        hotspot.textContent = s;
        console.log(positionAndNormal.normal.toString());
        console.log(positionAndNormal.position.toString());
        // Convert hotspot position to spherical coordinates to input to camera orbit attribute
        let normalX = positionAndNormal.normal.x;
        let normalY = positionAndNormal.normal.y;
        let normalZ = positionAndNormal.normal.z;
        let theta = Math.atan2(normalX, normalZ);
        let phi = Math.acos(normalY);

        let camOrbit = theta + "rad " + phi + "rad " + "1m";
        // hotspot.setAttribute("data-orbit", camOrbit);

        hotspot.setAttribute("slot", s);
        hotspot.setAttribute("id", s);
       
        modelViewer.appendChild(hotspot);
        window.flutterChannel.postMessage(JSON.stringify({"type":"hotspot-create","position":positionAndNormal.position.toString(),"normal":positionAndNormal.normal.toString(),"name":s}));
      }
    }
  }, 800);

  // Clear the timer if the user releases the mouse button
  modelViewer.addEventListener(
    "touchend",
    () => {
      clearTimeout(longPressTimer);
    },
    { once: true }
  );
});

modelViewer.ontouchmove = (event) => {
  clearTimeout(longPressTimer);
};

window.addEventListener('message', function(event) {
  console.log( "data from dart"+event.data);

  document.getElementById(event.data).style.backgroundColor="orange";
});