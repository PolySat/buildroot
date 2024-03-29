#############################################################
#
# epeg
#
#############################################################
EPEG_VERSION = v0.9.3
EPEG_SITE = https://github.com/mattes/epeg.git
EPEG_SITE_METHOD=git
EPEG_INSTALL_STAGING = YES
EPEG_DEPENDENCIES = jpeg libexif

define EPEG_CREATE_CONFIG_FILE
   (cd $(@D); PATH=$(PATH):$(HOST_DIR)/usr/bin NOCONFIGURE=1 $(@D)/autogen.sh)
endef

EPEG_PRE_CONFIGURE_HOOKS += EPEG_CREATE_CONFIG_FILE

$(eval $(call AUTOTARGETS))
