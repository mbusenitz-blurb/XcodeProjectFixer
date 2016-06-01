This is using the XcodeEditor xcode project with a added target called 'XcoceProjectFixer'. To build open the 
project 'lib/XcodeEditor/XcodeEditor.xcodeproj', select the 'XcoceProjectFixer' target and build. Then click on the 'Products' group to see the executable.  

Depenendency: https://github.com/appsquickly/XcodeEditor.git

git remote add lib/XcodeEditor https://github.com/appsquickly/XcodeEditor.git
git subtree pull -P lib/XcodeEditor lib/XcodeEditor master --squash
