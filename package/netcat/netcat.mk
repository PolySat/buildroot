#############################################################
#
# netcat
#
#############################################################

NETCAT_VERSION:=0.7.1
NETCAT_SOURCE:=netcat-$(NETCAT_VERSION).tar.gz
NETCAT_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/netcat
NETCAT_CONFIGURE_PREFIX=/usr/local
NETCAT_CONFIGURE_EXEC_PREFIX=/usr/local


$(eval $(call AUTOTARGETS))
