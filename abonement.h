#ifndef ABONEMENT_H
#define ABONEMENT_H
#include <QGuiApplication>
#include <QList>
#include <QString>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QAbstractListModel>
#include <QObject>

struct Abon {
    QString ID;
    QString client_name;
    QString abonement_type;
    QString date_of_expiration;
    int price;
};

class Manager : public QAbstractListModel
{
    Q_OBJECT
    QList<Abon> subscription;
public:
    enum Abon_Roles
    {
        Id_Role = Qt::UserRole + 1,
        Name_Role,
        Type_Role,
        Date_Role,
        Price_Role
    };

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE void save_to_csv(const QString &file_path);
    Q_INVOKABLE void delete_from_list(int id);
    Q_INVOKABLE void add_to_list(QString id, QString name, QString type, QString date, QString price);
    Q_INVOKABLE void change_list(int id, int position, QString new_value);
    Q_INVOKABLE void download_from_csv(const QString &file_path);
};

#endif // ABONEMENT_H