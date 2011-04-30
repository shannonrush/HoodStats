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
    [self initImageViews];
    [self initButtons];
}

-(void)initImageViews {
    imageViews = [[NSMutableArray alloc]init];
    for (UIImage *image in images) {
        UIImageView *view = [[UIImageView alloc]initWithImage:image];
        view.frame = self.view.frame;
        [self.view addSubview:view];
        [imageViews addObject:view];
        [view release];
    }
}

-(void)initButtons {
    buttonView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 395, 45, 45 );
    [backButton addTarget:self action:@selector(backPhoto) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:backButton];
    
    UIImage *fwdImage = [UIImage imageNamed:@"forward.png"];
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setBackgroundImage:fwdImage forState:UIControlStateNormal];
    forwardButton.frame = CGRectMake(265, 395, 45, 45);
    [forwardButton addTarget:self action:@selector(forwardPhoto) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:forwardButton];
    
    [self.view addSubview:buttonView];
    [self fadeOutButtons];
}

-(void)fadeOutButtons {
    [UIView animateWithDuration:3.0 delay:2.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{buttonView.alpha = 0.0;} completion:nil];
}

-(void)backPhoto {
    
}

-(void)forwardPhoto {
    
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
