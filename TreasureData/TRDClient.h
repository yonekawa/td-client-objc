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
- (id)initWithApiKey:(TRDApiKey *)apiKey;
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
                            withAuthHeader:(BOOL)withAuthHeader;
- (RACSignal *)enqueueRequest:(NSURLRequest *)request
             parseResultBlock:(void (^)(id<RACSubscriber> subscriber, id responseObject))parseResultBlock;
- (RACSignal *)enqueueRequest:(NSURLRequest *)request
                   serializer:(AFHTTPResponseSerializer *)serializer
             parseResultBlock:(void (^)(id<RACSubscriber> subscriber, id responseObject))parseResultBlock;
@end
