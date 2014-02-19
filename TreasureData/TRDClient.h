//
//  TRDClient.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import "TRDApiKey.h"

@interface TRDClient : AFHTTPRequestOperationManager
@property(readonly) TRDApiKey *apiKey;
+ (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password;
- (id)initWithApiKey:(TRDApiKey *)apiKey;
- (RACSignal *)fetchDatabases;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
                            withAuthHeader:(BOOL)withAuthHeader;
@end
