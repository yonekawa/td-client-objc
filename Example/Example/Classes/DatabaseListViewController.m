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
    TRDDatabase *database = self.databases[indexPath.row];

    @weakify(self);
    [[[[TRDClientManager sharedManager].client fetchJobsWithDatabase:database.name] collect]
      subscribeNext:^(NSArray *jobs) {
          @strongify(self)
          [self performSegueWithIdentifier:@"ShowJobsInDatabase" sender:self];
      } error:^(NSError *error) {
          @strongify(self)
          [self showError:error];
      }
    ];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TRDDatabase *database = self.databases[self.tableView.indexPathForSelectedRow.row];

    [[[[TRDClientManager sharedManager].client fetchJobsWithDatabase:database.name] collect]
     subscribeNext:^(NSArray *jobs) {
         JobListViewController *jobListViewController = segue.destinationViewController;
         jobListViewController.jobs = jobs;
         jobListViewController.navigationItem.title = database.name;
     }];
}

@end
