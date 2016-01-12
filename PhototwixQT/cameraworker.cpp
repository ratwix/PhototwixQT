#include <QDebug>
#include <QFile>
#include "cameraworker.h"
#include <string.h>

static int
_lookup_widget(CameraWidget *widget, const char *key, CameraWidget **child) {
    int ret;
    ret = gp_widget_get_child_by_name (widget, key, child);
    if (ret < GP_OK)
        ret = gp_widget_get_child_by_label (widget, key, child);
    return ret;
}

static void
ctx_error_func (GPContext *context, const char *str, void *data)
{
    qWarning() << "\n*** Cm_capturingFailCountontexterror ***\n" << str;
}

static void
ctx_status_func (GPContext *context, const char *str, void *data)
{
    qDebug() << "\n*** Status gphotos ***\n" << str;
}

/*
static void
errordumper(GPLogLevel level, const char *domain, const char *str, void *data) {
    qDebug() << "\n*** DUMP ERROR gphotos ***\n" << str;
}
*/


CameraWorker::CameraWorker(QQmlImageProviderBase::ImageType type, QQmlImageProviderBase::Flags flags):
    QQuickImageProvider(type, flags)
{
    m_context = 0;
    m_camera = 0;
    m_capturingFailCount = 0;
}

CameraWorker::~CameraWorker()
{
    closeCamera();
}

void CameraWorker::capturePreview()
{
    openCamera();

    //QImage result;

    CameraFile* file;
    int ret = gp_file_new(&file);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : Could not create file";
    } else {
        ret = gp_camera_capture_preview(m_camera, file, m_context);
        //qDebug() << "CAMERA : Get camera preview";
        if (ret < GP_OK) {
            qWarning() << "CAMERA : Failed retrieving preview" << gp_result_as_string(ret);

            m_capturingFailCount++;

            if (m_capturingFailCount >= CAPTURING_FAIL_LIMIT)
            {
              qWarning() << "CAMERA : Too many capture failed. Close and Open Camera";
              closeCamera();
              openCamera();
              m_capturingFailCount = 0;
            }
        } else {
            m_capturingFailCount = 0;
            const char* data;
            unsigned long int size = 0;

            gp_file_get_data_and_size(file, &data, &size);
            m_preview_result.loadFromData(QByteArray(data, size));
            emit previewChange();
        }
        gp_file_free(file);
    }
}

void CameraWorker::autofocus()
{
    CameraWidget		*widget = NULL, *child = NULL;
    CameraWidgetType	type;
    int			ret,val;

    qDebug() << "CAMERA : start autofocus";

    ret = gp_camera_get_config (m_camera, &widget, m_context);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : camera_get_config failed:" << ret;
        return;
    }

    ret = _lookup_widget (widget, "autofocusdrive", &child);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : lookup 'autofocusdrive' failed:" << ret;
        gp_widget_free (widget);
        return;
    }

    /* check that this is a toggle */
    ret = gp_widget_get_type (child, &type);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : widget get type failed:" << ret;
        gp_widget_free (widget);
        return;
    }
    switch (type) {
        case GP_WIDGET_TOGGLE:
            val = 1;
            gp_widget_set_value (child, &val);
            if (ret < GP_OK) {
                qWarning() << "CAMERA : could not set widget value to 1:" << ret;
                gp_widget_free (widget);
                return;
            }

            ret = gp_camera_set_config (m_camera, widget, m_context);
            if (ret < GP_OK) {
                qWarning() << "CAMERA : could not set config tree to autofocus:" << ret;
                gp_widget_free (widget);
                return;
            }
            break;
        default:
            qWarning() << "CAMERA : widget has bad type:" << type;
            gp_widget_free (widget);
            return;
    }

    ret = gp_widget_get_value (child, &val);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : could not get widget value:" << ret;
        gp_widget_free (widget);
        return;
    }
    val++;
    ret = gp_widget_set_value (child, &val);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : could not set widget value to 1:" << ret;
        gp_widget_free (widget);
        return;
    }

    ret = gp_camera_set_config (m_camera, widget, m_context);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : could not set config tree to autofocus:" << ret;
        gp_widget_free (widget);
        return;
    }

    gp_widget_free (widget);
}

