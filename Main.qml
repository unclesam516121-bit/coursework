import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

ApplicationWindow {
    width: 500
    height: 500
    visible: true
    title: "Fitness centre"
    header: Row {
        Button {
            text: "Открыть файл"
            onClicked: loadDialog.open()
        }
        Button {
            text: "Сохранить"
            onClicked: saveDialog.open()
        }
        Button {
            text: "Плюс одна запись"
            onClicked: inputPopup.open()
        }
    }

    ListView {
        anchors.fill: parent
        model: myModel
        delegate: ItemDelegate {
            width: parent.width
            text: idVal + " | " + nameVal + " | " + priceVal + " руб."
            onClicked: myModel.delete_from_list(index)
        }
    }

    FileDialog {
        id: loadDialog
        onAccepted: myModel.download_from_csv(selectedFile)
    }
    FileDialog {
        id: saveDialog
        fileMode: FileDialog.SaveFile
        onAccepted: myModel.save_to_csv(selectedFile)
    }

    Dialog {
        id: inputPopup
        title: "Вводи данные сюда"
        standardButtons: Dialog.Ok | Dialog.Cancel

        Column {
            spacing: 2
            TextField { id: t1; placeholderText: "ID" }
            TextField { id: t2; placeholderText: "Имя клиента" }
            TextField { id: t3; placeholderText: "Тип" }
            TextField { id: t4; placeholderText: "Дата" }
            TextField { id: t5; placeholderText: "Цена" }
        }
        onAccepted: {
            console.log("Добавляем:", t2.text)
            myModel.add_to_list(t1.text, t2.text, t3.text, t4.text, t5.text)
        }

    }
}