//
//  InfoViewController.h
//  HoodStats
//
//  Created by Shannon Rush on 4/14/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface InfoViewController : BaseController <UITableViewDelegate> {
    NSArray *locations;
    
}

-(NSArray *)locations;

@end
