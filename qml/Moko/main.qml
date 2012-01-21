import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "MokoUtils.js" as MokoUtils

PageStackWindow {
    // engine is injected as a context property
    id: appWindow
    property Page appListPage;
    Component.onCompleted: {
        MokoUtils._root = appWindow;
        console.debug("root is "+MokoUtils.root());
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
            platformIconId: "toolbar-refresh";
            onClicked: if(appListPage) appListPage.startUpdate();
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
                text: qsTr("About")
                onClicked: about.open();
            }
        }
    }

    QueryDialog {
        id: about
        titleText: "Moko";
        message: "Conceptualized and developed at Dreamcode DeviceWorks, 2012.\nContent courtesy my-meego.com.\nIcon courtesy openclipart.com"
        acceptButtonText: "OK";
        onAccepted: about.close();
    }
}
