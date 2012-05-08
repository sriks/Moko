# Moko Container pro
# Srikanth Sombhatla
# srikanthsombhatla@gmail.com
# Dreamcode 2012

TEMPLATE = subdirs
SUBDIRS += Moko.pro
# Required to run on Simulator
contains(MEEGO_EDITION,harmattan) {
    SUBDIRS += MokoSync/MokoSync.pro
}
