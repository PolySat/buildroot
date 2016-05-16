#############################################################
#
# netperf
#
#############################################################

http://downloads.sourceforge.net/project/gmic/gmic_1.5.5.2.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgmic%2Ffiles%2F&ts=1366841012&use_mirror=superb-dca3
GMIC_VERSION = 1.5.5.2
GMIC_SOURCE:=gmic_$(GMIC_VERSION).tar.gz
GMIC_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gmic
GMIC_CONFIGURE_PREFIX=/usr/local
GMIC_CONFIGURE_EXEC_PREFIX=/usr/local
#NETPBM_INSTALL_STAGING=YES
GMIC_INSTALL_TARGET=YES

#   make -C CC=$(TARGET_CC) $(@D)
define GMIC_BUILD_CMDS
   make CC=$(TARGET_CC) -C $(@D)/src lib
   make CC=$(TARGET_CC) -C $(@D)/src 
endef

define GMIC_INSTALL_TARGET_CMDS
endef

define GMIC_INSTALL_STAGING_CMDS
endef

define GMIC_POST_PATCH_CMDS
endef
GMIC_POST_PATCH_HOOKS+=GMIC_POST_PATCH_CMDS

$(eval $(call GENTARGETS,package,gmic))

#   cp $(@D)/
