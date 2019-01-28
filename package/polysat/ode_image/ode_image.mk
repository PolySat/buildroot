ifdef BR2_PACKAGE_ODE_IMAGE
ODE_IMAGE_BASE_NAME:=ode_image
ODE_IMAGE_SITE:=https://github.com/rbalthazor/ode-image.git
ODE_IMAGE_SITE_METHOD:=git
ODE_IMAGE_INSTALL_TARGET=YES

ROOTFS_CUSTOM_IMAGES += ode_image
ROOTFS_ode_image_TARGET_FS_PATH=$(ODE_IMAGE_DIR)

#ODE_IMAGE_VERSION:=$(subst ",,$(BR2_PACKAGE_ODE_IMAGE_BRANCH))
ifeq ($(BR2_PACKAGE_ODE_IMAGE_version_head),y)
   ODE_IMAGE_VERSION:=$(shell git ls-remote $(ODE_IMAGE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_ODE_IMAGE_version_custom),y)
   ODE_IMAGE_VERSION=$(subst ",,$(BR2_PACKAGE_ODE_IMAGE_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_ODE_IMAGE),y)
   ODE_IMAGE_VERSION?=$(shell git ls-remote $(ODE_IMAGE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   ODE_IMAGE_VERSION?=v0.0
endif


ODE_IMAGE_SOURCE:=ode_image-$(ODE_IMAGE_VERSION).tgz

$(eval $(call GENTARGETS,package,ode_image))

endif
