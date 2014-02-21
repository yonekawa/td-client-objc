//
//  TRDClientSpec.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"
#import "TRDClient+Authenticate.h"
#import "TRDClient+Database.h"
#import "TRDClient+Job.h"
#import "TRDApiKey.h"
#import "TRDDatabase.h"
#import "TRDJob.h"

SpecBegin(TRDClient)

void (^stubResponseWithHeaders)(NSString *, NSString *, NSDictionary *) = ^(NSString *path, NSString *responseFilename, NSDictionary *headers) {
    headers = [headers mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"Content-Type": @"application/json",
    }];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqual:path];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString *fileName = [[NSBundle bundleForClass:self.class] pathForResource:responseFilename.stringByDeletingPathExtension ofType:@"json"];
        return [OHHTTPStubsResponse responseWithFileAtPath:fileName statusCode:200 headers:headers];
    }];
};

void (^stubResponse)(NSString *, NSString *) = ^(NSString *path, NSString *responseFilename) {
    stubResponseWithHeaders(path, responseFilename, @{});
};

__block BOOL success;
__block NSError *error;

beforeEach(^{
    success = NO;
    error = nil;
});

describe(@"authenticate", ^{
    describe(@"+authenticateWithUsername:password:", ^{
        it(@"should return an api key object", ^{
            stubResponse(@"/v3/user/authenticate", @"authenticate.json");
            RACSignal *result = [TRDClient authenticateWithUsername:@"user" password:@"password"];
            TRDClient *client = [result asynchronousFirstOrDefault:nil success:&success error:&error];

            expect(client).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(client.apiKey.value).to.equal(@"e72e16c7e42f292c6912e7710c838347ae178b4a");
        });
    });
});

__block TRDClient *client = nil;

describe(@"database", ^{
    beforeEach(^{
        TRDApiKey *key = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:@{@"apikey": @"e72e16c7e42f292c6912e7710c838347ae178b4a"} error:NULL];
        client = [[TRDClient alloc] initWithApiKey:key];
    });

    describe(@"fetchAllDatabases", ^{
        it(@"should return database list", ^{
            stubResponse(@"/v3/database/list", @"database_list.json");
            RACSignal *result = [[client fetchAllDatabases] collect];
            NSArray *databases = [result asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(databases).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([databases count]).to.equal(2);
            expect(((TRDDatabase *)databases[0]).name).to.equal(@"database1");
            expect(((TRDDatabase *)databases[1]).name).to.equal(@"database2");
        });
    });
});

describe(@"job", ^{
    beforeEach(^{
        TRDApiKey *key = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:@{@"apikey": @"e72e16c7e42f292c6912e7710c838347ae178b4a"} error:NULL];
        client = [[TRDClient alloc] initWithApiKey:key];
    });

    describe(@"-fetchAllJobs", ^{
        it(@"should return all job list", ^{
            stubResponse(@"/v3/job/list", @"job_list.json");
            RACSignal *result = [[client fetchAllJobs] collect];
            NSArray *jobs = [result asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(jobs).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([jobs count]).to.equal(2);
            expect(((TRDJob *)jobs[0]).status).to.equal(TRDJobStatusSuccess);
            expect(((TRDJob *)jobs[1]).status).to.equal(TRDJobStatusRunning);
        });
    });

    describe(@"-fetchJobsWithDatabase:", ^{
        it(@"should return job list in specified database", ^{
            stubResponse(@"/v3/job/list", @"job_list_with_database.json");
            RACSignal *result = [[client fetchJobsWithDatabase:@"sample_db_2"] collect];
            NSArray *jobs = [result asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(jobs).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([jobs count]).to.equal(2);
            expect(((TRDJob *)jobs[0]).status).to.equal(TRDJobStatusRunning);
            expect(((TRDJob *)jobs[1]).status).to.equal(TRDJobStatusError);
        });
    });

    describe(@"-fetchJobWithJobID:", ^{
        it(@"should return job specified", ^{
            stubResponse(@"/v3/job/show/8038069", @"job_show.json");
            RACSignal *result = [client fetchJobWithJobID:8038069];
            TRDJob *job = [result asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(job).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(job.status).to.equal(TRDJobStatusSuccess);
            expect(job.debugSTDERR).to.equal(@"STANDARDERROR");
            expect(job.debugCMDOUT).to.equal(@"COMMANDOUT");
        });
    });

    describe(@"-fetchJobStatusWithJobID:", ^{
        it(@"should return job status", ^{
            stubResponse(@"/v3/job/status/8038069", @"job_status.json");

            RACSignal *result = [client fetchJobStatusWithJobID:8038069];
            TRDJob *job = [result asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(job).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
            expect(job.status).to.equal(TRDJobStatusSuccess);
            expect(job.startAt).to.equal([dateFormatter dateFromString:@"2012-09-17 21:00:01 UTC"]);
            expect(job.endAt).to.equal([dateFormatter dateFromString:@"2012-09-17 21:00:52 UTC"]);
        });
    });

    describe(@"-createNewJobWithQuery:database:", ^{
        it(@"should create new job", ^{
            stubResponse(@"/v3/job/issue/hive/sample_db", @"job_issue_hive.json");

            NSString *query = @"SELECT codd, COUNT(1) AS COUNT FROM www_access GROUP BY code";
            RACSignal *result = [client createNewJobWithQuery:query database:@"sample_db"];
            NSNumber *jobID = [result asynchronousFirstOrDefault:nil success:&success error:&error];
            expect([jobID integerValue]).to.equal(8038069);
        });
    });

    describe(@"-killJobWithJobID:", ^{
        it(@"should kill job specified", ^{
            stubResponse(@"/v3/job/kill/8038069", @"job_kill.json");

            RACSignal *result = [client killJobWithJobID:8038069];
            NSDictionary *response = [result asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(response).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(response[@"former_status"]).to.equal(@"error");
        });
    });
});

SpecEnd
