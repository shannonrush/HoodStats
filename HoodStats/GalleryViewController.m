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
    locationImages = [[NSMutableArray alloc]initWithArray:[self locationImages]];
}

-(void)increaseScrollViewHeight:(float)increase {
    scrollView.contentSize = CGSizeMake(280.0, scrollView.contentSize.height + increase);
}

-(void)initGallery {
    while (![HoodStatsAppDelegate imageDictionary]) {
        NSLog(@"Waiting");
    }
    float y = 0.0;
    scrollView.contentSize = CGSizeMake(280.0, 0);
    NSString *locationString = [self locationString:selectedLocation];
    locationDictionary = [[NSDictionary alloc]initWithDictionary:[[HoodStatsAppDelegate imageDictionary]objectForKey:locationString]];
    locationLabel.font = [UIFont fontWithName:@"Bellerose" size:24.0];
    locationLabel.textColor = [HoodStatsAppDelegate popColor];
    locationLabel.text = [NSString stringWithFormat:@"%@ Photos",locationString];
    
    NSArray *dates = [locationDictionary allKeys];
    for (NSString *date in dates) {
        // add date label
        float x = 0.0;

        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 300.0, 30.0)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont fontWithName:@"Bellerose" size:18.0];
        dateLabel.text = date;
        [self increaseScrollViewHeight:dateLabel.frame.size.height];
        [scrollView addSubview:dateLabel];
        [dateLabel release];
        
        y += 35.0;
        
        NSArray *images = [locationDictionary objectForKey:date];
        
        for (NSDictionary *imageDict in images) {
            int index = [images indexOfObject:imageDict];
            if (index > 0 && index % 4 == 0) {
                // make a new row
                y += 70.0;
                x = 0.0;
            }
            
            UIImage *thumbnail = [imageDict objectForKey:@"thumbnail"];
            
            // set button image to thumbnail
            
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton setBackgroundImage:thumbnail forState:UIControlStateNormal];
            imageButton.frame = CGRectMake(x, y, thumbnail.size.width, thumbnail.size.height);
            [imageButton addTarget:self action:@selector(loadImage:) forControlEvents:UIControlEventTouchUpInside];
            [self increaseScrollViewHeight:imageButton.frame.size.height];
            [scrollView addSubview:imageButton];
            x += 70.0;
        }
        y += 70.0;
    }
}

-(void)loadImage:(id)sender {    
    PhotoViewController *photoVC = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:[NSBundle mainBundle]];
    photoVC.initialImage = [self initialImage:[sender currentBackgroundImage]];
    photoVC.images = locationImages;
    [self presentModalViewController:photoVC animated:YES];
    [photoVC release];
}
                            
-(UIImage *)initialImage:(UIImage *)thumbnail {
    NSArray *dates = [locationDictionary allKeys];
    for (NSString *date in dates) {
        NSArray *images = [locationDictionary objectForKey:date];
        for (NSDictionary *imageDict in images) {
            if ([imageDict objectForKey:@"thumbnail"]==thumbnail) {
                return [imageDict objectForKey:@"image"];
            }
        }
    }
}

-(NSMutableArray *)locationImages {
    NSMutableArray *locImages = [NSMutableArray array];
    NSArray *dates = [locationDictionary allKeys];
    for (NSString *date in dates) {
        NSArray *images = [locationDictionary objectForKey:date];
        for (NSDictionary *imageDict in images) {
            [locImages addObject:[imageDict objectForKey:@"image"]];
        }
    }
    return locImages;
}

-(IBAction)navBack {
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



@end
