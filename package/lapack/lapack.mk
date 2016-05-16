#############################################################
#
# LAPACK
#
#############################################################

LAPACK_VERSION = 3.4.2
LAPACK_SOURCE =lapack-$(LAPACK_VERSION).tgz
LAPACK_SITE = http://www.netlib.org/lapack
LAPACK_INSTALL_STAGING = YES
LAPACK_POST_INSTALL_TARGET_HOOKS=LAPACK_CLEANUP_STATIC_LIBRARIES

define LAPACK_CLEANUP_STATIC_LIBRARIES
endef

define LAPACK_CONFIGURE_CMDS
endef

define LAPACK_BUILD_CMDS
   cat $(@D)/make.inc.example | sed -e 's/gfortran/$$(FC)/g' > $(@D)/make.inc
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) blaslib lapacklib tmglib
endef

define LAPACK_INSTALL_STAGING_CMDS
   mkdir -p $(STAGING_DIR)/usr/lib
   cp -f $(@D)/lib*.a $(STAGING_DIR)/usr/lib
   cp -f $(@D)/librefblas.a $(STAGING_DIR)/usr/lib/libblas.a
endef

define LAPACK_INSTALL_TARGET_CMDS
endef

define LAPACK_CLEAN_CMDS
endef

define LAPACK_UNINSTALL_STAGING_CMDS
endef

define LAPACK_UNINSTALL_TARGET_CMDS
endef

$(eval $(call GENTARGETS))
