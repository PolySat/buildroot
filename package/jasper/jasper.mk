################################################################################
#
# JasPer
#
################################################################################

JASPER_VERSION = 1.900.1
JASPER_SOURCE =jasper-$(JASPER_VERSION).zip
JASPER_SITE = http://www.ece.uvic.ca/~frodo/jasper/software/
JASPER_INSTALL_STAGING = YES
JASPER_EXTRACT_CMDS=unzip $(DL_DIR)/$(JASPER_SOURCE) -d $(BUILD_DIR)

define JASPER_REMOVE_USELESS_FILES
   mv -f $(TARGET_DIR)/usr/bin/jasper $(TARGET_DIR)/usr/local/bin
   mv -f $(TARGET_DIR)/usr/lib/libjasper.* $(TARGET_DIR)/usr/local/lib
endef

JASPER_POST_INSTALL_TARGET_HOOKS += JASPER_REMOVE_USELESS_FILES

$(eval $(call AUTOTARGETS))
