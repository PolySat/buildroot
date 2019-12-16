#############################################################
#
# Polysat exocube pib driver
#
#############################################################
ADE_PIB_DRIVER_SITE:=git@asof.atl.calpoly.edu:exocube/ade-pib-driver.git
ADE_PIB_DRIVER_SITE_METHOD:=git
ADE_PIB_DRIVER_INSTALL_TARGET=YES
#ADE_PIB_DRIVER_DEPENDENCIES=libproc openssl zlib libsatpkt

ifeq ($(BR2_PACKAGE_ADE_PIB_DRIVER_location_secondary),y)
   ADE_PIB_DRIVER_LOCATION=$(TARGET_DIR)/usr/local/lib
endif

ifeq ($(BR2_PACKAGE_ADE_PIB_DRIVER_location_initrd),y)
   ADE_PIB_DRIVER_LOCATION=$(TARGET_DIR)/lib
endif

ADE_PIB_DRIVER_LOCATION?=$(TARGET_DIR)/usr/local/lib

ifeq ($(BR2_PACKAGE_ADE_PIB_DRIVER_version_head),y)
   ADE_PIB_DRIVER_VERSION:=$(shell git ls-remote $(ADE_PIB_DRIVER_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_ADE_PIB_DRIVER_version_custom),y)
   ADE_PIB_DRIVER_VERSION=$(subst ",,$(BR2_PACKAGE_ADE_PIB_DRIVER_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_ADE_PIB_DRIVER),y)
   ADE_PIB_DRIVER_VERSION?=$(shell git ls-remote $(ADE_PIB_DRIVER_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   ADE_PIB_DRIVER_VERSION?=v0.0
endif


define ADE_PIB_DRIVER_BUILD_CMDS
 $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) PWD="$(@D)" KERNELDIR=$(LINUX_DIR) $(TARGET_CONFIGURE_OPTS) all
endef

define ADE_PIB_DRIVER_INSTALL_TARGET_CMDS
 $(MAKE) -C $(@D) HEADER_DIR=$(STAGING_DIR)/usr/include/linux/polysat INC_PATH=$(STAGING_DIR)/usr/include LIB_PATH=$(TARGET_DIR)/usr/lib BIN_PATH=$(TARGET_DIR)/usr/bin SBIN_PATH=$(TARGET_DIR)/usr/sbin PWD="$(@D)" KERNELDIR=$(LINUX_DIR) $(TARGET_CONFIGURE_OPTS) DRIVER_PATH=$(ADE_PIB_DRIVER_LOCATION)/drivers TARGET=arm  install
endef

$(eval $(call GENTARGETS,package,ade-pib-driver))
