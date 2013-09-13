//
//  TJMainViewController.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJMainViewController.h"
#import "TJInstagramManager.h"
#import "TJInstagramPhotoCell.h"
#import <RFQuiltLayout.h>
#import <AFNetworking.h>
#import "TJDetailViewController.h"

@interface TJMainViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RFQuiltLayoutDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

NSString *const TJUserAuthenticationStatusChanged = @"TJUserAuthenticationStatusChanged";

@implementation TJMainViewController
{
    NSMutableArray *_cellInfos;
    CGFloat _currentY;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *className = NSStringFromClass(TJInstagramPhotoCell.class);
    [self.collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
    
    RFQuiltLayout *layout = (id)[self.collectionView collectionViewLayout];
    layout.delegate = self;
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(100, 100);
    
    [TJInstagramManager.shared addObserverForKeyPath:@"isAuthenticated"
                                          identifier:TJUserAuthenticationStatusChanged
                                             options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew)
                                                task:^(id obj, NSDictionary *change)
     {
         // Fetch instagram
         [self fetchInstagram];
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Retain scroll position for transitions between detail and main view controller
    if (_currentY)
    {
        self.collectionView.contentOffset = CGPointMake(0, _currentY);
        _currentY = 0;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Fetcher methods

- (void)fetchInstagram
{
    if (!TJInstagramManager.shared.isAuthenticated)
        return;
    
    _cellInfos = [NSMutableArray array];
    
    TJInstagramManager.shared.updateBlock = ^(id result, NSString *hashtag)
    {
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (NSDictionary *info in result[@"data"])
        {
            NSMutableArray *objects = [NSMutableArray arrayWithObjects:
                                       info[@"images"][@"standard_resolution"][@"url"],
                                       info[@"images"][@"standard_resolution"][@"height"],
                                       info[@"images"][@"standard_resolution"][@"width"],
                                       info[@"user"][@"username"],
                                       hashtag,
                                       nil];
            
            NSMutableArray *keys = [NSMutableArray arrayWithObjects:
                                    @"url",
                                    @"height",
                                    @"width",
                                    @"username",
                                    @"hashtag",
                                    nil];
            
            if (info[@"location"])
            {
                [objects addObject:info[@"location"]];
                [keys addObject:@"location"];
            }
            
            [_cellInfos addObject:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_cellInfos.count - 1 inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    };
    
    [TJInstagramManager.shared fetchSpecialInstagramHashtags];
}

#pragma mark - UICollectionView dataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cellInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([TJInstagramPhotoCell class]);
    TJInstagramPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
    
    cell.info = _cellInfos[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionView delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJDetailViewController *detailViewController = [[TJDetailViewController alloc] init];
    detailViewController.info = _cellInfos[indexPath.row];
    
    TJInstagramPhotoCell *cell = (TJInstagramPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    detailViewController.image = cell.imageView.image;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    _currentY = self.collectionView.contentOffset.y;
}

#pragma mark - UIScrollView delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [TJInstagramManager.shared fetchNextSpecialInstagramHashtags];
}

#pragma mark - RFQuiltLayout delegate methods

- (UIEdgeInsets) insetsForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = 2;
    return UIEdgeInsetsMake(i, i, i, i);
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self removeObserversWithIdentifier:TJUserAuthenticationStatusChanged];
}

@end
