#!/usr/bin/env python3
import os
import sys
import glob
import re
import shutil

from build_ios import build_ios_with_type
from build_osx import build_osx_with_type

from mars_utils import *


SCRIPT_PATH = os.path.split(os.path.realpath(__file__))[0]

BUILD_OUT_PATH = 'libraries/MarsXLogOC'

GEN_IOS_OS_PROJ = 'cmake ../.. -G Xcode -DCMAKE_TOOLCHAIN_FILE=../../ios.toolchain.cmake -DPLATFORM=OS -DIOS_ARCH="arm64" -DENABLE_ARC=0 -DENABLE_BITCODE=0 -DENABLE_VISIBILITY=1'

def make_mars_xcframework(frameworks):
    path = BUILD_OUT_PATH + '/mars.xcframework'
    option = ' '.join(['-framework %s' % framework for framework in frameworks])
    command = 'xcodebuild -create-xcframework %s -output %s' % (option, path)
    ret = os.system(command)
    if ret != 0:
        return None
    
    return path

def build_all(args):
    if args in ['1', '2']:
        ios = build_ios_with_type(args)
        osx = build_osx_with_type(args)
        frameworks = ios + osx
        if len(frameworks) > 0:
            path = make_mars_xcframework(ios + osx)
            if path == None:
                print('!!!!!!!!!!!make xcframework fail!!!!!!!!!!!!!!!')
            else:
                print('xcframework success:' + path)

def main():
    if len(sys.argv) >= 2:
        build_all(sys.argv[1])
    else:
        num = input('Enter menu:\n1. Clean && build mars.\n2. Clean && build xlog.\n3. Exit\n')
        build_all(num)

if __name__ == '__main__':
    main()
