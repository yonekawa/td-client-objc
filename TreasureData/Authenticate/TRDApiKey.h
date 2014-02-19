//
//  TRDApiKey.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TRDApiKey : MTLModel <MTLJSONSerializing>
@property(readonly) NSString *value;
- (id)initWithValue:(NSString *)value;
@end
