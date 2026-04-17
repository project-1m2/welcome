#ifndef ICONPROVIDER_H
#define ICONPROVIDER_H

#include <QQuickImageProvider>
#include <QIcon>
#include <QPixmap>
#include <QImage>
#include <QFile>
#include <QDebug>

/**
 * IconProvider - Load icons with local SVG fallback
 * 
 * Priority:
 *   1. System theme icon (freedesktop)
 *   2. Local QRC SVG fallback (:/icons/name.svg)
 * 
 * Usage in QML:
 *   source: "image://icon/arrow-right"
 */
class IconProvider : public QQuickImageProvider {
public:
    IconProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap) {}
    
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override {
        int width = requestedSize.width() > 0 ? requestedSize.width() : 24;
        int height = requestedSize.height() > 0 ? requestedSize.height() : 24;
        
        QPixmap pixmap;
        
        // Try system theme first
        QIcon themeIcon = QIcon::fromTheme(id);
        if (!themeIcon.isNull() && !themeIcon.availableSizes().isEmpty()) {
            pixmap = themeIcon.pixmap(width, height);
        } else {
            // Fallback to local icon via QImage (try SVG first, then PNG)
            QString svgPath = QString(":/icons/%1.svg").arg(id);
            QString pngPath = QString(":/icons/%1.png").arg(id);
            
            QString iconPath;
            if (QFile::exists(svgPath)) {
                iconPath = svgPath;
            } else if (QFile::exists(pngPath)) {
                iconPath = pngPath;
            }
            
            if (!iconPath.isEmpty()) {
                QImage img(iconPath);
                if (!img.isNull()) {
                    pixmap = QPixmap::fromImage(img.scaled(width, height, 
                        Qt::KeepAspectRatio, Qt::SmoothTransformation));
                }
            } 
            
            // If still empty, create a placeholder
            if (pixmap.isNull()) {
                pixmap = QPixmap(width, height);
                pixmap.fill(Qt::transparent);
                qDebug() << "IconProvider: Icon not found:" << id;
            }
        }
        
        if (size) {
            *size = pixmap.size();
        }
        
        return pixmap;
    }
};

#endif // ICONPROVIDER_H
