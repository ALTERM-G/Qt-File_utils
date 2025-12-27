import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from backend.Controller import Controller
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath("ui/components")
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
