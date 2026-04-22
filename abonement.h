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

struct Abon
{
    QString ID;
    QString client_name;
    QString abonement_type;
    QString date_of_expiration;
    int price;
};

struct Tren
{
    int id;
    QString name;
    QString muscle_group;
    QHash<QString, QList<QString>> arr
        {
            {"Full_Body", {"Dumbbell Burpee", "Dumbbell Overhead Carry", "Medicine ball slam", "Jumping jack"}},
            {"Arms_Only", {"Chest Fly", "Dips", "bench press", "Pull-up"}},
            {"Legs_Only", {"Leg press", "Leg extension", "Wall sit", "Squat"}}
        };
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

class Trenagers : public QAbstractListModel
{
    Q_OBJECT
    QList<Tren> abonement;
public:
    enum Trenagers_Roles
    {
        Id_Role = Qt::UserRole + 1,
        Name_Role,
        Muscle_Group_Role,
        Data_Role
    };
    Trenagers(QObject *parent = nullptr) : QAbstractListModel(parent)
    {
        Tren t1;
        t1.id = 1;
        t1.name = "Full_Body";
        t1.muscle_group = "Whole Body";
        abonement.append(t1);
        Tren t2;
        t2.id = 2;
        t2.name = "Arms_Only";
        t2.muscle_group = "Upper Body";
        abonement.append(t2);
        Tren t3;
        t3.id = 3;
        t3.name = "Legs_Only";
        t3.muscle_group = "Lower Body";
        abonement.append(t3);
    }
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
};

#endif // ABONEMENT_H