import QtGraphicalEffects 1.0
import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: root
    height: 500
    width: 850
    title: ApplicationName
    visible: true

    Image {
        anchors.fill: parent
        fillMode: Image.Tile
        source: "qrc:///resources/images/background.jpg"
    }

    Item {
        anchors.fill: parent
        state: thumbnailBar.count > 0 ? "view" : "empty"

        Text {
            id: text
            anchors.left: parent.left
            height: parent.height
            width: parent.width
            color: "#D32F2F"
            font.pointSize: 24
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 1.2
            text: "No images to display\nDrop image or folder to start viewing"
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }

        Item {
            id: view
            anchors.top: parent.top
            height: parent.height
            width: parent.width
            clip: true
            focus: true

            Keys.onPressed: {
                switch (event.key) {
                    case Qt.Key_Home:
                        thumbnailBar.switchToFirst();
                        break;
                    case Qt.Key_End:
                        thumbnailBar.switchToLast();
                        break;
                    case Qt.Key_Left:
                        thumbnailBar.switchToPrevious();
                        break;
                    case Qt.Key_Right:
                        thumbnailBar.switchToNext();
                        break;
                    case Qt.Key_0:
                        imageView.zoomToFit();
                        break;
                    case Qt.Key_1:
                        imageView.zoomToOrigin();
                        break;
                    case Qt.Key_Minus:
                        imageView.zoomOut();
                        break;
                    case Qt.Key_Equal:
                        if (0 === (event.modifiers & Qt.ControlModifier))
                            break;
                        // fall through
                    case Qt.Key_Plus:
                        imageView.zoomIn();
                        break;
                }
            }

            Image {
                id: background
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: imageView.source
            }

            FastBlur {
                anchors.fill: background
                radius: 75
                source: background
            }

            ThumbnailBar {
                id: thumbnailBar
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                height: 100
                url: Utils.isMimeTypeSupported(InitUrl) ? InitUrl : ""
            }

            ImageView {
                id: imageView
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    top: thumbnailBar.bottom
                }
                source: thumbnailBar.currentUrl

                onSourceChanged: {
                    zoomToFit();
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton

                onWheel: {
                    thumbnailBar.switchBy(-Math.round(wheel.angleDelta.y / 120));
                }
            }
        }

        states: [
            State {
                name: "empty"

                AnchorChanges {
                    target: text
                    anchors.top: parent.top
                }

                AnchorChanges {
                    target: view
                    anchors.left: parent.right
                }
            },

            State {
                name: "view"

                AnchorChanges {
                    target: text
                    anchors.top: parent.bottom
                }

                AnchorChanges {
                    target: view
                    anchors.left: parent.left
                }
            }
        ]

        transitions: [
            Transition {
                AnchorAnimation {
                    duration: 200
                }
            }
        ]
    }

    DropArea {
        anchors.fill: parent
        keys: [
            "text/uri-list"
        ]

        onDropped: {
            var openInNewWindow = false;
            for (var i = 0; i < drop.urls.length; ++i) {
                var url = drop.urls[i];
                if (Utils.isMimeTypeSupported(url)) {
                    if (openInNewWindow) {
                        Utils.openInNewWindow(url);
                    } else {
                        thumbnailBar.url = url;
                        openInNewWindow = true;
                    }
                }
            }
        }
    }
}
