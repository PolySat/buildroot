#############################################################
#
# libpgf
#
#############################################################

#http://downloads.sourceforge.net/project/libpgf/libpgf/6.12.24-latest/libpgf-6.12.24-src.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flibpgf%2F&ts=1362573126&use_mirror=iweb
LIBPGF_VERSION = 6.12.24
LIBPGF_SOURCE =libpgf-$(LIBPGF_VERSION)-src.tar.gz
LIBPGF_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libpgf
LIBPGF_INSTALL_STAGING = YES
LIBPGF_AUTORECONF=YES

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
