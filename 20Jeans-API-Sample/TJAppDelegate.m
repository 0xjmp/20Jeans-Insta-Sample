//
//  TJAppDelegate.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJAppDelegate.h"
#import "TJInstagramManager.h"
#import "TJLoginViewController.h"
#import "TJMainViewController.h"

@implementation TJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TJMainViewController *mainViewController = [[TJMainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    if (!TJInstagramManager.shared.isAuthenticated)
    {
        TJLoginViewController *loginViewController = [[TJLoginViewController alloc] init];
        [navController presentViewController:loginViewController animated:NO completion:nil];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[TJInstagramManager shared] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[TJInstagramManager shared] handleOpenURL:url];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
