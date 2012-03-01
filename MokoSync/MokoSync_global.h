#ifndef MOKOSYNC_GLOBAL_H
#define MOKOSYNC_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(MOKOSYNC_LIBRARY)
#  define MOKOSYNCSHARED_EXPORT Q_DECL_EXPORT
#else
#  define MOKOSYNCSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // MOKOSYNC_GLOBAL_H
