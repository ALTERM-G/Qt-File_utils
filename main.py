import os
import sys

from PySide6.QtCore import QUrl
from PySide6.QtGui import QFontDatabase, QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent

from backend.controller import Controller
from backend.FileInfo.file_info import FileHelper

_qml_objects = []

def load_qml(engine, filename, context_name):
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), filename)

    if os.path.exists(path):
        component = QQmlComponent(engine, QUrl.fromLocalFile(path))
        obj = component.create()

        if obj:
            engine.rootContext().setContextProperty(context_name, obj)
            return obj
        else:
            print(f"Error loading {filename}")
            for error in component.errors():
                print(error.toString())
    else:
        print(f"Missing QML file: {path}")

    return None


def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    base = os.path.dirname(os.path.abspath(__file__))
    engine.addImportPath(os.path.join(base, "ui"))
    engine.addImportPath(os.path.join(base, "ui/components"))
    engine.addImportPath(os.path.join(base, "ui/workspaces"))

    # ---------------- Fonts ----------------
    font_dir = os.path.join(base, "assets", "fonts")
    if os.path.exists(font_dir):
        for font in os.listdir(font_dir):
            if font.endswith(".ttf"):
                QFontDatabase.addApplicationFont(os.path.join(font_dir, font))

    # ---------------- App Icon ----------------
    app.setWindowIcon(QIcon(os.path.join(base, "assets/icons/icon.svg")))

    # ---------------- Load QML singletons ----------------
    qml_singletons = [
        ("Theme", "data/ui/Theme.qml"),
        ("Data", "data/Data.qml"),
        ("Typography", "data/ui/Typography.qml"),
        ("AppConfig", "data/ui/AppConfig.qml"),
        ("Metrics", "data/ui/Metrics.qml")
    ]

    qml_objects = {}

    for name, path in qml_singletons:
        qml_objects[name] = load_qml(engine, path, name)

    # ---------------- Backend ----------------
    controller = Controller()
    file_helper = FileHelper()
    _qml_objects.extend([controller, file_helper])
    engine.rootContext().setContextProperty("controller", controller)
    engine.rootContext().setContextProperty("fileHelper", file_helper)

    # ---------------- Load main.qml ----------------
    main_qml = os.path.join(base, "ui", "main.qml")
    engine.load(QUrl.fromLocalFile(main_qml))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
