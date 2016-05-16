#############################################################
#
# Polysat watchdog
#
#############################################################
UVCCAPTURE_SITE:=git@asof.atl.calpoly.edu:uvccapture.git
UVCCAPTURE_SITE_METHOD:=git
UVCCAPTURE_INSTALL_TARGET=YES
UVCCAPTURE_DEPENDENCIES=jpeg

ifeq ($(BR2_PACKAGE_UVCCAPTURE_version_head),y)
   UVCCAPTURE_VERSION:=$(shell git ls-remote $(UVCCAPTURE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_UVCCAPTURE_version_custom),y)
   UVCCAPTURE_VERSION=$(subst ",,$(BR2_PACKAGE_UVCCAPTURE_CONFIG_CUSTOM_VERSION_STR))
endif


ifeq ($(BR2_PACKAGE_UVCCAPTURE_version_0_90),y)
   UVCCAPTURE_VERSION:=v0.90
endif

ifeq ($(BR2_PACKAGE_UVCCAPTURE_version_0_92),y)
   UVCCAPTURE_VERSION:=v0.92
endif

ifeq ($(BR2_PACKAGE_UVCCAPTURE_version_0_94),y)
   UVCCAPTURE_VERSION:=v0.94
endif

ifeq ($(BR2_PACKAGE_UVCCAPTURE),y)
   UVCCAPTURE_VERSION?=$(shell git ls-remote $(UVCCAPTURE_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   UVCCAPTURE_VERSION?=v0.92
endif

define UVCCAPTURE_BUILD_CMDS
 $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define UVCCAPTURE_INSTALL_TARGET_CMDS
   $(MAKE) -C $(@D) INC_PATH=$(STAGING_DIR)/usr/include LIB_PATH=$(TARGET_DIR)/usr/lib BIN_PATH=$(TARGET_DIR)/usr/bin SBIN_PATH=$(TARGET_DIR)/usr/sbin ETC_PATH=$(TARGET_DIR)/etc LOCAL_BIN_PATH=$(TARGET_DIR)/usr/local/bin LOCAL_SBIN_PATH=$(TARGET_DIR)/usr/local/sbin install
endef

$(eval $(call GENTARGETS,package,uvccapture))
