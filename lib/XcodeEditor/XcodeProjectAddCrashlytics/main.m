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
        NSString * libDir = [repositoryRoot stringByAppendingString:@"/build/app" ];
        
        // open project and frameworks group
        XCProject* project = [[XCProject alloc] initWithFilePath:projectDir ];
        XCGroup* group = [project groupWithDisplayName:@"Frameworks"];
        
        // add Crashlytics.framework
        XCFrameworkDefinition* frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:[libDir stringByAppendingString:@"/Crashlytics.framework"]copyToDestination:NO];
        [group addFramework:frameworkDefinition toTargets:[project targets]];
        
//        // add Fabric.framework
//        frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:[libDir stringByAppendingString:@"/Fabric.framework"]copyToDestination:NO];
//        [group addFramework:frameworkDefinition toTargets:[project targets]];
        
        // done
        [project save];
    }
    return 0;
}