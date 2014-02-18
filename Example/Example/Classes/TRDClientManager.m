//
//  TRDClientManager.m
//  Example
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014年 MogMog Developer. All rights reserved.
//

#import "TRDClientManager.h"

@implementation TRDClientManager

static TRDClientManager *_sharedManager = nil;
+ (TRDClientManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TRDClientManager alloc] init];
    });
    return _sharedManager;
}

- (id)init
{
    if (_sharedManager != nil) {
        return nil;
    }

    return [super init];
}

@end
