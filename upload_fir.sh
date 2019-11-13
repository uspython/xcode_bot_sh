#!/bin/sh
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

APP_PATH=$(find . -name "*.ipa" -print)
IPA_FILE=$(basename "${APP_PATH%.*}").ipa
echo ${IPA_FILE}

echo $(curl -m 1800 -X "POST" "http://api.fir.im/apps" -H "Content-Type: application/json" -d "{\"type\":\"ios\", \"bundle_id\":\"xxx.xxx.xxx\", \"api_token\":\"xxxxxxxxxx\"}") >upload_url.log

FIRKEY=$(jq -r .cert.binary.key upload_url.log)
FIRTOKEN=$(jq -r .cert.binary.token upload_url.log)
FIRURL=$(jq -r .cert.binary.upload_url upload_url.log)

# Magic, `xxxxxxxxxxx` is your project's configaration
versionNumber=$(plutil -extract objects.xxxxxxxxxx.buildSettings json -o - yourproject.xcodeproj/project.pbxproj | jq -r .MARKETING_VERSION)
buildNumber=$(xcrun agvtool vers)

echo $(curl -m 1800 -X "POST" "${FIRURL}" -F "key=${FIRKEY}" -F "token=${FIRTOKEN}" -F "file=@${IPA_FILE}" -F "x:name=youripabname" -F "x:version=${versionNumber}" -F "x:build=${buildNumber}" -F "x:release_type=Adhoc") >>upload_fir.log
