#!/usr/bin/env bash

PKG_NAME="LogicAnalyzer"

#BOARD_TYPES="BOARD_PICO BOARD_PICO_W BOARD_PICO_W_WIFI BOARD_ZERO BOARD_PICO_2 
BOARD_TYPES="BOARD_PICO_ANALYZER BOARD_PICO_ANALYZER2"

PUBLISH_DIR="publish"
BUILD_DIR="build"
SOURCE_DIR="."

BUILD_LOG="$BUILD_DIR/build.log"

# Clean publish directory
rm --recursive --force ${PUBLISH_DIR:?}/*
mkdir --parents $PUBLISH_DIR

# Create build directory if it does not exists
mkdir --parents $BUILD_DIR

# Backup old build log if it exists
[[ -f $BUILD_LOG ]] && cp $BUILD_LOG "$BUILD_LOG.bak"

# Create new build log with start time
{ echo -n "Build Time: "; date; } > $BUILD_LOG

# Loop through each board type and turbo mode
for BOARD_TYPE in $BOARD_TYPES; do
    for TURBO_MODE in {0..1}; do

        if [[ $TURBO_MODE -eq 1 && ( $BOARD_TYPE = "BOARD_PICO_W" || $BOARD_TYPE = "BOARD_PICO_W_WIFI" ) ]]; then
            echo "BOARD_TYPE: $BOARD_TYPE - TURBO_MODE: $TURBO_MODE -- SKIPPING"
            continue
        fi

        # Log build config to build log and terminal
        echo -n "BOARD_TYPE: $BOARD_TYPE - TURBO_MODE: $TURBO_MODE"
        echo "BOARD_TYPE: $BOARD_TYPE - TURBO_MODE: $TURBO_MODE" >> $BUILD_LOG

        # Run CMake config command
        cmake -GNinja -DBOARD_TYPE="$BOARD_TYPE" -DTURBO_MODE="$TURBO_MODE" -B $BUILD_DIR -S $SOURCE_DIR &>>$BUILD_LOG

        # Run CMake build command
        cmake --build $BUILD_DIR --config Release &>>$BUILD_LOG

        # Copy .uf2 file
        if [[ -f "$BUILD_DIR/$PKG_NAME.uf2" ]]; then
            if [[ $TURBO_MODE -eq 1 ]]; then
                cp "$BUILD_DIR/$PKG_NAME.uf2" "$PUBLISH_DIR/$PKG_NAME-$BOARD_TYPE-TURBO.uf2"
            else
                cp "$BUILD_DIR/$PKG_NAME.uf2" "$PUBLISH_DIR/$PKG_NAME-$BOARD_TYPE.uf2"
            fi
            echo " -- SUCCESS"
        else
            echo " -- FAIL"
        fi

        # Clean build directory
        # rm --recursive --force $BUILD_DIR/*
        find $BUILD_DIR -mindepth 1 -not -name "build.log*" -delete
    done
done
