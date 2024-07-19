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
