#############################################################
#
# CBLAS
#
#############################################################

CBLAS_VERSION = 1.0
CBLAS_SOURCE =cblas.tgz
CBLAS_SITE = http://www.netlib.org/blas/blast-forum
CBLAS_INSTALL_STAGING = YES
CBLAS_POST_INSTALL_TARGET_HOOKS=CBLAS_CLEANUP_STATIC_LIBRARIES

define CBLAS_CLEANUP_STATIC_LIBRARIES
endef

define CBLAS_CONFIGURE_CMDS
endef

define CBLAS_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) alllib
endef

define CBLAS_INSTALL_STAGING_CMDS
   mkdir -p $(STAGING_DIR)/usr/lib
   mkdir -p $(STAGING_DIR)/usr/include
   cp -f $(@D)/lib/*.a $(STAGING_DIR)/usr/lib
   cp -f $(@D)/include/* $(STAGING_DIR)/usr/include
endef

define CBLAS_INSTALL_TARGET_CMDS
endef

define CBLAS_CLEAN_CMDS
endef

define CBLAS_UNINSTALL_STAGING_CMDS
endef

define CBLAS_UNINSTALL_TARGET_CMDS
endef

$(eval $(call GENTARGETS))
