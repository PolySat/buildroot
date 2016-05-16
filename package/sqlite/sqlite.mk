#############################################################
#
# sqlite
#
#############################################################

SQLITE_VERSION = 3071100
SQLITE_SOURCE = sqlite-autoconf-$(SQLITE_VERSION).tar.gz
SQLITE_SITE = http://www.sqlite.org
SQLITE_INSTALL_STAGING = YES
SQLITE_CONFIGURE_PREFIX=/usr/local
SQLITE_CONFIGURE_EXEC_PREFIX=/usr/local
SQLITE_POST_INSTALL_TARGET_HOOKS+=SQLITE_CLEAN_STATIC_LIBS

define SQLITE_CLEAN_STATIC_LIBS
	rm -f $(addprefix $(TARGET_DIR)/usr/local/lib/,libsqlite3.a libsqlite3.la)
endef

ifneq ($(BR2_LARGEFILE),y)
# the sqlite configure script fails to define SQLITE_DISABLE_LFS when
# --disable-largefile is passed, breaking the build. Work around it by
# simply adding it to CFLAGS for configure instead
SQLITE_CFLAGS += -DSQLITE_DISABLE_LFS
endif

ifeq ($(BR2_PACKAGE_SQLITE_STAT3),y)
SQLITE_CFLAGS += -DSQLITE_ENABLE_STAT3
endif

SQLITE_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) $(SQLITE_CFLAGS)"

SQLITE_CONF_OPT = \
	--enable-threadsafe \
	--localstatedir=/var

ifeq ($(BR2_PACKAGE_SQLITE_READLINE),y)
SQLITE_DEPENDENCIES += ncurses readline
SQLITE_CONF_OPT += --with-readline-inc="-I$(STAGING_DIR)/usr/include"
else
SQLITE_CONF_OPT += --disable-readline
endif

define SQLITE_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/local/bin/sqlite3
	rm -f $(TARGET_DIR)/usr/local/lib/libsqlite3*
endef

define SQLITE_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/usr/bin/sqlite3
	rm -f $(STAGING_DIR)/usr/lib/libsqlite3*
	rm -f $(STAGING_DIR)/usr/lib/pkgconfig/sqlite3.pc
	rm -f $(STAGING_DIR)/usr/include/sqlite3*.h
endef

$(eval $(call AUTOTARGETS))
