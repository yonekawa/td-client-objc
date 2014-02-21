//
//  TRDJob.h
//  TreasureData
//
//  Created by Kenichi Yonekawa on 2014/02/20.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSUInteger, TRDJobStatus) {
    TRDJobStatusQueued,
    TRDJobStatusBooting,
    TRDJobStatusRunning,
    TRDJobStatusSuccess,
    TRDJobStatusError
};

typedef NS_ENUM(NSUInteger, TRDJobPriority) {
    TRDJobPriorityNormal = 0,
    TRDJobPriorityVeryLow = -2,
    TRDJobPriorityLow = -1,
    TRDJobPriorityHigh = 1,
    TRDJobPriorityVeryHigh = 2
};

typedef NS_ENUM(NSUInteger, TRDJobType) {
    TRDJobTypeHive
};

@interface TRDJob : MTLModel <MTLJSONSerializing>
@property(readonly) NSUInteger jobID;
@property(readonly) TRDJobStatus status;
@property(readonly) TRDJobPriority priority;
@property(readonly) TRDJobType type;
@property(readonly) NSDate *createdAt;
@property(readonly) NSDate *updatedAt;
@property(readonly) NSDate *startAt;
@property(readonly) NSDate *endAt;
@property(readonly) NSString *query;
@property(readonly) NSUInteger retryLimit;
@property(readonly) NSString *userName;
@property(readonly) NSString *database;
@property(readonly) NSString *url;
@property(readonly) NSString *result;
@property(readonly) NSString *debugSTDERR;
@property(readonly) NSString *debugCMDOUT;
@end
