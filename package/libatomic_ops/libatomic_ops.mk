#############################################################
#
# Atomic_ops library
#
#############################################################

LIBATOMIC_OPS_VERSION = 1.2
LIBATOMIC_OPS_SOURCE = libatomic_ops-$(LIBATOMIC_OPS_VERSION).tar.gz
LIBATOMIC_OPS_SITE = https://src.fedoraproject.org/repo/pkgs/libatomic_ops/libatomic_ops-1.2.tar.gz/
LIBATOMIC_OPS_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
