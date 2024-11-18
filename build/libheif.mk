PKG             := libheif
$(PKG)_WEBSITE  := http://www.libheif.org/
$(PKG)_DESCR    := libheif is a ISO/IEC 23008-12:2017 HEIF file format decoder and encoder.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.3
$(PKG)_CHECKSUM := 1e6d3bb5216888a78fbbf5fd958cd3cf3b941aceb002d2a8d635f85cc59a8599
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/patches/$(PKG)-[0-9]*.patch)))
$(PKG)_GH_CONF  := strukturag/libheif/releases,v
$(PKG)_DEPS     := cc aom

define $(PKG)_BUILD
    $(eval export CFLAGS += -O3)
    $(eval export CXXFLAGS += -O3)

    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DENABLE_PLUGIN_LOADING=0 \
        -DBUILD_TESTING=0 \
        -DWITH_EXAMPLES=0 \
        $(if $(IS_HEVC),, \
            -DWITH_LIBDE265=0 \
            -DWITH_X265=0) \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(subst -,/,$(INSTALL_STRIP_LIB))
endef
