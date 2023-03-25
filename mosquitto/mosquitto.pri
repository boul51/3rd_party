!equals(BUILDING_MOSQUITTO, TRUE) {
    include(mosquitto_paths.pri)

    isEmpty(LOCALDEPLOYLIBDIR) {
        error(Please include BuildRules.pri before including openssl.pri)
    }

    !equals(BUILD_OPENSSL, TRUE) {
        error(BUILD_OPENSSL should be set to TRUE when BUILD_MOSQUITTO is TRUE)
    }

    !equals(BUILDING_OPENSSL, TRUE):!equals(BUILDING_MOSQUITTO, TRUE) {
        QMAKE_CFLAGS += -I$${MOSQUITTO_INSTALL_DIR}/include
        QMAKE_CXXFLAGS += -I$${MOSQUITTO_INSTALL_DIR}/include
        QMAKE_LFLAGS += -L$${LOCALDEPLOYLIBDIR}
    }
}
