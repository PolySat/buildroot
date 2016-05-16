#############################################################
#
# netperf
#
#############################################################

NETPBM_VERSION = 10.35.88
NETPBM_SOURCE:=netpbm-$(NETPBM_VERSION).tgz
NETPBM_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/netpbm/super_stable/$(NETPBM_VERSION)
NETPBM_CONFIGURE_PREFIX=/usr/local
NETPBM_CONFIGURE_EXEC_PREFIX=/usr/local
#NETPBM_INSTALL_STAGING=YES
NETPBM_INSTALL_TARGET=YES

#   make -C CC=$(TARGET_CC) $(@D)
define NETPBM_BUILD_CMDS
   make CC=$(TARGET_CC) -C $(@D)
endef

define NETPBM_INSTALL_TARGET_CMDS
endef

define NETPBM_INSTALL_STAGING_CMDS
endef

define NETPBM_POST_PATCH_CMDS
   cp $(TOPDIR)/package/netpbm/Makefile.config $(@D)
endef
NETPBM_POST_PATCH_HOOKS+=NETPBM_POST_PATCH_CMDS

$(eval $(call GENTARGETS,package,netpbm))

#   cp $(@D)/
