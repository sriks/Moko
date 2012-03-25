#include <QDebug>
//#include <LogMacros.h>
#include <QTimer>
#include <QDateTime>
#include <QMap>
#include <QUrl>
#include <QFile>
#include <meventfeed.h>
#include "MokoSync.h"
#include "rssmanager/rssmanager.h"

const QString APPNAME("Moko");

class MokoSyncPrivate {
public:
    MokoSyncPrivate() {
        rssMgr = NULL;
        f = new QFile("/home/user/mokolog.txt");
        if(f->open(QIODevice::Append))
            writeLog(QString("New Log Starts: ") + QDateTime::currentDateTime().toString());
    }

    ~MokoSyncPrivate() {
        delete rssMgr;
        f->close();
        delete f;
    }
    void writeLog(QString msg) {
        if(f->isOpen())
            f->write(msg.toAscii());
    }

    RSSManager* rssMgr;
    QFile* f;
};

MokoSync* createPlugin(const QString& aPluginName,
                          const Buteo::SyncProfile& aProfile,
                          Buteo::PluginCbInterface *aCbInterface) {
    return new MokoSync(aPluginName,aProfile,aCbInterface);
}

void destroyPlugin(MokoSync* aClient) {
    delete aClient;
}

MokoSync::MokoSync(const QString& aPluginName,
            const Buteo::SyncProfile& aProfile,
            Buteo::PluginCbInterface *aCbInterface) :
    Buteo::ClientPlugin(aPluginName,aProfile,aCbInterface) {
    d = new MokoSyncPrivate;
}

MokoSync::~MokoSync() {
    delete d;
}

bool MokoSync::startSync() {
    d->writeLog(QString("\nMokoSync::startSync()"));
    QTimer::singleShot(100,d->rssMgr,SLOT(updateAll()));
    return true;
}

bool MokoSync::init() {
    d->writeLog("\ninit()");
    if(!d->rssMgr)
        d->rssMgr = new RSSManager(APPNAME,this);
    QObject::connect(d->rssMgr,SIGNAL(updateAvailable(QUrl,int)),
                     this,SLOT(onUpdateAvailable(QUrl,int)));
    d->rssMgr->restoreState();
    return true;
}

bool MokoSync::uninit() {
    return true;
}

void MokoSync::connectivityStateChanged(Sync::ConnectivityType aType, bool aState) {
    qDebug()<<Q_FUNC_INFO;
}

void MokoSync::onUpdateAvailable(QUrl url, int newItems) {
    Q_UNUSED(url)
    d->writeLog(QString("\nMokoSync::onUpdateAvailable:newitemscount:")+QString().setNum(newItems));
    if(newItems) {
        QString msg = QString().setNum(newItems) + " new app(s) available for your phone.";
        qlonglong id = -1;
        MEventFeed::instance()->removeItemsBySourceName("mokosync");
        id = MEventFeed::instance()->addItem(QString("/usr/share/icons/hicolor/80x80/apps/Moko80.png"),
                              QString("Moko"),
                              msg,
                              QStringList(),
                              QDateTime::currentDateTime(),
                              QString(),
                              false,
                              QUrl("moko://latest"),
                              QString("mokosync"),
                              QString("Moko"));

        d->writeLog("\n"+msg);
        d->writeLog(QString("\nMokoSync::updateReady: ")+QString().setNum(id));

    }

      // Always emit success.
      emit success(getProfileName(), "Success.");
//      else
//          emit error(getProfileName(), "Error.", Buteo::SyncResults::SYNC_RESULT_FAILED);
}

// eof
