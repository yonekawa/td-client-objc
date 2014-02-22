//
//  LoginViewController.m
//  Example
//
//  Created by Kenichi Yonekawa on 2014/02/18.
//  Copyright (c) 2014 MogMog Developer. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <TreasureData/TreasureData.h>
#import <Mantle/EXTScope.h>
#import "TRDClientManager.h"

@interface LoginViewController ()
@property(nonatomic, strong) IBOutlet UITextField *emailFiedld;
@property(nonatomic, strong) IBOutlet UITextField *passwordFiedld;
@property(nonatomic, strong) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    @weakify(self)

    RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[TRDClient authenticateWithUsername:self.emailFiedld.text
                                           password:self.passwordFiedld.text] materialize];
    }];

    [loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        @strongify(self);

        [self.emailFiedld resignFirstResponder];
        [self.passwordFiedld resignFirstResponder];

        RACSignal *signal = [loginSignal dematerialize];
        [signal subscribeNext:^(TRDClient *client) {
            [TRDClientManager sharedManager].client = client;
            [self performSegueWithIdentifier:@"Login" sender:self];
        } error:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                       message:error.description
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil] show];
        }];
    }];
    self.loginButton.rac_command = loginCommand;
}

@end
