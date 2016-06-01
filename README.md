### overview
This is using the XcodeEditor xcode project with an added target called `XcoceProjectFixer`. 

### build
To build open the 
project `lib/XcodeEditor/XcodeEditor.xcodeproj`, select the `XcoceProjectFixer` target and build.  Click on the `Products` group to see the executable.

### depenendencies
[XcodeEditor](https://github.com/appsquickly/XcodeEditor.git)
to update run:
```
git remote add lib/XcodeEditor https://github.com/appsquickly/XcodeEditor.git
git subtree pull -P lib/XcodeEditor lib/XcodeEditor master --squash
```
