//
//  TJInstagramManager.h
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TJInstaLoginBlock)(BOOL succeeded);
typedef void (^TJSuccessBlock)(id result, NSError *error);

@interface TJInstagramManager : NSObject

/** Block that's called when Instagram API successfully logs in */
@property (strong, nonatomic) TJInstaLoginBlock onInstagramLogin;

/** Block that's called when Instagram API sends json response */
@property (strong, nonatomic) TJSuccessBlock resultBlock;

+ (TJInstagramManager *)shared;

#pragma mark Fetcher methods

/* Initiates a request; result/error returned via resultBlock */
- (void)fetchListWithParams:(NSMutableDictionary *)params;

#pragma mark Auth logic
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)isAuthenticated;
- (void)logout;
- (void)authorizeWithScopes:(NSArray *)scopes;

@end
