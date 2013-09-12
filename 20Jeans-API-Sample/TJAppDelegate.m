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

@implementation TJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *mainViewController = [[UIViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = navController;
    
    if (!TJInstagramManager.shared.isAuthenticated)
    {
        TJLoginViewController *loginViewController = [[TJLoginViewController alloc] init];
        [navController presentViewController:loginViewController animated:NO completion:nil];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
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

@end
