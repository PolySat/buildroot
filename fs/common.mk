#
# Macro that builds the needed Makefile target to create a root
# filesystem image.
#
# The following variable must be defined before calling this macro
#
#  ROOTFS_$(FSTYPE)_CMD, the command that generates the root
#  filesystem image. A single command is allowed. The filename of the
#  filesystem image that it must generate is $$@.
#
# The following variables can optionaly be defined
#
#  ROOTFS_$(FSTYPE)_DEPENDENCIES, the list of dependencies needed to
#  build the root filesystem (usually host tools)
#
#  ROOTFS_$(FSTYPE)_PRE_GEN_HOOKS, a list of hooks to call before
#  generating the filesystem image
#
#  ROOTFS_$(FSTYPE)_POST_GEN_HOOKS, a list of hooks to call after
#  generating the filesystem image
#
#  ROOTFS_$(FSTYPE)_POST_TARGETS, the list of targets that should be
#  run after running the main filesystem target. This is useful for
#  initramfs, to rebuild the kernel once the initramfs is generated.
#
# In terms of configuration option, this macro assumes that the
# BR2_TARGET_ROOTFS_$(FSTYPE) config option allows to enable/disable
# the generation of a filesystem image of a particular type. If
# configura options BR2_TARGET_ROOTFS_$(FSTYPE)_GZIP,
# BR2_TARGET_ROOTFS_$(FSTYPE)_BZIP2 or
# BR2_TARGET_ROOTFS_$(FSTYPE)_LZMA exist and are enabled, then the
# macro will automatically generate a compressed filesystem image.

FAKEROOT_SCRIPT = $(BUILD_DIR)/_fakeroot.fs
FULL_DEVICE_TABLE = $(BUILD_DIR)/_device_table.txt
ROOTFS_DEVICE_TABLES = $(call qstrip,$(BR2_ROOTFS_DEVICE_TABLE)) \
	$(call qstrip,$(BR2_ROOTFS_STATIC_DEVICE_TABLE))

define ROOTFS_TARGET_INTERNAL

# extra deps
$(eval ROOTFS_$(2)_DEPENDENCIES += host-fakeroot host-makedevs $(if $(BR2_TARGET_ROOTFS_$(2)_LZMA),host-lzma))

# Stash the rootfs file name into a variable for others to use
ifeq ($$(BR2_TARGET_ROOTFS_$(2)),y)
ROOTFS_FILE_NAME=rootfs.$(1)
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_GZIP),y)
	ROOTFS_FILE_NAME=rootfs.$(1).gz
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_BZIP2),y)
	ROOTFS_FILE_NAME=rootfs.$(1).bz2
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZMA),y)
	ROOTFS_FILE_NAME=rootfs.$(1).lzma
endif
endif

ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)),y)
USRLOCAL_FILE_NAME=usr_local.$(1)
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_GZIP),y)
	USRLOCAL_FILE_NAME=usr_local.$(1).gz
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_BZIP2),y)
	USRLOCAL_FILE_NAME=usr_local.$(1).bz2
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZMA),y)
	USRLOCAL_FILE_NAME=usr_local.$(1).lzma
endif
endif

$(BINARIES_DIR)/rootfs.$(1): $(BINARIES_DIR)/snapshot.target.tar $(ROOTFS_$(2)_DEPENDENCIES)
	@$(call MESSAGE,"Generating root filesystem image rootfs.$(1)")
	rm -rf $(BUILD_DIR)/.saved_target
	mv $(TARGET_DIR) $(BUILD_DIR)/.saved_target
	mkdir -p $(TARGET_DIR)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.target.tar)
	$(foreach hook,$(ROOTFS_$(2)_PRE_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($(BR2_TARGET_SEPARATE_USR_LOCAL),y)
	rm -rf $(BUILD_DIR)/.saved_usr_local
	mv $(TARGET_DIR)/usr/local $(BUILD_DIR)/.saved_usr_local
	mkdir -p $(TARGET_DIR)/usr/local
endif
	rm -f $(FAKEROOT_SCRIPT)
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
ifneq ($(ROOTFS_DEVICE_TABLES),)
	cat $(ROOTFS_DEVICE_TABLES) > $(FULL_DEVICE_TABLE)
ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)
	echo -e '$(subst $(sep),\n,$(PACKAGES_DEVICES_TABLE))' >> $(FULL_DEVICE_TABLE)
endif
	echo -e '$(subst $(sep),\n,$(PACKAGES_PERMISSIONS_TABLE))' >> $(FULL_DEVICE_TABLE)
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(FULL_DEVICE_TABLE) $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
endif
	echo "$(ROOTFS_$(2)_CMD)" >> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT) $(FULL_DEVICE_TABLE)
	$(foreach hook,$(ROOTFS_$(2)_POST_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_GZIP),y)
	gzip -9 -c $$@ > $$@.gz
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_BZIP2),y)
	bzip2 -9 -c $$@ > $$@.bz2
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZMA),y)
	$(LZMA) -9 -c $$@ > $$@.lzma
