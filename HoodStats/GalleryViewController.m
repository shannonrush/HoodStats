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
    [self initImages];
    [self initGallery];
}

-(void)initImages {
    imageDictionary = [[NSMutableDictionary alloc]init];
    for (NSManagedObject *photo in [selectedLocation valueForKey:@"Photos"]) {
        NSDateFormatter*dateFormat =[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMMM e, YYYY"]; // May 8, 1977
        NSString *dateString = [dateFormat stringFromDate:[photo valueForKey:@"timestamp"]];   
        [dateFormat release];
        if (![[imageDictionary allKeys] containsObject:dateString]) {
            [imageDictionary setObject:[NSMutableArray array] forKey:dateString];
        }
        [[imageDictionary objectForKey:dateString]addObject:[UIImage imageWithData:[photo valueForKey:@"image"]]];
    }
}

-(void)initGallery {
    NSArray *dates = [imageDictionary allKeys];
    for (NSString *date in dates) {
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 300.0, 30.0)];
        dateLabel.text = date;
        [self.view addSubview:dateLabel];
        [dateLabel release];
        NSArray *images = [imageDictionary objectForKey:date];
        for (UIImage *image in images) {
            // make a thumbnail from the image and add it to a button
            
            // crop image to square
        
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, 640.0, 640.0));
            UIImage *croppedImage = [UIImage imageWithCGImage:imageRef]; 
            CGImageRelease(imageRef);
            
            // resize to thumbnail
            
            CGSize newSize = CGSizeMake(64.0, 64.0);
            UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height));
            [croppedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();    
            UIGraphicsEndImageContext();
            
            // set button image to thumbnail
            
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageButton setBackgroundImage:croppedImage forState:UIControlStateNormal];
            imageButton.frame = CGRectMake(10.0, 40.0, thumbnail.size.width, thumbnail.size.height);
            [self.view addSubview:imageButton];

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
