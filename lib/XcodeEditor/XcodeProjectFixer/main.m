//
//  main.m
//  XcodeProjectFixer
//
//  Created by Mark Busenitz on 6/1/16.
//  Copyright © 2016 appsquickly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeEditor/XcodeEditor.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        if (argc != 2)
        {
            NSLog( @"usage: XcodeProjectFixer path/to/repository/root/" );
            return 1;
        }
        
        NSString * repositoryRoot = [[NSString alloc] initWithUTF8String:argv[1] ];
        NSString * buildDir = [repositoryRoot stringByAppendingString:@"/build/app"];
        NSString * projectDir = [buildDir stringByAppendingString:@"/BookWright.xcodeproj" ];
        NSString * libDir = [repositoryRoot stringByAppendingString:@"/lib" ];
        NSString * scriptPath = [repositoryRoot stringByAppendingString: @"/tools/mac/FabricScript" ];
        
        // open project and frameworks group
        XCProject* project = [[XCProject alloc] initWithFilePath:projectDir ];
        
        // append run phase script
        NSData * data = [[NSFileManager defaultManager] contentsAtPath: scriptPath ];
        NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
        XCBuildShellScriptDefinition * script = [ XCBuildShellScriptDefinition shellScriptDefinitionWithName: @"FabricRun"
                                                                                                       files:nil
                                                                                                  inputPaths:nil
                                                                                                 outputPaths:nil
                                                                          runOnlyForDeploymentPostprocessing:NO
                                                                                                   shellPath:libDir
                                                                                                 shellScript:content ];
        XCTarget* target = [project targetWithName:@"BookWright"];
        [target makeAndAddShellScript:script ];

        XCGroup* frameworks = [project groupWithDisplayName:@"Frameworks"];
        
        // add Crashlytics.framework
        XCFrameworkDefinition* frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:[buildDir stringByAppendingString:@"/Crashlytics.framework"]copyToDestination:NO];
        [frameworks addFramework:frameworkDefinition toTargets:[project targets]];
        
        // add Fabric.framework
        frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:[buildDir stringByAppendingString:@"/Fabric.framework"]copyToDestination:NO];
        [frameworks addFramework:frameworkDefinition toTargets:[project targets]];
        
        // done
        [project save];
    }
    return 0;
}