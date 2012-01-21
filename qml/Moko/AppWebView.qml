// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtWebKit 1.0
import com.nokia.meego 1.0

Page {
    id: appWebView;
    property alias url:webView.url;
    tools: commonTools

    Flickable {
        id: flick
        contentWidth: webView.width;
        contentHeight: webView.height;
        anchors.fill: parent;
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        clip: true;

    WebView {
        id: webView;
        preferredWidth: parent.width;
        preferredHeight: parent.height;

        onTitleChanged: {
            console.debug("title changed to :"+title);
            console.debug(url);
            if(title.toLowerCase().search("nokia store") > -1) {
                console.debug("You are at ovistore "+webView.url);
                webView.stop.trigger();
                Qt.openUrlExternally(webView.url);
                appWindow.pageStack.pop();
            }
        }
    }

    Component.onCompleted: {
        console.debug("appwebview url:"+url);
    }
}

}

