ifdef BR2_PACKAGE_SUBMODULE_IMAGE
SUBMODULE_IMAGE_BASE_NAME:=submodule_image
SUBMODULE_IMAGE_SITE:=http://users.csc.calpoly.edu/~bellardo/polysat
SUBMODULE_IMAGE_SITE_METHOD:=wget
SUBMODULE_IMAGE_INSTALL_TARGET=YES
#SUBMODULE_IMAGE_SOURCE:=submodule_image.tgz
SUBMODULE_IMAGE_VERSION=local

ifeq ($(BR2_PACKAGE_SUBMODULE_IMAGE),y)
   ROOTFS_CUSTOM_IMAGES += submodule_image
   ROOTFS_submodule_image_TARGET_FS_PATH=$(SUBMODULE_IMAGE_DIR)
else
endif

define SUBMODULE_IMAGE_EXTRACT_CMDS
	rm -f $(@D)/.stamp_built
endef

define SUBMODULE_IMAGE_BUILD_CMDS
	rsync -a $(BASE_DIR)/../../rootfs/ $(@D)
	cp $(BASE_DIR)/../../cleanup.sh $(@D)
	touch $(DL_DIR)/$(SUBMODULE_IMAGE_SOURCE)
	rm -f $(@D)/.stamp_extracted
endef

define SUBMODULE_IMAGE_INSTALL_TARGET_CMDS
endef


$(eval $(call GENTARGETS,package,submodule_image))

endif
