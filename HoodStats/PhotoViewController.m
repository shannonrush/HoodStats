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
        [imageViews addObject:view];
        if (image==initialImage) {
            currentImageView = view;
            [self.view addSubview:currentImageView];
        }
        [view release];
    }
    if (currentImageView==[imageViews lastObject]) {
        forwardButton.hidden = YES;
    } else if (currentImageView==[imageViews objectAtIndex:0]){
        backButton.hidden = YES;
    }
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

-(void)backPhoto {

}

-(void)forwardPhoto {
    int index = [imageViews indexOfObject:currentImageView];
    if (index+1==[imageViews indexOfObject:[imageViews lastObject]]) {
        forwardButton.hidden = YES;
    }
    UIImageView *nextImage = [imageViews objectAtIndex:index+1];
    [self.view insertSubview:nextImage belowSubview:currentImageView];
    
    CALayer *layer = [currentImageView layer];
    layer.anchorPoint = CGPointMake(0.0, 0.5);
    currentImageView.frame = CGRectMake(0, 0, 320.0, 460.0);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D rotateTransform = CATransform3DMakeRotation(M_PI/2.0f,0.0f,-1.0f,0.0f);
    [anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [anim setToValue:[NSValue valueWithCATransform3D:rotateTransform]];
    [anim setDuration:0.75f];
    [layer addAnimation:anim forKey:nil];
    [layer setTransform:rotateTransform];
    currentImageView = nextImage;
}
     
-(UIImageView *)nextImageView {
    int nextIndex = [imageViews indexOfObject:currentImageView]+1;
    return [imageViews objectAtIndex:nextIndex];
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
