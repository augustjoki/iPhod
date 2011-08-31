//
//  IPhodAppDelegate.m
//  iPhod
//
//  Created by August Joki on 3/25/09.
//  Copyright Concinnous Software 2009. All rights reserved.
//

#import "IPhodAppDelegate.h"
#import "IPhodViewController.h"

@implementation IPhodAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
