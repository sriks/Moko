import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "MokoUtils.js" as MokoUtils

Page {
    id: appList;
    property string name: "applist" // TOSO: define in JS
    property QtObject engine;
    property QtObject parser;
    property bool loading;
    property string url: "http://my-meego.com/downloads/harmattan_downloads.xml";
    tools: commonTools

    onStatusChanged: {
        if(status === PageStatus.Active) {
            engine.add(url);
            startUpdate();
        }
    }

    function startUpdate() {
        appList.loading = true;
        engine.updateAll();
    }

    Connections {
        target: engine;
        onUpdateAvailable: {
            appList.loading = false;
            if(parser)
                parser.destroy(); // delete prev parser instance as we have its ownership.

            // This crates a new parser and ownership is transferred.
            // But do not delete it, and keep it alive unless a new request is initiated
            // because delegates will use it.
            parser = engine.parser(url);
            var count = parser.count();
            console.debug("pcount is :"+count);
            header.count = count;
            appListView.model = count;
            console.debug("model finished");
        }

        onError: {
            appList.loading = false;
            console.debug("error:"+errorDescription);
            error.text = errorDescription;
            error.visible = true;
        }
    }

    Label {
        id: error
        width: parent.width;
        visible: false;
        anchors {
            verticalCenter: parent.verticalCenter;
            left: parent.left;
            right: parent.right;
            margins: 15;
        }
    }

    Rectangle {
        id: header;
        property alias count: count.text;
        height: 73;
        color: "#cc8800";

        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
        }

        Label {
            id: headerTitle
            text: "Moko";
            smooth: true;
            anchors {
                left: parent.left;
                leftMargin: 15
                top: parent.top;
                topMargin: 7;
            }
            platformStyle: LabelStyle {
                textColor: "white";
                fontPixelSize: 27;
            }
        }

        Label {
            id: headerSubTitle;
            text: "Today's N9 apps from my-meego.com";
            smooth: true;
            anchors {
                left: parent.left;
                leftMargin: 15
                top: headerTitle.bottom;
                topMargin: 5;
            }
            platformStyle: LabelStyle {
                textColor: "lightgrey";
                fontPixelSize: 18;
            }
        }

        BusyIndicator {
            id:  busyIndicator;
            width: 50;
            height: 50;
            visible: appList.loading;
            running: appList.loading
            anchors {
                right: parent.right;
                rightMargin: 15;
                verticalCenter: parent.verticalCenter;
            }
        }

        ToolButton {
            id: count;
            visible: !busyIndicator.visible && text.length;
            z: busyIndicator.z + 1;
            width: 60;
            anchors {
                right: parent.right;
                rightMargin: 15;
                verticalCenter: parent.verticalCenter;
            }
            onClicked: startUpdate();
        }
    }

    ListView {
        id: appListView
        clip: true;
        delegate: appInfoDelegate;
        spacing: 10;
        anchors {
            top: header.bottom;
            topMargin: 5;
            bottom: parent.bottom;
            right: parent.right;
            left: parent.left;
        }
    }

    Component {
        id: appInfoDelegate;

        Column {
            id: appInfo;
            property bool expand;
            spacing: 10;
            onExpandChanged: {
                description.elide = (expand)?(Text.ElideNone):(Text.ElideRight);
                description.maximumLineCount = (expand)?(10):(4);
            }
            anchors {
                topMargin: 5;
                left: parent.left
                leftMargin: 10
                right: parent.right
                rightMargin: 10;
            }

            Label {
                id: title;
                text: parser.itemElement(index,"title");
                width: parent.width;
                wrapMode: Text.WordWrap;
                smooth: true;
                font {
                    bold: true;
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: expand = (expand)?(false):(true);
                }
            }

            Label {
                id: description;
                text: parser.itemElement(index,"description");
                width: parent.width;
                wrapMode: Text.WordWrap;
                elide: Text.ElideRight
                maximumLineCount: 4;
                smooth: true;
                font {
                    pointSize: title.font.pointSize - 2;
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: expand = (expand)?(false):(true);
                }
            }

            Label {
                id: date;
                text: parser.itemElement(index,"pubDate");
                smooth: true;
                font {
                    pointSize: description.font.pointSize - 1.5;
                }
            }

            Button {
                id: installButton;
                text: qsTr("Try it");
                visible: expand;
                anchors {
                    horizontalCenter: parent.horizontalCenter;
                }
                onClicked: {
                    console.debug("nfc is "+nfc);
//                    nfc.start(parser.itemElement(index,"link"));
                    var link = parser.itemElement(index,"link")
                    Qt.openUrlExternally(link);
                }
            }

            Rectangle {
                width: parent.width - 20;
                height: 3;
                color: "white";
                anchors {
                    horizontalCenter: parent.horizontalCenter;
                }
            }

        }
    }
}

// eof
