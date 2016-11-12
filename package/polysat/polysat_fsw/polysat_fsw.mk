#############################################################
#
# Polysat FSW
#
#############################################################
POLYSAT_FSW_SITE:=https://satcom.calpoly.edu/fsw
POLYSAT_FSW_VERSION = 1.0.2
POLYSAT_FSW_SOURCE = polysat_fsw-$(POLYSAT_FSW_VERSION).tgz
POLYSAT_FSW_SITE_METHOD:=wget_bauth
POLYSAT_FSW_WGET_AUTH:=$(shell cat '$(HOME)/.polysat_fsw.auth')
POLYSAT_FSW_INSTALL_STAGING=YES
POLYSAT_FSW_INSTALL_TARGET=YES
POLYSAT_FSW_DEPENDENCIES=host-module-init-tools

ifneq ( $(BR2_PACKAGE_POLYSAT_FSW_CONFIG_VERSION_STR),"")
   POLYSAT_FSW_VERSION=$(subst ",,$(BR2_PACKAGE_POLYSAT_FSW_CONFIG_VERSION_STR))
endif

define POLYSAT_FSW_BUILD_CMDS
endef

define POLYSAT_FSW_INSTALL_STAGING_CMDS
   rsync -a $(@D)/staging/ $(STAGING_DIR)
endef

define POLYSAT_FSW_INSTALL_TARGET_CMDS
   rsync -a $(@D)/target/ $(TARGET_DIR)
   rsync -a $(@D)/host/ $(HOST_DIR)
   $(HOST_DIR)/usr/sbin/depmod --basedir=$(TARGET_DIR) 2.6.30.2
endef

$(eval $(call GENTARGETS,package,polysat-fsw))
