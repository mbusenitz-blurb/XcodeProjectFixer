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
        NSString * projectDir = [repositoryRoot stringByAppendingString:@"/build/app/BookWright.xcodeproj" ];
        NSString * libDir = [repositoryRoot stringByAppendingString:@"/lib" ];
        NSString * scriptPath = [repositoryRoot stringByAppendingString: @"/tools/mac/FabricScript" ];
        
        // open project and frameworks group
        XCProject* project = [[XCProject alloc] initWithFilePath:projectDir ];
        XCGroup* group = [project groupWithDisplayName:@"Frameworks"];
        
        // add Fabric.framework
        XCFrameworkDefinition* frameworkDefinition =
        [[XCFrameworkDefinition alloc] initWithFilePath:[libDir stringByAppendingString:@"/Fabric.framework"] copyToDestination:NO];
        [group addFramework:frameworkDefinition toTargets:[project targets]];
        
        // add Crashlytics.framework
        frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:[libDir stringByAppendingString:@"/Crashlytics.framework"]copyToDestination:NO];
        [group addFramework:frameworkDefinition toTargets:[project targets]];
        
        // add Security.framework
        frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:@"Security.framework" copyToDestination:NO];
        [group addFramework:frameworkDefinition toTargets:[project targets]];
        
        // add SystemConfiguration.framework
        frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:@"SystemConfiguration.framework" copyToDestination:NO];
        [group addFramework:frameworkDefinition toTargets:[project targets]];
        
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
        XCTarget* examples = [project targetWithName:@"BookWright"];
        [examples makeAndAddShellScript:script ];
        
        // done
        [project save];
    }
    return 0;
}