//
//  TJInstagramManager.h
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TJInstaLoginBlock)(BOOL succeeded);
typedef void (^TJUpdateBlock)(id result, NSString *hashtag);

@interface TJInstagramManager : NSObject

@property (nonatomic, assign, readonly) BOOL isAuthenticated;

/** Block that's called when Instagram API successfully logs in */
@property (strong, nonatomic) TJInstaLoginBlock onInstagramLogin;

/** Block that's called when Instagram API sends json responses; adds on to what's current */
@property (strong, nonatomic) TJUpdateBlock updateBlock;

+ (TJInstagramManager *)shared;

#pragma mark Fetcher methods

/* Requires self.updateBlock */
- (void)fetchSpecialInstagramHashtags;

/* Requires self.updateBlock */
- (void)fetchNextSpecialInstagramHashtags;

#pragma mark Auth logic
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)isAuthenticated;
- (void)logout;
- (void)authorizeWithScopes:(NSArray *)scopes;

@end
