#############################################################
#
# Build the romfs root filesystem image
#
#############################################################

ROMFS_TARGET=$(IMAGE).romfs

ROOTFS_ROMFS_DEPENDENCIES = host-genromfs
USR_LOCAL_ROMFS_DEPENDENCIES = host-genromfs

define ROOTFS_ROMFS_CMD
	$(HOST_DIR)/usr/bin/genromfs -d $(TARGET_DIR) -f $$@
endef

define USR_LOCAL_ROMFS_CMD
	$(HOST_DIR)/usr/bin/genromfs -d $(TARGET_DIR)/usr/local -f $$@
endef

$(eval $(call ROOTFS_TARGET,romfs))
