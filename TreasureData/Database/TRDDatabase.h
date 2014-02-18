//
//  TRDDatabase.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TRDDatabase : MTLModel <MTLJSONSerializing>
@property(readonly) NSUInteger count;
@property(readonly) NSString *name;
@property(readonly) NSDate *createdAt;
@property(readonly) NSDate *updatedAt;
@end
