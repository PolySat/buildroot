#############################################################
#
# genext2fs to build to target ext2 filesystems
#
#############################################################
GENEXT2_VERSION=1.4
GENEXT2_DIR=$(BUILD_DIR)/genext2fs-$(GENEXT2_VERSION)
GENEXT2_SOURCE=genext2fs-$(GENEXT2_VERSION).tar.gz
GENEXT2_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/genext2fs

$(DL_DIR)/$(GENEXT2_SOURCE):
	$(call DOWNLOAD,$(GENEXT2_SITE),$(GENEXT2_SOURCE))

$(GENEXT2_DIR)/.unpacked: $(DL_DIR)/$(GENEXT2_SOURCE)
	$(ZCAT) $(DL_DIR)/$(GENEXT2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(GENEXT2_DIR) target/ext2/ genext2fs\*.patch
	touch $@

$(GENEXT2_DIR)/.configured: $(GENEXT2_DIR)/.unpacked
	chmod a+x $(GENEXT2_DIR)/configure
	(cd $(GENEXT2_DIR); rm -rf config.cache; \
		./configure $(QUIET) \
		CC="$(HOSTCC)" \
		--prefix=$(STAGING_DIR) \
	)
	touch $@

$(GENEXT2_DIR)/genext2fs: $(GENEXT2_DIR)/.configured
	$(MAKE) CFLAGS="-Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE \
		-D_FILE_OFFSET_BITS=64" -C $(GENEXT2_DIR)
	touch -c $@

genext2fs: $(GENEXT2_DIR)/genext2fs



#############################################################
#
# Build the ext2 root filesystem image
#
#############################################################

POLYSAT_INITRD_EXT2_OPTS :=

ifneq ($(strip $(BR2_TARGET_ROOTFS_POLYSAT_INITRD_BLOCKS)),0)
POLYSAT_INITRD_EXT2_OPTS += -b $(BR2_TARGET_ROOTFS_POLYSAT_INITRD_BLOCKS)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_POLYSAT_INITRD_INODES)),0)
POLYSAT_INITRD_EXT2_OPTS += -N $(BR2_TARGET_ROOTFS_POLYSAT_INITRD_INODES)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_POLYSAT_INITRD_RESBLKS)),)
POLYSAT_INITRD_EXT2_OPTS += -m $(BR2_TARGET_ROOTFS_POLYSAT_INITRD_RESBLKS)
endif

POLYSAT_INITRD_EXT2_BASE := $(call qstrip,$(BR2_TARGET_ROOTFS_POLYSAT_INITRD_OUTPUT))

POLYSAT_INITRD_EXT2_ROOTFS_COMPRESSOR:=gzip -9 -c
POLYSAT_INITRD_EXT2_ROOTFS_COMPRESSOR_EXT:=gz
POLYSAT_INITRD_EXT2_ROOTFS_COMPRESSOR_PREREQ:=
#EXT2_ROOTFS_COMPRESSOR_PREREQ:= gzip-host
POLYSAT_INITRD_EXT2_TARGET := $(POLYSAT_INITRD_EXT2_BASE).$(POLYSAT_INITRD_EXT2_ROOTFS_COMPRESSOR_EXT)

$(POLYSAT_INITRD_EXT2_BASE): host-fakeroot makedevs genext2fs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
	-rm -rf $(BUILD_DIR)/_savedlocal.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
	mv $(TARGET_DIR)/usr/local $(BUILD_DIR)/_savedlocal.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
	mkdir $(TARGET_DIR)/usr/local
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
endif
	# Use fakeroot so genext2fs believes the previous fakery
ifeq ($(strip $(BR2_TARGET_ROOTFS_POLYSAT_INITRD_BLOCKS)),0)
	GENEXT2_REALSIZE=`LC_ALL=C du -s -c -k $(TARGET_DIR) | grep total | sed -e "s/total//"`; \
	GENEXT2_ADDTOROOTSIZE=`if [ $$GENEXT2_REALSIZE -ge 20000 ]; then echo 16384; else echo 2400; fi`; \
	GENEXT2_SIZE=`expr $$GENEXT2_REALSIZE + $$GENEXT2_ADDTOROOTSIZE`; \
	GENEXT2_ADDTOINODESIZE=`find $(TARGET_DIR) | wc -l`; \
	GENEXT2_INODES=`expr $$GENEXT2_ADDTOINODESIZE + 400`; \
	set -x; \
	echo "$(GENEXT2_DIR)/genext2fs -b $$GENEXT2_SIZE " \
		"-N $$GENEXT2_INODES -d $(TARGET_DIR) " \
		"$(POLYSAT_INITRD_EXT2_OPTS) $(POLYSAT_INITRD_EXT2_BASE)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
else
	echo "$(GENEXT2_DIR)/genext2fs -d $(TARGET_DIR) " \
		"$(POLYSAT_INITRD_EXT2_OPTS) $(POLYSAT_INITRD_EXT2_BASE)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
endif

	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_INITRD_EXT2_TARGET))
	rmdir $(TARGET_DIR)/usr/local
	mv $(BUILD_DIR)/_savedlocal.$(notdir $(POLYSAT_INITRD_EXT2_TARGET)) $(TARGET_DIR)/usr/local

ifneq ($(POLYSAT_INITRD_EXT2_ROOTFS_COMPRESSOR),)
$(POLYSAT_INITRD_EXT2_TARGET): $(POLYSAT_INITRD_EXT2_ROOTFS_COMPRESSOR_PREREQ) $(POLYSAT_INITRD_EXT2_BASE)
	$(POLYSAT_INITRD_EXT2_ROOTFS_COMPRESSOR) $(POLYSAT_INITRD_EXT2_BASE) > $(POLYSAT_INITRD_EXT2_TARGET)
endif

POLYSAT_INITRD_EXT2_COPYTO := $(call qstrip,$(BR2_TARGET_ROOTFS_POLYSAT_INITRD_COPYTO))

polysat_root: $(POLYSAT_INITRD_EXT2_TARGET)
	@ls -l $(POLYSAT_INITRD_EXT2_TARGET)
ifneq ($(POLYSAT_INITRD_EXT2_COPYTO),)
	@cp -f $(POLYSAT_INITRD_EXT2_TARGET) $(POLYSAT_INITRD_EXT2_COPYTO)
endif

polysat_root-source: $(DL_DIR)/$(GENEXT2_SOURCE)

polysat_root-clean:
	-$(MAKE) -C $(GENEXT2_DIR) clean

polysat_root-dirclean:
	rm -rf $(GENEXT2_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_POLYSAT_INITRD),y)
TARGETS+=polysat_root
endif
