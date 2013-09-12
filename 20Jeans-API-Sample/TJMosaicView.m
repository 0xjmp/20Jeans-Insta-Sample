//
//  TJMosaicDataView.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJMosaicView.h"
#import "TJInstagramManager.h"

@interface TJMosaicView () <MosaicViewDelegateProtocol, MosaicViewDatasourceProtocol>

@end

@implementation TJMosaicView
{
    NSArray *_instagramPhotos;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self fetchInstagram];
}

#pragma mark - Fetcher methods

- (void)fetchInstagram
{
    if (!TJInstagramManager.shared.isAuthenticated)
        return;
    
    TJInstagramManager.shared.resultBlock = ^(id result, NSError *error)
    {
        if (!error)
        {
            _instagramPhotos = result;
        }
    };
    
    NSDictionary *params = @{
                             
                             };
    
    [[TJInstagramManager shared] fetchListWithParams:[params mutableCopy]];
}

#pragma mark - MosaicView dataSource methods

- (NSArray *)mosaicElements
{
    return @[];
}

#pragma mark - MosaicView delegate methods

- (void)mosaicViewDidTap:(MosaicDataView *)aModule
{
    
}

- (void)mosaicViewDidDoubleTap:(MosaicDataView *)aModule
{
    
}

@end
