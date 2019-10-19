#!/usr/bin/env bash

# referenced from: https://blog.kishikawakatsumi.com/entry/2019/06/17/090724

set -exo pipefail

PROJECT_ROOT=$(cd $(dirname $0);cd ../App; pwd)
PODS_ROOT="$PROJECT_ROOT/Pods"
PODS_PROJECT="$PODS_ROOT/Pods.xcodeproj"
SYMROOT="$PODS_ROOT/Build"

cd "$PROJECT_ROOT"
bundle exec pod repo update
COCOAPODS_DISABLE_STATS=true bundle exec pod install

xcodebuild -project "$PODS_PROJECT" \
  -sdk iphoneos -configuration Release -alltargets \
  ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=NO SYMROOT="$SYMROOT" \
  CLANG_ENABLE_MODULE_DEBUGGING=NO \
  BITCODE_GENERATION_MODE=bitcode

xcodebuild -project "$PODS_PROJECT" \
  -sdk iphonesimulator -configuration Release -alltargets \
  ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=NO SYMROOT="$SYMROOT" \
  CLANG_ENABLE_MODULE_DEBUGGING=NO
