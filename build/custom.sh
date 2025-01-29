#!/usr/bin/env bash

# usage: invoke with "x86_64" or "aarch64" as the sole arg.

set -e

export LLVM=true
export DEBUG=false

. variables.sh

deps="all"
target="${1}-w64-mingw32.static"

# Known good; update if too old when revisiting.
revision="c24870649b739d648aa878627f2e0e1266f8aa4d"

if [ -d "$mxe_dir" ]; then
  cd $mxe_dir
else
  git clone https://github.com/mxe/mxe
  cd $mxe_dir
  git reset --hard $revision
  # Patch MXE to support the ARM64 target
  git apply $work_dir/patches/mxe-fixes.patch
fi

cp -f $work_dir/settings/llvm-release.mk $mxe_dir/settings.mk

plugins="$work_dir"
plugins+=" $work_dir/plugins/mozjpeg"
plugins+=" $work_dir/plugins/hevc"
plugins+=" $work_dir/plugins/zlib-ng"
plugins+=" $work_dir/plugins/llvm-mingw"
plugins+=" $work_dir/plugins/proxy-libintl"

# Bootstrap
make pe-util IGNORE_SETTINGS=yes MXE_TMP="/var/tmp" \
  MXE_TARGETS=`$mxe_dir/ext/config.guess` MXE_USE_CCACHE=

make vips-$deps MXE_PLUGIN_DIRS="$plugins" MXE_TARGETS=$target.$deps

cp $mxe_prefix/$target.$deps/bin/vips.exe $work_dir
