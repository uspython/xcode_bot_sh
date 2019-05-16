#!/bin/sh
export LC_ALL="en_US.UTF-8"
cd $XCS_PRIMARY_REPO_DIR
pwd
whoami
export FLUTTER_STORAGE_BASE_URL=https://mirrors.sjtug.sjtu.edu.cn
export PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub/
export PATH=$PATH:"/usr/local/bin"
# your flutter path
/Users/`whoami`/develop/flutter/bin/flutter packages get
echo ******Pub Get Done******
buildNumber=$(git rev-list --count HEAD)
/Users/`whoami`/develop/flutter/bin/flutter build ios --release --no-codesign --build-number=$buildNumber
