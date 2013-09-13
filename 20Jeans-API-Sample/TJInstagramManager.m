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
#import <AFNetworking.h>

#define kInstagramClientId @"99f687781a2a4cee96c967ac28a8d576"
#define kInstagramTwentyJeansUserId @"233783356"

@interface TJInstagramManager () <IGSessionDelegate, IGRequestDelegate>
@property (strong, nonatomic) Instagram *instagram;
@property (nonatomic, assign, readwrite) BOOL isAuthenticated;
@property (strong, nonatomic) AFHTTPClient *serverClient;

@property (strong, nonatomic) NSMutableArray *paginations;
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

- (void)fetchSpecialInstagramHashtags
{
    if (!self.isAuthenticated || self.instagram.accessToken.length == 0)
    {
        NSLog(@"user not authenticated!");
        return;
    }
    
    NSArray *hashtags = @[
                          @"20jeans",
                          @"polychrom",
                          @"springst",
                          @"vantagepoint",
                          @"truegrit"
                          ];
    
    self.paginations = [NSMutableArray arrayWithCapacity:hashtags.count];
    
    for (NSString *hashtag in hashtags)
    {
        [self fetchInstagramPhotosForHashTag:hashtag];
    }
}

- (void)fetchInstagramPhotosForHashTag:(NSString *)hashtag
{
    NSDictionary *params = @{
                             @"access_token": self.instagram.accessToken
                             };
    
    NSString *path = [NSString stringWithFormat:@"tags/%@/media/recent", hashtag];
    
    [self.serverClient getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        if (self.updateBlock) self.updateBlock(dict, hashtag);
        
        NSDictionary *info = @{
                               @"hashtag" : hashtag,
                               @"max_tag" : dict[@"pagination"][@"next_max_id"]
                               };
        [self.paginations addObject:info];
    }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        // Don't call self.updateBlock here to prevent an update
        NSLog(@"Erorr: %@", error);
    }];
}

- (void)fetchNextSpecialInstagramHashtags
{
    if (!self.paginations)
        return;
    
    for (NSDictionary *info in self.paginations)
    {
        [self fetchNextForHashtag:info[@"hashtag"] maxTag:info[@"max_tag"]];
    }
}

- (void)fetchNextForHashtag:(NSString *)hashtag maxTag:(NSString *)maxTag
{
    NSString *path = [NSString stringWithFormat:@"tags/%@/media/recent", hashtag];
    
    NSDictionary *params = @{
                             @"access_token" : self.instagram.accessToken,
                             @"max_tag_id" : maxTag
                             };
    
    [self.serverClient getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
         
         if (self.updateBlock) self.updateBlock(dict, hashtag);
     }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         // Don't call self.updateBlock here to prevent an update
         NSLog(@"Erorr: %@", error);
     }];
}

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
//    return YES;
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
        _serverClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/"]];
    }
    
    return self;
}

#pragma mark IGSession delegate methods

- (void)igDidLogin
{
    self.isAuthenticated = YES;
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
