//
//  PhotoViewController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/27/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoViewController : UIViewController {
    IBOutlet UIImageView *photoView;
}

@property (nonatomic, retain) UIImage *initialImage;

@end
