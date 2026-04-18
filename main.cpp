#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <abonement.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    qputenv("QT_QPA_PLATFORM", "wayland;xcb");
    QGuiApplication app(argc, argv);
    Manager m;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("myModel", &m);
    const QUrl url(QStringLiteral("qrc:/qt/qml/coursework1/Main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl)
        {
            if (!obj && url == objUrl)
            {
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}