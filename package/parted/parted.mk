#############################################################
#
# parted
#
#############################################################

PARTED_VERSION = 3.1
PARTED_SOURCE = parted-$(PARTED_VERSION).tar.xz
PARTED_SITE = $(BR2_GNU_MIRROR)/parted
PARTED_DEPENDENCIES = readline util-linux lvm2
PARTED_INSTALL_STAGING = YES
PARTED_CONFIGURE_PREFIX=/usr/local
PARTED_CONFIGURE_EXEC_PREFIX=/usr/local
PARTED_POST_INSTALL_TARGET_HOOKS=PARTED_REMOVE_UNNEEDED_FILES

define PARTED_REMOVE_UNNEEDED_FILES
    rm -f $(TARGET_DIR)/usr/local/lib/libparted*.a
endef

$(eval $(call AUTOTARGETS))
