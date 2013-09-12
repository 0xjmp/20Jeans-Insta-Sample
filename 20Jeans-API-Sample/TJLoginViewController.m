//
//  TJInstaLoginViewController.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJLoginViewController.h"
#import "TJInstagramManager.h"

@interface TJLoginViewController ()

@end

@implementation TJLoginViewController

#pragma mark - Actions

- (IBAction)authorize:(id)sender
{
    TJInstagramManager.shared.onInstagramLogin = ^(BOOL succeeded)
    {
        if (succeeded)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            // dialog to show cancelled login
        }
    };
    
    [[TJInstagramManager shared] authorizeWithScopes:nil];
}

@end
