QT += quick

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        duplicates.cpp \
        duplicatesfinder.cpp \
        main.cpp \
        md5.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Boost libs
INCLUDEPATH += C:/"Program Files"/boost/boost_1_66_0/boost_mingw_810_64/include/boost-1_66
DEPENDPATH += C:/"Program Files"/boost/boost_1_66_0/boost_mingw_810_64/include/boost-1_66
LIBS += -L"C:/Program Files/boost/boost_1_66_0/boost_mingw_810_64/lib" \
            -llibboost_filesystem-mgw81-mt-x64-1_66 \
            -llibboost_system-mgw81-mt-x64-1_66

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    duplicates.h \
    duplicatesfinder.h \
    md5.h
