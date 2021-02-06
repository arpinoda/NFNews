#!/bin/bash

#  update_build_number.sh
#  Ref: https://fuller.li/posts/versioning-with-xcode-and-git/
#
#  Created by me on 4/30/20.
#  Copyright © 2020 arpinoda. All rights reserved.

GIT_RELEASE_VERSION=$(git describe --tags --always --dirty)
COMMITS=$(git rev-list HEAD | wc -l)
COMMITS=$(($COMMITS))
defaults write "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH%.*}" "CFBundleShortVersionString" "${GIT_RELEASE_VERSION#*v}"
defaults write "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH%.*}" "CFBundleVersion" "${COMMITS}"
