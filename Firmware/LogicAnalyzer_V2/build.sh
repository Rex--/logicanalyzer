#!/usr/bin/env bash
# Build the firmware for a given configuration. Leaves the .uf2 in the 'build'
# directory. Cleans the build directory prior to building.
#
# Usage: ./build.sh [BOARD_TYPE [TURBO_MODE]]
# - When run with no arguments, the firmware is built according to the
#   configuration in 'LogicAnalyzer_Build_Settings.cmake'
# - The first argument is a BOARD_TYPE as is given in the configuration file
# - The second argument should be either 0 or 1 to enable turbo mode

BOARD_TYPE=$1
TURBO_MODE=${2:-0}

BUILD_DIR="build"
SOURCE_DIR="."

# Clean build directory
rm -rf ${BUILD_DIR:?}
mkdir --parents $BUILD_DIR

# Log build config to terminal
echo "BOARD_TYPE: $BOARD_TYPE - TURBO_MODE: $TURBO_MODE"

# Run CMake config command
cmake -GNinja -DBOARD_TYPE="$BOARD_TYPE" -DTURBO_MODE="$TURBO_MODE" -B $BUILD_DIR -S $SOURCE_DIR

# Run CMake build command
cmake --build $BUILD_DIR --config Release
