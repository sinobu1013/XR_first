import QtQuick
import QtQuick3D.Helpers
import QtQuick3D
import QtQuick3D.Xr
import QtCharts

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

        XrController {
            controller: XrController.ControllerLeft
            poseSpace: XrController.AimPose
            Model {
                source: "#Cube"
                scale: Qt.vector3d(0.1, 0.1, 0.1)
                materials: PrincipledMaterial {
                    lighting: DefaultMaterial.NoLighting
                    baseColor: "red"
                }
            }
        }

        XrController {
            controller: XrController.ControllerRight
            poseSpace: XrController.AimPose
            Model {
                source: "#Cube"
                scale: Qt.vector3d(0.1, 0.1, 0.1)
                materials: PrincipledMaterial {
                    lighting: DefaultMaterial.NoLighting
                    baseColor: "green"
                }
            }
        }
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

    Timer {
        id: valueChangeTimer
        property real a:0
        property real b:0
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            valueChangeTimer.a = Math.random() * 10;
            valueChangeTimer.b = Math.random() * 10;
            console.log("a: ",valueChangeTimer.a, ", b: ", valueChangeTimer.b);
            graf;
        }
    }

    XrItem {
        id: graf
        x: 0
        y: 100
        z: -200
        width: 200
        height: 200

        Rectangle {
            width: 200
            height: 200
            color: "red"

            ChartView {
                // title: "Line Chart"
                anchors.fill: parent
                antialiasing: true

                LineSeries {
                    id: lineSeries
                    name: "Line"
                    XYPoint { x: 0; y: 0 }
                    XYPoint { x: 1.1; y: 2.1 }
                    XYPoint { x: 1.9; y: 3.3 }
                    XYPoint { x: 2.1; y: 2.1 }
                    XYPoint { x: valueChangeTimer.a; y: valueChangeTimer.b }
                    XYPoint { x: 3.4; y: 3.0 }
                    XYPoint { x: 4.1; y: 3.3 }
                }
            }
        }
    }

}
