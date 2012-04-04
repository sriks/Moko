import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "MokoUtils.js" as MokoUtils

Page {
    id: appList;
    property string name: "applist"
    property QtObject engine;
    property QtObject parser;
    property bool loading;
    property int count:0;
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
        error.clear();
        engine.updateAll();
    }

    function stopUpdate() {
        appList.loading = false;
        engine.stopAll();
    }

    Connections {
        target: engine;
        onUpdateAvailable: {
            appList.loading = false;
            if(parser)
                parser.destroy(); // delete prev parser instance as we have its ownership.

            // This creates a new parser and ownership is transferred.
            // But do not delete it, and keep it alive unless a new request is initiated
            // because delegates will use it.
            parser = engine.parser(url);
            appList.count = parser.count();
            header.count = appList.count;
            appListView.model = appList.count;
        }

        onError: {
            appList.loading = false;
            console.debug("error:"+errorDescription);
            if(0 === appList.count) {
                error.text = errorDescription;
                error.visible = true;
            }
        }
    }

    Label {
        id: error
        width: parent.width;
        visible: false;
        anchors.centerIn: parent;
        function clear() {
            text = "";
            visible = false;
        }
    }

    Rectangle {
        id: header;
        property alias count: count.text;
        height: 73;
        color: "#cc5500";

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
            text: "Today's apps from my-meego.com";
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
        }
    }

    ListView {
        id: appListView
        clip: true;
        delegate: appInfoDelegate;
        spacing: 10;
        cacheBuffer: 1000;
        anchors {
            top: header.bottom;
            topMargin: 5;
            bottom: parent.bottom;
            right: parent.right;
            left: parent.left;
        }
    }

    ScrollDecorator {
        flickableItem: appListView;
    }

    Component {
        id: appInfoDelegate;

        Column {
            id: appInfo;
            property bool expand: false;
            property string contentColor: "#333333"; // dark grey
            spacing: 5;
            anchors {
                topMargin: 4;
                left: parent.left
                leftMargin: 15
                right: parent.right
                rightMargin: 15;
            }

            Label {
                id: title;
                text: parser.decodeHtml(parser.itemElement(index,"title"));
                width: parent.width;
                wrapMode: Text.WordWrap;
                smooth: true;
                font { bold: true; }
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
                elide: (appInfo.expand)?(Text.ElideNone):(Text.ElideRight);
                maximumLineCount: (appInfo.expand)?(15):(3);
                smooth: true;
                color: appInfo.contentColor;
                font { pointSize: title.font.pointSize - 1;}
                MouseArea {
                    anchors.fill: parent;
                    onClicked: expand = (expand)?(false):(true);
                }
            }

            Label {
                id: date;
                text: parser.itemElement(index,"pubDate");
                smooth: true;
                color: "#CC5500";
                font {
                    pointSize: description.font.pointSize - 1.5;
                }
            }

            Row {
                id: buttonContainer;
                spacing: 15;
                visible: expand;
                anchors {
                    horizontalCenter: parent.horizontalCenter;
                }

                Button {
                    id: installButton;
                    width: 160;
                    text: qsTr("Try it");
                    anchors.verticalCenter: parent.verticalCenter;
                    onClicked: {
                        var link = parser.itemElement(index,"link")
                        Qt.openUrlExternally(link);
                    }
                }

                ToolIcon {
                    id: share;
                    anchors.verticalCenter: parent.verticalCenter;
                    platformIconId: "toolbar-share";
                    onClicked: {
                        var t = title.text;
                        var l = parser.itemElement(index,"link")
                        shareui.share(t,"",l);
                    }
                }
            }

            Rectangle {
                id: line;
                width: parent.width - 20;
                height: 3;
                radius: 1.5;
                smooth: true;
                color: "white";
                anchors {
                    horizontalCenter: parent.horizontalCenter;
                }
            }

        }
    }
}

// eof
