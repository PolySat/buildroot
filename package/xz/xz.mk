#############################################################
#
# xz-utils
#
#############################################################
XZ_VERSION = 5.0.3
XZ_SOURCE = xz-$(XZ_VERSION).tar.bz2
XZ_SITE = http://tukaani.org/xz/
XZ_INSTALL_STAGING = YES
XZ_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
XZ_CONFIGURE_PREFIX=/usr/local
XZ_CONFIGURE_EXEC_PREFIX=/usr/local
XZ_POST_INSTALL_TARGET_HOOKS+=XZ_REMOVE_STATIC_LIBS

define XZ_REMOVE_STATIC_LIBS
	rm -f $(addprefix $(TARGET_DIR)/usr/local/lib/,liblzma.a liblzma.la)
endef

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
