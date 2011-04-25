//
//  HoodStatsViewController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//
#import "BaseController.h"


@interface HoodStatsViewController : BaseController <UIAccelerometerDelegate, CLLocationManagerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    UIImageView *loadingImage;
    UIImageView *scanningImage;

    NSMutableArray *data;
    AVCaptureStillImageOutput *captureOutput;
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
    
    BOOL dataRetrieved;
}

@property(nonatomic, retain)CLLocation *currentLocation;
@property(nonatomic, retain)AVCaptureSession *captureSession;
@property(nonatomic, retain)AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, retain)AVCaptureStillImageOutput *captureOutput;
@property (nonatomic,assign)AVCaptureVideoOrientation	orientation;
@property (nonatomic, retain)UIImage *screenshotImage;

-(void)initVideo;
-(void)addLoadingLayer;
-(void)animateScanner;
-(void)loadInfoScreen;
-(void)addButtons;
-(void)takePhoto;
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
- (void)renderView:(UIView*)view inContext:(CGContextRef)context;
- (void) captureStillImageFailedWithError:(NSError *)error;
- (void) cannotWriteToAssetLibrary;

@end
