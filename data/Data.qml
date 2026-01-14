pragma Singleton
import QtQuick

QtObject {
    // --- Colors and Fonts ---
    readonly property string fontRegular: "JetBrainsMono NL"
    readonly property string fontBold: "JetBrainsMono"
    readonly property color appBackground: "#222222"
    readonly property color themeColor: "#dd1124"
    readonly property color hoverBackgroundColor: "#4b4b4b"
    readonly property color backgroundColor: "#333333"
    readonly property color backgroundColor_2: "#2a2a2a"
    readonly property color topBarColor: "#121212"
    readonly property color topBarTextColor: "#e6e6e6"
    readonly property color borderColor: "#888888"
    readonly property color textColor: "#ffffff"
    readonly property color selectedTextColor: "#000000"
    readonly property color successTextColor: "#4CAF50"

    // --- Extension to Type ---
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

    // --- Titles ---
    readonly property var workspaceTitles: ([
        "Convert Files",
        "Compress Files",
        "Extract Media Files",
        "File Info"
    ])
}
