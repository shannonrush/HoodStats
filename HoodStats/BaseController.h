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
    NSMutableDictionary *imageDictionary;
}

@property (nonatomic, retain) NSMutableDictionary *imageDictionary;

-(NSMutableArray *)getData:(CLLocation *)newLocation;
-(NSManagedObject *)location:(NSString *)city withState:(NSString *)state;
-(void)saveHistoryItem:(NSString *)label withValue:(NSString *)value;
-(void)savePhoto:(UIImage *)screenshot;
-(void)initImages;
-(UIImage *)thumbnail:(UIImage *)image;
-(NSArray *)locations;
-(NSDictionary *)locationDictionary:(NSManagedObject *)selectedLocation;

@end
