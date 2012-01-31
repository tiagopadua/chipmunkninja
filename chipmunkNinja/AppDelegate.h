//
//  AppDelegate.h
//  chipmunkNinja
//
//  Created by Tiago Padua on 31/1/12.
//  Copyright Terra Networks 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
