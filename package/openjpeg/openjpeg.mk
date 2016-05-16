#############################################################
#
# openjpeg (libraries needed by some apps)
#
#############################################################
OPENJPEG_VERSION = r2301
OPENJPEG_SITE = http://openjpeg.googlecode.com/svn/trunk
OPENJPEG_SITE_METHOD=svn
OPENJPEG_CONFIGURE_PREFIX=/usr/local
OPENJPEG_CONFIGURE_EXEC_PREFIX=/usr/local
OPENJPEG_DEPENDENCIES += host-cmake
OPENJPEG_INSTALL_STAGING=YES

define OPENJPEG_FIX_INSTALL_LOCATIONS
   rm -rf $(TARGET_DIR)/usr/include
   rm -rf $(TARGET_DIR)/usr/lib/pkgconfig
   rm -rf $(TARGET_DIR)/usr/lib/openjpeg-*
   mv -f $(TARGET_DIR)/usr/lib/libopenjp2.* $(TARGET_DIR)/usr/local/lib
   mv -f $(TARGET_DIR)/usr/bin/opj_* $(TARGET_DIR)/usr/local/bin
endef

OPENJPEG_POST_INSTALL_TARGET_HOOKS += OPENJPEG_FIX_INSTALL_LOCATIONS

$(eval $(call CMAKETARGETS))
