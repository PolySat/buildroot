#############################################################
#
# BLAS
#
#############################################################

BLAS_VERSION = 1.0
BLAS_SOURCE =blas.tgz
BLAS_SITE = http://www.netlib.org/blas
BLAS_INSTALL_STAGING = YES
BLAS_POST_INSTALL_TARGET_HOOKS=BLAS_CLEANUP_STATIC_LIBRARIES

define BLAS_CLEANUP_STATIC_LIBRARIES
endef

define BLAS_CONFIGURE_CMDS
endef

define BLAS_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) alllib
endef

define BLAS_INSTALL_STAGING_CMDS
   mkdir -p $(STAGING_DIR)/usr/lib
   mkdir -p $(STAGING_DIR)/usr/include
   #cp -f $(@D)/lib/*.a $(STAGING_DIR)/usr/lib
   #cp -f $(@D)/include/* $(STAGING_DIR)/usr/include
endef

define BLAS_INSTALL_TARGET_CMDS
endef

define BLAS_CLEAN_CMDS
endef

define BLAS_UNINSTALL_STAGING_CMDS
endef

define BLAS_UNINSTALL_TARGET_CMDS
endef

$(eval $(call GENTARGETS))
