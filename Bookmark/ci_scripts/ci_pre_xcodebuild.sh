#!/bin/sh
#  ci_pre_xcodebuild.sh
#
#
echo "BOOKSTORE_API_KEY = $BOOKSTORE_API_KEY" > "$CI_WORKSPACE/Secrets.xcconfig"
echo "ASK_NOTION = $ASK_NOTION" > "$CI_WORKSPACE/Secrets.xcconfig"
echo "MY_APP_ID = $MY_APP_ID" > "$CI_WORKSPACE/Secrets.xcconfig"
echo "INTRODUCE_NOTION = $INTRODUCE_NOTION" > "$CI_WORKSPACE/Secrets.xcconfig"
echo "CLIENT_ID = $CLIENT_ID" > "$CI_WORKSPACE/Secrets.xcconfig"
echo "NOTION = $NOTION" > "$CI_WORKSPACE/Secrets.xcconfig"
echo "BUNDLE_NAME = $BUNDLE_NAME" > "$CI_WORKSPACE/Secrets.xcconfig"
