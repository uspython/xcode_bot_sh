#Pre-integration Scripts
#npm install
#!/bin/sh
export LC_ALL="en_US.UTF-8"
cd $XCS_SOURCE_DIR/YOUR PROJECT PATH
pwd
npm install 

#pod install
#!/bin/sh
export LC_ALL="en_US.UTF-8"
cd $XCS_PRIMARY_REPO_DIR/ios
/usr/local/bin/pod install --repo-update

#Post-intergration Scripts
#!/bin/sh
# 生成的ipa文件名
IPA_NAME=$(basename "${XCS_ARCHIVE%.*}")
# 重签名的文件夹, `_Resign` is folder name
IPA_RESIGN_PATH="/Users/`whoami`/$IPA_NAME"_Resign
rm -rf $IPA_RESIGN_PATH
mkdir $IPA_RESIGN_PATH
# 导出archive文件
NEW_ARCHIVE="$IPA_RESIGN_PATH/$IPA_NAME".xcarchive
cp -r $XCS_ARCHIVE $NEW_ARCHIVE
# 导出ExportOptions
NEW_EXPORT_OPTION=$IPA_RESIGN_PATH/ExportOptions.plist
cp $XCS_OUTPUT_DIR/ExportOptions.plist $NEW_EXPORT_OPTION
# 修改导出ipa的配置
cd $IPA_RESIGN_PATH
## bitcode
plutil -insert compileBitcode -bool "Yes" ExportOptions.plist
## 不导出瘦身ipa
plutil -replace thinning -string "<none>" ExportOptions.plist
# 开始导出ipa
IPA_EXPORT_PATH=$IPA_RESIGN_PATH/ExportedProduct
mkdir $IPA_EXPORT_PATH
/usr/bin/xcrun xcodebuild -exportArchive -archivePath $NEW_ARCHIVE -exportPath $IPA_EXPORT_PATH -exportOptionsPlist $NEW_EXPORT_OPTION -IDEPostProgressNotifications=YES -DVTAllowServerCertificates=YES -DTDKProvisioningProfileExtraSearchPaths=/Library/Developer/XcodeServer/ProvisioningProfiles
# 把描述文件复制到ipa目录
cp "/Users/`whoami`/YOUR_PRIVISION_FILE.mobileprovision" $IPA_EXPORT_PATH
cd $IPA_EXPORT_PATH
# 重签名
/Users/`whoami`/.rbenv/versions/2.5.1/bin/fastlane sigh resign --signing_identity "YOUR SIGN ID NAME, eg, 'iPhone Distribution: xxxxxxx Co., Ltd.'" >> resign.log
# 上传蒲公英
APP_PATH=`find . -name "*.ipa" -print`
IPA_FILE=$(basename "${APP_PATH%.*}").ipa
echo ${IPA_FILE}
echo `curl -F "file=@${IPA_FILE}" -F "uKey=your key" -F "_api_key=your api key" -F "publishRange=2" https://www.pgyer.com/apiv1/app/upload` >> upload.log

#发送邮件给指定邮件组
MAILPATH=$XCS_PRIMARY_REPO_DIR"/ios/ci"
cd $MAILPATH
pwd
python mail.py ALPHA
