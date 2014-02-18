//
//  TRDApiKey.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "MTLModel.h"

@interface TRDApiKey : MTLModel <MTLJSONSerializing>
@property(readonly) NSString *value;
@end
