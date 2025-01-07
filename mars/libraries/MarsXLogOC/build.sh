#!/bin/bash

rm -rf builds

xcodebuild archive \
-scheme MarsXLogOC \
-destination "generic/platform=iOS" \
-archivePath "builds/MarsXLogOC_ios" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme MarsXLogOC \
-destination "generic/platform=iOS Simulator" \
-archivePath "builds/MarsXLogOC_sim" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme MarsXLogOC \
-destination "generic/platform=macosx" \
-archivePath "builds/MarsXLogOC_macosx" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
-framework ./builds/MarsXLogOC_ios.xcarchive/Products/Library/Frameworks/MarsXLogOC.framework \
-framework ./builds/MarsXLogOC_sim.xcarchive/Products/Library/Frameworks/MarsXLogOC.framework \
-framework ./builds/MarsXLogOC_macosx.xcarchive/Products/Library/Frameworks/MarsXLogOC.framework \
-output ./builds/MarsXLogOC.xcframework
