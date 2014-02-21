//
//  TRDTableSpec.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDTable.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

SpecBegin(TRDTable)

NSDictionary *representation = @{
    @"count": @5000,
    @"counter_updated_at": @"2014-02-18T08:12:36Z",
    @"created_at": @"2014-02-18 08:12:29 UTC",
    @"estimated_storage_size": @0,
    @"expire_days": [NSNull null],
    @"id": @102538,
    @"last_log_timestamp": @"2013-09-07T01:13:45Z",
    @"name": @"table1",
    @"schema": @"[[\"host\",\"string\"],[\"path\",\"string\"],[\"method\",\"string\"],[\"referer\",\"string\"],[\"code\",\"long\"],[\"agent\",\"string\"],[\"user\",\"string\"],[\"size\",\"long\"]]",
    @"type": @"log",
    @"updated_at": @"2014-02-18 08:12:36 UTC"
};

__block TRDTable *table;

beforeEach(^{
    table = [MTLJSONAdapter modelOfClass:[TRDTable class] fromJSONDictionary:representation error:NULL];
    expect(table).notTo.beNil();
});

it(@"should initialize", ^{
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    expect(table.name).to.equal(@"table1");
    expect(table.count).to.equal(5000);
    expect(table.createdAt).to.equal([dateFormatter dateFromString:@"2014-02-18 08:12:29 UTC"]);
    expect(table.updatedAt).to.equal([dateFormatter dateFromString:@"2014-02-18 08:12:36 UTC"]);
    expect(table.lastLogTimestamp).to.equal([dateFormatter dateFromString:@"2013-09-07T01:13:45Z"]);
    expect(table.counterUpdatedAt).to.equal([dateFormatter dateFromString:@"2014-02-18T08:12:36Z"]);
});

SpecEnd
