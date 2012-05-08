#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QtDeclarative>
#include <QDebug>
#include <QUrl>
#include "qmlapplicationviewer.h"
#include "rssmanager.h"
#include "rssparser.h"
#include "NfcMaster.h"
#if defined(DC_HARMATTAN)
#include "ShareUi.h"
#include "meventfeed.h"
#endif

const QString APPNAME("MokoApp");

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    RSSManager rssMgr(APPNAME);
    qmlRegisterType<RSSParser>();
    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.rootContext()->setContextProperty("engine",(QObject*)&rssMgr);
#if defined(DC_HARMATTAN)
    ShareUi shareui;
    viewer.rootContext()->setContextProperty("shareui",(QObject*)&shareui);
#endif
    viewer.setMainQmlFile(QLatin1String("qml/Moko/main.qml"));
    viewer.showExpanded();
    return app->exec();
}
