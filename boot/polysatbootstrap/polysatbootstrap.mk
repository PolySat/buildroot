#############################################################
#
# at91bootstrap
#
#############################################################

ifdef BR2_TARGET_POLYSATBOOTSTRAP

POLYSATBOOTSTRAP_SITE = https://satcom.calpoly.edu/fsw
POLYSATBOOTSTRAP_SITE_METHOD = wget_bauth
POLYSATBOOTSTRAP_VERSION = 1.16-irvine01
POLYSATBOOTSTRAP_SOURCE = PolySatBootstrap-$(POLYSATBOOTSTRAP_VERSION).tar.gz
POLYSATBOOTSTRAP_WGET_AUTH = $(shell cat '$(HOME)/.polysat_fsw.auth')

POLYSATBOOTSTRAP_BOARD = at91sam9g20ek
POLYSATBOOTSTRAP_MEMORY = intrepid
POLYSATBOOTSTRAP_BINARY = $(POLYSATBOOTSTRAP_MEMORY)_$(POLYSATBOOTSTRAP_BOARD).bin

POLYSATBOOTSTRAP_INSTALL_IMAGES = YES
POLYSATBOOTSTRAP_INSTALL_TARGET = NO

ifeq ($(BR2_TARGET_POLYSATBOOTSTRAP_version_custom),y)
   POLYSATBOOTSTRAP_VERSION:=$(subst ",,$(BR2_TARGET_POLYSATBOOTSTRAP_CONFIG_CUSTOM_VERSION_STR))
endif

define POLYSATBOOTSTRAP_BUILD_CMDS
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)
endef

define POLYSATBOOTSTRAP_INSTALL_IMAGES_CMDS
endef

