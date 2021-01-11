#include "duplicatesfinder.h"

DuplicatesFinder::DuplicatesFinder(QObject * parent) : QObject(parent){

}

DuplicatesFinder::~DuplicatesFinder()
{
    delete this->dir1;
    delete this->dir2;
}

void DuplicatesFinder::setDirectories(QString path1, QString path2)
{
    this->dir1 = new Directory(fs::path(path1.toStdString()));
    this->dir2 = new Directory(fs::path(path2.toStdString()));
}

void DuplicatesFinder::findDuplicates()
{
    this->dir1->findDuplicates(this->dir2);
}

QString DuplicatesFinder::getDuplicates()
{
    QString output;
    auto duplicates = this->dir1->getDuplicates();
    std::cout << duplicates.size() << " duplicates found:" << std::endl;
    output.append(QString::number(duplicates.size()));
    output.append(" duplicates found:\n");
    for (auto it = duplicates.begin(); it != duplicates.end(); ++it)
    {
        output.append(QString::fromUtf8(std::string(it->first->getPath().generic_string()).c_str())); // I'm sorry for that ...
        output.append("\n");
        output.append(QString::fromUtf8(std::string(it->second->getPath().generic_string()).c_str()));
        output.append("\n\n");
    }
    return output;
}
