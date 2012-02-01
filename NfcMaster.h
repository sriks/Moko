#ifndef NFCMASTER_H
#define NFCMASTER_H

#include <QObject>
#include <QVariant>
#include <QNearFieldTarget>
#include <QLlcpSocket>

QTM_USE_NAMESPACE

class NfcMasterPrivate;
class NfcMaster : public QObject
{
    Q_OBJECT
public:
    explicit NfcMaster(QObject *parent = 0);
    ~NfcMaster();
signals:
    
public slots:
    void start(QVariant msgToWrite);
    void onTargetDetected(QNearFieldTarget* target);
    void onTargetLost(QNearFieldTarget* target);
    void onSocketError(QLlcpSocket::SocketError socketError);
    void onSocketConnected();
private:
    NfcMasterPrivate* d;
};

#endif // NFCMASTER_H
