//
//  TRDTable.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDTable.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

@implementation TRDTable

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"createdAt":        @"created_at",
        @"updatedAt":        @"updated_at",
        @"lastLogTimestamp": @"last_log_timestamp",
        @"counterUpdatedAt": @"counter_updated_at",
    };
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[[ISO8601DateFormatter alloc] init] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[[ISO8601DateFormatter alloc] init] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[[ISO8601DateFormatter alloc] init] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[[ISO8601DateFormatter alloc] init] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)lastLogTimestampJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[[ISO8601DateFormatter alloc] init] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[[ISO8601DateFormatter alloc] init] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)counterUpdatedAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[[ISO8601DateFormatter alloc] init] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[[ISO8601DateFormatter alloc] init] stringFromDate:date];
    }];
}

@end
