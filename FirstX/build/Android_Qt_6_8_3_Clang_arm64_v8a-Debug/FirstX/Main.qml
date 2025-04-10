import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

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

        XrController {
            id: rightController
            controller: XrController.ControllerRight
            poseSpace: XrController.AimPose

            onRotationChanged: {
                pickRay.length = 50
                const pickResult = xrView.rayPick(scenePosition, forward);
                if (pickResult.hitType !== PickResult.Null) {
                    pickRay.length = pickResult.distance;
                }
            }

            Node {
                id: pickRay
                property real length: 50
                property bool hit: false

                z: -length/2
                Model {
                    eulerRotation.x: 90
                    scale: Qt.vector3d(0.02, pickRay.length/100, 0.02)
                    source: "#Cylinder"
                    materials: PrincipledMaterial { baseColor: pickRay.hit ? "green" : "gray" }
                    opacity: 0.5
                }
            }

            Node {
                z: 5
                Model {
                    eulerRotation.x: 90
                    scale: Qt.vector3d(0.05, 0.10, 0.05)
                    source: "#Cylinder"
                    materials: PrincipledMaterial {
                        baseColor: "black"
                        roughness: 0.2
                    }
                }
            }
        }
    }

    XrInputAction {
        id: rightTrigger
        hand: XrInputAction.RightHand
        actionId: [XrInputAction.TriggerPressed, XrInputAction.TriggerValue, XrInputAction.IndexFingerPinch]
        onTriggered: {
            console.log("Button ON !!!!!!");
        }
    }

    XrVirtualMouse {
        view: xrView
        source: rightController
        rightMouseButton: rightTrigger.pressed
    }

    DirectionalLight {
        eulerRotation.x: -30
        eulerRotation.y: -70
    }

    // The scene:
    Model {
        y: 100
        z: -50
        source: "#Cube"
        scale: Qt.vector3d(0.2, 0.2, 0.2)
        materials: PrincipledMaterial {
            baseColor: "green"
        }
        eulerRotation.x: 30
        PropertyAnimation on eulerRotation {
            from: "30, 0, 0"
            to: "30, 360, 0"
            loops: -1
            duration: 20000
        }
    }
    // Anchors:
    Repeater3D {
        id: spatialAnchors
        model: XrSpatialAnchorListModel {
        }
        delegate: Node {
            id: anchorNode
            required property XrSpatialAnchor anchor
            required property int index
            position: anchor.position
            rotation: anchor.rotation

            Model {
                // Visualize anchor orientation
                materials: PrincipledMaterial { baseColor: "white" }
                source: "#Cone"
                scale: Qt.vector3d(0.2, 0.2, 0.2)
                eulerRotation.x: 90
            }
            visible: anchor.has2DBounds || anchor.has3DBounds
        }
    }

    XrItem {
        x: 0
        y: 150
        z: -100
        width: 100
        height: 100

        contentItem: Rectangle {
            width: 300
            height: 400
            color: Qt.rgba(1, 1, 1, 0.5)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Button {
                    text: "Tokyo"
                    onClicked: {
                        console.log("Tokyo");
                    }
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 2 / 3
                }
                Button {
                    text: "Kyoto"
                    onClicked: {
                        console.log("Kyoto");
                    }
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 2 / 3
                }
                Button {
                    text: "Yamaguti"
                    onClicked: {
                        console.log("Yamaguti");
                    }
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 2 / 3
                }
            }
        }
    }

}
