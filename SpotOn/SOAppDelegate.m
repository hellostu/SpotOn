//
//  SLAppDelegate.m
//  DotGame
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOAppDelegate.h"
#import "SOPassAndPlayViewController.h"
#import "TestFlight.h"
#import "SOGameCenterHelper.h"
#import "SOMenuController.h"

#import "SOTutorialViewController.h"

@implementation SOAppDelegate

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupTestFlight];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor blackColor];
    
    SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
    [gameCenterHelper clearOldMatchData];
    
    //SOTutorialViewController *tutorialVC = [[SOTutorialViewController alloc] init];
    //self.window.rootViewController = tutorialVC;
    //[tutorialVC release];
    
    //SOPassAndPlayViewController *passAndPlay = [[SOPassAndPlayViewController alloc] init];
    //self.window.rootViewController = passAndPlay;
    //[passAndPlay release];

    //SOGameCenterViewController *gameCenterVC = [[SOGameCenterViewController alloc] init];
    //self.window.rootViewController = gameCenterVC;
    //[gameCenterVC release];
    
    SOMenuController *menuController = [[SOMenuController alloc] init];
    self.window.rootViewController = menuController;
    [menuController release];

return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)setupTestFlight
{
    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    [TestFlight setDeviceIdentifier:uuid];
    [TestFlight takeOff:@"dbb4a13f-8cb8-490d-a36f-b985fd25d454"];
}

@end
