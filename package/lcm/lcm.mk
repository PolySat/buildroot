#############################################################
#
# openocd
#
#############################################################
#https://lcm.googlecode.com/files/lcm-1.0.0.tar.gz
LCM_VERSION:=1.0.0
LCM_SOURCE = lcm-$(LCM_VERSION).tar.gz
LCM_SITE = https://lcm.googlecode.com/files

#LCM_AUTORECONF = YES
#LCM_DEPENDENCIES =

HOST_LCM_DEPENDENCIES = host-libglib2
LCM_ST_HEADERS=$(STAGING_DIR)/usr/include/lcm

define LCM_INSTALL_STAGING_CMDS
endef

define LCM_INSTALL_TARGET_CMDS
endef

define HOST_LCM_INSTALL_CMDS
        $(MAKE1) -C $(@D) install
	mkdir -p $(LCM_ST_HEADERS)
	cp -f $(@D)/lcm/eventlog.h $(@D)/lcm/lcm_coretypes.h $(@D)/lcm/lcm-cpp.hpp $(@D)/lcm/lcm-cpp-impl.hpp $(@D)/lcm/lcm.h $(LCM_ST_HEADERS)
endef


#$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
