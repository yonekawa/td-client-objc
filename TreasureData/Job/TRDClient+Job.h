//
//  TRDClient+Job.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "TRDClient.h"
#import "TRDJob.h"

typedef NS_ENUM(NSUInteger, TRDJobResultFormat) {
    TRDJobResultFormatTsv,
    TRDJobResultFormatCsv,
    TRDJobResultFormatJson,
    TRDJobResultFormatMessagePack,
    TRDJobResultFormatMessagePackGzip
};

@interface TRDClient (Job)
- (RACSignal *)fetchAllJobs;
- (RACSignal *)fetchJobsWithDatabase:(NSString *)database;
- (RACSignal *)fetchJobWithJobID:(NSUInteger)jobID;
- (RACSignal *)fetchJobStatusWithJobID:(NSUInteger)jobID;
- (RACSignal *)createNewJobWithQuery:(NSString *)query database:(NSString *)database;
- (RACSignal *)createNewJobWithQuery:(NSString *)query database:(NSString *)database priority:(TRDJobPriority)priority;
- (RACSignal *)killJobWithJobID:(NSUInteger)jobID;
- (RACSignal *)downloadJobResultWithJobID:(NSUInteger)jobID format:(TRDJobResultFormat)format;
@end
