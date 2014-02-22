//
//  TRDClient.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle/EXTScope.h>
#import "TRDDatabase.h"

static NSString *const TRDBaseURLString = @"https://api.treasure-data.com/";
static NSString *const TRDAuthorizationHeaderFormat = @"TD1 %@";

@interface TRDClient()
@property(strong) TRDApiKey *apiKey;
@end

@implementation TRDClient

- (instancetype)init
{
    return [super initWithBaseURL:[NSURL URLWithString:TRDBaseURLString]];
}

- (instancetype)initWithApiKey:(TRDApiKey *)apiKey
{
    self = [self init];
    if (self) {
        self.apiKey = apiKey;
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
                            withAuthHeader:(BOOL)withAuthHeader
{
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:[url absoluteString]
                                                                  parameters:parameters
                                                                       error:nil]; // TODO: error handling.
    [request addValue:[NSString stringWithFormat:TRDAuthorizationHeaderFormat, self.apiKey.value] forHTTPHeaderField:@"AUTHORIZATION"];
    return request;
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request parseResultBlock:(void (^)(id<RACSubscriber> subscriber, id responseObject))parseResultBlock
{
    return [self enqueueRequest:request serializer:nil parseResultBlock:parseResultBlock];
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request
                   serializer:(AFHTTPResponseSerializer *)serializer
             parseResultBlock:(void (^)(id<RACSubscriber> subscriber, id responseObject))parseResultBlock
{
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (parseResultBlock) {
                  parseResultBlock(subscriber, responseObject);
              } else {
                  [subscriber sendNext:responseObject];
              }
              [subscriber sendCompleted];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [subscriber sendError:error];
          }
        ];

        if (serializer) {
            operation.responseSerializer = serializer;
        }
        [self.operationQueue addOperation:operation];

        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
	}];
    }];
    return [[signal replayLazily] setNameWithFormat:@"enqueueRequest"];
}

@end
