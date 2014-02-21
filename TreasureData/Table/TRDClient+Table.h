//
//  TRDClient+Table.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"

@interface TRDClient (Table)
- (RACSignal *)fetchTablesWithDatabase:(NSString *)database;
@end
