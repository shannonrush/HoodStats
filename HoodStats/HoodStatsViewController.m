//
//  HoodStatsViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "HoodStatsViewController.h"
#import "InfoViewController.h"
#import "HoodStatsAppDelegate.h"

@implementation HoodStatsViewController

@synthesize currentLocation, captureSession, previewLayer, captureOutput, orientation, screenshotImage;

-(void)viewDidLoad {
    [super viewDidLoad];
    if (!dataRetrieved) {
        if (![HoodStatsAppDelegate imageDictionary]) 
            [self performSelectorInBackground:@selector(initImages) withObject:nil];
        
        data = [[NSMutableArray alloc]init];
        [self initVideo];
        [self addLoadingLayer];
        bubbleViews = [[NSMutableArray alloc]init];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!dataRetrieved) {
        if (!locationManager) 
            locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager setDelegate:self];
        [locationManager startUpdatingLocation];
        [[self captureSession] startRunning];
    }
}


-(void)initVideo {
    // device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
		NSError *error = nil;
		if ([device lockForConfiguration:&error]) {
			device.flashMode					= AVCaptureFlashModeAuto;
			[device unlockForConfiguration];
		}
	}	
    
    // device input
    NSError *error;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    // device output
    captureOutput = [[AVCaptureStillImageOutput alloc] init];
	NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
	[captureOutput setOutputSettings:outputSettings];
	
    // capture session
    captureSession = [[AVCaptureSession alloc] init];
    captureSession.sessionPreset = AVCaptureSessionPreset640x480;

    // add input and output
    [captureSession addInput:captureInput];
    [captureSession addOutput:captureOutput];

    CALayer *layer = [self.view layer];
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    CGRect frame = [layer frame];
    frame.origin.x = frame.origin.y = 0;
    [previewLayer setFrame:frame];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [layer addSublayer:previewLayer];
    [captureSession startRunning];
    
}

-(void)addLoadingLayer {
    scanningImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scanning.png"]];
    scanningImage.frame = CGRectMake(18, 80, 286, 2);
    [[self view] addSubview:scanningImage];
    loadingImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];
    [[self view] addSubview:loadingImage];
    [self animateScanner];
}

-(void)animateScanner {
    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
        CGRect newFrame = scanningImage.frame;
        newFrame.origin.y += 350.0;
        scanningImage.frame = newFrame;
    } completion:^ (BOOL finished) {
        [scanningImage removeFromSuperview];
        [loadingImage removeFromSuperview];
        while ([data count]==0) {
            NSLog(@"wait now");
        }
        [self performSelector:@selector(setupUI) withObject:nil afterDelay:0.01];
        [self performSelector:@selector(addButtons) withObject:nil afterDelay:0.01];}
     ];
}

-(void)addButtons {
    UIImage *infoImage = [UIImage imageNamed:@"info.png"];
    infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton setBackgroundImage:infoImage forState:UIControlStateNormal];
    infoButton.frame = CGRectMake(265, 395, 45, 45);
    [infoButton addTarget:self action:@selector(loadInfoScreen) forControlEvents:UIControlEventTouchUpInside];
    infoButton.tag = 1;
    [self.view addSubview:infoButton];
    
    UIImage *cameraImage = [UIImage imageNamed:@"camera.png"];
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setBackgroundImage:cameraImage forState:UIControlStateNormal];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera_highlight.png"] forState:UIControlStateHighlighted];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera_highlight.png"] forState:UIControlStateSelected];
    cameraButton.frame = CGRectMake(15, 395, 45, 45);
    [cameraButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.tag = 1;
    [self.view addSubview:cameraButton];
    
    cameraActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    cameraActivity.center = cameraButton.center;
    cameraActivity.hidesWhenStopped = YES;
    cameraActivity.tag = 1;
    [self.view addSubview:cameraActivity];
    
}

-(void)setupUI {
    [self addOverlay];
    if ([bubbleViews count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Problem" message:@"We couldn't get information about your location.  Please check your connection and try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        motionManager = [[CMMotionManager alloc] init];
        motionManager.deviceMotionUpdateInterval = 0.1; 
        motionQueue = [[NSOperationQueue mainQueue] retain];
        CMDeviceMotionHandler motionHandler = ^ (CMDeviceMotion *motion, NSError *error) {
            [self processMotion:motion withError:error];
        };
        
        [motionManager startDeviceMotionUpdatesToQueue:motionQueue withHandler:motionHandler];
    }
}

-(void)processMotion:(CMDeviceMotion *)motion withError:(NSError *)error {
    if (!referenceAttitude) {
        referenceAttitude = [motionManager.deviceMotion.attitude retain];
    }
    CMAttitude *currentAttitude = motion.attitude;
    [currentAttitude multiplyByInverseOfAttitude:referenceAttitude];
    for (UIView *view in bubbleViews) {
        view.transform = CGAffineTransformMakeRotation(currentAttitude.yaw);
        CGPoint viewCenter = view.center;
        viewCenter.x += currentAttitude.roll * 10;
        view.center = viewCenter;
    }
}

- (void)addOverlay {
    for (NSDictionary *stat in data) {
        if ([[stat allKeys]containsObject:@"label"]&&[[stat allKeys]containsObject:@"value"]) {
            UILabel *markerLabel = [[UILabel alloc] initWithFrame:CGRectMake(250*([data indexOfObject:stat]-1)+50, 200, 220, 55)];
            markerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble.png"]];
            [markerLabel setOpaque:NO];
            markerLabel.adjustsFontSizeToFitWidth = YES;
            markerLabel.textAlignment = UITextAlignmentCenter;
            markerLabel.textColor = [UIColor whiteColor]; 
            markerLabel.font = [UIFont fontWithName:@"Verdana" size:34.0f];
            markerLabel.text = [NSString stringWithFormat:@"  %@: %@  ",[stat objectForKey:@"label"],[stat objectForKey:@"value"]];
            [bubbleViews addObject:markerLabel];
            [self.view addSubview:markerLabel];
            [markerLabel release];
        } else if ([[stat allKeys]containsObject:@"city"]) {
            cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 100, 100)];
            cityLabel.backgroundColor = [UIColor clearColor];
            cityLabel.textColor = [HoodStatsAppDelegate popColor]; 
            cityLabel.adjustsFontSizeToFitWidth = YES;
            cityLabel.textAlignment = UITextAlignmentCenter;
            cityLabel.font = [UIFont fontWithName:@"Bellerose" size:60.0f];
            cityLabel.text = [stat objectForKey:@"city"];
            [bubbleViews addObject:cityLabel];
            [self.view addSubview:cityLabel];
        }
    }
}


