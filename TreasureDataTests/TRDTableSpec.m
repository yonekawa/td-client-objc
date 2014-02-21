//
//  TRDTableSpec.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDTable.h"

SpecBegin(TRDTable)

NSDictionary *representation = @{
    @"name": @"table1",
    @"count": @5000,
};

__block TRDTable *table;

beforeEach(^{
    table = [MTLJSONAdapter modelOfClass:[TRDTable class] fromJSONDictionary:representation error:NULL];
    expect(table).notTo.beNil();
});

it(@"should initialize", ^{
    expect(table.name).to.equal(@"table1");
    expect(table.count).to.equal(5000);
});

SpecEnd
