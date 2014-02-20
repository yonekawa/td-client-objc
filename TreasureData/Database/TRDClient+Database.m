//
//  TRDClient+Database.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient+Database.h"
#import "TRDDatabase.h"

@implementation TRDClient (Database)

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

@end
