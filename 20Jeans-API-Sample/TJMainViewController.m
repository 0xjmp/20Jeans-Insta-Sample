//
//  TJMainViewController.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJMainViewController.h"
#import "TJInstagramManager.h"

@interface TJMainViewController ()

@end

@implementation TJMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self fetchInstagram];
}

#pragma mark - Fetcher methods

- (void)fetchInstagram
{
    if (!TJInstagramManager.shared.isAuthenticated)
        return;
    
    // Fetch Instagram objects
}

@end
