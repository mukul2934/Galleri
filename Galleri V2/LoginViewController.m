//
//  LoginViewController.m
//  Galleri V2
//
//  Created by Mukul Surajiwale on 8/25/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "LoginViewController.h"
#import "CameraViewController.h"

@interface LoginViewController ()

#pragma Properties
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

#pragma Actions
- (IBAction)loginButtonPressed:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginButton.hidden = YES;
    self.activityIndicator.hidden = YES;
    
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(showLoginButton:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginButton:(NSTimer *) t {
    if ([self.usernameTextField.text length] > 1 && [self.passwordTextField.text length] >= 5) {
        self.loginButton.hidden = NO;
    } else {
        self.loginButton.hidden = YES;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginToCamera"]) {
        CameraViewController *cameraView = [segue destinationViewController];
    }
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Login Successful");
            [self.activityIndicator stopAnimating];
            [self performSegueWithIdentifier:@"loginToCamera" sender:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username/Password is invalid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.passwordTextField resignFirstResponder];
        }
    }];
}
@end
