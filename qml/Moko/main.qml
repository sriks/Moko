import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "MokoUtils.js" as MokoUtils

PageStackWindow {
    // engine is injected as a context property
    // shareui is injected as a context property to launch share ui
    id: appWindow
    property Page appListPage;
    Component.onCompleted: {
        MokoUtils._root = appWindow;
        showAppList();
    }

    function showAppList() {
        if(!appListPage)
            appListPage = pageStack.push("qrc:/qml/Moko/AppList.qml",{"engine":engine});
        else
            pageStack.pop(appListPage);
    }

    function showAppWebView(url) {
        pageStack.push("qrc:/qml/Moko/AppWebView.qml",{"url":url});
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            id: backButton;
            platformIconId: "toolbar-back";
            anchors.left: (parent === undefined) ? undefined : parent.left;
            visible: (pageStack.depth>1)?(true):(false);
            onClicked: pageStack.pop();
        }

        ToolIcon {
            platformIconId: (visible && appListPage.loading)?("toolbar-stop"):("toolbar-refresh");
            onClicked: (visible && appListPage.loading)?(appListPage.stopUpdate()):(appListPage.startUpdate());
            visible: (appListPage)?(true):(false);
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("my-meego.com")
                onClicked: Qt.openUrlExternally("http://my-meego.com/software/")
            }

            MenuItem {
                text: qsTr("About")
                onClicked: about.open();
            }
        }
    }

    QueryDialog {
        id: about
        icon: "qrc:/Moko80.png";
        titleText: "Moko";
        message: "Conceptualized and developed at Dreamcode, 2012.\nContent courtesy my-meego.com."
        acceptButtonText: "OK";
        onAccepted: about.close();
    }
}
