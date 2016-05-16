INTREPID_SAM_BA_SITE:=git@asof.atl.calpoly.edu:sam-ba
INTREPID_SAM_BA_SITE_METHOD:=git
INTREPID_SAM_BA_VERSION:=HEAD
HOST_INTREPID_SAM_BA_DEPENDENCIES:=host-sourcery-codebench

define HOST_INTREPID_SAM_BA_BUILD_CMDS
	$(MAKE) -C $(@D)/applets/isp-project CROSS_COMPILE=$(HOST_SOURCERY_CODEBENCH_PATH)/bin/arm-none-eabi-
endef

# Since it's a prebuilt application and it does not conform to the
# usual Unix hierarchy, we install it in $(HOST_DIR)/opt/sam-ba and
# then create a symbolic link from $(HOST_DIR)/usr/bin to the
# application binary, for easier usage.

define HOST_INTREPID_SAM_BA_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/opt/intrepid-sam-ba/
	cp -a $(@D)/* $(HOST_DIR)/opt/intrepid-sam-ba/
endef

host-intrepid-sam-ba: host-sourcery-codebench

$(eval $(call GENTARGETS,host))
