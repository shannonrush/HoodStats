//
//  BaseController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface BaseController : UIViewController {
    NSManagedObject *location;
}

-(NSMutableArray *)getData:(CLLocation *)newLocation;
-(NSManagedObject *)location:(NSString *)city withState:(NSString *)state;
-(void)addHistoryItem:(NSString *)label withValue:(NSString *)value;
-(void)savePhoto:(UIImage *)screenshot;

@end
