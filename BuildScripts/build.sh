#!/usr/bin/env bash

set -ex

dir=$(cd $(dirname $0);pwd)
export_dir="${dir}/../build"
app_name="Somari"

if ! type bundle 2>&1 >/dev/null;then
  echo 'required bundle'
  exit 1
fi

pushd $dir/..
bundle install --path vendor/bundle
popd

pushd $dir/../App
bundle exec pod install
popd

pushd $dir
$dir/build_pod.sh "ios"

bundle exec fastlane build

mkdir -p "$export_dir"

find $dir -name "${app_name}.ipa" \
  -o -name "${app_name}.app" \
  -o -name "${app_name}.app.dSYM.zip" \
  | xargs -I{} mv {} "${export_dir}/"
