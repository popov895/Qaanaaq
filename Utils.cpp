#include "Utils.h"

#include <QFileInfo>
#include <QGuiApplication>
#include <QMimeDatabase>
#include <QProcess>

// Utils

Utils::Utils()
    : QObject()
{}

Utils* Utils::instance()
{
    static Utils instance;

    return (&instance);
}

bool Utils::isFolder(const QUrl &url) const
{
    if (url.isValid() && url.isLocalFile())
        return QFileInfo(url.toLocalFile()).isDir();

    return false;
}

bool Utils::isMimeTypeSupported(const QUrl &url) const
{
    if (url.isValid() && url.isLocalFile()) {
        static QMimeDatabase mimeDatabase;
        static const QStringList supportedMimeTypes {
            "image/bmp",
            "image/gif",
            "image/jpeg",
            "image/png",
            "image/svg+xml",
            "image/svg+xml-compressed",
            "image/vnd.microsoft.icon",
            "inode/directory"
        };

        return (supportedMimeTypes.indexOf(mimeDatabase.mimeTypeForUrl(url).name()) > -1);
    }

    return false;
}

QUrl Utils::getAbsolutePath(const QUrl &url) const
{
    if (url.isValid() && url.isLocalFile())
        return QUrl::fromLocalFile(QFileInfo(url.toLocalFile()).absolutePath());

    return QUrl();
}

void Utils::openInNewWindow(const QUrl &url) const
{
    QProcess::startDetached(QGuiApplication::applicationFilePath(), QStringList { url.toLocalFile() });
}