endif
ifeq ($(BR2_TARGET_SEPARATE_USR_LOCAL),y)
	rmdir $(TARGET_DIR)/usr/local
	mv $(BUILD_DIR)/.saved_usr_local $(TARGET_DIR)/usr/local
	rm -rf $(BUILD_DIR)/.saved_usr_local
endif
	rm -rf $(TARGET_DIR)
	mv $(BUILD_DIR)/.saved_target $(TARGET_DIR)

$(BINARIES_DIR)/%.rootfs.$(1): $(BINARIES_DIR)/snapshot.%.target.tar $(ROOTFS_$(2)_DEPENDENCIES)
	@$(call MESSAGE,"Generating root filesystem image $$(@:$(BINARIES_DIR)/%.rootfs.$(1)=%).rootfs.$(1)")
	rm -rf $(BUILD_DIR)/.saved_target
	mv $(TARGET_DIR) $(BUILD_DIR)/.saved_target
	mkdir -p $(TARGET_DIR)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.$$(@:$(BINARIES_DIR)/%.rootfs.$(1)=%).target.tar)
	$(foreach hook,$(ROOTFS_$(2)_PRE_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($(BR2_TARGET_SEPARATE_USR_LOCAL),y)
	rm -rf $(BUILD_DIR)/.saved_usr_local
	mv $(TARGET_DIR)/usr/local $(BUILD_DIR)/.saved_usr_local
	mkdir -p $(TARGET_DIR)/usr/local
endif
	rm -f $(FAKEROOT_SCRIPT)
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
ifneq ($(ROOTFS_DEVICE_TABLES),)
	cat $(ROOTFS_DEVICE_TABLES) > $(FULL_DEVICE_TABLE)
ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)
	echo -e '$(subst $(sep),\n,$(PACKAGES_DEVICES_TABLE))' >> $(FULL_DEVICE_TABLE)
endif
	echo -e '$(subst $(sep),\n,$(PACKAGES_PERMISSIONS_TABLE))' >> $(FULL_DEVICE_TABLE)
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(FULL_DEVICE_TABLE) $(TARGET_DIR)" >> $(FAKEROOT_SCRIPT)
endif
	echo "$(ROOTFS_$(2)_CMD)" >> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT) $(FULL_DEVICE_TABLE)
	$(foreach hook,$(ROOTFS_$(2)_POST_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_GZIP),y)
	gzip -9 -c $$@ > $$@.gz
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_BZIP2),y)
	bzip2 -9 -c $$@ > $$@.bz2
endif
ifeq ($$(BR2_TARGET_ROOTFS_$(2)_LZMA),y)
	$(LZMA) -9 -c $$@ > $$@.lzma
endif
ifeq ($(BR2_TARGET_SEPARATE_USR_LOCAL),y)
	rmdir $(TARGET_DIR)/usr/local
	mv $(BUILD_DIR)/.saved_usr_local $(TARGET_DIR)/usr/local
	rm -rf $(BUILD_DIR)/.saved_usr_local
endif
	rm -rf $(TARGET_DIR)
	mv $(BUILD_DIR)/.saved_target $(TARGET_DIR)

ifeq ($(BR2_TARGET_SEPARATE_USR_LOCAL),y)
$(BINARIES_DIR)/usr_local.$(1): $(BINARIES_DIR)/snapshot.target.tar $(USR_LOCAL_$(2)_DEPENDENCIES)
	@$(call MESSAGE,"Generating /usr/local filesystem image usr_local.$(1)")
	rm -rf $(BUILD_DIR)/.saved_target
	mv $(TARGET_DIR) $(BUILD_DIR)/.saved_target
	mkdir -p $(TARGET_DIR)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.target.tar)
	$(foreach hook,$(USR_LOCAL_$(2)_PRE_GEN_HOOKS),$(call $(hook))$(sep))
	rm -f $(FAKEROOT_SCRIPT)
	echo "chown -R 0:0 $(TARGET_DIR)/usr/local" >> $(FAKEROOT_SCRIPT)
	echo "$(USR_LOCAL_$(2)_CMD)" >> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT)
	$(foreach hook,$(USR_LOCAL_$(2)_POST_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)_GZIP),y)
	gzip -9 -c $$@ > $$@.gz
endif
ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)_BZIP2),y)
	bzip2 -9 -c $$@ > $$@.bz2
