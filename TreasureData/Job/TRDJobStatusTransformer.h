//
//  TRDJobStatusTransformer.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "MTLValueTransformer.h"

@interface TRDJobStatusTransformer : MTLValueTransformer
+ (MTLValueTransformer *)reversibleTransformer;
@end
