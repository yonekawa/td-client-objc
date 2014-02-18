//
//  TRDClient.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"
#import <AFNetworking/AFNetworking.h>
#import "TRDDatabase.h"

static NSString *const TRDBaseURLString = @"https://api.treasure-data.com/";

@interface TRDClient()
@property(strong) TRDApiKey *apiKey;
@end

@implementation TRDClient

+ (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:TRDBaseURLString]];
        AFHTTPRequestOperation *operation = [manager POST:@"/v3/user/authenticate" parameters:@{@"user": username, @"password": password}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error = nil;
              TRDApiKey *apiKey = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:responseObject error:&error];
              if (error) {
                  [subscriber sendError:error];
              } else {
                  TRDClient *client = [[TRDClient alloc] initWithApiKey:apiKey];
                  [subscriber sendNext:client];
                  [subscriber sendCompleted];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [subscriber sendError:error];
          }
        ];

        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
		}];
    }];

    return [[signal replayLazily] setNameWithFormat:@"+authenticateWithUsername"];
}

- (id)initWithApiKey:(TRDApiKey *)apiKey
{
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
    }
    return self;
}

- (RACSignal *)fetchDatabases
{
    __weak typeof(self) wSelf = self;
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:TRDBaseURLString]];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"TD1 %@", wSelf.apiKey.value] forHTTPHeaderField:@"AUTHORIZATION"];
        AFHTTPRequestOperation *operation = [manager GET:@"/v3/database/list" parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *databases = responseObject[@"databases"];
              for (NSDictionary *db in databases) {
                  TRDDatabase *database = [MTLJSONAdapter modelOfClass:[TRDDatabase class] fromJSONDictionary:db error:NULL];
                  [subscriber sendNext:database];
              }
              [subscriber sendCompleted];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [subscriber sendError:error];
          }
        ];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
		}];
    }];
    return [[signal replayLazily] setNameWithFormat:@"-fetchDatabases"];
}

@end
