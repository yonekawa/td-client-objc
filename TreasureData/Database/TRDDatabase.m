//
//  TRDDatabase.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDDatabase.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

@implementation TRDDatabase

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"createdAt": @"created_at", @"updatedAt": @"updated_at"};
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

@end
