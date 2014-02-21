//
//  TRDClient+Authenticate.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient+Authenticate.h"

@interface TRDClient()
@property(strong) TRDApiKey *apiKey;
@end

@implementation TRDClient (Authenticate)

+ (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    NSParameterAssert(username);
    NSParameterAssert(password);

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

@end
