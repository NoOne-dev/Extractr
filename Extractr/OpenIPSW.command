#!/bin/sh

#  OpenIPSW.command
#  Extractr
#
#  Created by Tanner Bennett on 8/1/16.
#  Modified by Mark Malstrom on 8/3/16.
#  Copyright © 2016 Tangaroa. All rights reserved.

# 1 == destination path
cd "${1}"
mkdir "iOS File System"
cd "iOS File System"

# 2 == IPSW path
unzip "${2}"

# list files by size
# filter by file ending in .dmg or .DMG or .dMg etc
# return the first field of the first row
rootfs=`ls -S | grep .[dD][mM][gG] | awk 'NR==1{print $1}'`

# If $rootfs is blank, echo and return
if [[ -z "$rootfs" ]] then
  echo "No root file system DMG found."
  return
fi

# Mount the $rootfs DMG
hdiutil attach "$rootfs"

### End tool for mounting DMG ###

### Begin tool for making folder out of mounted DMG ###

cp -r
