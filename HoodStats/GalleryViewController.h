//
//  GalleryViewController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/23/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface GalleryViewController : BaseController {
    NSManagedObject *selectedLocation;
    NSDictionary *locationDictionary;
    NSMutableArray *locationImages;
}

@property (nonatomic, retain) NSManagedObject *selectedLocation;


-(void)initGallery;
-(void)loadImage:(id)sender;
-(UIImage *)initialImage:(UIImage *)thumbnail;
-(NSMutableArray *)locationImages;


@end
