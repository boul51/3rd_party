TEMPLATE = subdirs

include(../BuildRules.pri)

equals(BUILD_OPENSSL, TRUE) {
    SUBDIRS += openssl
}

equals(BUILD_MOSQUITTO, TRUE) {
    SUBDIRS += mosquitto
    mosquitto.depends += openssl
}
