#!/bin/sh
PROJECT_NAME="openclik"
CONFIGURATION="release"
export PATH=/Applications/Xcode.app/Contents/Developer/usr/bin/:$PATH
CONFIGURATION_BUILD_DIR="."
PROJECT_DIR="."
VERSION=1.5.5
REVISION=`svn info | grep Revision | cut -d " " -f 2`
SDKDIR="opencliksdk"
BUILDDIR=${SDKDIR}${VERSION}_build_${REVISION}
BUILD_DIR="build"

SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PROJECT_NAME}.a" &&
DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PROJECT_NAME}.a" &&


#xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphonesimulator -target ${PROJECT_NAME} -configuration ${CONFIGURATION} build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator

#xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphoneos -target ${PROJECT_NAME} -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos
#lipo "${SIMULATOR_LIBRARY_PATH}" "${DEVICE_LIBRARY_PATH}" -create -output "${PROJECT_DIR}/lib${PROJECT_NAME}.a" &&
rm -rf ${SDKDIR}*
mkdir ${BUILDDIR}
mkdir ${BUILDDIR}/lib
mkdir ${BUILDDIR}/include
mkdir ${BUILDDIR}/img
cp classes/OpenClikViewController.h ${BUILDDIR}/include
cp -R img/* ${BUILDDIR}/img
cp libopenclik.a ${BUILDDIR}/lib
