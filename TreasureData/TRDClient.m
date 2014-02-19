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

@interface TRDClient()
@property(strong) TRDApiKey *apiKey;
@end

@implementation TRDClient

+ (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    TRDClient *client = [[TRDClient alloc] init];
    NSURLRequest *request = [client requestWithMethod:@"POST"
                                                 path:@"/v3/user/authenticate"
                                           parameters:@{@"user": username, @"password": password}
                                       withAuthHeader:NO];
    return [client enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
          NSError *error = nil;
          client.apiKey = [MTLJSONAdapter modelOfClass:[TRDApiKey class]
                                    fromJSONDictionary:responseObject error:&error];
          if (error) {
              [subscriber sendError:error];
          } else {
              [subscriber sendNext:client];
          }
    }];
}

- (id)init
{
    return [super initWithBaseURL:[NSURL URLWithString:TRDBaseURLString]];
}

- (id)initWithApiKey:(TRDApiKey *)apiKey
{
    self = [self init];
    if (self) {
        self.apiKey = apiKey;
    }
    return self;
}

- (RACSignal *)fetchDatabases
{
    TRDClient *client = [[TRDClient alloc] init];
    NSURLRequest *request = [client requestWithMethod:@"GET"
                                                 path:@"/v3/database/list"
                                           parameters:nil
                                       withAuthHeader:YES];
    return [client enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
        NSArray *databases = responseObject[@"databases"];
        for (NSDictionary *db in databases) {
            TRDDatabase *database = [MTLJSONAdapter modelOfClass:[TRDDatabase class] fromJSONDictionary:db error:NULL];
            [subscriber sendNext:database];
        }
    }];
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request parseResultBlock:(void (^)(id<RACSubscriber> subscriber, id responseObject))parseResultBlock
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
        [self.operationQueue addOperation:operation];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
		}];
    }];
    return [[signal replayLazily] setNameWithFormat:@"enqueuRequest"];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
                            withAuthHeader:(BOOL)withAuthHeader
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                                  parameters:parameters
                                                                       error:nil]; // TODO: error handling.
    [request addValue:[NSString stringWithFormat:@"TD1 %@", self.apiKey.value] forHTTPHeaderField:@"AUTHORIZATION"];
    return request;
}

@end
