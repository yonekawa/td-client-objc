//
//  TRDJob.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDJob.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "TRDJobStatusTransformer.h"

@implementation TRDJob

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"jobID":      @"job_id",
        @"createdAt":  @"created_at",
        @"updatedAt":  @"updated_at",
        @"startAt":    @"start_at",
        @"endAt":      @"end_at",
        @"retryLimit": @"retry_limit",
        @"userName":   @"user_name",
    };
}

+ (NSValueTransformer *)statusJSONTransformer
{
    return [TRDJobStatusTransformer reversibleTransformer];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    // only ‘hive’ at the moment
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return @(TRDJobTypeHive);
    } reverseBlock:^(NSNumber *type) {
        return @"hive";
    }];
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

+ (NSValueTransformer *)startAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[[ISO8601DateFormatter alloc] init] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[[ISO8601DateFormatter alloc] init] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)endAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[[ISO8601DateFormatter alloc] init] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[[ISO8601DateFormatter alloc] init] stringFromDate:date];
    }];
}

@end
