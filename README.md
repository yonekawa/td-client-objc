# Treasure Data Client for Objective-C

[![Build Status](https://travis-ci.org/yonekawa/td-client-objc.png?branch=master)](https://travis-ci.org/yonekawa/td-client-objc)

Objective-C Client Library for [Treasure Data REST API](http://docs.treasuredata.com/articles/rest-api), built using [AFNetworking](https://github.com/AFNetworking/AFNetworking), [Mantle](https://github.com/MantleFramework/Mantle), and [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa).

## Install

### Installation with CocoaPods

#### Podfile

    platform :ios, '7.0'
    pod "TreasureData", "~> 0.1.0"

## Usage

Each request method on `TRDClient` returns a [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) signal.

### Authenticate

Treasure Data REST API uses API key for authentication key. See  [API document](http://docs.treasuredata.com/articles/rest-api#authorization).

You can create a client with api key directly.

    TRDApiKey *apiKey = [TRDApiKey apiKeyWithValue:@"TD_API_KEY"];
    TRDClient *client = [[TRDClient alloc] initWithApiKey:apiKey];

If you want to authenticate with email & password, `authenticateWithUsername:password` can be used.

    [[TRDCLient authenticateWithUsername:@"email" password:@"pass"] subscribeNext:^(TRDClient *client) {
        NSLog("apiKey: %@" client.apiKey.value);
    }];

### Receiving result

#### one-by-one

It often makes sense to handle each result object independently, so you can spread any processing out instead of doing it all at once:

    RACSingal *request = [cleint fetchAllDatabases];
    [request subscribeNext:^(TRDDatabaes *database) {
        // This block is invoked for _each_ result received, so you can deal with
        // them one-by-one as they arrive.
    } error:^(NSError *error) {
        // Invoked when an error occurs.
        //
        // Your `next` and `completed` blocks won't be invoked after this point.
    } completed:^{
        // Invoked when the request completes and we've received/processed all the
        // results.
        //
        // Your `next` and `error` blocks won't be invoked after this point.
    }];

#### all result at once

If you can't do anything until you have all of the results, you can `collect` them into a single array:

    RACSingal *request = [cleint fetchAllDatabases];
    [[request collect] subscribeNext:^(NSArray *databases) {
        // Thanks to -collect, this block is invoked after the request completes,
        // with _all_ the results that were received.
    } error:^(NSError *error) {
        // Invoked when an error occurs. You won't receive any results if this
        // happens.
    }];

## License

MIT license.
