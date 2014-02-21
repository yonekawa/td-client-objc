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
#import "TRDClient+Table.h"
#import "TRDClient+Job.h"
#import "TRDApiKey.h"
#import "TRDDatabase.h"
#import "TRDTable.h"
#import "TRDJob.h"

SpecBegin(TRDClient)

void (^stubResponseWithHeaders)(NSString *, NSString *, NSDictionary *) = ^(NSString *path, NSString *responseFilename, NSDictionary *headers) {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqual:path];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString *fileName = [[NSBundle bundleForClass:self.class] pathForResource:responseFilename.stringByDeletingPathExtension ofType:[responseFilename pathExtension]];
        return [OHHTTPStubsResponse responseWithFileAtPath:fileName statusCode:200 headers:headers];
    }];
};

void (^stubResponse)(NSString *, NSString *, NSString *) = ^(NSString *path, NSString *responseFilename, NSString *contentType) {
    stubResponseWithHeaders(path, responseFilename, @{@"Content-Type": contentType});
};

void (^stubJsonResponse)(NSString *, NSString *) = ^(NSString *path, NSString *responseFilename) {
    stubResponse(path, responseFilename, @"application/json");
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
            stubJsonResponse(@"/v3/user/authenticate", @"authenticate.json");
            RACSignal *response = [TRDClient authenticateWithUsername:@"user" password:@"password"];
            TRDClient *client = [response asynchronousFirstOrDefault:nil success:&success error:&error];

            expect(client).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(client.apiKey.value).to.equal(@"e72e16c7e42f292c6912e7710c838347ae178b4a");
        });
    });
});

__block TRDClient *client = nil;
void (^useMockClient)() = ^() {
    TRDApiKey *key = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:@{@"apikey": @"e72e16c7e42f292c6912e7710c838347ae178b4a"} error:NULL];
    client = [[TRDClient alloc] initWithApiKey:key];
};

describe(@"database", ^{
    beforeEach(^{
        useMockClient();
    });

    describe(@"-fetchAllDatabases", ^{
        it(@"should return database list", ^{
            stubJsonResponse(@"/v3/database/list", @"database_list.json");
            RACSignal *response = [[client fetchAllDatabases] collect];
            NSArray *databases = [response asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(databases).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([databases count]).to.equal(2);
            expect(((TRDDatabase *)databases[0]).name).to.equal(@"database1");
            expect(((TRDDatabase *)databases[1]).name).to.equal(@"database2");
        });
    });
});

describe(@"table", ^{
    beforeEach(^{
        useMockClient();
    });

    describe(@"-fetchTableWithDatabase", ^{
        it(@"should return table list in database specified", ^{
            stubJsonResponse(@"/v3/table/list/database1", @"table_list.json");
            RACSignal *response = [[client fetchTablesWithDatabase:@"database1"] collect];
            NSArray *tables = [response asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(tables).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            expect([tables count]).to.equal(2);
            expect(((TRDTable *)tables[0]).name).to.equal(@"table1");
            expect(((TRDTable *)tables[1]).name).to.equal(@"table2");
        });
    });
});

describe(@"job", ^{
    beforeEach(^{
        useMockClient();
    });

    describe(@"-fetchAllJobs", ^{
        it(@"should return all job list", ^{
            stubJsonResponse(@"/v3/job/list", @"job_list.json");
            RACSignal *response = [[client fetchAllJobs] collect];
            NSArray *jobs = [response asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(jobs).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect([jobs count]).to.equal(2);
            expect(((TRDJob *)jobs[0]).status).to.equal(TRDJobStatusSuccess);
            expect(((TRDJob *)jobs[1]).status).to.equal(TRDJobStatusRunning);
        });
    });

    describe(@"-fetchJobsWithDatabase:", ^{
        it(@"should return job list in database specified", ^{
            stubJsonResponse(@"/v3/job/list", @"job_list_with_database.json");
            RACSignal *response = [[client fetchJobsWithDatabase:@"sample_db_2"] collect];
            NSArray *jobs = [response asynchronousFirstOrDefault:nil success:&success error:&error];
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
            stubJsonResponse(@"/v3/job/show/8038069", @"job_show.json");
            RACSignal *response = [client fetchJobWithJobID:8038069];
            TRDJob *job = [response asynchronousFirstOrDefault:nil success:&success error:&error];
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
            stubJsonResponse(@"/v3/job/status/8038069", @"job_status.json");

            RACSignal *response = [client fetchJobStatusWithJobID:8038069];
            TRDJob *job = [response asynchronousFirstOrDefault:nil success:&success error:&error];
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
            stubJsonResponse(@"/v3/job/issue/hive/sample_db", @"job_issue_hive.json");

            NSString *query = @"SELECT codd, COUNT(1) AS COUNT FROM www_access GROUP BY code";
            RACSignal *response = [client createNewJobWithQuery:query database:@"sample_db"];
            NSNumber *jobID = [response asynchronousFirstOrDefault:nil success:&success error:&error];
            expect([jobID integerValue]).to.equal(8038069);
        });
    });

    describe(@"-killJobWithJobID:", ^{
        it(@"should kill job specified", ^{
            stubJsonResponse(@"/v3/job/kill/8038069", @"job_kill.json");

            RACSignal *response = [client killJobWithJobID:8038069];
            NSDictionary *result = [response asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(result).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            expect(result[@"former_status"]).to.equal(@"error");
        });
    });

    describe(@"-downloadJobResultWithJobID:format:", ^{
        it(@"should return job result by format specified", ^{
            stubResponse(@"/v3/job/result/8038069", @"job_result.csv", @"text/csv");

            RACSignal *response = [client downloadJobResultWithJobID:8038069 format:TRDJobResultFormatCsv];
            NSData *result = [response asynchronousFirstOrDefault:nil success:&success error:&error];
            expect(result).notTo.beNil();
            expect(success).to.beTruthy();
            expect(error).to.beNil();

            NSString *data = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            expect(data).to.equal(@"200,4981\n404,17\n500,2");
        });
    });
});

SpecEnd
