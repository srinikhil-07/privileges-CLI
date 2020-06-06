#!/bin/bash
# needs sudo
if [ "$1" == "uninstall" ];
then
    sudo launchctl unload /Library/LaunchDaemons/com.privilege.helper.plist
    sudo rm -f /Library/PrivilegedHelperTools/com.privilege.helper
    sudo rm -f /usr/local/bin/privilege
    sudo rm -f /Library/LaunchDaemons/com.privilege.helper.plist
    exit 0
fi
#clean and build
if [ "$1" == "build" ];
then
sudo rm -rf DerivedData/
xcodebuild -workspace privilege.xcworkspace -scheme privilege -configuration Release clean
xcodebuild -workspace privilege.xcworkspace -scheme privilegehelper -configuration Release clean
xcodebuild -workspace privilege.xcworkspace -scheme privilege -configuration Release build
xcodebuild -workspace privilege.xcworkspace -scheme privilegehelper -configuration Release build
#uncomment below line and add your codesign 
#codesign -f -s "SHA256 HASH" -v --deep -o runtime --timestamp DerivedData/privilege/Build/Products/Release/com.privilege.helper
#codesign -f -s "SHA256 HASH" -v --deep -o runtime --timestamp DerivedData/privilege/Build/Products/Release/privilege
fi

# needs to run as sudo
if [ "$1" == "install" ];
then
    sudo cp DerivedData/privilege/Build/Products/Release/com.privilege.helper /Library/PrivilegedHelperTools/
    sudo cp DerivedData/privilege/Build/Products/Release/privilege /usr/local/bin/
    sudo cp com.privilege.helper.plist /Library/LaunchDaemons/
    cd /Library/LaunchDaemons/
    sudo launchctl load com.privilege.helper.plist
fi


