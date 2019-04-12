const CameraApp = new Vue({
    el: "#Camera_Container",

    data: {
        camerasOpen: false,
        cameraBoxLabel: "Testing",
        cameraLabel: "Front Left Store Camera"
    },

    methods: {
        OpenCameras(boxLabel, label) {
            this.camerasOpen = true;
            this.cameraLabel = label;
            this.cameraBoxLabel =  boxLabel;
        },

        CloseCameras() {
            this.camerasOpen = false;
        },

        UpdateCameraLabel(label) {
            this.cameraLabel = label;
        }
    }
});

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {

            if (event.data.type == "enablecam") {
                
                CameraApp.OpenCameras(event.data.box, event.data.label);

            } else if (event.data.type == "disablecam") {

                CameraApp.CloseCameras();

            } else if (event.data.type == "updatecam") {

                CameraApp.UpdateCameraLabel(event.data.label);

            }

        });
    };
};