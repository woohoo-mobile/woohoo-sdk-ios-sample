//
//  ViewController.m
//  WoohooOffersSDK Example
//
//  Created by Manuel Maly on 19.03.14.
//  Copyright (c) 2014 woohoo mobile marketing GmbH. All rights reserved.
//

#import "ViewController.h"
#import "WoohooSDK.h"
#import "WOOOffersController.h"
#import "UIView+WOOAdditions.h"


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
    [self.startSDKButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.startSDKButton.backgroundColor = UIColor.whiteColor;
    self.startSDKButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.startSDKButton.layer.borderWidth = 2.f;
    [self.startSDKButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    NSString *secret = @"ZxvODOFezGTfZ6hQEdqbZIQlmSGVP7WoZxiZVIMafEUl7SasQ+eQgPrCYVN+1cviM7mCjugbOW7b53vvzTpJuA==";
    NSString *APIKey = @"paTnIrCQbPcjTg==";
    self.woohooSDK = [[WoohooSDK alloc] initWithAPIKey:APIKey APISecret:secret sandboxMode:YES success:^(BOOL available) {
        NSLog(available ? @"Success Callback: Yes" : @"Success Callback: No");
        if(available){
            [self.startSDKButton setTitle:@"Start Woohoo SDK" forState:UIControlStateNormal];
            [self.startSDKButton addTarget:self action:@selector(onStartSDKButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.startSDKButton];

        }
        else {
            [self.startSDKButton setTitle:@"Offers n/a in your Region" forState:UIControlStateNormal];
            [self.view addSubview:self.startSDKButton];
        }
        
    } failure:^(NSError *err) {
        NSLog(@"Failure Callback");
        [self.startSDKButton setTitle:@"Offer availability check failed!" forState:UIControlStateNormal];
        [self.view addSubview:self.startSDKButton];
    }];

    self.woohooSDK.virtualCurrencyName = @"Tokens";
    self.woohooSDK.balance = 10000;
    
    self.balanceLabel = UILabel.new;
    self.balanceLabel.text = @"Set Virtual Balance:";
    self.balanceTextField = UITextField.new;
    self.balanceTextField.textAlignment = NSTextAlignmentCenter;
    self.balanceTextField.backgroundColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [self.view addGestureRecognizer:tgr];
    
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
