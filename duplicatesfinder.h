#ifndef DUPLICATESFINDER_H
#define DUPLICATESFINDER_H

#include <QObject>
#include <qqml.h>
#include "duplicates.h"

class DuplicatesFinder : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit DuplicatesFinder(QObject * parent = nullptr);
    ~DuplicatesFinder();

public slots:
    void setDirectories(QString path1, QString path2);
    void findDuplicates();
    QString getDuplicates();
private:
    Directory* dir1;
    Directory* dir2;
};

#endif // DUPLICATESFINDER_H
