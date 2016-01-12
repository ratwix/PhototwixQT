#ifndef CAMERAWORKER_H
#define CAMERAWORKER_H

#include <QObject>
#include <QImage>
#include <QQuickImageProvider>
#include <gphoto2/gphoto2-camera.h>

#define CAPTURING_FAIL_LIMIT 15

class CameraWorker : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    Q_PROPERTY(QImage preview READ preview_result WRITE setPreview_result NOTIFY previewChange)

public:
    CameraWorker(QQuickImageProvider::ImageType type=QQuickImageProvider::Image,
                 QQuickImageProvider::Flags flags=QQmlImageProviderBase::ForceAsynchronousImageLoading);

    ~CameraWorker();

    Q_INVOKABLE void capturePreview();
    Q_INVOKABLE void autofocus();
    Q_INVOKABLE void autofocus2();
    Q_INVOKABLE void focus(int value); //-3 -- 3
    Q_INVOKABLE void capturePhoto(const QString &fileName);
    Q_INVOKABLE void openCamera();
    Q_INVOKABLE void closeCamera();



    QImage preview_result() const;
    void setPreview_result(const QImage &preview_result);

    virtual QImage requestImage(const QString &id, QSize *size, const QSize& requestedSize);

private:
    void create_context();


    QImage m_preview_result;

    Camera *m_camera;
    GPContext *m_context;

    int m_capturingFailCount;

signals:
    void initCameraError();
    void closeCameraError();
    void previewChange();
    void imageCaptureError();
    void imageCaptured(const QByteArray &imageData, const QString &fileName);

public slots:

};

#endif // CAMERA_H
