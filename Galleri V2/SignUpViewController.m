//
//  SignUpViewController.m
//  Galleri V2
//
//  Created by Mukul Surajiwale on 8/25/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "SignUpViewController.h"
#import "CameraViewController.h"
@interface SignUpViewController ()

// Properties
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Actions
- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)selectProfilePictureButtonPressed:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)showLoginButton:(NSTimer *) t {
    if ([self.passwordTextField.text length] >= 5 && [self.usernameTextField.text length] > 1) {
        self.loginButton.hidden = NO;
    } else {
        self.loginButton.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.hidden = YES;
    self.activityIndicator.hidden = YES;
    // Create a timer to check when to show the login button
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(showLoginButton:) userInfo:nil repeats:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signupToCamera"]) {
        CameraViewController *cameraView = [segue destinationViewController];
    }
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    [user signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (success) {
            // Link profile image with user
            NSData *imageData = UIImagePNGRepresentation(self.profileImageView.image);
            PFFile *imageFile = [PFFile fileWithData:imageData];
            
            [user setObject:imageFile forKey:@"profileImage"];
            [user saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if (success) {
                    // Create Default Album
                    PFObject *album = [PFObject objectWithClassName:@"Album"];
                    [album setObject:[PFUser currentUser] forKey:@"Owner"];
                    [album setObject:@"Camera Role" forKey:@"Name"];
                    [album setObject:@"NO" forKey:@"Shared"];
                    [album saveInBackgroundWithBlock:^(BOOL sucess, NSError *error) {
                        if (success) {
                            PFQuery *query = [PFQuery queryWithClassName:@"Album"];
                            [query whereKey:@"Owner" equalTo:[PFUser currentUser]];
                            [query whereKey:@"Name" equalTo:@"Camera Role"];
                            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                if (object) {
                                    PFObject *album = object;
                                    PFObject *albumUserLink = [PFObject objectWithClassName:@"User_Album"];
                                    [albumUserLink setObject:[PFUser currentUser] forKey:@"User"];
                                    [albumUserLink setObject:album forKey:@"Album"];
                                    [albumUserLink saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (succeeded) {
                                            NSLog(@"LOGIN SUCCESSFUL");
                                            [self.activityIndicator stopAnimating];
                                            [self performSegueWithIdentifier:@"signupToCamera" sender:nil];
                                        } else {
                                            NSLog(@"Failed to save User <-> Album link");
                                        }
                                    }];
                                } else {
                                    NSLog(@"Failed to retrive album");
                                }
                            }];
                        } else {
                             NSLog(@"%@", error);
                        }
                    }];
                } else {
                     NSLog(@"%@", error);
                }
            }];
        } else {
             NSLog(@"%@", error);
        }
    }];
    
}

- (IBAction)selectProfilePictureButtonPressed:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma UIImagePickerController Delagate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = chosenImage;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 55;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
