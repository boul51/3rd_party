!equals(BUILDING_OPENSSL, TRUE) {
    include(openssl_paths.pri)

    isEmpty(LOCALDEPLOYLIBDIR) {
        error(Please include BuildRules.pri before including openssl.pri)
    }

    QMAKE_CFLAGS += -I$${OPENSSL_INSTALL_DIR}/include
    QMAKE_CXXFLAGS += -I$${OPENSSL_INSTALL_DIR}/include
    QMAKE_LFLAGS += -L$${LOCALDEPLOYLIBDIR} #-l:libssl.so -L$${LOCALDEPLOYLIBDIR} -l:libcrypto.so
}
