ifdef BR2_PACKAGE_FSW_IMAGE
FSW_IMAGE_BASE_NAME:=fsw_image
FSW_IMAGE_SITE:=$(BR2_PACKAGE_FSW_IMAGE_CONFIG_GIT_URL)
FSW_IMAGE_SITE_METHOD:=git
FSW_IMAGE_INSTALL_TARGET=YES

ROOTFS_CUSTOM_IMAGES += fsw_image
ROOTFS_fsw_image_TARGET_FS_PATH=$(FSW_IMAGE_DIR)

#FSW_IMAGE_VERSION:=$(subst ",,$(BR2_PACKAGE_FSW_IMAGE_BRANCH))
ifeq ($(BR2_PACKAGE_FSW_IMAGE_version_head),y)
   FSW_IMAGE_VERSION:=$(shell git ls-remote $(FSW_IMAGE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_FSW_IMAGE_version_custom),y)
   FSW_IMAGE_VERSION=$(subst ",,$(BR2_PACKAGE_FSW_IMAGE_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_FSW_IMAGE),y)
   FSW_IMAGE_VERSION?=$(shell git ls-remote $(FSW_IMAGE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   FSW_IMAGE_VERSION?=v0.0
endif


FSW_IMAGE_SOURCE:=fsw_image-$(FSW_IMAGE_VERSION).tgz

$(eval $(call GENTARGETS,package,fsw_image))

endif
