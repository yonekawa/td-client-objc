//
//  TRDDatabaseSpec.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDDatabase.h"

SpecBegin(TRDDatabase)

NSDictionary *representation = @{
    @"name": @"database1",
    @"count": @5000,
    @"created_at": @"2013-11-01 16:48:41 -700",
    @"updated_at": @"2013-12-02 16:48:41 -700",
};

__block TRDDatabase *database;

beforeEach(^{
    database = [MTLJSONAdapter modelOfClass:[TRDDatabase class] fromJSONDictionary:representation error:NULL];
    expect(database).notTo.beNil();
});

it(@"should initialize", ^{
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    expect(database.name).to.equal(@"database1");
    expect(database.count).to.equal(5000);
    expect(database.createdAt).to.equal([dateFormatter dateFromString:@"2013-11-01 16:48:41 -700"]);
    expect(database.updatedAt).to.equal([dateFormatter dateFromString:@"2013-12-02 16:48:41 -700"]);
});

SpecEnd