endif
ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)_LZMA),y)
	$(LZMA) -9 -c $$@ > $$@.lzma
endif
	rm -rf $(TARGET_DIR)
	mv $(BUILD_DIR)/.saved_target $(TARGET_DIR)

$(BINARIES_DIR)/%.usr_local.$(1): $(BINARIES_DIR)/snapshot.%.target.tar $(USR_LOCAL_$(2)_DEPENDENCIES)
	@$(call MESSAGE,"Generating /usr/local filesystem image $$(@:$(BINARIES_DIR)/%.usr_local.$(1)=%).usr_local.$(1)")
	rm -rf $(BUILD_DIR)/.saved_target
	mv $(TARGET_DIR) $(BUILD_DIR)/.saved_target
	mkdir -p $(TARGET_DIR)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.$$(@:$(BINARIES_DIR)/%.usr_local.$(1)=%).target.tar)
	$(foreach hook,$(USR_LOCAL_$(2)_PRE_GEN_HOOKS),$(call $(hook))$(sep))
	rm -f $(FAKEROOT_SCRIPT)
	echo "chown -R 0:0 $(TARGET_DIR)/usr/local" >> $(FAKEROOT_SCRIPT)
	echo "$(USR_LOCAL_$(2)_CMD)" >> $(FAKEROOT_SCRIPT)
	chmod a+x $(FAKEROOT_SCRIPT)
	$(HOST_DIR)/usr/bin/fakeroot -- $(FAKEROOT_SCRIPT)
	-@rm -f $(FAKEROOT_SCRIPT)
	$(foreach hook,$(USR_LOCAL_$(2)_POST_GEN_HOOKS),$(call $(hook))$(sep))
ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)_GZIP),y)
	gzip -9 -c $$@ > $$@.gz
endif
ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)_BZIP2),y)
	bzip2 -9 -c $$@ > $$@.bz2
endif
ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)_LZMA),y)
	$(LZMA) -9 -c $$@ > $$@.lzma
endif
	rm -rf $(TARGET_DIR)
	mv $(BUILD_DIR)/.saved_target $(TARGET_DIR)
endif

rootfs-$(1)-show-depends:
	@echo $(ROOTFS_$(2)_DEPENDENCIES)

usr-local-$(1)-show-depends:
	@echo $(USR_LOCAL_$(2)_DEPENDENCIES)

rootfs-$(1): $(BINARIES_DIR)/rootfs.$(1) $(ROOTFS_$(2)_POST_TARGETS)

usr-local-$(1): $(BINARIES_DIR)/usr_local.$(1) $(USR_LOCAL_$(2)_POST_TARGETS)

ifeq ($$(BR2_TARGET_ROOTFS_$(2)),y)
TARGETS += rootfs-$(1)
TARGETS += $(ROOTFS_CUSTOM_IMAGES:%=%-rootfs-$(1))
FS_TARGETS += $(ROOTFS_CUSTOM_IMAGES:%=%-rootfs-$(1))
$(foreach cust,$(ROOTFS_CUSTOM_IMAGES),$(eval $(call ROOTFS_TARGET_ADD_CUSTOM_IMAGE_ROOTFS_DEPS,$(cust),$(1),$(2))))

endif

ifeq ($$(BR2_TARGET_USR_LOCAL_$(2)),y)
TARGETS += usr-local-$(1)
TARGETS += $(ROOTFS_CUSTOM_IMAGES:%=%-usr-local-$(1))
FS_TARGETS += $(ROOTFS_CUSTOM_IMAGES:%=%-usr-local-$(1))
$(foreach cust,$(ROOTFS_CUSTOM_IMAGES),$(eval $(call ROOTFS_TARGET_ADD_CUSTOM_IMAGE_USR_LOCAL_DEPS,$(cust),$(1),$(2))))
endif
endef

define ROOTFS_TARGET_ADD_CUSTOM_IMAGE_ROOTFS_DEPS
$(1)-rootfs-$(2): $(BINARIES_DIR)/$(1).rootfs.$(2) $(ROOTFS_$(3)_POST_TARGETS)
endef

define ROOTFS_TARGET_ADD_CUSTOM_IMAGE_USR_LOCAL_DEPS
$(1)-usr-local-$(2): $(BINARIES_DIR)/$(1).usr_local.$(2) $(ROOTFS_$(3)_POST_TARGETS)
endef

define ROOTFS_TARGET_ADD_CUSTOM_IMAGE
ROOTFS_CUSTOM_IMAGES += $(1)
ROOTFS_$(1)_TARGET_FS_PATH=$(2)
endef

define ROOTFS_TARGET
$(call ROOTFS_TARGET_INTERNAL,$(1),$(call UPPERCASE,$(1)))
endef

