#############################################################
#
# Polysat beacon
#
#############################################################
BEACON_SITE:=https://github.com/PolySat/beacon
BEACON_SITE_METHOD:=git
BEACON_INSTALL_TARGET=YES
BEACON_DEPENDENCIES=libproc libsatpkt

ifeq ($(BR2_PACKAGE_BEACON_version_head),y)
BEACON_VERSION:=$(shell git ls-remote $(BEACON_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_BEACON_version_custom),y)
   BEACON_VERSION=$(subst ",,$(BR2_PACKAGE_BEACON_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_BEACON_version_1_19),y)
BEACON_VERSION:=v1.19
endif

ifeq ($(BR2_PACKAGE_BEACON_version_1_0),y)
BEACON_VERSION:=v1.0
endif

ifeq ($(BR2_PACKAGE_BEACON),y)
   BEACON_VERSION?=$(shell git ls-remote $(BEACON_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
   ifeq ($(BR2_PACKAGE_AUTOTELEM),y)
      ifeq ($(BR2_PACKAGE_BEACON_AUTOTELEM),y)
         AUTOTELEM_DEPENDENCIES+=host-beacon
         BR2_PACKAGE_AUTOTELEM_UTIL_SOURCES+=$(HOST_DIR)/usr/bin/beacon-util
      endif
   endif

else
   BEACON_VERSION?=v1.19
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_Spinnaker3),y)
BEACON_FORMAT:=SPINNAKER3
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_1U),y)
BEACON_FORMAT:=1U
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_ExoCube),y)
BEACON_FORMAT:=EXOCUBE
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_ipex1),y)
BEACON_FORMAT:=IPEX1
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_ipexbf1),y)
BEACON_FORMAT:=IPEXBF1
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_ipexbf2),y)
BEACON_FORMAT:=IPEXBF2
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_ISX),y)
BEACON_FORMAT:=ISX
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_lsb),y)
BEACON_DEPENDENCIES+=pscam
BEACON_FORMAT:=LIGHTSAIL_B
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_ExoCube2),y)
BEACON_FORMAT:=EXOCUBE2
endif

ifeq ($(BR2_PACKAGE_BEACON_fmt_stub),y)
BEACON_FORMAT:=STUB
endif

BEACON_FORMAT?=STUB

define BEACON_BUILD_CMDS
 $(MAKE) $(TARGET_CONFIGURE_OPTS) BEACON_FMT=$(BEACON_FORMAT) -C $(@D)
endef

define HOST_BEACON_BUILD_CMDS
 $(MAKE1) -C $(@D) ARM_TOOLCHAIN_PATH=$(HOST_DIR)/usr
endef

define BEACON_INSTALL_TARGET_CMDS
   $(MAKE) $(TARGET_CONFIGURE_OPTS) BEACON_FMT=$(BEACON_FORMAT) -C $(@D) INC_PATH=$(STAGING_DIR)/usr/include LIB_PATH=$(TARGET_DIR)/usr/lib BIN_PATH=$(TARGET_DIR)/usr/bin SBIN_PATH=$(TARGET_DIR)/usr/sbin ETC_PATH=$(TARGET_DIR)/etc LOCAL_BIN_PATH=$(TARGET_DIR)/usr/local/bin LOCAL_SBIN_PATH=$(TARGET_DIR)/usr/local/sbin install
endef

define HOST_BEACON_INSTALL_CMDS
   $(MAKE1) -C $(@D) INC_PATH=$(HOST_DIR)/usr/include LIB_PATH=$(HOST_DIR)/usr/lib BIN_PATH=$(HOST_DIR)/usr/bin SBIN_PATH=$(HOST_DIR)/usr/sbin ETC_PATH=$(HOST_DIR)/etc LOCAL_BIN_PATH=$(HOST_DIR)/usr/bin LOCAL_SBIN_PATH=$(HOST_DIR)/usr/sbin install
endef

$(eval $(call GENTARGETS,package,beacon))
$(eval $(call GENTARGETS,host,beacon))
