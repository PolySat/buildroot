#############################################################
#
# jpeg (libraries needed by some apps)
#
#############################################################
JPEG_VERSION = 8d
JPEG_SITE = http://www.ijg.org/files/
JPEG_SOURCE = jpegsrc.v$(JPEG_VERSION).tar.gz
JPEG_INSTALL_STAGING = YES
JPEG_CONFIGURE_PREFIX=/usr/local
JPEG_CONFIGURE_EXEC_PREFIX=/usr/local

define JPEG_REMOVE_USELESS_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/local/bin/,cjpeg djpeg jpegtrans rdjpgcom wrjpgcom); \
	rm -f $(addprefix $(TARGET_DIR)/usr/local/lib/,libjpeg.a libjpeg.la)
endef

JPEG_POST_INSTALL_TARGET_HOOKS += JPEG_REMOVE_USELESS_TOOLS

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
