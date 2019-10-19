#!/usr/bin/env bash

dir=$(cd $(dirname $0);pwd)

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
$dir/build_pod.sh

bundle exec fastlane build
