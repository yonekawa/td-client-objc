//
//  TRDClient+Job.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"
#import "TRDJob.h"

@interface TRDClient (Job)
- (RACSignal *)fetchAllJobs;
- (RACSignal *)fetchJobsWithDatabase:(NSString *)database;
- (RACSignal *)fetchJobWithJobID:(NSUInteger)jobID;
- (RACSignal *)fetchJobStatusWithJobID:(NSUInteger)jobID;
- (RACSignal *)createNewJobWithQuery:(NSString *)query database:(NSString *)database;
- (RACSignal *)createNewJobWithQuery:(NSString *)query database:(NSString *)database priority:(TRDJobPriority)priority;
- (RACSignal *)killJobWithJobID:(NSUInteger)jobID;
@end
