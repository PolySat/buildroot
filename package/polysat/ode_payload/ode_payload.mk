#############################################################
#
# ode_payload
#
#############################################################
ODE_PAYLOAD_SITE:=git@github.com:rbalthazor/ode-payload.git
ODE_PAYLOAD_SITE_METHOD:=git
ODE_PAYLOAD_INSTALL_TARGET=YES
ODE_PAYLOAD_DEPENDENCIES=

ifeq ($(BR2_PACKAGE_ODE_PAYLOAD_version_head),y)
   ODE_PAYLOAD_VERSION:=$(shell git ls-remote $(ODE_PAYLOAD_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_ODE_PAYLOAD_version_custom),y)
   ODE_PAYLOAD_VERSION:=$(subst ",,$(BR2_PACKAGE_ODE_PAYLOAD_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_ODE_PAYLOAD),y)
   ODE_PAYLOAD_VERSION?=$(shell git ls-remote $(ODE_PAYLOAD_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   ODE_PAYLOAD_VERSION?=v1.25
endif

define ODE_PAYLOAD_BUILD_CMDS
 $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define ODE_PAYLOAD_INSTALL_TARGET_CMDS
   $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) INC_PATH=$(STAGING_DIR)/usr/include LIB_PATH=$(TARGET_DIR)/usr/local/lib BIN_PATH=$(TARGET_DIR)/usr/local/bin SBIN_PATH=$(TARGET_DIR)/usr/local/sbin ETC_PATH=$(TARGET_DIR)/usr/local/etc LOCAL_BIN_PATH=$(TARGET_DIR)/usr/local/bin LOCAL_SBIN_PATH=$(TARGET_DIR)/usr/local/sbin install
endef

$(eval $(call GENTARGETS,package,ode_payload))
