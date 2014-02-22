//
//  JobListViewCell.h
//  Example
//
//  Created by Kenichi Yonekawa on 2014/02/22.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TreasureData/TreasureData.h>

@interface JobListViewCell : UITableViewCell
@property(nonatomic, strong) TRDJob *job;
@property(nonatomic, strong) IBOutlet UILabel *statusLabel;
@property(nonatomic, strong) IBOutlet UILabel *queryLabel;
@end
