import os
import subprocess
import zipfile

from PIL import Image
from pypdf import PdfReader
from PySide6.QtCore import QDateTime, QObject, Slot


class FileHelper(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

    def _format_size(self, size_bytes):
        if size_bytes < 1024:
            return f"{size_bytes} bytes"
        elif size_bytes < 1024**2:
            return f"{size_bytes / 1024:.2f} KB"
        elif size_bytes < 1024**3:
            return f"{size_bytes / 1024**2:.2f} MB"
        elif size_bytes < 1024**4:
            return f"{size_bytes / 1024**3:.2f} GB"
        else:
            return f"{size_bytes / 1024**4:.2f} TB"

    @Slot(str, result=str)
    def fileSize(self, path):
        try:
            size_bytes = os.path.getsize(path)
            return self._format_size(size_bytes)
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

    @Slot(str, result="QVariant")
    def getInfo(self, path):
        info = {
            "path": path,
            "name": "",
            "extension": "",
            "size": "Unknown",
            "lastModified": "Unknown",
            "created": "Unknown",
            "isCorrupted": "Unknown",
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
            info["isCorrupted"] = self.isCorrupted(local)

            try:
                size_bytes = os.path.getsize(local)
                info["size"] = self._format_size(size_bytes)
            except Exception:
                info["size"] = "Unknown"

            try:
                ts = os.path.getmtime(local)
                info["lastModified"] = QDateTime.fromSecsSinceEpoch(int(ts)).toString(
                    "yyyy-MM-dd hh:mm:ss"
                )
            except Exception:
                info["lastModified"] = "Unknown"

            try:
                cts = os.path.getctime(local)
                info["created"] = QDateTime.fromSecsSinceEpoch(int(cts)).toString(
                    "yyyy-MM-dd hh:mm:ss"
                )
            except Exception:
                info["created"] = "Unknown"

        except Exception:
            pass

        return info
