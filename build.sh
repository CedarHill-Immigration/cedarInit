#!/bin/bash

PACKAGE_JSON="package.json"
MANIFEST_JSON="cedarInit/manifest.json"
VERSION=$(jq -r '.version' "$PACKAGE_JSON")

if [ -z "$VERSION" ]; then
  echo "Error: Failed to read version from $PACKAGE_JSON"
  exit 1
fi

echo "Version read from package.json: $VERSION"

jq --indent 4 --arg version "$VERSION" '.version = $version' "$MANIFEST_JSON" > "$MANIFEST_JSON.tmp" && mv "$MANIFEST_JSON.tmp" "$MANIFEST_JSON"

if [ $? -eq 0 ]; then
  echo "Version updated in $MANIFEST_JSON"
else
  echo "Error: Failed to update version in $MANIFEST_JSON"
  exit 1
fi

OUTPUT_DIR="bin"
OUTPUT_FILE="$OUTPUT_DIR/CedarInit_${VERSION}.crx"

mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_FILE"

if (
  cd cedarInit && \
  zip -qr "../$OUTPUT_FILE" ./*
); then
  echo "Package created at $OUTPUT_FILE"
else
  echo "Error: Failed to create package at $OUTPUT_FILE"
  exit 1
fi
