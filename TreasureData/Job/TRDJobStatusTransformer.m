//
//  TRDJobStatusTransformer.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDJobStatusTransformer.h"
#import "TRDJob.h"

@implementation TRDJobStatusTransformer

+ (MTLValueTransformer *)reversibleTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        if ([str isEqualToString:@"success"]) {
            return @(TRDJobStatusSuccess);
        } else if ([str isEqualToString:@"error"]) {
            return @(TRDJobStatusError);
        } else if ([str isEqualToString:@"booting"]) {
            return @(TRDJobStatusBooting);
        } else if ([str isEqualToString:@"running"]) {
            return @(TRDJobStatusRunning);
        } else {
            return @(TRDJobStatusQueued);
        }
    } reverseBlock:^(NSNumber *status) {
        switch ([status integerValue]) {
            case TRDJobStatusSuccess:
                return @"success";
            case TRDJobStatusError:
                return @"error";
            case TRDJobStatusBooting:
                return @"booting";
            case TRDJobStatusRunning:
                return @"running";
            default:
                return @"queued";
        }
    }];
}

@end
