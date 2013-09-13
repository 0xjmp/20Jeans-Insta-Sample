//
//  TJInstagramPhotoCell.h
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJInstagramPhotoCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSDictionary *info;
@end