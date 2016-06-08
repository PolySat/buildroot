#############################################################
#
# libpng (Portable Network Graphic library)
#
#############################################################
LIBROHC_VERSION:=1.5.0
LIBROHC_SITE = http://launchpadlibrarian.net/120478022
LIBROHC_SOURCE = rohc-$(LIBROHC_VERSION).tar.bz2
LIBROHC_LIBTOOL_PATCH = NO
LIBROHC_INSTALL_STAGING = YES
LIBROHC_CONF_OPT = --disable-rohc-tests --enable-rohc-debug=0

#LIBROHC_CONF_PREFIX =/usr/local
#LIBROHC_CONF_EXEC_PREFIX =/usr/local
#LIBROHC_CONF_SYSCONFDIR =/usr/local/etc

define LIBROHC_POSTINST
#-rm $(TARGET_DIR)/usr/local/lib/libpng.a
#-rm $(TARGET_DIR)/usr/local/lib/libpng.la
#-rm $(TARGET_DIR)/usr/local/lib/libpng12.a
#-rm $(TARGET_DIR)/usr/local/lib/libpng12.la
#-rm $(TARGET_DIR)/usr/local/lib/libjpeg.la
#-rm -rf $(TARGET_DIR)/usr/local/include/libpng12
#-rm $(TARGET_DIR)/usr/local/include/png.h
#-rm $(TARGET_DIR)/usr/local/include/pngconf.h
endef

LIBROHC_POST_INSTALL_TARGET_HOOKS += LIBROHC_POSTINST


$(eval $(call AUTOTARGETS,package/polysat,librohc))

#$(LIBROHC_HOOK_POST_INSTALL):
#$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr/local\',g" \
#-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr/local\',g" \
#-e "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/local/include/libpng12\',g" \
#-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/local/lib\',g" \
#$(STAGING_DIR)/usr/local/bin/libpng12-config
#touch $@

