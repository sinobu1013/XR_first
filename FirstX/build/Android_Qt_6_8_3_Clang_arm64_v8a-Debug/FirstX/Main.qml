import QtQuick
import QtQuick3D.Helpers
import QtQuick3D
import QtQuick3D.Xr

import QtQuick.Layouts
import QtQuick.Controls

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

        XrController{
            id: righthand
            controller: handright.hand
            poseSpace: XrController.AimPose
        }

        XrHandModel{
            id: handright
            hand: XrHandModel.RightHand
            materials: PrincipledMaterial{
                baseColor: "red"
        }

    }


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

    XrItem {
        id: try_button
        z: 50
        width: 100
        height: 100

        Rectangle {
            width: 100
            height: 100
            color: "red"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                Button {
                    text: "OK!"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }





}
