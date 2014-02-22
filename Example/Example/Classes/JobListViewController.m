//
//  JobListViewController.m
//  Example
//
//  Created by Kenichi Yonekawa on 2014/02/21.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "JobListViewController.h"
#import <Mantle/EXTScope.h>
#import <TreasureData/TreasureData.h>
#import "JobListViewCell.h"

@implementation JobListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.splitViewController.delegate = self;

    @weakify(self);
    [RACObserve(self, jobs) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.jobs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"JobListViewCell";
    JobListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    cell.job = self.jobs[indexPath.row];
    return cell;
}

#pragma mark - UISplitViewController delegates

- (BOOL)splitViewController:(UISplitViewController*)splitViewController
   shouldHideViewController:(UIViewController *)viewController
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

@end
