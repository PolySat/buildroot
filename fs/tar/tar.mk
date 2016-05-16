#############################################################
#
# tar to archive target filesystem
#
#############################################################

TAR_OPTS:=$(BR2_TARGET_ROOTFS_TAR_OPTIONS)
TAR_USR_LOCAL_OPTS:=$(BR2_TARGET_USR_LOCAL_TAR_OPTIONS)

define ROOTFS_TAR_CMD
 tar -c$(TAR_OPTS)f $$@ -C $(TARGET_DIR) .
endef

define USR_LOCAL_TAR_CMD
 tar -c$(TAR_USR_LOCAL_OPTS)f $$@ -C $(TARGET_DIR)/usr/local .
endef

$(eval $(call ROOTFS_TARGET,tar))
