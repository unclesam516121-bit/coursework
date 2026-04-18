import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow
{
    id: window
    width: 600
    height: 500
    visible: true
    title: "Fitness subscriptions"

    FileDialog
    {
        id: openDlg
        title: "Открыть CSV"
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: myModel.download_from_csv(selectedFile.toString())
    }

    FileDialog
    {
        id: saveDlg
        title: "Сохранить CSV"
        fileMode: FileDialog.SaveFile
        onAccepted: myModel.save_to_csv(selectedFile.toString())
    }

    header: ToolBar
    {
        Row
        {
            spacing: 10
            padding: 5
            Button { text: "Открыть"; onClicked: openDlg.open() }
            Button { text: "Сохранить"; onClicked: saveDlg.open() }
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        ListView
        {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: myModel
            highlight: Rectangle { color: "lightsteelblue"; radius: 2 }
            focus: true
            delegate: ItemDelegate
            {
                width: listView.width
                contentItem: Text
                {
                    text: idVal + " | " + nameVal + " | " + typeVal + " | " + dateVal + " | " + priceVal + " руб."
                    font.pixelSize: 14
                }
                onClicked:
                {
                    listView.currentIndex = index
                    f1.text = idVal
                    f2.text = nameVal
                    f3.text = typeVal
                    f4.text = dateVal
                    f5.text = priceVal
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 120
            color: "#f0f0f0"
            border.color: "#ccc"
            radius: 5

            GridLayout
            {
                anchors.fill: parent
                anchors.margins: 10
                columns: 3
                rowSpacing: 5
                TextField { id: f1; placeholderText: "ID"; Layout.preferredWidth: 60 }
                TextField { id: f2; placeholderText: "Имя"; Layout.fillWidth: true }
                TextField { id: f3; placeholderText: "Тип"; Layout.preferredWidth: 100 }
                TextField { id: f4; placeholderText: "Дата"; Layout.preferredWidth: 100 }
                TextField { id: f5; placeholderText: "Цена"; Layout.preferredWidth: 100 }

                RowLayout
                {
                    Layout.columnSpan: 3
                    Button
                    {
                        text: "Добавить"
                        onClicked: myModel.add_to_list(f1.text, f2.text, f3.text, f4.text, f5.text)
                    }
                    Button
                    {
                        text: "Изменить"
                        enabled: listView.currentIndex !== -1
                        onClicked: {
                            myModel.change_list(listView.currentIndex, 1, f1.text)
                            myModel.change_list(listView.currentIndex, 2, f2.text)
                            myModel.change_list(listView.currentIndex, 3, f3.text)
                            myModel.change_list(listView.currentIndex, 4, f4.text)
                            myModel.change_list(listView.currentIndex, 5, f5.text)
                        }
                    }
                    Button
                    {
                        text: "Удалить"
                        onClicked: myModel.delete_from_list(listView.currentIndex)
                    }
                }
            }
        }
    }
}
