#############################################################
#
# octave
#
#############################################################

OCTAVE_VERSION = 3.6.3
OCTAVE_SOURCE = octave-$(OCTAVE_VERSION).tar.gz
OCTAVE_SITE = ftp://ftp.gnu.org/gnu/octave
OCTAVE_DEPENDENCIES = pcre lapack
OCTAVE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS))
