//
//  TJDetailViewController.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/13/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJDetailViewController.h"
#import <MapKit/MapKit.h>

typedef void (^TJGeocodeSuccessBlock)(NSArray *placemarks, NSError *error);

@interface TJDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hashtagLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@end

@implementation TJDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.usernameLabel.text = self.info[@"username"];
    self.hashtagLabel.text = [NSString stringWithFormat:@"#%@", self.info[@"hashtag"]];
    
    self.locationLabel.hidden = YES;
    [self reverseGeocodedLocation];
    
    [self.imageView setImage:self.image];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)reverseGeocodedLocation
{
    if (![self.info[@"location"] isKindOfClass:[NSDictionary class]])
        return;
    
    NSDictionary *dict = self.info[@"location"];
    
    // Exception for Instagram sending a custom name
    if ([dict objectForKey:@"name"])
    {
        self.locationLabel.text = dict[@"name"];
        self.locationLabel.hidden = NO;
        return;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSNumber *latitude = self.info[@"location"][@"latitude"];
    NSNumber *longitude = self.info[@"location"][@"longitude"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude.floatValue
                                                      longitude:longitude.floatValue];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!error)
         {
             self.locationLabel.hidden = NO;
             
             CLPlacemark *placemark = placemarks[0];
             
             self.locationLabel.text = placemark.name;
         }
         else
         {
             NSLog(@"Geocoder error: %@", error);
         }
     }];
}

@end
