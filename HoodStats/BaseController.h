//
//  BaseController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/13/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface BaseController : UIViewController {
    
}

-(NSMutableArray *)getData:(CLLocation *)newLocation;
-(NSDictionary *)location:(NSString *)city withState:(NSString *)state;

@end
