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

__block TRDClient *client = nil;

describe(@"database", ^{
    beforeEach(^{
        TRDApiKey *key = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:@{@"apikey": @"e72e16c7e42f292c6912e7710c838347ae178b4a"} error:NULL];
        client = [[TRDClient alloc] initWithApiKey:key];
    });
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

describe(@"job", ^{
    beforeEach(^{
        TRDApiKey *key = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:@{@"apikey": @"e72e16c7e42f292c6912e7710c838347ae178b4a"} error:NULL];
        client = [[TRDClient alloc] initWithApiKey:key];
    });

    it(@"should return all job list", ^{
        stubResponse(@"/v3/job/list", @"job_list.json");
        RACSignal *result = [[client fetchAllJobs] collect];
        NSArray *jobs = [result asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(jobs).notTo.beNil();
		expect(success).to.beTruthy();
		expect(error).to.beNil();

        expect([jobs count]).to.equal(2);
        expect(((TRDJob *)jobs[0]).status).to.equal(@"success");
        expect(((TRDJob *)jobs[1]).status).to.equal(@"running");
    });

    it(@"should return job list in specified database", ^{
        stubResponse(@"/v3/job/list", @"job_list_with_database.json");
        RACSignal *result = [[client fetchJobsWithDatabase:@"sample_db_2"] collect];
        NSArray *jobs = [result asynchronousFirstOrDefault:nil success:&success error:&error];
        expect(jobs).notTo.beNil();
		expect(success).to.beTruthy();
		expect(error).to.beNil();
        
        expect([jobs count]).to.equal(2);
        expect(((TRDJob *)jobs[0]).status).to.equal(@"running");
        expect(((TRDJob *)jobs[1]).status).to.equal(@"error");
    });
});

SpecEnd