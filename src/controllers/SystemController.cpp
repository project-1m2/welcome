/**
 * SystemController implementation
 */

#include "SystemController.h"
#include <QStandardPaths>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QDesktopServices>
#include <QUrl>
#include <QTextStream>

SystemController::SystemController(QObject *parent)
    : QObject(parent)
{
    // Check autostart status
    m_autostartEnabled = QFile::exists(getAutostartPath());
    
    // Read OS version
    QFile osRelease("/etc/os-release");
    if (osRelease.open(QIODevice::ReadOnly)) {
        QTextStream stream(&osRelease);
        while (!stream.atEnd()) {
            QString line = stream.readLine();
            if (line.startsWith("PRETTY_NAME=")) {
                m_osVersion = line.mid(13).remove('"');
                break;
            }
        }
        osRelease.close();
    }
    
    // Get KDE version
    QProcess kdeVersion;
    kdeVersion.start("plasmashell", QStringList() << "--version");
    if (kdeVersion.waitForFinished(2000)) {
        QString output = QString::fromUtf8(kdeVersion.readAllStandardOutput()).trimmed();
        if (output.contains("plasmashell")) {
            m_kdeVersion = output.split(' ').last();
        }
    }
}

bool SystemController::autostartEnabled() const
{
    return m_autostartEnabled;
}

QString SystemController::osVersion() const
{
    return m_osVersion.isEmpty() ? "TigerOS" : m_osVersion;
}

QString SystemController::kdeVersion() const
{
    return m_kdeVersion.isEmpty() ? "Unknown" : m_kdeVersion;
}

QString SystemController::getAutostartPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) 
           + "/autostart/tiger-welcome.desktop";
}

void SystemController::setAutostartEnabled(bool enabled)
{
    if (m_autostartEnabled == enabled)
        return;
    
    m_autostartEnabled = enabled;
    
    if (enabled) {
        setupAutostart();
    } else {
        removeAutostart();
    }
    
    emit autostartEnabledChanged();
}

void SystemController::setupAutostart()
{
    QString autostartDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) 
                           + "/autostart";
    QDir dir;
    dir.mkpath(autostartDir);
    
    QString desktopEntry = 
        "[Desktop Entry]\n"
        "Type=Application\n"
        "Name=TigerOS Welcome\n"
        "Comment=Welcome to TigerOS\n"
        "Exec=tiger-welcome\n"
        "Icon=tigeros-welcome\n"
        "Categories=System;\n"
        "X-GNOME-Autostart-enabled=true\n";
    
    QFile file(getAutostartPath());
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file);
        stream << desktopEntry;
        file.close();
    }
}

void SystemController::removeAutostart()
{
    QFile::remove(getAutostartPath());
}

void SystemController::executeScript(const QString &scriptPath, int modelIndex)
{
    // Clean up any existing process
    if (m_currentProcess) {
        m_currentProcess->kill();
        m_currentProcess->deleteLater();
    }
    
    m_currentModelIndex = modelIndex;
    m_currentProcess = new QProcess(this);
    
    connect(m_currentProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &SystemController::handleProcessFinished);
    connect(m_currentProcess, &QProcess::errorOccurred,
            this, &SystemController::handleProcessError);
    connect(m_currentProcess, &QProcess::readyReadStandardOutput,
            this, &SystemController::handleStdout);
    connect(m_currentProcess, &QProcess::readyReadStandardError,
            this, &SystemController::handleStderr);
    
    emit scriptStarted(modelIndex);
    
    // Handle resource paths (qrc:/)
    QString actualPath = scriptPath;
    if (scriptPath.startsWith(":/")) {
        // Extract resource to temp and execute
        QFile resourceFile(scriptPath);
        if (resourceFile.open(QIODevice::ReadOnly)) {
            QString tempPath = QStandardPaths::writableLocation(QStandardPaths::TempLocation)
                               + "/" + QFileInfo(scriptPath).fileName();
            QFile tempFile(tempPath);
            if (tempFile.open(QIODevice::WriteOnly)) {
                tempFile.write(resourceFile.readAll());
                tempFile.setPermissions(QFile::ReadOwner | QFile::WriteOwner | QFile::ExeOwner);
                tempFile.close();
                actualPath = tempPath;
            }
            resourceFile.close();
        }
    }
    
    // Execute with pkexec for root privileges if needed
    m_currentProcess->start("/bin/bash", QStringList() << actualPath);
}

void SystemController::handleProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    Q_UNUSED(exitStatus)
    emit scriptFinished(m_currentModelIndex, exitCode == 0);
    
    m_currentProcess->deleteLater();
    m_currentProcess = nullptr;
    m_currentModelIndex = -1;
}

void SystemController::handleProcessError(QProcess::ProcessError error)
{
    Q_UNUSED(error)
    emit scriptError(m_currentModelIndex, m_currentProcess->errorString());
}

void SystemController::handleStdout()
{
    QString output = QString::fromUtf8(m_currentProcess->readAllStandardOutput());
    emit scriptOutput(m_currentModelIndex, output);
}

void SystemController::handleStderr()
{
    QString error = QString::fromUtf8(m_currentProcess->readAllStandardError());
    emit scriptError(m_currentModelIndex, error);
}

void SystemController::openUrl(const QString &url)
{
    QDesktopServices::openUrl(QUrl(url));
}

void SystemController::openApplication(const QString &desktopFile)
{
    QProcess::startDetached("kioclient5", QStringList() << "exec" << desktopFile);
}

void SystemController::runCommand(const QString &command)
{
    QProcess::startDetached("/bin/sh", QStringList() << "-c" << command);
}

bool SystemController::commandExists(const QString &command)
{
    QProcess process;
    process.start("which", QStringList() << command);
    process.waitForFinished(2000);
    return process.exitCode() == 0;
}
