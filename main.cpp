#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <abonement.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    Manager m;
    Trenagers t;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("abonements", &m);
    engine.rootContext()->setContextProperty("trenagers", &t);
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