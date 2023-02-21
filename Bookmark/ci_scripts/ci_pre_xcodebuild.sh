#!/bin/sh
#  ci_pre_xcodebuild.sh
#
#
echo "BOOKSTORE_API_KEY = $BOOKSTORE_API_KEY" > "$CI_WORKSPACE/Secrets.xcconfig"
echo "BUNDLE_NAME = $BUNDLE_NAME" > "$CI_WORKSPACE/Secrets.xcconfig"
