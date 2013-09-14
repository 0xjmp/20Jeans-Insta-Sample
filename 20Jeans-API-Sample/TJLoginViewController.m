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
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation TJLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = UIApplication.sharedApplication.keyWindow.frame;
    
    if (frame.size.height >= 568)
    {
        self.imageView.image = [UIImage imageNamed:@"loginScreen568h-@2x.png"];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"loginScreen.png"];
    }
}

#pragma mark - Actions

- (IBAction)authorize:(id)sender
{
    TJInstagramManager.shared.onInstagramLogin = ^(BOOL succeeded)
    {
        if (succeeded)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    [[TJInstagramManager shared] authorizeWithScopes:@[@"basic", @"likes", @"relationships"]];
}

@end
