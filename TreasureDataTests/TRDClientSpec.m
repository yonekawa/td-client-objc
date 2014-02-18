//
//  TRDClientSpec.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"
#import "TRDApiKey.h"

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

/*
void (^stubResponseWithStatusCode)(NSString *, int) = ^(NSString *path, int statusCode) {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqual:path];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:statusCode headers:nil];
    }];
};
*/

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
        TRDApiKey *response = [result asynchronousFirstOrDefault:nil success:&success error:&error];

        expect(response).notTo.beNil();
		expect(success).to.beTruthy();
		expect(error).to.beNil();

        expect(response.apiKey).to.equal(@"e72e16c7e42f292c6912e7710c838347ae178b4a");
    });
});

SpecEnd