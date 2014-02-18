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
	// Do any additional setup after loading the view, typically from a nib.

    __weak typeof(self) wSelf = self;
    RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[TRDClient authenticateWithUsername:wSelf.emailFiedld.text password:wSelf.passwordFiedld.text] materialize];
    }];
    [loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        RACSignal *signal = [loginSignal dematerialize];
        [signal subscribeNext:^(TRDClient *client) {
            [TRDClientManager sharedManager].client = client;
            UINavigationController *mainViewController =
                [self.storyboard instantiateViewControllerWithIdentifier:@"MainScene"];
            [self presentViewController:mainViewController animated:YES completion:nil];
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
