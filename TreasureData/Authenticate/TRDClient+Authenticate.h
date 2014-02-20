//
//  TRDClient+Authenticate.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"

@interface TRDClient (Authenticate)
@property(readonly) TRDApiKey *apiKey;
+ (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password;
@end
