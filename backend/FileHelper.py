import os
from PySide6.QtCore import QObject, Slot, QDateTime

class FileHelper(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

    @Slot(str, result=str)
    def fileSize(self, path):
        try:
            return f"{os.path.getsize(path)} bytes"
        except Exception:
            return "Unknown"

    @Slot(str, result=str)
    def lastModified(self, path):
        try:
            ts = os.path.getmtime(path)
            dt = QDateTime.fromSecsSinceEpoch(int(ts))
            return dt.toString("yyyy-MM-dd hh:mm:ss")
        except Exception:
            return "Unknown"

    @Slot(str, result='QVariant')
    def getInfo(self, path):
        info = {
            "path": path,
            "name": "",
            "extension": "",
            "size": "Unknown",
            "lastModified": "Unknown"
        }
        try:
            if not path:
                return info

            if path.startswith("file:///"):
                local = path[7:]
            elif path.startswith("file://"):
                local = path[6:]
            else:
                local = path

            name = os.path.basename(local)
            root, ext = os.path.splitext(name)
            ext = ext.lstrip(".").lower()

            info["path"] = local
            info["name"] = name
            info["extension"] = ext
            try:
                info["size"] = f"{os.path.getsize(local)} bytes"
            except Exception:
                info["size"] = "Unknown"

            try:
                ts = os.path.getmtime(local)
                info["lastModified"] = QDateTime.fromSecsSinceEpoch(int(ts)).toString("yyyy-MM-dd hh:mm:ss")
            except Exception:
                info["lastModified"] = "Unknown"

        except Exception:
            pass

        return info
