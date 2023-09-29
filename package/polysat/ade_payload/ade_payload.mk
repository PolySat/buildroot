#############################################################
#
# Polysat exocube pib driver
#
#############################################################
ADE_PAYLOAD_SITE:=git@github.com:PolySat/ade-payload.git
ADE_PAYLOAD_SITE_METHOD:=git
ADE_PAYLOAD_INSTALL_TARGET=YES
ADE_PAYLOAD_INSTALL_STAGING=YES
ADE_PAYLOAD_DEPENDENCIES=polysat_fsw

ifeq ($(BR2_PACKAGE_ADE_PAYLOAD_location_secondary),y)
   ADE_PAYLOAD_LOCATION=$(TARGET_DIR)/usr/local/lib
endif

ifeq ($(BR2_PACKAGE_ADE_PAYLOAD_location_initrd),y)
   ADE_PAYLOAD_LOCATION=$(TARGET_DIR)/lib
endif

ADE_PAYLOAD_LOCATION?=$(TARGET_DIR)/lib

ifeq ($(BR2_PACKAGE_ADE_PAYLOAD_version_head),y)
   ADE_PAYLOAD_VERSION:=$(shell git ls-remote $(ADE_PAYLOAD_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_ADE_PAYLOAD_version_custom),y)
   ADE_PAYLOAD_VERSION=$(subst ",,$(BR2_PACKAGE_ADE_PAYLOAD_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_ADE_PAYLOAD),y)
   ADE_PAYLOAD_VERSION?=$(shell git ls-remote $(ADE_PAYLOAD_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   ADE_PAYLOAD_VERSION?=v0.0
endif


define ADE_PAYLOAD_BUILD_CMDS
 $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) PWD="$(@D)" KERNELDIR=$(LINUX_DIR) $(TARGET_CONFIGURE_OPTS) all
endef

define ADE_PAYLOAD_INSTALL_TARGET_CMDS
 $(MAKE) -C $(@D) HEADER_DIR=$(STAGING_DIR)/usr/include/linux/polysat INC_PATH=$(STAGING_DIR)/usr/include LIB_PATH=$(TARGET_DIR)/usr/lib BIN_PATH=$(TARGET_DIR)/usr/bin SBIN_PATH=$(TARGET_DIR)/usr/sbin PWD="$(@D)" KERNELDIR=$(LINUX_DIR) $(TARGET_CONFIGURE_OPTS) DRIVER_PATH=$(ADE_PAYLOAD_LOCATION)/drivers TARGET=arm  install
endef

define ADE_PAYLOAD_INSTALL_STAGING_CMDS
 $(MAKE) -C $(@D) HEADER_DIR=$(STAGING_DIR)/usr/include/linux/polysat INC_PATH=$(STAGING_DIR)/usr/include LIB_PATH=$(STAGING_DIR)/usr/lib BIN_PATH=$(STAGING_DIR)/usr/bin SBIN_PATH=$(STAGING_DIR)/usr/sbin PWD="$(@D)" KERNELDIR=$(LINUX_DIR) $(TARGET_CONFIGURE_OPTS) DRIVER_PATH=$(ADE_PAYLOAD_LOCATION)/drivers TARGET=arm  install
endef

$(eval $(call GENTARGETS,package,ade-payload))
