//
//  TJInstagramManager.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJInstagramManager.h"
#import <Instagram.h>
#import "TJLoginViewController.h"

#define kInstagramClientId @"99f687781a2a4cee96c967ac28a8d576"

@interface TJInstagramManager () <IGSessionDelegate, IGRequestDelegate>
@property (strong, nonatomic) Instagram *instagram;
@end

@implementation TJInstagramManager

#pragma mark - Public methods

+ (TJInstagramManager *)shared
{
    static TJInstagramManager *_shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[TJInstagramManager alloc] init];
    });
    
    return _shared;
}

#pragma mark Fetcher methods

- (void)fetchListWithParams:(NSMutableDictionary *)params
{
    [self.instagram requestWithParams:params delegate:self];
}

#pragma mark Auth logic

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [self.instagram handleOpenURL:url];
}

- (BOOL)isAuthenticated
{
    return [self.instagram isSessionValid];
}

- (void)logout
{
    [self.instagram logout];
}

- (void)authorizeWithScopes:(NSArray *)scopes
{
    [self.instagram authorize:scopes];
}

#pragma mark - Private methods

- (id)init
{
    self = [super init];
    if (self)
    {
        _instagram = [[Instagram alloc] initWithClientId:kInstagramClientId delegate:self];
    }
    
    return self;
}

#pragma mark IGSession delegate methods

- (void)igDidLogin
{
    if (self.onInstagramLogin) self.onInstagramLogin(YES);
}

- (void)igDidNotLogin:(BOOL)cancelled
{
    if (self.onInstagramLogin) self.onInstagramLogin(cancelled);
}

- (void)igDidLogout
{
    // TODO: popToRoot - present login view controller
}

- (void)igSessionInvalidated
{
    // TODO: popToRoot - present login view controller
}

#pragma mark IGRequest delegate methods

- (void)request:(IGRequest *)request didLoad:(id)result
{
    if (self.resultBlock) self.resultBlock(result, nil);
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Instagram API error: %@", error);
    
    if (self.resultBlock) self.resultBlock(nil, error);
}

@end
