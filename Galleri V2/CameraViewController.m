//
//  CameraViewController.m
//  Galleri
//
//  Created by Mukul Surajiwale on 6/16/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()

#pragma - View Outlets
@property (strong, nonatomic) IBOutlet UIView *frameForCapture;
@property (strong, nonatomic) IBOutlet UILabel *albumLabel;
@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *picUploadActivitySpinner;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *cameraMenuView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *largeImagePreviewContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *largeImageView;

#pragma - Actions
- (IBAction)takePhotoButtonPressed:(UIButton *)sender;
- (IBAction)swipeGestureShowMenue:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeGestureHideMenue:(UISwipeGestureRecognizer *)sender;
- (IBAction)previewImageButtonPressed:(UIButton *)sender;

#pragma - Properties
@property (strong, nonatomic) NSMutableArray *albums;
@property (strong, nonatomic) PFObject *currentAlbum;
@property (nonatomic) int albumIndex;
@property (nonatomic) int previewImageCounter;



@end

@implementation CameraViewController

AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.largeImagePreviewContainerView.hidden = YES;
    self.cameraMenuView.hidden = YES;
    self.picUploadActivitySpinner.hidden = YES;
    self.albumIndex = 0;
    
    // Query for all albums associated with current user
    PFQuery *query = [PFQuery queryWithClassName:@"Album"];
    [query whereKey:@"Owner" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            self.albums = [objects mutableCopy];
            self.currentAlbum = self.albums[0];
            self.albumLabel.text = self.currentAlbum[@"Name"];
            NSLog(@"Album Count: %lu", [self.albums count]);
            NSLog(@"%@", self.albums);
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    } else {
        NSLog(@"Error: CameraViewController, line 41, Cannot add deviceInput");
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *cameraLayer = self.frameForCapture.layer;
    [cameraLayer setMasksToBounds:YES];
    [previewLayer setFrame:[cameraLayer bounds]];
    [cameraLayer addSublayer:previewLayer];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    [session startRunning];

}

- (void)viewDidAppear:(BOOL)animated {
    self.largeImagePreviewContainerView.hidden = YES;
    self.previewImageCounter = 0;
    [self.albumLabel setText:self.currentAlbum[@"Name"]];
    [self.albumLabel performSelector:@selector(setText:) withObject:@"" afterDelay:0.5];
}


- (IBAction)takePhotoButtonPressed:(UIButton *)sender {
    self.picUploadActivitySpinner.hidden = NO;
    [self.picUploadActivitySpinner startAnimating];
    
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != nil) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            PFFile *imageFile = [PFFile fileWithData:imageData];
            
            PFObject *image = [PFObject objectWithClassName:@"Photo"];
            [image setObject:imageFile forKey:@"ImageFile"];
            [image setObject:[PFUser currentUser] forKey:@"Owner"];
            [image setObject:self.currentAlbum forKey:@"Album"];
            [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.previewImageView.image = [UIImage imageWithData:imageData];
                    self.largeImageView.image = [UIImage imageWithData:imageData];
                    
                    [self.picUploadActivitySpinner stopAnimating];
                    self.picUploadActivitySpinner.hidden = YES;
                    NSLog(@"Image saved to %@ album", self.currentAlbum[@"Name"]);
                } else {
                    UIAlertView *saveFailedAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Image failed to save. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [saveFailedAlert show];
                }
            }];
        }
    }];

}

- (IBAction)swipeGestureShowMenue:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Show Menu");
    self.cameraMenuView.hidden = NO;
}

- (IBAction)swipeGestureHideMenue:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Hide Menu");
    self.cameraMenuView.hidden = YES;
}

- (IBAction)previewImageButtonPressed:(UIButton *)sender {
    if (self.previewImageCounter % 2 == 0) {
        self.largeImagePreviewContainerView.hidden = NO;
        self.previewImageCounter++;
    } else {
        self.largeImagePreviewContainerView.hidden = YES;
        self.previewImageCounter++;
    }
}
@end
