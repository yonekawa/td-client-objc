//
//  DatabaseListViewController.m
//  Example
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "DatabaseListViewController.h"
#import <Mantle/EXTScope.h>
#import <TreasureData/TreasureData.h>
#import "TRDClientManager.h"
#import "JobListViewController.h"

@implementation DatabaseListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    @weakify(self);
    [RACObserve(self, databases) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];

    [[[[TRDClientManager sharedManager].client fetchAllDatabases] collect]
      subscribeNext:^(NSArray *databases) {
          @strongify(self);
          self.databases = databases;
      } error:^(NSError *error) {
          @strongify(self);
          [self showError:error];
      }
    ];
}

- (RACSignal *)fetchJobsWithDatabase:(TRDDatabase *)database
{
    return [[[TRDClientManager sharedManager].client fetchJobsWithDatabase:database.name] collect];
}

- (void)showError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:error.description
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.databases count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DatabaseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = ((TRDDatabase *)self.databases[indexPath.row]).name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        @weakify(self);
        TRDDatabase *database = self.databases[indexPath.row];
        [[self fetchJobsWithDatabase:database] subscribeNext:^(NSArray *jobs) {
            @strongify(self)
            JobListViewController *jobListViewController = [self.splitViewController.viewControllers lastObject];
            jobListViewController.jobs = jobs;
        }];
    } else {
        [self performSegueWithIdentifier:@"ShowJobsInDatabase" sender:self];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TRDDatabase *database = self.databases[self.tableView.indexPathForSelectedRow.row];
    [[self fetchJobsWithDatabase:database] subscribeNext:^(NSArray *jobs) {
        JobListViewController *jobListViewController = segue.destinationViewController;
        jobListViewController.jobs = jobs;
        jobListViewController.navigationItem.title = database.name;
    }];
}

@end
