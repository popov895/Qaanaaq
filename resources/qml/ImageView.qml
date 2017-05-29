import QtQuick 2.6

Item {
    property alias source: image.source

    function zoomIn() {
        zoomTo(flickable.zoom + flickable.zoom * 0.2);
    }

    function zoomOut() {
        zoomTo(flickable.zoom - flickable.zoom * 0.2);
    }

    function zoomToFit() {
        flickable.zoom = Qt.binding(function () {
            return flickable.boundedZoom;
        });
    }

    function zoomToOrigin() {
        zoomTo(1);
    }

    function zoomTo(zoom) {
        zoom = Math.min(flickable.maxZoom, Math.max(flickable.minZoom, zoom));
        if (flickable.zoom !== zoom) {
            var x = width / 2;
            var y = height / 2;
            var xy = mapToItem(image, x, y);
            var delta = zoom / flickable.zoom - 1;
            flickable.contentX = xy.x + xy.x * delta - x;
            flickable.contentY = xy.y + xy.y * delta - y;
            flickable.zoom = zoom;
            flickable.rebound.active = false;
            flickable.returnToBounds();
            flickable.rebound.active = true;
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent

        property real zoom: boundedZoom
        readonly property real boundedZoom: Math.min(1, Math.min(width / image.sourceSize.width, height / image.sourceSize.height))
        readonly property real maxZoom: 10
        readonly property real minZoom: 0.1

        clip: true
        contentHeight: Math.max(height, image.height)
        contentWidth: Math.max(width, image.width)
        rebound: Transition {
            property bool active: true

            NumberAnimation {
                duration: flickable.rebound.active ? 600 : 0
                easing.type: Easing.OutElastic
                properties: "x,y"
            }
        }

        Item {
            anchors.fill: parent

            AnimatedImage {
                id: image
                anchors.centerIn: parent
                height: flickable.zoom * sourceSize.height
                width: flickable.zoom * sourceSize.width
                asynchronous: true
                autoTransform: true
                cache: false
                fillMode: Image.PreserveAspectFit
                mipmap: true
                playing: AnimatedImage.Ready === state
            }
        }
    }
}
