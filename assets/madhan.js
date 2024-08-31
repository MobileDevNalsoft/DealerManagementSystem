var modelViewer = document.getElementById("model");
var hotspotCounter = 0;
let longPressTimer;

// ontouchstart is a method of modelViewer object that is triggered when touch is started by user on model viewer rendered area.
modelViewer.ontouchstart = (event) => {
    // to create a long press functionality( touch will be triggered after the time out )
    longPressTimer = setTimeout(() => {
        // to confirm whether the touch is started or not
        console.log('Touch started : ', event.targetTouches.item(0).clientX);

        // surfaceFromPoint will take the touch point on screen then it uses rayCasting to check whether the touch action
        // is made on the model object in the rendered area or not.
        // if [Yes] it returns a surface point object with some values else returns null.
        const surfacePoint = modelViewer.surfaceFromPoint(event.targetTouches.item(0).clientX, event.targetTouches.item(0).clientY);

        console.log('Surface Point : ', surfacePoint);

        /*
        Position

            Definition: In 3D graphics, position refers to the location of a point or object in a 3D space. It is 
            typically represented as a vector with three components (x, y, z) that specify the coordinates relative 
            to a coordinate system origin.
            Role in Rendering: The position of each vertex in a 3D model determines its location on the screen when 
            the model is rendered. By manipulating the position of vertices, you can transform the model's shape, 
            size, and orientation.
        */

        /*
        https://www.makeuseof.com/normals-in-3d-modeling-explained/

        Normal

            A normal is a unit vector that is perpendicular to a surface at a given point. It points outward from the surface.
            normals are typically predefined for 3D models. When a 3D model is created or exported, the software used to create
            it will usually calculate and store the normals for each vertex or face of the model.

            These normals are essential for determining the orientation of surfaces and calculating lighting and 
            shading effects during rendering. Without normals, it would be impossible to accurately render a 3D model
            with realistic lighting and shading.
        */
        let positionAndNormal = modelViewer.positionAndNormalFromPoint(
            event.targetTouches.item(0).clientX,
            event.targetTouches.item(0).clientY
            );

        let hotspot = document.createElement("button");
        
    }, 1000);
}

// ontouchstart is a method of modelViewer object that is triggered when touch is ended by user on model viewer rendered area.
modelViewer.ontouchend = (event) => {
  clearTimeout(longPressTimer);
};

// window.flutterChannel.onMessageReceived(())