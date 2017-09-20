//
//  ipadHB.m
//  tabeee2
//
//  Created by MA21AS on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ipadHB.h"
#import "OpenClikViewController.h"

@implementation ipadHB

-(IBAction)tohome:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    OpenClikViewController *openclikViewController =[OpenClikViewController getInstance];
    [openclikViewController setKey:@"A5BBBB1D-7FF5-4194-9973-AF3E6175B504"];
    [self.view addSubview: openclikViewController.view];
    //[openclikViewController show:opencliktop];
    [openclikViewController show:interstitial];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return
    (
     (interfaceOrientation == UIInterfaceOrientationPortrait)
     ||
     (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
     );
}

@end
