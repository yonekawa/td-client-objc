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
    return [self fetchJobsWithDatabase:nil];
}

- (RACSignal *)fetchJobsWithDatabase:(NSString *)database
{
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:@"/v3/job/list"
                                         parameters:@{@"from": @0}
                                     withAuthHeader:YES];
    return [[self enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
        NSArray *jobs = responseObject[@"jobs"];
        for (NSDictionary *jobObject in jobs) {
            TRDJob *job = [MTLJSONAdapter modelOfClass:[TRDJob class] fromJSONDictionary:jobObject error:NULL];
            [subscriber sendNext:job];
        }
    }] filter:^BOOL(TRDJob *job) {
        if (!database) {
            return YES;
        }
        return [database isEqualToString:job.database];
    }];
}

- (RACSignal *)fetchJobWithJobID:(NSUInteger)jobID
{
    NSParameterAssert(jobID);

    NSString *path = [NSString stringWithFormat:@"/v3/job/show/%lu", (unsigned long)jobID];
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:path
                                         parameters:nil
                                     withAuthHeader:YES];
    return [self enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
        TRDJob *job = [MTLJSONAdapter modelOfClass:[TRDJob class] fromJSONDictionary:responseObject error:NULL];
        [subscriber sendNext:job];
    }];
}

- (RACSignal *)fetchJobStatusWithJobID:(NSUInteger)jobID
{
    NSParameterAssert(jobID);

    NSString *path = [NSString stringWithFormat:@"/v3/job/status/%lu", (unsigned long)jobID];
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:path
                                         parameters:nil
                                     withAuthHeader:YES];
    return [self enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
        TRDJob *job = [MTLJSONAdapter modelOfClass:[TRDJob class] fromJSONDictionary:responseObject error:NULL];
        [subscriber sendNext:job];
    }];
}

- (RACSignal *)createNewJobWithQuery:(NSString *)query database:(NSString *)database
{
    return [self createNewJobWithQuery:query database:database priority:TRDJobPriorityNormal];
}

- (RACSignal *)createNewJobWithQuery:(NSString *)query database:(NSString *)database priority:(TRDJobPriority)priority
{
    NSParameterAssert(query);
    NSParameterAssert(database);

    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:[NSString stringWithFormat:@"/v3/job/issue/hive/%@", database]
                                         parameters:@{@"query": query, @"priority": @(priority)}
                                     withAuthHeader:YES];
    return [self enqueueRequest:request parseResultBlock:^(id<RACSubscriber> subscriber, id responseObject) {
        [subscriber sendNext:responseObject[@"job_id"]];
    }];
}

- (RACSignal *)killJobWithJobID:(NSUInteger)jobID
{
    NSParameterAssert(jobID);

    NSString *path = [NSString stringWithFormat:@"/v3/job/kill/%lu", (unsigned long)jobID];
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:path
                                         parameters:nil
                                     withAuthHeader:YES];
    return [self enqueueRequest:request parseResultBlock:nil];
}

- (RACSignal *)downloadJobResultWithJobID:(NSUInteger)jobID format:(TRDJobResultFormat)format
{
    NSParameterAssert(jobID);

    NSString *formatName = nil;
    switch (format) {
        case TRDJobResultFormatCsv:
            formatName = @"csv";
            break;
        case TRDJobResultFormatJson:
            formatName = @"json";
            break;
        case TRDJobResultFormatMessagePack:
            formatName = @"msgpack";
            break;
        case TRDJobResultFormatMessagePackGzip:
            formatName = @"msgpack.gz";
            break;
        default:
            formatName = @"tsv";
            break;
    }
    NSString *path = [NSString stringWithFormat:@"/v3/job/result/%lu", (unsigned long)jobID];
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:path
                                         parameters:@{@"format": formatName}
                                     withAuthHeader:YES];
    return [self enqueueRequest:request serializer:[AFHTTPResponseSerializer serializer] parseResultBlock:nil];
}

@end
