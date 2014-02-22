//
//  TRDApiKeySpec.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDApiKey.h"

SpecBegin(TRDApiKey)

NSDictionary *representation = @{@"apikey": @"e72e16c7e42f292c6912e7710c838347ae178b4a"};

__block TRDApiKey *apiKey;

beforeEach(^{
    apiKey = [MTLJSONAdapter modelOfClass:[TRDApiKey class] fromJSONDictionary:representation error:NULL];
    expect(apiKey).notTo.beNil();
});

it(@"should initialize", ^{
    expect(apiKey.value).to.equal(@"e72e16c7e42f292c6912e7710c838347ae178b4a");
});

describe(@"+apiKeyWithValue", ^{
    beforeEach(^{
        apiKey = [TRDApiKey apiKeyWithValue:@"e72e16c7e42f292c6912e7710c838347ae178b4a"];
        expect(apiKey).notTo.beNil();
    });
    
    it(@"should return initialized instance", ^{
        expect(apiKey.value).to.equal(@"e72e16c7e42f292c6912e7710c838347ae178b4a");
    });
});

SpecEnd
