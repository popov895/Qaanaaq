import QtQuick 2.6
import Qt.labs.folderlistmodel 2.1

Item {
    id: root

    property url url: ""
    readonly property string currentUrl: listView.count > 0 ? listView.currentUrl : ""
    property alias count: listView.count

    function switchToFirst() {
        switchTo(0);
    }

    function switchToLast() {
        switchTo(listView.count - 1);
    }

    function switchToNext() {
        switchBy(1);
    }

    function switchToPrevious() {
        switchBy(-1);
    }

    function switchBy(count) {
        switchTo(listView.currentIndex + count);
    }

    function switchTo(index) {
        listView.currentIndex = Math.min(listView.count - 1, Math.max(0, index));
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.65
    }

    ListView {
        id: listView
        anchors {
            fill: parent
            margins: 5
        }

        property string currentUrl: ""

        highlightMoveDuration: 200
        highlightMoveVelocity: -1
        orientation: ListView.Horizontal
        spacing: anchors.margins
        delegate: Item {
            id: delegate
            height: ListView.view.height
            width: height

            ListView.onIsCurrentItemChanged: {
                if (ListView.isCurrentItem)
                    delegate.ListView.view.currentUrl = fileURL;
            }

            Image {
                id: image
                anchors {
                    fill: parent
                    margins: 5
                }
                asynchronous: true
                autoTransform: true
                cache: false
                fillMode: Image.PreserveAspectFit
                mipmap: true
                source: fileURL
                sourceSize {
                    height: height
                    width: width
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    delegate.ListView.view.currentIndex = index;
                }
            }
        }
        highlight: Rectangle {
            color: "white"
            opacity: 0.35
        }
        rebound: Transition {
            NumberAnimation {
                duration: 600
                easing.type: Easing.OutElastic
                properties: "x,y"
            }
        }
        model: FolderListModel {
            id: model
            folder: Utils.isFolder(root.url) ? root.url : Utils.getAbsolutePath(root.url)
            nameFilters: [
                "*.bmp",
                "*.gif",
                "*.ico",
                "*.jpeg",
                "*.jpg",
                "*.png",
                "*.svg",
                "*.svgz"
            ]
            showDirs: false
            showOnlyReadable: true
            sortField: FolderListModel.Name

            onModelReset: {
                listView.currentIndex = Utils.isFolder(root.url) ? 0 : model.indexOf(root.url);
            }
        }
    }
}
