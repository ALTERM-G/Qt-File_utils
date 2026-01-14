import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QIcon, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent

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

    # --- Load Data.qml ---
    data_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "Data.qml")
    data_component = QQmlComponent(engine, QUrl.fromLocalFile(data_path))
    data_object = data_component.create()
    engine.rootContext().setContextProperty("Data", data_object)

    assets_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets")
    font_dir = os.path.join(assets_path, "fonts")
    for font_filename in os.listdir(font_dir):
        if font_filename.endswith(".ttf"):
            font_path = os.path.join(font_dir, font_filename)
            font_id = QFontDatabase.addApplicationFont(font_path)
            family = QFontDatabase.applicationFontFamilies(font_id)[0]

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
