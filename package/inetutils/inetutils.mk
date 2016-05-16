#############################################################
#
# zlib
#
#############################################################
INETUTILS_VERSION:=1.9
INETUTILS_SOURCE:=inetutils-$(INETUTILS_VERSION).tar.gz
INETUTILS_SITE:=http://ftp.gnu.org/gnu/inetutils
INETUTILS_INSTALL_STAGING=NO

ifeq ($(BR2_PREFER_STATIC_LIB),y)
INETUTILS_PIC :=
INETUTILS_SHARED :=
else
INETUTILS_PIC := -fPIC
INETUTILSL_SHARED := --shared
endif

define INETUTILS_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(INETUTILS_PIC)" \
		./configure \
      --disable-ifconfig \
      --disable-libls \
      --host=arm \
		--prefix=/usr \
		--exec-prefix=$(STAGING_DIR)/usr/bin \
		--libdir=$(STAGING_DIR)/usr/lib \
		--includedir=$(STAGING_DIR)/usr/include \
	)
endef

#		$(INETUTILSL_SHARED) \


define INETUTILS_BUILD_CMDS
	$(MAKE) -C $(@D) all
endef

define INETUTILS_INSTALL_SBIN_HELPER
if [ "$(BR2_PACKAGE_INETUTILS_$(2))" = "y" ] ; then \
	mkdir -p $(TARGET_DIR)/usr/sbin;  \
	rm -f $(TARGET_DIR)/usr/sbin/$(1); \
	cp -dpf $(@D)/$(3)/$(1) $(TARGET_DIR)/usr/sbin;  \
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/sbin/$(1);  \
fi
endef

define INETUTILS_INSTALL_LOCAL_HELPER
if [ "$(BR2_PACKAGE_INETUTILS_$(2))" = "y" ] ; then \
	mkdir -p $(TARGET_DIR)/usr/local/bin; \
	rm -f $(TARGET_DIR)/usr/local/bin/$(1); \
	cp -dpf $(@D)/$(3)/$(1) $(TARGET_DIR)/usr/local/bin; \
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/local/bin/$(1); \
fi
endef

define INETUTILS_INSTALL_TARGET_CMDS
	$(call INETUTILS_INSTALL_SBIN_HELPER,inetd,INETD,src)
	$(call INETUTILS_INSTALL_SBIN_HELPER,telnetd,TELNETD,telnetd)
	$(call INETUTILS_INSTALL_SBIN_HELPER,ftpd,FTPD,ftpd)
	$(call INETUTILS_INSTALL_SBIN_HELPER,tftpd,TFTPD,src)
	$(call INETUTILS_INSTALL_LOCAL_HELPER,telnet,TELNET,telnet)
	$(call INETUTILS_INSTALL_LOCAL_HELPER,ftp,FTP,ftp)
	$(call INETUTILS_INSTALL_LOCAL_HELPER,tftp,TFTP,src)
	$(call INETUTILS_INSTALL_LOCAL_HELPER,rcp,RCP,src)
	$(call INETUTILS_INSTALL_LOCAL_HELPER,rlogin,RLOGIN,src)
	$(call INETUTILS_INSTALL_LOCAL_HELPER,rsh,RSH,src)
	$(call INETUTILS_INSTALL_SBIN_HELPER,rexecd,REXECD,src)
	$(call INETUTILS_INSTALL_LOCAL_HELPER,rexec,REXEC,src)
endef

$(eval $(call GENTARGETS,package,inetutils))
