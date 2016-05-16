#############################################################
#
# lzma
#
#############################################################
LZMA_VERSION:=4.32.7
LZMA_SOURCE:=lzma-$(LZMA_VERSION).tar.gz
LZMA_SITE:=http://tukaani.org/lzma/
LZMA_INSTALL_STAGING = YES
LZMA_CONF_OPT = $(if $(BR2_ENABLE_DEBUG),--enable-debug,--disable-debug)
LZMA_CONFIGURE_PREFIX=/usr/local
LZMA_CONFIGURE_EXEC_PREFIX=/usr/local

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))

LZMA=$(HOST_DIR)/usr/bin/lzma
