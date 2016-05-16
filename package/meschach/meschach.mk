#############################################################
#
# meschach
#
#############################################################

MESCHACH_VERSION=12b
MESCHACH_SOURCE=mesch$(MESCHACH_VERSION).tar.gz
MESCHACH_SITE=http://homepage.math.uiowa.edu/~dstewart/meschach
MESCHACH_INSTALL_STAGING=YES
MESCHACH_INSTALL_TARGET=NO

define MESCHACH_EXTRACT_CMDS
	$(TAR) -C $(MESCHACH_DIR) -z $(TAR_OPTIONS) $(DL_DIR)/$(MESCHACH_SOURCE)
endef

define MESCHACH_BUILD_CMDS
        $(MAKE) $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS) $(BR2_MESCHACH_CFLAGS) -O3" CFLAGS="$(TARGET_CFLAGS) -O3" -C $(@D) basic
	cp -f $(@D)/meschach.a $(@D)/libmeschach.a
endef

define MESCHACH_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/err.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/machine.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/matrix2.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/meminfo.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/sparse2.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/zmatrix2.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/iter.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/matlab.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/matrix.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/oldnames.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/sparse.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/zmatrix.h $(STAGING_DIR)/usr/include/meschach
	$(INSTALL) -m 644 $(@D)/libmeschach.a $(STAGING_DIR)/usr/lib
endef

$(eval $(call AUTOTARGETS))
