import QtQuick 2.9
import Lomiri.Components 1.3

LomiriShape {

    id: flyingButtonItem
    property var iconName: ""
    signal clicked()
    property var visibleState: false

    width: units.gu(6)
    height: width
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: width / 2
    anchors.rightMargin: -(hideSidebarButton.width * 1.5)
    backgroundColor: Theme.name == "Lomiri.Components.Themes.SuruDark" ? "#202020" : "#dedede"
    aspect: LomiriShape.DropShadow
    radius: "large"
    opacity: 0.75

    z: 14
    MouseArea {
        id: mouseArea
        onPressed: parent.backgroundColor = "#888888"
        onReleased: parent.backgroundColor = Theme.name == "Lomiri.Components.Themes.SuruDark" ? "#202020" : "#dedede"
        anchors.fill: parent
        enabled: parent.visible
        onClicked: parent.clicked()
    }
    Icon {
        name: iconName
        width: units.gu(3.5)
        height: width
        anchors.topMargin: height / 2
        anchors.centerIn: parent
        z: 14
        color: Theme.name == "Lomiri.Components.Themes.SuruDark" ? "white" : "black"
    }

    transitions: Transition {
        SpringAnimation {
            spring: 2
            damping: 0.2
            properties: "anchors.rightMargin"
        }
    }
    states: State {
        name: "visible"
        when: visibleState
        PropertyChanges {
            target: hideSidebarButton
            anchors.rightMargin: hideSidebarButton.width / 2
        }
    }
}
