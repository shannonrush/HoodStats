//
//  GalleryViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/23/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "GalleryViewController.h"
#import "HoodStatsAppDelegate.h"
#import "PhotoViewController.h"


@implementation GalleryViewController

@synthesize selectedLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGallery];
}

-(void)initGallery {
    while (![HoodStatsAppDelegate imageDictionary]) {
        NSLog(@"Waiting");
    }
    float y = 0.0;
    NSString *locationString = [NSString stringWithFormat:@"%@, %@",[selectedLocation valueForKey:@"city"],[selectedLocation valueForKey:@"state"]];
    locationDictionary = [[NSDictionary alloc]initWithDictionary:[[HoodStatsAppDelegate imageDictionary]objectForKey:locationString]];
    NSMutableArray *dates = [NSMutableArray arrayWithArray:[locationDictionary allKeys]];
    [dates removeObject:@"locationImages"];
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
            [imageButton addTarget:self action:@selector(loadImage:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:imageButton];
            x += 70.0;
        }
        y += 70.0;
    }
}

-(void)loadImage:(id)sender {    
    PhotoViewController *photoVC = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:[NSBundle mainBundle]];
    photoVC.initialImage = [self initialImage:[sender currentBackgroundImage]];
    [self presentModalViewController:photoVC animated:YES];
    [photoVC release];
}
                            
-(UIImage *)initialImage:(UIImage *)thumbnail {
    NSMutableArray *dates = [NSMutableArray arrayWithArray:[locationDictionary allKeys]];
    [dates removeObject:@"locationImages"];
    for (NSString *date in dates) {
        NSArray *images = [locationDictionary objectForKey:date];
        for (NSDictionary *imageDict in images) {
            if ([imageDict objectForKey:@"thumbnail"]==thumbnail) {
                return [imageDict objectForKey:@"image"];
            }

        }
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
