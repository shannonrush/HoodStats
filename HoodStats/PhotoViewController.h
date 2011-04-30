//
//  PhotoViewController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/29/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoViewController : UIViewController {
    NSMutableArray *imageViews;
    UIView *buttonView;
}

@property (nonatomic, retain) UIImage *initialImage;
@property (nonatomic, retain) NSMutableArray *images;

-(void)initImageViews;
-(void)initButtons;
-(void)fadeOutButtons;
-(void)backPhoto;
-(void)forwardPhoto;

@end
