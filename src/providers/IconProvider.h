#ifndef ICONPROVIDER_H
#define ICONPROVIDER_H

#include <QQuickImageProvider>
#include <QIcon>
#include <QPixmap>

/**
 * IconProvider - Load freedesktop icons for QML
 * 
 * Usage in QML:
 *   source: "image://icon/system-software-update"
 *   source: "image://icon/preferences-desktop-theme"
 */
class IconProvider : public QQuickImageProvider {
public:
    IconProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap) {}
    
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override {
        int width = requestedSize.width() > 0 ? requestedSize.width() : 64;
        int height = requestedSize.height() > 0 ? requestedSize.height() : 64;
        
        // Load icon from system theme
        QIcon icon = QIcon::fromTheme(id, QIcon::fromTheme("application-x-executable"));
        QPixmap pixmap = icon.pixmap(width, height);
        
        if (size) {
            *size = pixmap.size();
        }
        
        return pixmap;
    }
};

#endif // ICONPROVIDER_H
