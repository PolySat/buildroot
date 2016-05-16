#############################################################
#
# cpio to archive target filesystem
#
#############################################################

CPIO_POLYSAT_BASE:=$(IMAGE).polysat-root.cpio

CPIO_ROOTFS_POLYSAT_COMPRESSOR:=
CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT:=
CPIO_ROOTFS_POLYSAT_COMPRESSOR_PREREQ:=
ifeq ($(BR2_TARGET_ROOTFS_POLYSAT_CPIO_GZIP),y)
CPIO_ROOTFS_POLYSAT_COMPRESSOR:=gzip -9 -c
CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT:=gz
#CPIO_ROOTFS_POLYSAT_COMPRESSOR_PREREQ:= gzip-host
endif
ifeq ($(BR2_TARGET_ROOTFS_POLYSAT_CPIO_BZIP2),y)
CPIO_ROOTFS_POLYSAT_COMPRESSOR:=bzip2 -9 -c
CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT:=bz2
#CPIO_ROOTFS_POLYSAT_COMPRESSOR_PREREQ:= bzip2-host
endif
ifeq ($(BR2_TARGET_ROOTFS_POLYSAT_CPIO_LZMA),y)
CPIO_ROOTFS_POLYSAT_COMPRESSOR:=lzma -9 -c
CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT:=lzma
CPIO_ROOTFS_POLYSAT_COMPRESSOR_PREREQ:= lzma-host
endif

ifneq ($(CPIO_ROOTFS_POLYSAT_COMPRESSOR),)
CPIO_POLYSAT_TARGET := $(CPIO_POLYSAT_BASE).$(CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT)
else
CPIO_POLYSAT_TARGET := $(CPIO_POLYSAT_BASE)
endif

ROOTFS_POLYSAT_CPIO_COPYTO:=$(call qstrip,$(BR2_TARGET_ROOTFS_POLYSAT_CPIO_COPYTO))
#

cpioroot-init:
	rm -f $(TARGET_DIR)/init
	ln -s sbin/init $(TARGET_DIR)/init

$(CPIO_POLYSAT_BASE): host-fakeroot makedevs cpioroot-init
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	-rm -rf $(BUILD_DIR)/_savedlocal.$(notdir $(CPIO_POLYSAT_BASE))
	-mv -f $(TARGET_DIR)/usr/bin/gdb $(TARGET_DIR)/usr/local/bin
	-mv -f $(TARGET_DIR)/usr/bin/gdbserver $(TARGET_DIR)/usr/local/bin
	-mv -f $(TARGET_DIR)/usr/bin/openssl $(TARGET_DIR)/usr/local/bin
	mv $(TARGET_DIR)/usr/local $(BUILD_DIR)/_savedlocal.$(notdir $(CPIO_POLYSAT_BASE))
	mkdir $(TARGET_DIR)/usr/local
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
endif
	# Use fakeroot so tar believes the previous fakery
	echo "chmod 755 $(TARGET_DIR)/root" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	echo "chmod 755 $(TARGET_DIR)/root/.ssh" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	echo "cd $(TARGET_DIR) && find . | cpio --quiet -o -H newc > $(CPIO_POLYSAT_BASE)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	#-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(CPIO_POLYSAT_BASE))
	rmdir $(TARGET_DIR)/usr/local
	mv $(BUILD_DIR)/_savedlocal.$(notdir $(CPIO_POLYSAT_BASE)) $(TARGET_DIR)/usr/local

ifeq ($(CPIO_ROOTFS_POLYSAT_COMPRESSOR),)
ifneq ($(ROOTFS_POLYSAT_CPIO_COPYTO),)
	$(Q)cp -f $(CPIO_POLYSAT_BASE) $(ROOTFS_POLYSAT_CPIO_COPYTO)
endif
endif

ifneq ($(CPIO_ROOTFS_POLYSAT_COMPRESSOR),)
$(CPIO_POLYSAT_BASE).$(CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT): $(CPIO_ROOTFS_POLYSAT_COMPRESSOR_PREREQ) $(CPIO_POLYSAT_BASE)
	$(CPIO_ROOTFS_POLYSAT_COMPRESSOR) $(CPIO_POLYSAT_BASE) > $(CPIO_POLYSAT_TARGET)
ifneq ($(ROOTFS_POLYSAT_CPIO_COPYTO),)
	$(Q)cp -f $(CPIO_POLYSAT_BASE).$(CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT) $(ROOTFS_POLYSAT_CPIO_COPYTO).$(CPIO_ROOTFS_POLYSAT_COMPRESSOR_EXT)
endif
endif

cpioroot: $(CPIO_POLYSAT_TARGET)

cpioroot-source:

cpioroot-clean:

cpioroot-dirclean:

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_POLYSAT_CPIO),y)
TARGETS+=cpioroot
endif
