//
//  TRDClient.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRDClient : NSObject
+ (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password;
@end
