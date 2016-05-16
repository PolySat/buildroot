#############################################################
#
# gnutls
#
#############################################################

CPIO_VERSION = 2.11
CPIO_SOURCE = cpio-$(CPIO_VERSION).tar.bz2
CPIO_SITE = $(BR2_GNU_MIRROR)/cpio
CPIO_CONF_OPT = --bindir=/usr/local/bin

$(eval $(call AUTOTARGETS))
