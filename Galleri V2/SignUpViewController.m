//
//  SignUpViewController.m
//  Galleri V2
//
//  Created by Mukul Surajiwale on 8/25/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

// Properties
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

// Actions
- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)selectProfilePictureButtonPressed:(UIButton *)sender;

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.hidden = YES;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonPressed:(UIButton *)sender {
}

- (IBAction)selectProfilePictureButtonPressed:(UIButton *)sender {
}
@end
