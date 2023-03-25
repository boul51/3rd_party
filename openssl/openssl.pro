TEMPLATE = aux

BUILDING_OPENSSL = TRUE

include(openssl_paths.pri)
include(../../BuildRules.pri)

GIT_REMOTE = https://github.com/openssl/openssl.git
GIT_REV = 12ad22dd16ffe47f8cde3cddb84a160e8cdb3e30  # OpenSSL_1_0_2-stable,

ROOT_DIR=$$shell_quote($$shadowed($$PWD))
SRC_DIR=$$shell_quote($$shadowed($${PWD}/src))

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

configureTarget.commands = \
    cd $$SRC_DIR && \
    [ -f Makefile ] \
    || ( \
        ./config -shared --prefix=$$OPENSSL_INSTALL_DIR \
    )

configureTarget.depends = cloneTarget

buildTarget.commands = \
    cd $$SRC_DIR && \
    $(MAKE) CC=$$shell_quote($$QMAKE_CC)

buildTarget.depends = configureTarget

installTarget.commands = \
    cd $$SRC_DIR && \
    $(MAKE) install_sw && \
    $(MKDIR) $$shell_quote($$LOCALDEPLOYLIBDIR) && \
    cp -Pf $$OPENSSL_INSTALL_DIR/lib/libcrypto.so* $$shell_quote($$LOCALDEPLOYLIBDIR) && \
    cp -Pf $$OPENSSL_INSTALL_DIR/lib/libssl.so* $$shell_quote($$LOCALDEPLOYLIBDIR)

installTarget.depends = buildTarget

cleanTarget.commands = \
    rm -rf $$SRC_DIR $$OPENSSL_INSTALL_DIR && \
    $(RM) $$shell_quote($$LOCALDEPLOYLIBDIR)/libcrypto.so* && \
    $(RM) $$shell_quote($$LOCALDEPLOYLIBDIR)/libssl.so*

clean.depends += cleanTarget

QMAKE_EXTRA_TARGETS = cloneTarget configureTarget buildTarget installTarget cleanTarget clean
PRE_TARGETDEPS += cloneTarget configureTarget buildTarget installTarget
