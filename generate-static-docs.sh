#!/bin/bash

# Use this script to generate the static files to be hosted on https://docs.x.immutable.com/sdk-docs/core-sdk-swift/overview
while getopts "v:" OPTION; do
  case "$OPTION" in
    v)
      VERSION=$OPTARG
      echo "Generating docs for version: $VERSION";;
    \?)
      echo "Error: missing version. e.g. -v 1-0-0"
      exit;;
    esac
done

if [[ -z "$VERSION" ]]; then
    echo "Must provide -v. e.g. -v 1-0-0" 1>&2
    exit 1
fi

if [[ "$VERSION" == *"."* ]]; then
  echo "Version must use dashes instead of periods. e.g. -v 1-0-0" 1>&2
    exit 1
fi

$(xcrun --find docc) process-archive transform-for-static-hosting ImmutableXCore.doccarchive --output-path docs --hosting-base-path /sdk-references/core-sdk-swift/$VERSION
echo "Generated under /docs using hosting-base-path: /sdk-references/core-sdk-swift/$VERSION"