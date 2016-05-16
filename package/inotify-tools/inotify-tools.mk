#############################################################
#
# inotify-utils
#
#############################################################
INOTIFY_TOOLS_VERSION = 3.14
INOTIFY_TOOLS_SITE = http://github.com/downloads/rvoicilas/inotify-tools/
INOTIFY_TOOLS_CONFIGURE_PREFIX=/usr/local
INOTIFY_TOOLS_CONFIGURE_EXEC_PREFIX=/usr/local
INOTIFY_TOOLS_POST_INSTALL_TARGET_HOOKS+=INOTIFY_TOOLS_CLEAN_STATIC_LIBS

define INOTIFY_TOOLS_CLEAN_STATIC_LIBS
	rm -f $(addprefix $(TARGET_DIR)/usr/local/lib/,libinotifytools.a libinotifytools.la)
endef

$(eval $(call AUTOTARGETS))
