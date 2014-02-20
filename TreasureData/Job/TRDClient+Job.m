//
//  TRDClient+Job.m
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient+Job.h"
#import "TRDJob.h"

@implementation TRDClient (Job)

- (RACSignal *)fetchAllJobs
{
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:@"/v3/job/list"
                                         parameters:@{@"from": @0}
                                     withAuthHeader:YES];
    return [self enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
        NSArray *jobs = responseObject[@"jobs"];
        for (NSDictionary *jobObject in jobs) {
            TRDJob *job = [MTLJSONAdapter modelOfClass:[TRDJob class] fromJSONDictionary:jobObject error:NULL];
            [subscriber sendNext:job];
        }
    }];
}

@end
