#############################################################
#
# iperf
#
#############################################################
JFS_TOOLS_VERSION = 1.1.15
#http://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz
JFS_TOOLS_SOURCE = jfsutils-$(JFS_TOOLS_VERSION).tar.gz
JFS_TOOLS_SITE = http://jfs.sourceforge.net/project/pub

$(eval $(call AUTOTARGETS))
