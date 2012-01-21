#include <QNearFieldManager>
#include <QNearFieldTarget>
#include <QNdefNfcUriRecord>
#include <QNdefMessage>
#include <QDebug>
#include <QVariant>
#include <QUrl>
#include "NfcMaster.h"

struct NfcMasterPrivate {
   QNearFieldManager* nfcMgr;
   QVariant msg;
};

NfcMaster::NfcMaster(QObject *parent) :
    QObject(parent) {
    d = new NfcMasterPrivate;
    d->nfcMgr = NULL;
}

NfcMaster::~NfcMaster() {
    delete d;
}

void NfcMaster::start(QVariant msgToWrite) {
    qDebug()<<Q_FUNC_INFO<<msgToWrite;
    d->msg = msgToWrite;

    if(!d->nfcMgr) {
        d->nfcMgr = new QNearFieldManager(this);
        connect(d->nfcMgr,SIGNAL(targetDetected(QNearFieldTarget*)),
                this,SLOT(onTargetDetected(QNearFieldTarget*)),
                Qt::UniqueConnection);

        connect(d->nfcMgr,SIGNAL(targetLost(QNearFieldTarget*)),
                this,SLOT(onTargetLost(QNearFieldTarget*)),
                Qt::UniqueConnection);
    }
    bool started = d->nfcMgr->startTargetDetection();
    qDebug()<<Q_FUNC_INFO<<" target request is "+started;
}

void NfcMaster::onTargetDetected(QNearFieldTarget *target) {
    qDebug()<<Q_FUNC_INFO;
//    qDebug()<<Q_FUNC_INFO<<"supported accessmethods:"<<target->accessMethods();
//    qDebug()<<Q_FUNC_INFO<<"target url:"<<target->url();
//    target->sendCommand("www.google.com");
    QUrl url = QUrl::fromUserInput(QString("www.google.com"));
    if(url.isValid())
        qDebug()<<Q_FUNC_INFO<<" url is valid";
    QNdefMessage msg;
    QNdefNfcUriRecord rec;
    rec.setUri(url);
    msg.append(rec);
    qDebug()<<Q_FUNC_INFO<<" msg is: "<<msg.toByteArray();
    QNearFieldTarget::RequestId id = target->writeNdefMessages(QList<QNdefMessage>()<<msg);
    qDebug()<<"req id is valid "<<id.isValid();
}

void NfcMaster::onTargetLost(QNearFieldTarget *target) {
    qDebug()<<Q_FUNC_INFO;
    target->deleteLater();
}


// eof
