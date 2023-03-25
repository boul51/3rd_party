TEMPLATE = aux

BUILDING_MOSQUITTO = TRUE

include(../../BuildRules.pri)

include(mosquitto_paths.pri)
include(../openssl/openssl.pri)

GIT_REMOTE = https://github.com/eclipse/mosquitto.git
GIT_REV = b0277869d9806f6fab8e1bc11c4a4987c9a79ded  # v2.0.15

ROOT_DIR=$$shell_quote($$shadowed($$PWD))
SRC_DIR=$$shell_quote($$shadowed($${PWD}/src))
BUILD_DIR=$$ROOT_DIR/build

QMAKE_LFLAGS -= -l:mosquitto.so -l:mosquittopp.so

cloneTarget.commands = \
    [ -d $$SRC_DIR ] \
    || ( \
        $(MKDIR) $$ROOT_DIR && \
        cd $$ROOT_DIR && \
        git clone --depth=1 $$GIT_REMOTE $$SRC_DIR && \
        cd $$SRC_DIR && \
        git fetch origin --depth=1 $$GIT_REV && \
        git checkout $$GIT_REV \
    )

CMAKE_CCACHE_VAR = ""
ccacheAvailable() {
    CMAKE_CCACHE_VAR = -DCMAKE_C_COMPILER_LAUNCHER=ccache
}

cmakeTarget.commands = \
    $(MKDIR) $$BUILD_DIR && \
    cd $$BUILD_DIR && \
    cmake $$SRC_DIR \
        $$CMAKE_CCACHE_VAR \
        -DCMAKE_INSTALL_PREFIX=$$MOSQUITTO_INSTALL_DIR \
        -DCMAKE_C_FLAGS=$$shell_quote($$QMAKE_CFLAGS) \
        -DCMAKE_CXX_FLAGS=$$shell_quote($$QMAKE_CXXFLAGS) \
        -DCMAKE_SHARED_LINKER_FLAGS=$$shell_quote($$QMAKE_LFLAGS) \
        -DCMAKE_EXE_LINKER_FLAGS=$$shell_quote($$QMAKE_LFLAGS)


cmakeTarget.depends = cloneTarget

buildTarget.commands = \
    cd $$BUILD_DIR && \
    $(MAKE) VERBOSE=1

buildTarget.depends = cmakeTarget

installTarget.commands = \
    cd $$BUILD_DIR && \
    $(MAKE) install && \
    $(MKDIR) $$shell_quote($$LOCALDEPLOYLIBDIR) && \
    cp -P $$MOSQUITTO_INSTALL_DIR/lib/libmosquitto.so* $$shell_quote($$LOCALDEPLOYLIBDIR) && \
    cp -P $$MOSQUITTO_INSTALL_DIR/lib/libmosquittopp.so* $$shell_quote($$LOCALDEPLOYLIBDIR)

installTarget.depends = buildTarget

cleanTarget.commands = \
    rm -rf $$SRC_DIR $$MOSQUITTO_INSTALL_DIR && \
    $(RM) $$shell_quote($$LOCALDEPLOYLIBDIR)/libmosquitto.so* && \
    $(RM) $$shell_quote($$LOCALDEPLOYLIBDIR)/libmosquittopp.so*

clean.depends += cleanTarget

QMAKE_EXTRA_TARGETS = cloneTarget cmakeTarget buildTarget installTarget cleanTarget clean
PRE_TARGETDEPS += cloneTarget cmakeTarget buildTarget installTarget
