import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow
{
    id: window
    width: 800
    height: 600
    visible: true
    title: "Fitness subscriptions"
    property string currentSelectedType: ""

    FileDialog
    {
        id: openDlg
        title: "Открыть CSV"
        fileMode: FileDialog.OpenFile
        onAccepted: abonements.download_from_csv(selectedFile)
    }

    FileDialog
    {
        id: saveDlg
        title: "Сохранить CSV"
        fileMode: FileDialog.SaveFile
        onAccepted: abonements.save_to_csv(selectedFile)
    }

    header: ToolBar
    {
        RowLayout
        {
            anchors.fill: parent
            spacing: 10
            Button
            {
                text: "Открыть";
                onClicked: openDlg.open()
            }
            Button
            {
                text: "Сохранить";
                onClicked: saveDlg.open()
            }
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

//Abonements
        Label
        {
            text: "Абонементы";
            font.pixelSize: 16
        }
        Frame
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: 0
            ListView
            {
                id: subList
                anchors.fill: parent
                clip: true
                model: abonements
                highlight: Rectangle
                {
                    color: "#e0e0e0";
                    radius: 5
                }
                focus: true
                delegate: ItemDelegate
                {
                    width: subList.width
                    height: 40
                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 20
                        Text
                        {
                            text: idVal;
                            Layout.preferredWidth: 30
                        }
                        Text
                        {
                            text: nameVal;
                            Layout.fillWidth: true
                        }
                        Text
                        {
                            text: typeVal;
                            Layout.preferredWidth: 100
                        }
                        Text
                        {
                            text: dateVal;
                            Layout.preferredWidth: 80
                        }
                        Text
                        {
                            text: priceVal + " руб.";
                            Layout.preferredWidth: 80
                        }
                    }

                    onClicked:
                    {
                        subList.currentIndex = index
                        window.currentSelectedType = typeVal
                        f1.text = idVal;
                        f2.text = nameVal;
                        f3.text = typeVal
                        f4.text = dateVal;
                        f5.text = priceVal
                        exerciseList.forceLayout()
                    }
                }
            }
        }
        Label
        {
            text: "упражнения"
            font.pixelSize: 16
        }
        Frame
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: 0
            ListView
            {
                id: exerciseList
                anchors.fill: parent
                clip: true
                model: trenagers
                delegate: Item
                {
                    width: parent.width
                    height: nameVal === window.currentSelectedType ? contentCol.implicitHeight + 10 : 0
                    visible: height > 0
                    Column
                    {
                        id: contentCol
                        width: parent.width
                        padding: 5
                        spacing: 2
                        Text
                        {
                            text: nameVal + " (" + MuscleGroupVal + ")"
                            font.pixelSize: 14
                        }
                        Repeater
                        {
                            model: dataVal
                            delegate: Text
                            {
                                text: modelData
                                font.pixelSize: 12
                                leftPadding: 10
                                width: parent.width
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
                Label
                {
                    anchors.centerIn: parent
                    text: "Выберите абонемент"
                    color: "gray"
                    visible: exerciseList.count === 0 || !window.currentSelectedType
                }
            }
        }
        Rectangle
        {
            Layout.fillWidth: true
            height: 140
            color: "#f5f5f5"
            border.color: "#ddd"
            radius: 5
            GridLayout
            {
                anchors.fill: parent
                columns: 6
                rowSpacing: 10

                TextField
                {
                    id: f1;
                    placeholderText: "ID";
                    Layout.preferredWidth: 50
                }
                TextField
                {
                    id: f2;
                    placeholderText: "Имя";
                    Layout.fillWidth: true
                }
                TextField
                {
                    id: f3;
                    placeholderText: "Тип";
                    Layout.preferredWidth: 100
                }
                TextField
                {
                    id: f4;
                    placeholderText: "Дата";
                    Layout.preferredWidth: 90
                }
                TextField
                {
                    id: f5;
                    placeholderText: "Цена";
                    Layout.preferredWidth: 70
                }

                ColumnLayout
                {
                    spacing: 5
                    Button
                    {
                        text: "Добавить"
                        highlighted: true
                        Layout.fillWidth: true
                        onClicked: abonements.add_to_list(f1.text, f2.text, f3.text, f4.text, f5.text)
                    }

                    Button
                    {
                        text: "Изменить"
                        Layout.fillWidth: true
                        enabled: subList.currentIndex !== -1
                        onClicked:
                        {
                            var idx = subList.currentIndex
                            abonements.change_list(idx, 1, f1.text)
                            abonements.change_list(idx, 2, f2.text)
                            abonements.change_list(idx, 3, f3.text)
                            abonements.change_list(idx, 4, f4.text)
                            abonements.change_list(idx, 5, f5.text)
                            window.currentSelectedType = f3.text
                        }
                    }

                    Button
                    {
                        text: "Удалить"
                        Layout.fillWidth: true
                        onClicked: abonements.delete_from_list(subList.currentIndex)
                    }
                }
            }
        }

    }
}
