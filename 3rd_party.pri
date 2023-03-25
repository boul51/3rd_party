for (SUBDIR, SUBDIRS) {
    !equals(SUBDIR, 3rd_party) {
        $${SUBDIR}.depends = 3rd_party $$eval($${SUBDIR}.depends)
        message($${SUBDIR}.depends is now $$eval($${SUBDIR}.depends))
    }
}

SUBDIRS += 3rd_party