-(void)loadInfoScreen {
    InfoViewController *info = [[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:[NSBundle mainBundle]];
    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:info animated:YES];
    [info release];
}

-(void)takePhoto {
    [cameraActivity startAnimating];
    NSLog(@"showing camera activity");
    cameraActivity.hidden = NO;
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[self.captureOutput connections]];
    if ([videoConnection isVideoOrientationSupported]) 
		[videoConnection setVideoOrientation:[[UIDevice currentDevice] orientation]]; 

    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection
															   completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer != NULL) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             UIImage *image = [[UIImage alloc] initWithData:imageData];

             CGSize imageSize = [[UIScreen mainScreen] bounds].size;
             UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
             
             CGContextRef context = UIGraphicsGetCurrentContext();
             UIGraphicsPushContext(context);
             [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
             UIGraphicsPopContext();
             
             for (UIView *view in [self.view subviews]) {
                 if (view.tag != 1) 
                     [self renderView:view inContext:context];
             }
             
             UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
             self.screenshotImage = screenshot;
                          
             UIGraphicsEndImageContext();
             
             UIImageView *screenshotView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 57, 240, 345)];
             screenshotView.image = screenshot;
             [self.view addSubview:screenshotView];
             [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationCurveLinear animations:^{
                 screenshotView.frame = CGRectMake(260, 225, 40, 57);
             }completion:^(BOOL finished) {
                 [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveLinear animations:^{
                     screenshotView.frame = CGRectMake(infoButton.center.x, infoButton.center.y, 0, 0);
                 } completion:^(BOOL finished) {
                     [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
                     [cameraActivity stopAnimating];
                 }];
             }];

             [self savePhoto:screenshotImage];
             
             ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
             
             [library writeImageToSavedPhotosAlbum:[screenshot CGImage]
                                       orientation:ALAssetOrientationUp
                                   completionBlock:^(NSURL *assetURL, NSError *error){
                  if (error) {
                      if ([self respondsToSelector:@selector(captureStillImageFailedWithError:)]) 
                          [self captureStillImageFailedWithError:error];
                  }
              }];
             
             [library release];
             
             [image release];
         } 
         else if (error) {
             NSLog(@"Oops!");
             if ([self respondsToSelector:@selector(captureStillImageFailedWithError:)]) 
                 [self captureStillImageFailedWithError:error];
        }
     }];
}

- (void)renderView:(UIView*)view inContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    CGContextConcatCTM(context, [view transform]);
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);
    [[view layer] renderInContext:context];
    CGContextRestoreGState(context);
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
	for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:mediaType] ) 
				return [[connection retain] autorelease];
		}
	}
	return nil;
}

#pragma mark -
#pragma mark Error Handling Methods

- (void) captureStillImageFailedWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Still Image Capture Failure"
															 message:[error localizedDescription]
															delegate:nil
												   cancelButtonTitle:@"Okay"
												   otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}



- (void) cannotWriteToAssetLibrary {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incompatible with Asset Library"
															 message:@"The captured file cannot be written to the library."
															delegate:nil
												   cancelButtonTitle:@"Okay"
												   otherButtonTitles:nil];
    [alertView show];
    [alertView release];        
}


#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval age = [newLocation.timestamp timeIntervalSinceNow];
    if(abs(age) < 60.0 && !dataRetrieved) {
        NSLog(@"updated");
        [self setCurrentLocation:newLocation];
        [data setArray:[self getData:newLocation]];
        dataRetrieved = YES;
    }
}

#pragma mark memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [locationManager stopUpdatingHeading]; 
	[locationManager stopUpdatingLocation]; 
	[locationManager setDelegate:nil];
    
	[captureSession release];
    [captureOutput release];
	[previewLayer release];
    [currentLocation release]; 
    [locationManager release]; 
    
    [bubbleViews release];
    
    [super dealloc];
}

@end
