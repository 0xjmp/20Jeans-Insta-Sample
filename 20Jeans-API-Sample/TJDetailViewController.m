//
//  TJDetailViewController.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/13/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJDetailViewController.h"

@interface TJDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hashtagLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@end

@implementation TJDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.usernameLabel.text = self.info[@"username"];
    self.hashtagLabel.text = [NSString stringWithFormat:@"#%@", self.info[@"hashtag"]];
    
    [self.imageView setImage:self.image];
}

- (void)setInfo:(NSDictionary *)info
{
    _info = info;
    
    self.usernameLabel.text = info[@"username"];
    self.hashtagLabel.text = info[@"hashtag"];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.imageView setImage:image];
}

@end
