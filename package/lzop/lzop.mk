#############################################################
#
# lzop
#
#############################################################
LZOP_VERSION = 1.03
LZOP_SOURCE = lzop-$(LZOP_VERSION).tar.gz
LZOP_SITE = http://www.lzop.org/download/
LZOP_DEPENDENCIES = lzo
LZOP_CONFIGURE_PREFIX=/usr/local
LZOP_CONFIGURE_EXEC_PREFIX=/usr/local

$(eval $(call AUTOTARGETS))
