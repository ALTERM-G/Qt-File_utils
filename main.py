import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from backend.Controller import Controller
from backend.FileHelper import FileHelper
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PySide6.QtCore import QUrl

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath("ui/components")
    engine.addImportPath("ui/workspaces")
    data_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "Data.qml")
    qmlRegisterSingletonType(QUrl.fromLocalFile(data_path), "Data", 1, 0, "Data")
    file_helper = FileHelper()
    engine.rootContext().setContextProperty("fileHelper", file_helper)
    controller = Controller()
    engine.rootContext().setContextProperty("controller", controller)
    engine.load("ui/main.qml")
    app.setWindowIcon(QIcon("assets/icon.svg"))
    if not engine.rootObjects():
        sys.exit(-1)

    def cleanup():
        controller.deleteLater()
        engine.deleteLater()

    app.aboutToQuit.connect(cleanup)
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
