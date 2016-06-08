ifdef BR2_PACKAGE_EXAMPLE_IMAGE
EXAMPLE_IMAGE_BASE_NAME:=example_image
EXAMPLE_IMAGE_SITE:=git@github.com:PolySat/example-image.git
EXAMPLE_IMAGE_SITE_METHOD:=git
EXAMPLE_IMAGE_INSTALL_TARGET=YES

ROOTFS_CUSTOM_IMAGES += example_image
ROOTFS_example_image_TARGET_FS_PATH=$(EXAMPLE_IMAGE_DIR)

#EXAMPLE_IMAGE_VERSION:=$(subst ",,$(BR2_PACKAGE_EXAMPLE_IMAGE_BRANCH))
ifeq ($(BR2_PACKAGE_EXAMPLE_IMAGE_version_head),y)
   EXAMPLE_IMAGE_VERSION:=$(shell git ls-remote $(EXAMPLE_IMAGE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_EXAMPLE_IMAGE_version_custom),y)
   EXAMPLE_IMAGE_VERSION=$(subst ",,$(BR2_PACKAGE_EXAMPLE_IMAGE_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_EXAMPLE_IMAGE),y)
   EXAMPLE_IMAGE_VERSION?=$(shell git ls-remote $(EXAMPLE_IMAGE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   EXAMPLE_IMAGE_VERSION?=v0.0
endif


EXAMPLE_IMAGE_SOURCE:=example_image-$(EXAMPLE_IMAGE_VERSION).tgz

$(eval $(call GENTARGETS,package,example_image))

endif
