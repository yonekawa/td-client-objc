//
//  TRDClient+Database.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"

@interface TRDClient (Database)
- (RACSignal *)fetchDatabases;
@end
