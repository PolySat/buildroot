#############################################################
#
# Polysat camera drivers
#
#############################################################
ATMEL_ISI_SITE:=git@github.com:PolySat/atmel-isi.git
ATMEL_ISI_SITE_METHOD:=git
ATMEL_ISI_INSTALL_TARGET=YES
ATMEL_ISI_INSTALL_STAGING=YES
ATMEL_ISI_DEPENDENCIES=linux

ifeq ($(BR2_PACKAGE_ATMEL_ISI_version_head),y)
   ATMEL_ISI_VERSION:=$(shell git ls-remote $(ATMEL_ISI_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
endif

ifeq ($(BR2_PACKAGE_ATMEL_ISI_version_custom),y)
   ATMEL_ISI_VERSION=$(subst ",,$(BR2_PACKAGE_ATMEL_ISI_CONFIG_CUSTOM_VERSION_STR))
endif

ifeq ($(BR2_PACKAGE_ATMEL_ISI),y)
   ATMEL_ISI_VERSION?=$(shell git ls-remote $(ATMEL_ISI_SITE) | grep HEAD | head -1 | sed -e 's/[ \t]*HEAD//')
else
   ATMEL_ISI_VERSION?=v0.00
endif

define ATMEL_ISI_BUILD_CMDS
 $(ATMEL_ISI_MAKE_PARAMS) $(MAKE1) $(LINUX_MAKE_FLAGS) DEPMOD="$(HOST_DIR)/usr/sbin/depmod" M="$(@D)" -C "$(LINUX_DIR)" modules
endef

define ATMEL_ISI_INSTALL_STAGING_CMDS
	mkdir -p $(LINUX_DIR)/include/linux/polysat
	$(ATMEL_ISI_MAKE_PARAMS) $(MAKE) HEADER_DIR=$(LINUX_DIR)/include/linux/polysat -C "$(@D)" PWD="$(@D)" install_headers
	mkdir -p $(STAGING_DIR)/usr/include/linux/polysat
	$(ATMEL_ISI_MAKE_PARAMS) $(MAKE) HEADER_DIR=$(STAGING_DIR)/usr/include/linux/polysat -C "$(@D)" PWD="$(@D)" install_headers
endef

define ATMEL_ISI_INSTALL_TARGET_CMDS
 $(ATMEL_ISI_MAKE_PARAMS) $(MAKE1) $(LINUX_MAKE_FLAGS) DEPMOD="$(HOST_DIR)/usr/sbin/depmod" M="$(@D)" -C "$(LINUX_DIR)" modules_install
endef

$(eval $(call GENTARGETS,package,atmel-isi))
