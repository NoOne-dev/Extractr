#!/bin/sh

#  ExtractFileSystem.command
#  Extractr
#
#  Created by Mark Malstrom on 7/28/16.
#  Copyright © 2016 Tangaroa. All rights reserved.

# `cd` to output directory
# 1 == output directory
cd "${1}"

# Use unar to extract the OTA .zip file
echo "*********************"
echo "Unziping OTA ZIP file"
echo "*********************"

# 2 == OTA .zip path
unzip "${2}"

# 5 == name of expanded zip directory
mv "${5}" "iOS File System"
cd "iOS File System"

# Create pb.xz
echo "*******************"
echo "Creating pb.xz file"
echo "*******************"

# 4 == pbxz binary path
"${4}" AssetData/payloadv2/payload > pb.xz

# Unarchive pb.xz
echo "**********************"
echo "Unarchiving pb.xz file"
echo "**********************"

# 3 == unar binary path
"${3}" ./pb.xz

# Create a rootfs temp directory
mkdir rootfs

# Move the pb file there
mv ./pb ./rootfs

# cd to rootfs
cd rootfs

# Extract the root file system
echo "*******************************"
echo "Extracting the root file system"
echo "*******************************"

# 6 == otaa binary path
"${6}" -e '*' ./pb

# Clean up
rm -rf pb
cd ..
rm -rf AssetData
rm -rf Info.plist
rm -rf META-INF
rm -rf pb.xz
mv rootfs/* .
rm -rf rootfs

echo "Done! Successfully extracted the iOS File System from ${5}.zip"


