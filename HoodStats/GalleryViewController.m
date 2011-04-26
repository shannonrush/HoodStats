//
//  GalleryViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/23/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "GalleryViewController.h"


@implementation GalleryViewController

@synthesize selectedLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGallery];
}



-(void)initGallery {
    float y = 0.0;
    NSDictionary *locationDictionary = [self locationDictionary:selectedLocation];;
    NSArray *dates = [locationDictionary allKeys];
    for (NSString *date in dates) {
        // add date label
        float x = 20.0;

        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 300.0, 30.0)];
        dateLabel.text = date;
        [self.view addSubview:dateLabel];
        [dateLabel release];
        
        y += 35.0;
        
        NSArray *images = [locationDictionary objectForKey:date];
        
        for (NSDictionary *imageDict in images) {
            int index = [images indexOfObject:imageDict];
            if (index > 0 && index % 4 == 0) {
                // make a new row
                y += 70.0;
                x = 20.0;
            }
            
            UIImage *thumbnail = [imageDict objectForKey:@"thumbnail"];
            
            // set button image to thumbnail
            
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton setBackgroundImage:thumbnail forState:UIControlStateNormal];
            imageButton.frame = CGRectMake(x, y, thumbnail.size.width, thumbnail.size.height);
            [self.view addSubview:imageButton];
            x += 70.0;
        }
        y += 70.0;
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



@end
