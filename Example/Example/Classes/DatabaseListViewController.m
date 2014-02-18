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

@interface DatabaseListViewController ()
@property(strong) NSArray *databases;
@property(nonatomic, strong) IBOutlet UITableView *databaseListView;
@end

@implementation DatabaseListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    @weakify(self);
    [[[[TRDClientManager sharedManager].client fetchDatabases] collect] subscribeNext:^(NSArray *databases) {
        @strongify(self);
        self.databases = databases;
        [self.databaseListView reloadData];
    } error:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:error.description
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }];
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

@end
