//
//  JobListViewCell.m
//  Example
//
//  Created by Kenichi Yonekawa on 2014/02/22.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "JobListViewCell.h"

@implementation JobListViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    self.statusLabel.text = @"";
    self.queryLabel.text = @"";
}

- (void)setJob:(TRDJob *)job
{
    if (_job == job) {
        return;
    }
    _job = job;

    self.queryLabel.text = job.query;
    [self setStatus:job.status];
}

- (void)setStatus:(TRDJobStatus)status
{
    switch (status) {
        case TRDJobStatusSuccess:
            self.statusLabel.text = @"success";
            self.statusLabel.backgroundColor = [UIColor greenColor];
            break;
        case TRDJobStatusError:
            self.statusLabel.text = @"error";
            self.statusLabel.backgroundColor = [UIColor redColor];
            break;
        case TRDJobStatusBooting:
            self.statusLabel.text = @"booting";
            self.statusLabel.backgroundColor = [UIColor lightGrayColor];
            break;
        case TRDJobStatusQueued:
            self.statusLabel.text = @"queued";
            self.statusLabel.backgroundColor = [UIColor lightGrayColor];
            break;
        default:
            self.statusLabel.text = @"running";
            self.statusLabel.backgroundColor = [UIColor orangeColor];
            break;
    }
}

@end
