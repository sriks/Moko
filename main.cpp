#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "rssmanager.h"
#include "rssparser.h"
#include "NfcMaster.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    RSSManager rssMgr;
    qmlRegisterType<RSSParser>();
    NfcMaster nfc;
    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.rootContext()->setContextProperty("engine",(QObject*)&rssMgr);
    viewer.rootContext()->setContextProperty("nfc",(QObject*)&nfc);
    viewer.setMainQmlFile(QLatin1String("qml/Moko/main.qml"));
    viewer.showExpanded();
    return app->exec();
}
