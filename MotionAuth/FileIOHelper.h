#ifndef FILEIOHELPER_H
#define FILEIOHELPER_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDebug>

class FileIOHelper : public QObject
{
    Q_OBJECT
public:
    explicit FileIOHelper(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void saveToFile(const QString &filePath, const QString &data) {
        QString path;
#if defined(Q_OS_ANDROID)
        path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" + filePath;
#else
        path = filePath;
#endif

        QFile file(path);
        if (file.open(QIODevice::WriteOnly)) {
            QTextStream out(&file);
            out << data;
            file.close();
        } else {
            qDebug() << "Failed to open file for writing:" << path;
        }
    }
};

#endif // FILEIOHELPER_H
