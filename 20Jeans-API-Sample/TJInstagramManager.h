//
//  TJInstagramManager.h
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJInstagramManager : NSObject

+ (TJInstagramManager *)shared;

#pragma mark Auth logic
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)isAuthenticated;
- (void)logout;
- (void)authorizeWithScopes:(NSArray *)scopes;

@end
