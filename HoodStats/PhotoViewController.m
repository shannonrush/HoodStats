//
//  PhotoViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/29/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "PhotoViewController.h"


@implementation PhotoViewController

@synthesize images, initialImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButtons];
    [self initImageViews];
}

-(void)initImageViews {
    imageViews = [[NSMutableArray alloc]init];
    for (UIImage *image in images) {
        UIImageView *view = [[UIImageView alloc]initWithImage:image];
        view.frame = self.view.frame;
        [imageViews addObject:view];
        if (image==initialImage) {
            currentImageView = view;
            [self.view addSubview:currentImageView];
        }
        [view release];
    }
    [self.view bringSubviewToFront:forwardButton];
    [self.view bringSubviewToFront:backButton];
    [self resetButtons];
}

-(void)initButtons {    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 395, 45, 45 );
    [backButton addTarget:self action:@selector(backPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImage *fwdImage = [UIImage imageNamed:@"forward.png"];
    forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setBackgroundImage:fwdImage forState:UIControlStateNormal];
    forwardButton.frame = CGRectMake(265, 395, 45, 45);
    [forwardButton addTarget:self action:@selector(forwardPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardButton];
    

    //[self fadeOutButtons];
}

-(void)fadeOutButtons {
    [UIView animateWithDuration:3.0 delay:2.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        backButton.alpha = 0.0;
        forwardButton.alpha = 0.0;
    } completion:nil];
}

-(void)resetButtons {
    int index = [imageViews indexOfObject:currentImageView];
    if (index==[imageViews indexOfObject:[imageViews lastObject]]) {
        [UIView animateWithDuration:0.75 animations:^{forwardButton.alpha = 0.0;}];
    } else {
        [UIView animateWithDuration:0.75 animations:^{forwardButton.alpha = 1.0;}];
    }
    if (index==0) {
        [UIView animateWithDuration:0.75 animations:^{backButton.alpha = 0.0;}];
    } else {
        [UIView animateWithDuration:0.75 animations:^{backButton.alpha = 1.0;}];
    }
}

-(void)backPhoto {
    int index = [imageViews indexOfObject:currentImageView];
    UIImageView *previousImage = [imageViews objectAtIndex:index-1];
    if (![previousImage isDescendantOfView:self.view]) {
        previousImage.frame = CGRectMake(-320, 0, 320, 460);
        [self.view insertSubview:previousImage belowSubview:backButton];
    }
    [UIView animateWithDuration:2.0 
                     animations:^{
                         previousImage.frame = CGRectMake(0, 0, 320, 460);
                     }];

    currentImageView = previousImage;
    [self resetButtons];

}

-(void)forwardPhoto {

    int index = [imageViews indexOfObject:currentImageView];

    UIImageView *nextImage = [imageViews objectAtIndex:index+1];
    [self.view insertSubview:nextImage belowSubview:currentImageView];
    [UIView animateWithDuration:2.0 
                     animations:^{
                         currentImageView.frame = CGRectMake(-320, 0, 320, 460);
                     }];
    currentImageView = nextImage;
    [self resetButtons];

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

#pragma mark - View lifecycle



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
