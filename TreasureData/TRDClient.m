//
//  TRDClient.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"
#import <AFNetworking/AFNetworking.h>
#import "TRDApiKey.h"

@implementation TRDClient

+ (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSURL *baseURL = [NSURL URLWithString:@"https://api.treasure-data.com/"];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        AFHTTPRequestOperation *operation = [manager POST:@"/v3/user/authenticate" parameters:@{@"user": username, @"password": password}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error = nil;
              TRDApiKey *apiKey = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:responseObject error:&error];
              if (error) {
                  [subscriber sendError:error];
              } else {
                  [subscriber sendNext:apiKey];
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

@end
