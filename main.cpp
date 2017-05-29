#include <QCommandLineParser>
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "Utils.h"

int main(int argc, char *argv[])
{
    QGuiApplication application(argc, argv);
    application.setApplicationName(QStringLiteral("Qaanaaq"));
    application.setOrganizationName(QStringLiteral("popov895"));
    application.setWindowIcon(QIcon(QStringLiteral(":/resources/icons/application.svgz")));

    auto url = QUrl::fromLocalFile(application.applicationDirPath());
    QCommandLineParser parser;
    parser.process(application);
    auto arguments = parser.positionalArguments();
    if (!arguments.isEmpty())
        url = QUrl::fromLocalFile(arguments.first());

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("ApplicationName"), application.applicationName());
    engine.rootContext()->setContextProperty(QStringLiteral("InitUrl"), url);
    engine.rootContext()->setContextProperty("Utils", Utils::instance());
    engine.load(QUrl(QStringLiteral("qrc:/resources/qml/main.qml")));

    return application.exec();
}
