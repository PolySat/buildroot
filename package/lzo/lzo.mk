#############################################################
#
# lzo
#
#############################################################
LZO_VERSION = 2.06
LZO_SITE = http://www.oberhumer.com/opensource/lzo/download
LZO_INSTALL_STAGING = YES
LZO_CONFIGURE_PREFIX=/usr/local
LZO_CONFIGURE_EXEC_PREFIX=/usr/local
LZO_POST_INSTALL_TARGET_HOOKS+=LZO_CLEAN_STATIC_LIBS

define LZO_CLEAN_STATIC_LIBS
	rm -f $(addprefix $(TARGET_DIR)/usr/local/lib/,liblzo2.a liblzo2.la)
endef

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
