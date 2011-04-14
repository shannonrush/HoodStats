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
-(NSManagedObject *)location:(NSString *)city withState:(NSString *)state;
-(void)addHistoryItem:(NSString *)label withValue:(NSString *)value withLocation:(NSManagedObject *)location;

@end
