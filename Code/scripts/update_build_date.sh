#!/bin/sh

#  update_build_date.sh
#  BuildNumber
#
#  Created by me on 6/21/20.
#  Copyright © 2020 arpinoda. All rights reserved.

BUILD_DATE=$(date)
defaults write "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH%.*}" "BuildDateTime" "${BUILD_DATE}"