#.FORCE: $(BINARIES_DIR)/%/.stamp_installed
#$(BINARIES_DIR)/%/.stamp_:
#$(BINARIES_DIR)/%/.stamp_installed: CUST_TARGET=$(@:$(BINARIES_DIR)/%/.stamp_installed=%)
$(STAMP_DIR)/installer-%-created: CUST_TARGET=$(@:$(STAMP_DIR)installer-%-created=%)
$(STAMP_DIR)/installer-%-created: $(FS_TARGETS)
	@$(call MESSAGE,"Generating install images for $(CUST_TARGET)")
	mkdir -p $(BINARIES_DIR)/$(CUST_TARGET)
	mv $(BINARIES_DIR)/$(CUST_TARGET).* $(BINARIES_DIR)/$(CUST_TARGET)
	-cp $(BINARIES_DIR)/vmlinuz $(BINARIES_DIR)/$(CUST_TARGET)
	-cp $(BINARIES_DIR)/zImage $(BINARIES_DIR)/$(CUST_TARGET)
	touch $@

$(BINARIES_DIR)/snapshot.br2.tar:
	@$(call MESSAGE,"Generating snapshot of base target filesystem")
	(cd $(TARGET_DIR) ; tar -cf $@ .)

$(BINARIES_DIR)/snapshot.target.tar: $(BINARIES_DIR)/snapshot.br2.tar
	@$(call MESSAGE,"Generating snapshot of custom target filesystem")
ifeq ($(TARGET_CUSTOM_FILES_PATH),)
	cp $< $@
else
	rm -rf $(BUILD_DIR)/.saved_target
	mv $(TARGET_DIR) $(BUILD_DIR)/.saved_target
	mkdir -p $(TARGET_DIR)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.br2.tar)
	(cd $(TARGET_CUSTOM_FILES_PATH); tar -cf $(BINARIES_DIR)/snapshot.custom_files.tar .)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.custom_files.tar; ./cleanup.sh; rm cleanup.sh; tar -cf $(BINARIES_DIR)/snapshot.target.tar .)
	rm -rf $(TARGET_DIR)
	mv $(BUILD_DIR)/.saved_target $(TARGET_DIR)
	rm -rf $(BUILD_DIR)/.saved_target
endif


$(BINARIES_DIR)/snapshot.%.target.tar: CUST_TARGET=$(@:$(BINARIES_DIR)/snapshot.%.target.tar=%)
$(BINARIES_DIR)/snapshot.%.target.tar: CUST_FILES=$(ROOTFS_$(CUST_TARGET)_TARGET_FS_PATH)
$(BINARIES_DIR)/snapshot.%.target.tar: $(BINARIES_DIR)/snapshot.target.tar
	@$(call MESSAGE,"Generating snapshot of $(CUST_TARGET) target filesystem")
	rm -rf $(BUILD_DIR)/.saved_target
	mv $(TARGET_DIR) $(BUILD_DIR)/.saved_target
	mkdir -p $(TARGET_DIR)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.target.tar)
	(cd $(CUST_FILES); tar -cf $(BINARIES_DIR)/snapshot.$(CUST_TARGET).custom_files.tar .)
	(cd $(TARGET_DIR); tar -xf $(BINARIES_DIR)/snapshot.$(CUST_TARGET).custom_files.tar; ./cleanup.sh; rm cleanup.sh; tar -cf $(BINARIES_DIR)/snapshot.$(CUST_TARGET).target.tar .)
	rm -rf $(TARGET_DIR)
	mv $(BUILD_DIR)/.saved_target $(TARGET_DIR)
	rm -rf $(BUILD_DIR)/.saved_target

rootfs-cleanup:
	rm -f $(BINARIES_DIR)/snapshot.*

show-fs-targets:
	echo $(STAMP_DIR)
	echo $(FS_TARGETS)

define INSTALLER_IMAGE

	@$(call MESSAGE,"Generating install images for $(1)")
	rm -rf $(BINARIES_DIR)/$(1)
	mkdir -p $(BINARIES_DIR)/$(1)
	mv $(BINARIES_DIR)/$(1).* $(BINARIES_DIR)/$(1)
	cp $(BINARIES_DIR)/$(LINUX_IMAGE_NAME) $(BINARIES_DIR)/$(1)/linux-kernel.bin
	$(foreach boot,$(BOOTSTRAP_INSTALL_HOOKS),$(call $(boot),$(1),$(BINARIES_DIR)/$(1)))

endef

installer-images:
	$(foreach cust,$(ROOTFS_CUSTOM_IMAGES),$(call INSTALLER_IMAGE,$(cust)))

include fs/*/*.mk

.FORCE: installer-images
