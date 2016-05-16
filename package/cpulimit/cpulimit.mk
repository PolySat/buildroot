#############################################################
#
# cpulimit
#
#############################################################
CPULIMIT_VERSION = HEAD
#CPULIMIT_SOURCE = cpulimit-$(IPERF_VERSION).tar.gz
CPULIMIT_SITE = https://github.com/opsengine/cpulimit.git
CPULIMIT_SITE_METHOD=git

define CPULIMIT_BUILD_CMDS
 $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/src
 $(STRIPCMD) $(@D)/src/cpulimit
endef

define CPULIMIT_INSTALL_TARGET_CMDS
 cp -f $(@D)/src/cpulimit $(TARGET_DIR)/usr/local/bin
endef

$(eval $(call GENTARGETS,package,cpulimit))
