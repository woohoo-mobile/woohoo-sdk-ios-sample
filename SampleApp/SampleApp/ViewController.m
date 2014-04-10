//
//  ViewController.m
//  WoohooOffersSDK Example
//
//  Created by Manuel Maly on 19.03.14.
//  Copyright (c) 2014 woohoo mobile marketing GmbH. All rights reserved.
//

#import "ViewController.h"
#import "WoohooSDK.h"


@interface ViewController () <WOOOffersControllerDelegate>

@property (strong, nonatomic) UIButton *startSDKButton;
@property (strong, nonatomic) UITextField *balanceTextField;
@property (strong, nonatomic) UILabel *balanceLabel;
@property (strong, nonatomic) WoohooSDK *woohooSDK;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.startSDKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startSDKButton setTitle:@"Start Woohoo SDK" forState:UIControlStateNormal];
    [self.startSDKButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.startSDKButton.backgroundColor = UIColor.whiteColor;
    self.startSDKButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.startSDKButton.layer.borderWidth = 2.f;
    [self.startSDKButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.startSDKButton addTarget:self action:@selector(onStartSDKButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *secret = @"b3GytUrWLj0YGim37WgW4+22qld/xEkFzVJSxYR1EDpIV1Uq/SyO73185OhWOMyr7LV+3xITnHDzUj4zL1h7Jw==";
    NSString *APIKey = @"3Xu4IpvloXrbmQ==";
    self.woohooSDK = [[WoohooSDK alloc] initWithAPIKey:APIKey APISecret:secret sandboxMode:YES];
    self.woohooSDK.balance = 100000;
    
    self.balanceLabel = UILabel.new;
    self.balanceLabel.text = @"Set Virtual Balance:";
    self.balanceTextField = UITextField.new;
    self.balanceTextField.textAlignment = NSTextAlignmentCenter;
    self.balanceTextField.backgroundColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [self.view addGestureRecognizer:tgr];
    
    [self.view addSubview:self.startSDKButton];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.balanceTextField];
}

- (void)backgroundTapped {
    [self.view woosdk_findAndResignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.balanceTextField.text = [NSString stringWithFormat:@"%d", self.woohooSDK.balance];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.startSDKButton sizeToFit];
    self.startSDKButton.frame = CGRectInset(self.startSDKButton.frame, -10, -5);
    self.startSDKButton.center = CGPointMake(self.view.center.x, 130.f);
    
    self.balanceLabel.frame = CGRectOffset(self.startSDKButton.frame, 0, CGRectGetHeight(self.startSDKButton.frame) + 20.f);
    self.balanceTextField.frame = CGRectOffset(self.balanceLabel.frame, 0, CGRectGetHeight(self.balanceLabel.frame));
}

- (void)onStartSDKButtonTapped {
    NSInteger userDefinedBalance = [self.balanceTextField.text integerValue];
    BOOL intValid = !(userDefinedBalance == 0 && self.balanceTextField.text.length > 0);
    
    if (intValid) {
        self.woohooSDK.balance = userDefinedBalance;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid integer" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self presentViewController:[self.woohooSDK offersControllerWithDelegate:self] animated:YES completion:NULL];
}

#pragma mark - WOOSDKControllerDelegate

- (void)woosdk_controllerDidFinish:(WOOOffersController *)controller {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