void CameraWorker::autofocus2()
{
    CameraWidget		*widget = NULL, *child = NULL;
    CameraWidgetType	type;
    int                 ret,val;
    char                *mval;

    qDebug() << "CAMERA : start autofocus2";

    ret = gp_camera_get_config (m_camera, &widget, m_context);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : camera_get_config failed:" << ret;
        return;
    }

    ret = _lookup_widget (widget, "eosremoterelease", &child);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : lookup 'eosremoterelease' failed:" << ret;
        gp_widget_free (widget);
        return;
    }

    /* check that this is a toggle */
    ret = gp_widget_get_type (child, &type);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : widget get type failed:" << ret;
        gp_widget_free (widget);
        return;
    }

    switch (type) {
        case GP_WIDGET_RADIO: {
                int choices = gp_widget_count_choices (child);

                ret = gp_widget_get_value (child, &mval);
                if (ret < GP_OK) {
                    qWarning() << "CAMERA : could not get widget value:" << ret;
                    gp_widget_free (widget);
                    return;
                }

                ret = gp_widget_get_choice (child, 1, (const char**)&mval);
                qDebug() << "CAMERA : EOS Remote value " << mval;
                if (ret < GP_OK) {
                    qWarning() << "CAMERA : could not get widget choice:" << 1 << " " << ret;
                    gp_widget_free (widget);
                    return;
                }

                ret = gp_widget_set_value (child, mval);
                if (ret < GP_OK) {
                    qWarning() << "CAMERA : could not set widget value to 1:" << ret;
                    gp_widget_free (widget);
                    return;
                }

                ret = gp_camera_set_config (m_camera, widget, m_context);
                if (ret < GP_OK) {
                    qWarning() << "CAMERA : could not set config tree to autofocus:" << ret;
                    gp_widget_free (widget);
                    return;
                }
                break;
            }
        default:
            qWarning() << "CAMERA : widget has bad type:" << type;
            gp_widget_free (widget);
            return;





    }

    gp_widget_free (widget);
}

void CameraWorker::focus(int value)
{
    CameraWidget		*widget = NULL, *child = NULL;
    CameraWidgetType	type;
    int                 ret;
    float               rval;
    char                *mval;

    ret = gp_camera_get_config (m_camera, &widget, m_context);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : camera_get_config failed:" << ret;
        return;
    }

    ret = _lookup_widget (widget, "manualfocusdrive", &child);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : lookup 'manualfocusdrive' failed:" << ret;
        gp_widget_free (widget);
        return;
    }

    /* check that this is a toggle */
    ret = gp_widget_get_type (child, &type);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : widget get type failed:" << ret;
        gp_widget_free (widget);
        return;
    }
    switch (type) {
        case GP_WIDGET_RADIO: {
            int choices = gp_widget_count_choices (child);

            ret = gp_widget_get_value (child, &mval);
            if (ret < GP_OK) {
                qWarning() << "CAMERA : could not get widget value:" << ret;
                gp_widget_free (widget);
                return;
            }

            if (choices == 7) { /* see what Canon has in EOS_MFDrive */
                ret = gp_widget_get_choice (child, value + 3, (const char**)&mval);
                if (ret < GP_OK) {
                    qWarning() << "CAMERA : could not get widget choice:" << value + 2 << " " << ret;
                    gp_widget_free (widget);
                    return;
                }
                qDebug() << "CAMERA : manual focus:" << value << "-->" << mval;
            }

            ret = gp_widget_set_value (child, mval);
            if (ret < GP_OK) {
                qWarning() << "CAMERA : could not set widget value to 1:" << ret;
                gp_widget_free (widget);
                return;
            }
            break;
        }

        case GP_WIDGET_RANGE:
            ret = gp_widget_get_value (child, &rval);
            if (ret < GP_OK) {
                qWarning() << "CAMERA : could not get widget value:" << ret;
                gp_widget_free (widget);
                return;
            }

            switch (value) { /* Range is on Nikon from -32768 <-> 32768 */
                case -3:	rval = -1024;break;
                case -2:	rval =  -512;break;
                case -1:	rval =  -128;break;
                case  0:	rval =     0;break;
                case  1:	rval =   128;break;
                case  2:	rval =   512;break;
                case  3:	rval =  1024;break;

                default:	rval = value;	break; /* hack */
            }

            qDebug() << "CAMERA : manual focus " << value << " -> " << rval;

            ret = gp_widget_set_value (child, &rval);
            if (ret < GP_OK) {
                qWarning() << "CAMERA : could not set widget value to 1:" << ret;
                gp_widget_free (widget);
                return;
            }
            break;
        default:
            qWarning() << "CAMERA : widget has bad type " << type;
            ret = GP_ERROR_BAD_PARAMETERS;
            gp_widget_free (widget);
            return;
    }

    ret = gp_camera_set_config (m_camera, widget, m_context);
    if (ret < GP_OK) {
        qWarning() << "CAMERA : could not set config tree to autofocus:" << ret;
        gp_widget_free (widget);
        return;
    }
    gp_widget_free (widget);
}

