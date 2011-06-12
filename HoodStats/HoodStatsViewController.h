//
//  HoodStatsViewController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//
#import "BaseController.h"
#import <CoreMotion/CoreMotion.h>



@interface HoodStatsViewController : BaseController <CLLocationManagerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    UIImageView *loadingImage;
    UIImageView *scanningImage;

    NSMutableArray *data;
    NSMutableArray *bubbleViews;
    UILabel *cityLabel;
    AVCaptureStillImageOutput *captureOutput;
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *previewLayer;
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;
    NSOperationQueue *motionQueue;
    CMAttitude *referenceAttitude;
    
	CLLocation *currentLocation;
    
    CLLocationDirection magCompassHeadingInDeg;
    
    BOOL dataRetrieved;
    
    UIView *firstView;
    UIView *lastView;
    
    
}

@property(nonatomic, retain)CLLocation *currentLocation;
@property(nonatomic, retain)AVCaptureSession *captureSession;
@property(nonatomic, retain)AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, retain)AVCaptureStillImageOutput *captureOutput;
@property (nonatomic,assign)AVCaptureVideoOrientation	orientation;
@property (nonatomic, retain)UIImage *screenshotImage;

-(void)initVideo;
- (void)addOverlay;
-(void)addLoadingLayer;
-(void)animateScanner;
-(void)loadInfoScreen;
-(void)addButtons;
-(void)takePhoto;
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
- (void)renderView:(UIView*)view inContext:(CGContextRef)context;
- (void) captureStillImageFailedWithError:(NSError *)error;
- (void) cannotWriteToAssetLibrary;
-(void)processMotion:(CMDeviceMotion *)motion withError:(NSError *)error;

@end
