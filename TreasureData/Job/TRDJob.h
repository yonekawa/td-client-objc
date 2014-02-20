//
//  TRDJob.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TRDJob : MTLModel <MTLJSONSerializing>
@property(readonly) NSString *status; // TODO: enumerize.
@property(readonly) NSUInteger jobID;
@property(readonly) NSDate *createdAt;
@property(readonly) NSDate *updatedAt;
@property(readonly) NSDate *startAt;
@property(readonly) NSDate *endAt;
@property(readonly) NSString *query;
@property(readonly) NSString *type; // TODO: enumerise.
@property(readonly) NSUInteger priority; // TODO: enumerise.
@property(readonly) NSUInteger retryLimit;
@property(readonly) NSString *userName;

// "hive_result_schema": null,
// "result": "",
// "url": "http://console.treasure-data.com/jobs/215782",
// "organization": null,
// "database": "database1"
@end
