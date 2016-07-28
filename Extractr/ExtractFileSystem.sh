#!/bin/sh

#  ExtractFileSystem.sh
#  Extractr
#
#  Created by Mark Malstrom on 7/28/16.
#  Copyright © 2016 Tangaroa. All rights reserved.

# `cd` to output directory
# 1 == output directory
cd "${1}"

# Use unar to extract the OTA .zip file
echo "Unziping OTA zip file"

# 3 == unar binary path
# 2 == OTA .zip path
"${3}" "${2}"

# Create pb.xz
echo "Creating pb.xz file"

# 4 == pbxz binary path
"${4}" AssetData/payloadv2/payload > pb.xz

# Unarchive pb.xz
echo "Unarchiving pb.xz file"

# 3 == unar binary path
"${3}" ./pb.xz

# Create a rootfs temp directory
mkdir rootfs

# Move the pb file there
mv ./pb ./rootfs

# cd to rootfs
cd rootfs

# Extract the root file system
echo "Extracting the root file system"
 ../otaa -e '*' ./pb








