//
//  TRDTable.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TRDTable : MTLModel <MTLJSONSerializing>
@property(readonly) NSUInteger count;
@property(readonly) NSString *name;
@property(readonly) NSString *schema;
@property(readonly) NSDate *createdAt;
@property(readonly) NSDate *updatedAt;
@property(readonly) NSDate *lastLogTimestamp;
@property(readonly) NSDate *counterUpdatedAt;
@end
