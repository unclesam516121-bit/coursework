#include "abonement.h"
#include <QUrl>

QVariant Trenagers::data(const QModelIndex &index, int role) const
{
    const Tren &item = abonement[index.row()];
    if(index.isValid() && index.row() < abonement.size())
    {
        switch (role)
        {
        case Id_Role:
            return abonement[index.row()].id;
        case Name_Role:
            return abonement[index.row()].name;
        case Muscle_Group_Role:
            return abonement[index.row()].muscle_group;
        case Data_Role:
            return QStringList(item.arr.value(item.name));
        }
    }
    return QVariant();
}

int Trenagers::rowCount(const QModelIndex &parent) const
{
    return abonement.size();
}

QHash<int, QByteArray> Trenagers::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id_Role] = "idVal";
    roles[Name_Role] = "nameVal";
    roles[Muscle_Group_Role] = "MuscleGroupVal";
    roles[Data_Role] = "dataVal";
    return roles;
}

QHash<int, QByteArray> Manager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Id_Role] = "idVal";
    roles[Name_Role] = "nameVal";
    roles[Type_Role] = "typeVal";
    roles[Date_Role] = "dateVal";
    roles[Price_Role] = "priceVal";
    return roles;
}

int Manager::rowCount(const QModelIndex &parent) const
{
    return subscription.size();
}

QVariant Manager::data(const QModelIndex &index, int role) const
{
    if(index.isValid() && index.row() < subscription.size())
    {
        switch (role)
        {
        case Id_Role:
            return subscription[index.row()].ID;
        case Name_Role:
            return subscription[index.row()].client_name;
        case Type_Role:
            return subscription[index.row()].abonement_type;
        case Date_Role:
            return subscription[index.row()].date_of_expiration;
        case Price_Role:
            return subscription[index.row()].price;
        }
    }
    return QVariant();
}

void Manager::save_to_csv(const QString &file_path)
{
    QUrl url(file_path);
    QString path = url.isLocalFile() ? url.toLocalFile() : file_path;
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        return;
    QTextStream out(&file);
    for(Abon &ab : subscription)
    {
        out << ab.ID << "," << ab.client_name << "," << ab.abonement_type << "," << ab.date_of_expiration << "," << ab.price << "\n";
    }
}

void Manager::delete_from_list(int id)
{
    if(id >= 0 && id < subscription.size())
    {
        beginRemoveRows(QModelIndex(), id, id);
        subscription.removeAt(id);
        endRemoveRows();
    }
}

void Manager::add_to_list(QString id, QString name, QString type, QString date, QString price)
{
    beginInsertRows(QModelIndex(), subscription.size(), subscription.size());
    subscription.append({id, name, type, date, price.toInt()});
    endInsertRows();
}

void Manager::change_list(int id, int position, QString new_value)
{
    if(id >= 0 && id < subscription.size() && position <= 5)
    {
        switch (position)
        {
        case 1:
            subscription[id].ID = new_value;
            break;
        case 2:
            subscription[id].client_name = new_value;
            break;
        case 3:
            subscription[id].abonement_type = new_value;
            break;
        case 4:
            subscription[id].date_of_expiration = new_value;
            break;
        case 5:
            subscription[id].price = new_value.toInt();
            break;
        }
        QModelIndex modelIndex = index(id);
        emit dataChanged(modelIndex, modelIndex);
    }
}

void Manager::download_from_csv(const QString &file_path)
{
    QUrl url(file_path);
    QString path = url.isLocalFile() ? url.toLocalFile() : file_path;
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;
    beginResetModel();
    subscription.clear();
    QTextStream out(&file);
    QString line;
    while(out.readLineInto(&line))
    {
        QStringList list = line.split(u',');
        if(list.size() == 5)
        {
            Abon item;
            item.ID = list[0];
            item.client_name = list[1];
            item.abonement_type = list[2];
            item.date_of_expiration = list[3];
            item.price = list[4].toInt();
            subscription.append(item);
        }
    }
    endResetModel();
    file.close();
}



