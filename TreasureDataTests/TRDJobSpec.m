//
//  TRDJobSpec.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDJob.h"

SpecBegin(TRDJob)

NSDictionary *representation = @{
    @"created_at": @"2014-02-20 10:21:55 UTC",
    @"database": @"sample_db",
    @"end_at": @"2014-02-20 10:21:55 UTC",
    @"hive_result_schema": @"[[\"code\",\"bigint\"],[\"count\",\"bigint\"]]",
    @"job_id": @8015461,
    @"organization": [NSNull null],
    @"priority": @0,
    @"query": @"SELECT code, COUNT(1) AS count FROM www_access GROUP BY code",
    @"result": @"",
    @"retry_limit": @0,
    @"start_at": @"2014-02-20 10:21:55 UTC",
    @"status": @"success",
    @"type": @"hive",
    @"updated_at": @"2014-02-20 10:22:43 UTC",
    @"url": @"http://console.treasuredata.com/jobs/8015461",
    @"user_name": @"owner"
};

__block TRDJob *job;

beforeEach(^{
    job = [MTLJSONAdapter modelOfClass:[TRDJob class] fromJSONDictionary:representation error:NULL];
    expect(job).notTo.beNil();
});

it(@"should initialize", ^{
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    expect(job.status).to.equal(TRDJobStatusSuccess);
    expect(job.type).to.equal(TRDJobTypeHive);
    expect(job.priority).to.equal(TRDJobPriorityNormal);
    expect(job.jobID).to.equal(8015461);
    expect(job.startAt).to.equal([dateFormatter dateFromString:@"2014-02-20 10:21:55 UTC"]);
    expect(job.endAt).to.equal([dateFormatter dateFromString:@"2014-02-20 10:21:55 UTC"]);
});

SpecEnd
