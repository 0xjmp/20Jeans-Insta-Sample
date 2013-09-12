//
//  TJInstagramManager.m
//  20Jeans-API-Sample
//
//  Created by Jacob Peterson on 9/11/13.
//  Copyright (c) 2013 Jacob Peterson. All rights reserved.
//

#import "TJInstagramManager.h"
#import <Instagram.h>

#define kInstagramClientId @"99f687781a2a4cee96c967ac28a8d576"

@interface TJInstagramManager () <IGSessionDelegate>
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
    
}

- (void)igSessionInvalidated
{
    
}

@end
