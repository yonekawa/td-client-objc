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
#import "AppDelegate.h"
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
        self.loginButton.enabled = NO;

        RACSignal *signal = [loginSignal dematerialize];
        [signal subscribeNext:^(TRDClient *client) {
            [TRDClientManager sharedManager].client = client;
            [self loggedIn];
        } error:^(NSError *error) {
            self.loginButton.enabled = YES;
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                       message:error.description
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil] show];
        }];
    }];
    self.loginButton.rac_command = loginCommand;
}

- (void)loggedIn
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScene"];
    } else {
        [self performSegueWithIdentifier:@"Login" sender:self];
    }
}

@end
