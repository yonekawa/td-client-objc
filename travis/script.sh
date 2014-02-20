#!/bin/sh
set -e

xctool -workspace TreasureData.xcworkspace -scheme TreasureData build test
