#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New CotEditor Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗒

# Documentation:
# @raycast.author guttyar2213

LANG=en_US.UTF-8
pbpaste | cot -n

