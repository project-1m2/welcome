/**
 * SystemController - Handles system operations and script execution
 * 
 * Provides async script execution with progress feedback,
 * autostart configuration, and system info retrieval.
 */

#ifndef SYSTEMCONTROLLER_H
#define SYSTEMCONTROLLER_H

#include <QObject>
#include <QProcess>

class SystemController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool autostartEnabled READ autostartEnabled WRITE setAutostartEnabled NOTIFY autostartEnabledChanged)
    Q_PROPERTY(QString osVersion READ osVersion CONSTANT)
    Q_PROPERTY(QString kdeVersion READ kdeVersion CONSTANT)

public:
    explicit SystemController(QObject *parent = nullptr);

    bool autostartEnabled() const;
    QString osVersion() const;
    QString kdeVersion() const;

    Q_INVOKABLE void setAutostartEnabled(bool enabled);
    
    // Execute a script asynchronously, emits signals for progress/completion
    Q_INVOKABLE void executeScript(const QString &scriptPath, int modelIndex = -1);
    
    // Open URLs or applications
    Q_INVOKABLE void openUrl(const QString &url);
    Q_INVOKABLE void openApplication(const QString &desktopFile);
    Q_INVOKABLE void runCommand(const QString &command);
    
    // Check if a command exists
    Q_INVOKABLE bool commandExists(const QString &command);

signals:
    void autostartEnabledChanged();
    void scriptStarted(int modelIndex);
    void scriptFinished(int modelIndex, bool success);
    void scriptOutput(int modelIndex, const QString &output);
    void scriptError(int modelIndex, const QString &error);

private slots:
    void handleProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void handleProcessError(QProcess::ProcessError error);
    void handleStdout();
    void handleStderr();

private:
    void setupAutostart();
    void removeAutostart();
    QString getAutostartPath() const;
    
    QProcess *m_currentProcess = nullptr;
    int m_currentModelIndex = -1;
    bool m_autostartEnabled = false;
    QString m_osVersion;
    QString m_kdeVersion;
};

#endif // SYSTEMCONTROLLER_H
