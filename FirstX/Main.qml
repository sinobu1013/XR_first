import QtQuick
import QtQuick3D.Helpers
import QtQuick3D
import QtQuick3D.Xr

XrView {
    id: xrView

    property bool preferPassthrough: true
    passthroughEnabled: passthroughSupported && preferPassthrough

    environment: SceneEnvironment {
        clearColor: "skyblue"
        backgroundMode: xrView.passthroughEnabled ? SceneEnvironment.Transparent : SceneEnvironment.Color
    }

    xrOrigin: theOrigin
    XrOrigin {
        id: theOrigin
        z: 100
    }

    DirectionalLight {
        eulerRotation.x: -30
        eulerRotation.y: -70
    }

    Model{
        id: table
        property real height: 70
        position: Qt.vector3d(0, height / 2, 0)
        source: "#Cube"
        scale: Qt.vector3d(0.4, height / 100, 0.4)
        materials: PrincipledMaterial {
            baseColor: "red"
            roughness: 0.7
        }
    }

    Model{
        id: teapot
        y: table.height + 5
        source: "meshes/teapot.mesh"
        scale: Qt.vector3d(10, 10, 10)
        property color color: "#cdad52"
        materials: [
            PrincipledMaterial {
                baseColor: teapot.color
                roughness: 0.1
                clearcoatAmount: clearcoatSlider.value
                clearcoatRoughnessAmount: 0.1
                metalness: metalnessCheckBox.checked ? 1.0 : 0.0
            }
        ]
    }





}