define POLYSATBOOTSTRAP_INSTALL_HOOK
	mv $(2)/$(1).$(ROOTFS_FILE_NAME) $(2)/rootfs.bin
	mv $(2)/$(1).$(USRLOCAL_FILE_NAME) $(2)/$(USRLOCAL_FILE_NAME)
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) DFL_KERN=$(2)/linux-kernel.bin DFL_FS=$(2)/rootfs.bin DFL_LOCAL_FS=$(2)/$(USRLOCAL_FILE_NAME) -C $(POLYSATBOOTSTRAP_DIR)
	cp -f $(POLYSATBOOTSTRAP_DIR)/install.sh $(2)
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-part2.bin $(2)/bootstrap-part2.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-devboard.bin $(2)/bootstrap-devboard-64mb.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-4nand-devboard.bin $(2)/bootstrap-devboard-64mb-4nand.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-128-devboard.bin $(2)/bootstrap-devboard-128mb.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-128-4nand-devboard.bin $(2)/bootstrap-devboard-128mb-4nand.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-128-4nand-flightboard.bin $(2)/bootstrap-intrepid-128mb-4nand.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-64-flightboard.bin $(2)/bootstrap-intrepid-64mb.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-64-4nand-flightboard.bin $(2)/bootstrap-intrepid-64mb-4nand.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-flightboard.bin $(2)/bootstrap-intrepid-128mb.bin
	cp $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-flightboard.bin $(2)/bootstrap-intrepid-128mb.bin
	rm -f $(2)/.sed_script
	echo s!set basePath \".*\"!set basePath \"`cd $(2); pwd -P `\"!g >> $(2)/.sed_script
	echo s!asePath/.*/linux-kernel.bin\"!asePath/linux-kernel.bin\"!g >> $(2)/.sed_script
	echo s!asePath/.*/rootfs.bin\"!asePath/rootfs.bin\"!g >> $(2)/.sed_script
	echo s/intrepid_at91sam9g20ek-part2.bin/bootstrap-part2.bin/g >> $(2)/.sed_script
	echo s/intrepid_at91sam9g20ek-devboard.bin/bootstrap-devboard-64mb.bin/g >> $(2)/.sed_script
	echo s/intrepid_at91sam9g20ek-64-flightboard.bin/bootstrap-intrepid-64mb.bin/g >> $(2)/.sed_script
	sed -f $(2)/.sed_script $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-DevBoard-AT45DB.tcl > $(2)/flash-devboard-64mb.tcl
	sed -f $(2)/.sed_script $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-intrepid-64.tcl > $(2)/flash-intrepid-64mb.tcl
	sed -e s/bootstrap-intrepid-64mb/bootstrap-intrepid-128mb/g $(2)/flash-intrepid-64mb.tcl > $(2)/flash-intrepid-128mb.tcl
	sed -e s/bootstrap-intrepid-64mb/bootstrap-intrepid-128mb-4nand/g $(2)/flash-intrepid-64mb.tcl > $(2)/flash-intrepid-128mb-4nand.tcl
	sed -e s/bootstrap-intrepid-64mb/bootstrap-intrepid-64mb-4nand/g $(2)/flash-intrepid-64mb.tcl > $(2)/flash-intrepid-64mb-4nand.tcl
	sed -e s/bootstrap-devboard-64mb/bootstrap-devboard-64mb-4nand/g $(2)/flash-devboard-64mb.tcl > $(2)/flash-devboard-64mb-4nand.tcl
	sed -e s/bootstrap-devboard-64mb/bootstrap-devboard-128mb-4nand/g $(2)/flash-devboard-64mb.tcl > $(2)/flash-devboard-128mb-4nand.tcl
	sed -e s/bootstrap-devboard-64mb/bootstrap-devboard-128mb/g $(2)/flash-devboard-64mb.tcl > $(2)/flash-devboard-128mb.tcl
	rm $(2)/.sed_script
	echo s/intrepid_at91sam9g20ek-part2.bin/bootstrap-part2.bin/g >> $(2)/.sed_script
	echo s/intrepid_at91sam9g20ek-devboard.bin/bootstrap-devboard-64mb.bin/g >> $(2)/.sed_script
	echo s/intrepid_at91sam9g20ek-64-flightboard.bin/bootstrap-intrepid-64mb.bin/g >> $(2)/.sed_script
	sed -f $(2)/.sed_script $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-DevBoard-AT45DB.sh > $(2)/flash-devboard-64mb.sh
	sed -f $(2)/.sed_script $(POLYSATBOOTSTRAP_DIR)/intrepid_at91sam9g20ek-intrepid-64.sh > $(2)/flash-intrepid-64mb.sh
	sed -e s/bootstrap-intrepid-64mb/bootstrap-intrepid-128mb/g $(2)/flash-intrepid-64mb.sh > $(2)/flash-intrepid-128mb.sh
	sed -e s/bootstrap-intrepid-64mb/bootstrap-intrepid-128mb-4nand/g $(2)/flash-intrepid-64mb.sh > $(2)/flash-intrepid-128mb-4nand.sh
	sed -e s/bootstrap-intrepid-64mb/bootstrap-intrepid-64mb-4nand/g $(2)/flash-intrepid-64mb.sh > $(2)/flash-intrepid-64mb-4nand.sh
	sed -e s/bootstrap-devboard-64mb/bootstrap-devboard-64mb-4nand/g $(2)/flash-devboard-64mb.sh > $(2)/flash-devboard-64mb-4nand.sh
	sed -e s/bootstrap-devboard-64mb/bootstrap-devboard-128mb-4nand/g $(2)/flash-devboard-64mb.sh > $(2)/flash-devboard-128mb-4nand.sh
	sed -e s/bootstrap-devboard-64mb/bootstrap-devboard-128mb/g $(2)/flash-devboard-64mb.sh > $(2)/flash-devboard-128mb.sh
	rm $(2)/.sed_script
endef

BOOTSTRAP_INSTALL_HOOKS += POLYSATBOOTSTRAP_INSTALL_HOOK

$(eval $(call GENTARGETS,package,polysatbootstrap))

endif
