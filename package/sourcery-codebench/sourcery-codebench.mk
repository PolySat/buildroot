SOURCERY_CODEBENCH_SITE=https://sourcery.mentor.com/GNUToolchain/package10385/public/arm-none-eabi
SOURCERY_CODEBENCH_VERSION=2012-03-56
SOURCERY_CODEBENCH_SOURCE=arm-2012.03-56-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
HOST_SOURCERY_CODEBENCH_PATH=$(HOST_DIR)/opt/sourcery_codebench

#URL=https://sourcery.mentor.com/GNUToolchain/package10385/public/arm-none-eabi/arm-2012.03-56-arm-none-eabi-i686-pc-linux-gnu.tar.bz2

define HOST_SOURCERY_CODEBENCH_INSTALL_CMDS
	mkdir -p $(HOST_SOURCERY_CODEBENCH_PATH)
	cp -a $(@D)/* $(HOST_SOURCERY_CODEBENCH_PATH)
endef

$(eval $(call GENTARGETS,host))
