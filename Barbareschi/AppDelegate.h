//
//  AppDelegate.h
//  Barbareschi
//
//  Created by Enrico on 24/01/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    UINavigationController *navController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, readonly) RootViewController *viewController;

@end
