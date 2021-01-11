import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Styles 1.4

import DuplicatesFinder 1.0

Window {
    id: root
    width: 640
    height: 640
    visible: true
    title: qsTr("DuplicatesFinder")

    // Gradient style
    Rectangle{
        width: parent.width * 2
        height: parent.height * 2
        anchors.centerIn: parent
        rotation: 175
        gradient: Gradient{
            GradientStop { position: 0.0; color: "#ff9999" }
            GradientStop { position: 0.5; color: "#ffdbae" }
            GradientStop { position: 1; color: "#fffec0" }
        }
    }

    // get name from url
    function basename(str) {
        return (str.slice(str.lastIndexOf("/")+1))
    }

    // get correct path from url
    function getPath(str){
        return (str.slice(str.indexOf("/")+3))
    }

    // first file dialog
    FileDialog{
        id: firstFileD
        visible: false
        selectFolder: true
        folder: "./"
        onAccepted: {
            firstFolderName.text = getPath(fileUrl.toString())
        }
        onRejected: {
            firstFolderName.text = "Folder path"
        }
    }
    // second file dialog
    FileDialog{
        id: secondFileD
        visible: false
        selectFolder: true
        folder: "./"
        onAccepted: {
            secondFolderName.text = getPath(fileUrl.toString())
        }
        onRejected: {
            secondFolderName.text = "Folder name"
        }
    }

    // All elements
    Rectangle{
        width: root.width > 800 ? 800 : root.width
        height: root.height
        anchors.centerIn: parent
        color: "#00000000"
        ColumnLayout{

            // Header
            Rectangle{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width > 800 ? 800 : root.width
                Layout.preferredHeight: root.height / 6
                color: "#00000000"

                Text {
                    anchors.centerIn: parent
                    text: "Duplicates finder"
                    font.bold: true
                    font.pointSize: Math.min(parent.width, parent.height) / 4
                }
            }

            // Information
            Rectangle{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width > 800 ? 800 : root.width
                Layout.preferredHeight:  root.height / 6 > 70 ? 70 : root.height / 6
                color: "#00000000"
                id: infoHeader
                Text {
                    anchors.fill: parent
                    minimumPixelSize: 10
                    fontSizeMode: Text.Fit
                    font.pixelSize: 200
                    text: "The program finds duplicate files in two selected directories\n" +
                          "Please select two directories via the buttons below and press Find Duplicates button"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Buttons
            Rectangle{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width > 800 ? 800 : root.width
                Layout.preferredHeight:  root.height / 6 > 80 ? 80 : root.height / 6
                id: buttonsRec
                color: "#00000000"
                Row{
                    spacing: 20
                    //anchors.centerIn: buttonsRec
                    anchors.horizontalCenter: buttonsRec.horizontalCenter
                    rightPadding: 10
                    leftPadding: 10

                    Button{
                        width: buttonsRec.width > 500 ? 240 : buttonsRec.width / 2
                        Text{
                            padding: 9
                            anchors.fill: parent
                            minimumPixelSize: 10
                            fontSizeMode: Text.Fit
                            font.pixelSize: 100
                            color: "white"
                            text: "Choose the first directory"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }


                        background: Rectangle{
                            implicitWidth: parent.width
                            implicitHeight: 40
                            radius: 4
                            color: parent.hovered ? "#5c82ff" : "#2b5dff"
                        }

                        // Folder name
                        Text{
                            id: firstFolderName
                            text: "Folder path"
                            anchors.top: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            padding: 5
                            font.pointSize: 9
                        }

                        onClicked: firstFileD.visible = true
                    }

                    Button{
                        width: root.width > 500 ? 240 : root.width / 2
                        Text{
                            padding: 8
                            anchors.fill: parent
                            minimumPixelSize: 10
                            fontSizeMode: Text.Fit
                            font.pixelSize: 100
                            color: "white"
                            text: "Choose the second directory"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle{
                            implicitWidth: parent.width
                            implicitHeight: 40
                            radius: 4
                            color: parent.hovered ? "#5c82ff" : "#2b5dff"
                        }

                        // Folder name
                        Text{
                            id: secondFolderName
                            text: "Folder path"
                            anchors.top: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            padding: 5
                            font.pointSize: 9
                        }

                        onClicked: secondFileD.visible = true
                    }
                }
            }

            DuplicatesFinder{
                id: duplicatesFinder
            }

            // Find duplicates button
            Rectangle{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width > 800 ? 800 : root.width
                Layout.preferredHeight:  root.height / 8 > 50 ? 50 : root.height / 8
                color: "#00000000"
                Button{
                    id: findDuplicatesButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: root.width > 500 ? 240 : root.width / 2

                    background: Rectangle{
                        implicitWidth: parent.width
                        implicitHeight: 40
                        radius: 4
                        color: parent.hovered ? "#474747" : "black"
                    }

                    Text{
                        padding: 8
                        color: "white"
                        font.weight: Font.Light
                        anchors.fill: parent
                        minimumPixelSize: 10
                        fontSizeMode: Text.Fit
                        font.pixelSize: 100
                        text: "Find Duplicates"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        duplicatesFinder.setDirectories(getPath(firstFileD.fileUrl.toString()), getPath(secondFileD.fileUrl.toString()));
                        duplicatesFinder.findDuplicates();
                        outPutTextArea.text = duplicatesFinder.getDuplicates();
                    }
                }
            }

            // Output
            Rectangle{
                id: outRec
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width > 800 ? 800 - 20 : root.width - 20
                //Layout.fillHeight: true
                color: "#10121212"
                Layout.preferredHeight: root.height > 400 ? 300 : root.height / 4 - 10
                radius: 5
                ScrollView{
                    id: view
                    anchors.fill: parent
                    width: parent.width
                    height: 100
                    clip: true
                    ScrollBar.horizontal: ScrollBar.AlwaysOn
                    ScrollBar.vertical: ScrollBar.AlwaysOn
                    TextArea{
                        id: outPutTextArea
                    }
                }
            }
        }
    }

}