void CameraWorker::capturePhoto(const QString &fileName)
{
    QByteArray result;

    // Capture the frame from camera
    CameraFilePath filePath;
    int ret = gp_camera_capture(m_camera, GP_CAPTURE_IMAGE, &filePath, m_context);

    if (ret < GP_OK) {
        qWarning() << "CAMERA : Failed to capture frame:" << ret;
        emit imageCaptureError();
    } else {
        qDebug() << "Captured frame:" << filePath.folder << filePath.name;

        // Download the file
        CameraFile* file;
        ret = gp_file_new(&file);
        ret = gp_camera_file_get(m_camera, filePath.folder, filePath.name, GP_FILE_TYPE_NORMAL, file, m_context);

        if (ret < GP_OK) {
            qWarning() << "CAMERA : Failed to get file from camera:" << ret;
            emit imageCaptureError();
        } else {
            const char* data;
            unsigned long int size = 0;

            gp_file_get_data_and_size(file, &data, &size);
            result = QByteArray(data, size);

            ret = gp_camera_file_delete(m_camera, filePath.folder, filePath.name, m_context);
            if (ret < GP_OK) {
                qWarning() << "CAMERA : Failed to delete file from camera:" << ret;
            }

            //Save file
            QFile outFile(fileName);
            outFile.open(QIODevice::WriteOnly);
            outFile.write(result);
            outFile.close();

            //Capture Finished
            emit imageCaptured(result, fileName);
        }

        gp_file_free(file);
    }
}

QImage CameraWorker::preview_result() const
{
    return m_preview_result;
}

void CameraWorker::setPreview_result(const QImage &preview_result)
{
    m_preview_result = preview_result;
}

QImage CameraWorker::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    return m_preview_result;
}

void CameraWorker::openCamera()
{
    if (m_camera)  // Camera is already open
        return;

    if (!m_context)
        create_context();

    // Create camera object
    int ret = gp_camera_new(&m_camera);
    if (ret != GP_OK) {
        m_camera = 0;
        emit initCameraError();
        qWarning() << "CAMERA : Unable to open camera";
        return;
    }

    // Init camera object
    ret = gp_camera_init(m_camera, m_context);
    if (ret != GP_OK) {
        m_camera = 0;
        emit initCameraError();
        qWarning() << "CAMERA : Unable to init camera";
        return;
    }
}

void CameraWorker::closeCamera()
{
    // Camera is already closed
    if (!m_camera)
        return;

    // Close GPhoto camera session
    int ret = gp_camera_exit(m_camera, m_context);
    if (ret != GP_OK) {
        qWarning() << "CAMERA : Unable to close camera";
        emit closeCameraError();
        return;
    }

    gp_camera_free(m_camera);
    m_camera = 0;

    gp_context_unref(m_context);
    m_context = 0;
}

void CameraWorker::create_context()
{
    GPContext *context;

    /* This is the mandatory part */
    m_context = gp_context_new();

    /* All the parts below are optional! */
    //gp_log_add_func(GP_LOG_ERROR, errordumper, NULL);
    gp_context_set_error_func (m_context, ctx_error_func, NULL);
    gp_context_set_status_func (m_context, ctx_status_func, NULL);

    /* also:
    gp_context_set_cancel_func    (p->context, ctx_cancel_func,  p);
    gp_context_set_message_func   (p->context, ctx_message_func, p);
    if (isatty (STDOUT_FILENO))
            gp_context_set_progress_funcs (p->context,
                    ctx_progress_start_func, ctx_progress_update_func,
                    ctx_progress_stop_func, p);
     */

    //TODO : Envoyer signal d'erreur initialisation de la camera

    if (!m_context) {
        emit initCameraError();
        qWarning() << "CAMERA : Erreur de creation du context";
    }

}
