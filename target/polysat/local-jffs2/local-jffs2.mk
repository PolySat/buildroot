#############################################################
#
# Build the jffs2 root filesystem image
#
#############################################################

POLYSAT_LOCAL_JFFS2_OPTS := -e $(BR2_TARGET_POLYSAT_LOCAL_JFFS2_EBSIZE)
POLYSAT_LOCAL_SUMTOOL_OPTS := $(POLYSAT_LOCAL_JFFS2_OPTS)

ifeq ($(BR2_TARGET_POLYSAT_LOCAL_JFFS2_PAD),y)
ifneq ($(strip $(BR2_TARGET_POLYSAT_LOCAL_JFFS2_PADSIZE)),0x0)
POLYSAT_LOCAL_JFFS2_OPTS += --pad=$(strip $(BR2_TARGET_POLYSAT_LOCAL_JFFS2_PADSIZE))
else
POLYSAT_LOCAL_JFFS2_OPTS += -p
endif
POLYSAT_LOCAL_SUMTOOL_OPTS += -p
endif

ifeq ($(BR2_TARGET_POLYSAT_LOCAL_JFFS2_LE),y)
POLYSAT_LOCAL_JFFS2_OPTS += -l
POLYSAT_LOCAL_SUMTOOL_OPTS += -l
endif

ifeq ($(BR2_TARGET_POLYSAT_LOCAL_JFFS2_BE),y)
POLYSAT_LOCAL_JFFS2_OPTS += -b
POLYSAT_LOCAL_SUMTOOL_OPTS += -b
endif

POLYSAT_LOCAL_JFFS2_OPTS += -s $(BR2_TARGET_POLYSAT_LOCAL_JFFS2_PAGESIZE)
ifeq ($(BR2_TARGET_POLYSAT_LOCAL_JFFS2_NOCLEANMARKER),y)
POLYSAT_LOCAL_JFFS2_OPTS += -n
POLYSAT_LOCAL_SUMTOOL_OPTS += -n
endif

POLYSAT_LOCAL_JFFS2_TARGET := $(call qstrip,$(BR2_TARGET_POLYSAT_LOCAL_JFFS2_OUTPUT))
POLYSAT_LOCAL_DIR=$(TARGET_DIR)/usr/local


#
# mtd-host is a dependency which builds a local copy of mkfs.jffs2 if it is needed.
# the actual build is done from package/mtd/mtd.mk and it sets the
# value of MKFS_JFFS2 to either the previously installed copy or the one
# just built.
#
$(POLYSAT_LOCAL_JFFS2_TARGET): host-fakeroot makedevs mtd-host
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
	echo "chown -R 0:0 $(POLYSAT_LOCAL_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
	# Use fakeroot so mkfs.jffs2 believes the previous fakery
ifneq ($(BR2_TARGET_POLYSAT_LOCAL_JFFS2_SUMMARY),)
	echo "$(MKFS_JFFS2) $(POLYSAT_LOCAL_JFFS2_OPTS) -d $(POLYSAT_LOCAL_DIR) -o $(POLYSAT_LOCAL_JFFS2_TARGET).nosummary && " \
		"$(SUMTOOL) $(POLYSAT_LOCAL_SUMTOOL_OPTS) -i $(POLYSAT_LOCAL_JFFS2_TARGET).nosummary -o $(POLYSAT_LOCAL_JFFS2_TARGET) && " \
		"rm $(POLYSAT_LOCAL_JFFS2_TARGET).nosummary" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
else
	echo "$(MKFS_JFFS2) $(POLYSAT_LOCAL_JFFS2_OPTS) -d $(POLYSAT_LOCAL_DIR) -o $(POLYSAT_LOCAL_JFFS2_TARGET)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
endif
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(POLYSAT_LOCAL_JFFS2_TARGET))
	@ls -l $(POLYSAT_LOCAL_JFFS2_TARGET)
ifeq ($(BR2_POLYSAT_LOCAL_JFFS2_TARGET_SREC),y)
	$(TARGET_CROSS)objcopy -I binary -O srec --adjust-vma 0xa1000000 $(POLYSAT_LOCAL_JFFS2_TARGET) $(POLYSAT_LOCAL_JFFS2_TARGET).srec
	@ls -l $(POLYSAT_LOCAL_JFFS2_TARGET).srec
endif

JFFS2_COPYTO := $(call qstrip,$(BR2_TARGET_POLYSAT_LOCAL_JFFS2_COPYTO))

polysat-local-jffs2: $(POLYSAT_LOCAL_JFFS2_TARGET)
ifneq ($(JFFS2_COPYTO),)
	@cp -f $(POLYSAT_LOCAL_JFFS2_TARGET) $(JFFS2_COPYTO)
endif

polysat-local-jffs2-source: mtd-host-source

polysat-local-jffs2-clean: mtd-host-clean
	-rm -f $(POLYSAT_LOCAL_JFFS2_TARGET)

polysat-local-jffs2-dirclean: mtd-host-dirclean
	-rm -f $(POLYSAT_LOCAL_JFFS2_TARGET)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_POLYSAT_LOCAL_JFFS2),y)
TARGETS+=polysat-local-jffs2
endif
