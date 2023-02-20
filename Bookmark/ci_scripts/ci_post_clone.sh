#!/bin/sh
#  ci_post_clone.sh
#
# Install CocoaPods using Homebrew.
brew install cocoapods
        
# Install dependencies you manage with CocoaPods.
pod install
