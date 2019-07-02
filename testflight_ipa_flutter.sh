#Pre-integration Scripts
#PUB Install
#!/bin/sh
export LC_ALL="en_US.UTF-8"
cd $XCS_SOURCE_DIR/your_project
pwd
whoami
export FLUTTER_STORAGE_BASE_URL=https://mirrors.sjtug.sjtu.edu.cn
export PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub/
export PATH=$PATH:"/usr/local/bin"
/Users/`whoami`/develop/flutter/bin/flutter packages get
echo ******Pub Get Done******
buildNumber=$(git rev-list --count HEAD)
/Users/`whoami`/develop/flutter/bin/flutter build ios --release --no-codesign --build-number=$buildNumber


#Post-integration Scripts
#Upload
#!/bin/sh
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$PATH:"/Users/`whoami`/.rbenv/versions/2.5.1/bin"
cd $XCS_SOURCE_DIR/your_project/ios
pwd
bundle exec fastlane ios beta

#发送邮件给邮件组
MAILPATH=$XCS_PRIMARY_REPO_DIR"/scripts"
cd $MAILPATH
pwd
python mail.py ios_release

