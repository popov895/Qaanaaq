#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QUrl>

// Utils
class Utils : public QObject
{
    Q_OBJECT

private:
    Utils();

public:
    static Utils* instance();

    Q_INVOKABLE bool isFolder(const QUrl &url) const;
    Q_INVOKABLE bool isMimeTypeSupported(const QUrl &url) const;
    Q_INVOKABLE QUrl getAbsolutePath(const QUrl &url) const;
    Q_INVOKABLE void openInNewWindow(const QUrl &url) const;
};

#endif // UTILS_H
