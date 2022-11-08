#!/bin/bash

openapi-generator generate -i openapi.json -g swift5 -t .openapi-generator/templates/swift5 -o Generated/ --additional-properties=useJsonEncodable=false,readonlyProperties=true,responseAs=AsyncAwait,useSPMFileStructure=true,nonPublicApi=true

rm -rf Sources/ImmutableXCore/Generated
cp -R Generated/Sources/OpenAPIClient Sources/ImmutableXCore/Generated
rm -rf Generated