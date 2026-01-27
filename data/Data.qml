pragma Singleton
import QtQuick

QtObject {
   readonly property var extensionToTypeMap: ({
        // Documents
        "txt": "Document",
        "md": "Document",
        "html": "Document",
        "htm": "Document",
        "rtf": "Document",
        "csv": "Document",
        "doc": "Document",
        "docx": "Document",
        "odt": "Document",
        "pdf": "Document",
        "ppt": "Document",
        "pptx": "Document",
        "xls": "Document",
        "xlsx": "Document",
        "log": "Log",
        "json": "Document",
        "xml": "Document",

        // Images
        "png": "Image",
        "jpg": "Image",
        "jpeg": "Image",
        "gif": "Image",
        "bmp": "Image",
        "webp": "Image",
        "tiff": "Image",
        "heic": "Image",

        // Vector
        "svg": "Vector",
        "eps": "Vector",
        "ai": "Vector",

        // Video
        "mp4": "Video",
        "mkv": "Video",
        "avi": "Video",
        "mov": "Video",
        "wmv": "Video",
        "flv": "Video",
        "webm": "Video",
        "m4v": "Video",

        // Audio
        "mp3": "Audio",
        "wav": "Audio",
        "flac": "Audio",
        "ogg": "Audio",
        "m4a": "Audio",
        "aac": "Audio",
        "wma": "Audio",

        // Archives
        "zip": "Archive",
        "rar": "Archive",
        "7z": "Archive",
        "tar": "Archive",
        "gz": "Archive",
        "bz2": "Archive",
        "xz": "Archive",

        // Code
        "py": "Code",
        "js": "Code",
        "ts": "Code",
        "java": "Code",
        "c": "Code",
        "cpp": "Code",
        "h": "Code",
        "cs": "Code",
        "php": "Code",
        "rb": "Code",
        "sh": "Code",
        "bat": "Code",
        "pl": "Code",
        "go": "Code",
        "rs": "Code",

        // System
        "iso": "DiskImage",
        "img": "DiskImage",
        "sys": "System",
        "dll": "System",
        "exe": "System",
        "bin": "System",
        "apk": "System",

        // Fonts
        "ttf": "Font",
        "otf": "Font",
        "woff": "Font",
        "woff2": "Font"
    })

    readonly property var workspaceTitles: ([
        "Convert Files",
        "Compress Files",
        "Extract Media Files",
        "File Info"
    ])

    function getOutputFormats(type) {
        var formats = []
        if (type === "Video")
            formats = [".mp4", ".mkv", ".avi", ".mov"]
        else if (type === "Vector")
            formats = [".svg", ".pdf", ".png", ".eps"]
        else if (type === "Image")
            formats = [".png", ".jpg", ".webp", ".bmp"]
        else if (type === "Audio")
            formats = [".mp3", ".wav", ".flac", ".ogg", ".aac", ".m4a", ".opus"]
        else if (type === "Document")
            formats = [".txt", ".md", ".html", ".rtf", ".csv", ".docx", ".pdf"]
        
        return formats
    }

    function getFileType(path) {
        var ext = path.split(".").pop().toLowerCase()
        return extensionToTypeMap[ext]
    }
}
