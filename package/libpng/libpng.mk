#############################################################
#
# libpng (Portable Network Graphic library)
#
#############################################################

LIBPNG_VERSION = 1.4.11
LIBPNG_SERIES = 14
LIBPNG_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/libpng/libpng$(LIBPNG_SERIES)/$(LIBPNG_VERSION)
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.bz2
LIBPNG_INSTALL_STAGING = YES
LIBPNG_DEPENDENCIES = host-pkg-config zlib
LIBPNG_CONFIGURE_PREFIX=/usr/local
LIBPNG_CONFIGURE_EXEC_PREFIX=/usr/local

define LIBPNG_STAGING_LIBPNG12_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr/local\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr/local\',g" \
		-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/local/include/libpng$(LIBPNG_SERIES)\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/local/lib\',g" \
		$(STAGING_DIR)/usr/local/bin/libpng$(LIBPNG_SERIES)-config
endef

LIBPNG_POST_INSTALL_STAGING_HOOKS += LIBPNG_STAGING_LIBPNG12_CONFIG_FIXUP

define LIBPNG_REMOVE_CONFIG_SCRIPTS
	$(RM) -f $(TARGET_DIR)/usr/local/bin/libpng$(LIBPNG_SERIES)-config \
		 $(TARGET_DIR)/usr/local/bin/libpng-config \
		 $(TARGET_DIR)/usr/local/lib/libpng$(LIBPNG_SERIES).a \
		 $(TARGET_DIR)/usr/local/lib/libpng$(LIBPNG_SERIES).la \
		 $(TARGET_DIR)/usr/local/lib/libpng.a \
		 $(TARGET_DIR)/usr/local/lib/libpng.la
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
LIBPNG_POST_INSTALL_TARGET_HOOKS += LIBPNG_REMOVE_CONFIG_SCRIPTS
endif

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
