import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType

from backend.controller import Controller
from backend.FileInfo.file_info import FileHelper


def main():
    app = QGuiApplication(sys.argv)
    _qml_objects = []
    engine = QQmlApplicationEngine()
    engine.addImportPath("ui/components")
    engine.addImportPath("ui/workspaces")
    data_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "data", "Data.qml"
    )
    qmlRegisterSingletonType(QUrl.fromLocalFile(data_path), "Data", 1, 0, "Data")
    file_helper = FileHelper()
    _qml_objects.append(file_helper)
    engine.rootContext().setContextProperty("fileHelper", file_helper)
    controller = Controller()
    _qml_objects.append(controller)
    engine.rootContext().setContextProperty("controller", controller)
    engine.load("ui/main.qml")
    app.setWindowIcon(QIcon("assets/icons/icon.svg"))
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
