#include <QNearFieldManager>
#include <QNearFieldTarget>
#include <QNdefNfcUriRecord>
#include <QNdefMessage>
#include <QLlcpSocket>
#include <QDebug>
#include <QVariant>
#include <QUrl>
#include "NfcMaster.h"
//"urn:nfc:xsn:nokia.com:moko";

struct NfcMasterPrivate {
   QNearFieldManager* nfcMgr;
   QLlcpSocket* nfcSocket;
   QVariant msg;
};

NfcMaster::NfcMaster(QObject *parent) :
    QObject(parent) {
    d = new NfcMasterPrivate;
    d->nfcMgr = NULL;
    d->nfcSocket = new QLlcpSocket(this);
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
    Q_UNUSED(started)
}

void NfcMaster::onTargetDetected(QNearFieldTarget *target) {
    qDebug()<<Q_FUNC_INFO;
    qDebug()<<Q_FUNC_INFO<<"supported accessmethods:"<<target->accessMethods();
    QNearFieldTarget::RequestId id = target->sendCommand("/usr/bin/gallery");
    qDebug()<<"req id is valid "<<id.isValid();
    // Send url to peer nfc device is not working :(
//    QUrl url = QUrl::fromUserInput(QString("www.google.com"));
//    if(url.isValid())
//        qDebug()<<Q_FUNC_INFO<<" url is valid";
//    QNdefMessage msg;
//    QNdefNfcUriRecord rec;
//    rec.setUri(url);
//    msg.append(rec);
//    QNearFieldTarget::RequestId id = target->writeNdefMessages(QList<QNdefMessage>()<<msg);
//    qDebug()<<"req id is valid "<<id.isValid();
}

void NfcMaster::onTargetLost(QNearFieldTarget *target) {
    qDebug()<<Q_FUNC_INFO;
    target->deleteLater();
}

void NfcMaster::onSocketError(QLlcpSocket::SocketError socketError) {
    qDebug()<<Q_FUNC_INFO<<socketError;
}

void NfcMaster::onSocketConnected() {
    qDebug()<<Q_FUNC_INFO;
}


// eof
