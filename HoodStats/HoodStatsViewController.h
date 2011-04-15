//
//  HoodStatsViewController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "BaseController.h"

@interface HoodStatsViewController : BaseController <UIAccelerometerDelegate, CLLocationManagerDelegate> {
    
    UIImageView *loadingImage;
    UIImageView *scanningImage;
    
    NSMutableArray *data;
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *previewLayer;
	NSArray *overlayGraphicViews;
    CLLocationManager *locationManager;
    
	CLLocation *currentLocation;   
    
    CLLocationDirection magCompassHeadingInDeg;
    double angle; //rad
    double angleInDeg;
    double vertAngle; //rad
    double vertAngleInDeg;
    
}

@property(nonatomic, retain)CLLocation *currentLocation;
@property(nonatomic, retain)AVCaptureSession *captureSession;
@property(nonatomic, retain)AVCaptureVideoPreviewLayer *previewLayer;

-(void)addLoadingLayer;
-(void)animateScanner;
-(void)loadInfoScreen;
-(void)addButtons;
-(void)takePhoto;

@end
