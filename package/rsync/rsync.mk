#############################################################
#
# rsync
#
#############################################################

RSYNC_VERSION = 3.0.9
RSYNC_SOURCE = rsync-$(RSYNC_VERSION).tar.gz
RSYNC_SITE = http://rsync.samba.org/ftp/rsync/src
RSYNC_CONF_OPT = $(if $(BR2_ENABLE_DEBUG),--enable-debug,--disable-debug)
RSYNC_CONF_OPT = --with-included-popt
RSYNC_CONFIGURE_PREFIX=/usr/local
RSYNC_CONFIGURE_EXEC_PREFIX=/usr/local
RSYNC_CONFIGURE_SYSCONFDIR=/usr/local/etc

$(eval $(call AUTOTARGETS))
