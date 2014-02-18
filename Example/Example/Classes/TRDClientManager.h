//
//  TRDClientManager.h
//  Example
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TreasureData/TRDClient.h>

@interface TRDClientManager : NSObject
@property(strong) TRDClient *client;
+ (TRDClientManager *)sharedManager;
@end
