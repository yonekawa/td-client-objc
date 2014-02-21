//
//  TRDClient+Table.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient+Table.h"
#import "TRDTable.h"

@implementation TRDClient (Table)

- (RACSignal *)fetchTablesWithDatabase:(NSString *)database
{
    NSParameterAssert(database);

    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:[NSString stringWithFormat:@"/v3/table/list/%@", database]
                                         parameters:nil
                                     withAuthHeader:YES];
    return [self enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
        NSArray *tables = responseObject[@"tables"];
        for (NSDictionary *tableObject in tables) {
            TRDTable *table = [MTLJSONAdapter modelOfClass:[TRDTable class] fromJSONDictionary:tableObject error:NULL];
            [subscriber sendNext:table];
        }
    }];
}

@end
