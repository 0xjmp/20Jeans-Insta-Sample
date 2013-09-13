//
//  TJInstagramPhotoCell.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJInstagramPhotoCell.h"
#import <AFNetworking.h>

@implementation TJInstagramPhotoCell

- (void)setInfo:(NSDictionary *)info
{
    _info = info;
    [self update];
}

- (void)update
{
    if (!self.info)
        return;
    
    [super prepareForReuse];
    
    self.activityIndicator.center = self.center;
    [self.activityIndicator startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.info[@"url"]]];
    
    __weak __typeof(self)weakSelf = self;
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
    {
        [weakSelf.activityIndicator stopAnimating];
        
        [weakSelf setNeedsDisplay];
        
        weakSelf.imageView.image = image;
        
        weakSelf.hashtagLabel.text = [NSString stringWithFormat:@"#%@", weakSelf.info[@"hashtag"]];
        weakSelf.usernameLabel.text = weakSelf.info[@"username"];
    }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}

- (void)setFrame:(CGRect)frame
{
    // Force the cell to redraw itself, which will optimize dequeing
    [super setFrame:frame];
    [self setNeedsDisplay];
}

@end
