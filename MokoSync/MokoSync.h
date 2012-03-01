#ifndef MOKOSYNC_H
#define MOKOSYNC_H

#include <libsyncpluginmgr/ClientPlugin.h>
#include <libsyncprofile/SyncResults.h>
#include <libsyncpluginmgr/PluginCbInterface.h>
#include <QVariant>
#include <QUrl>
#include "MokoSync_global.h"

class MokoSyncPrivate;
class MOKOSYNCSHARED_EXPORT MokoSync : public Buteo::ClientPlugin {
    Q_OBJECT
public:
    MokoSync(const QString& aPluginName,
                const Buteo::SyncProfile& aProfile,
                Buteo::PluginCbInterface *aCbInterface);
    virtual ~MokoSync();

    // From ClientPlugin
    virtual bool startSync();

    // From SyncPluginBase
    virtual bool init();
    virtual bool uninit();

public slots:
    // From SyncPluginBase
    virtual void connectivityStateChanged( Sync::ConnectivityType aType, bool aState );
    virtual void onUpdateAvailable(QUrl url,int newItems);
private:
    MokoSyncPrivate* d;
};

extern "C" MokoSync* createPlugin(const QString& aPluginName,
                                     const Buteo::SyncProfile& aProfile,
                                     Buteo::PluginCbInterface *aCbInterface);
extern "C" void destroyPlugin(MokoSync* aClient);
#endif // MOKOSYNC_H
