//
//  IPhodAppDelegate.h
//  iPhod
//
//  Created by August Joki on 3/25/09.
//  Copyright Concinnous Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IPhodViewController;

@interface IPhodAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IPhodViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet IPhodViewController *viewController;

@end

