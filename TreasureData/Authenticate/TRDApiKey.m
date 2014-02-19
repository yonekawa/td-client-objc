//
//  TRDApiKey.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDApiKey.h"

@interface TRDApiKey()
@property(strong) NSString *value;
@end

@implementation TRDApiKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"value": @"apikey"};
}

- (id)initWithValue:(NSString *)value
{
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}

@end
