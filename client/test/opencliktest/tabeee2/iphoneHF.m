//
//  iphoneHF.m
//  tabeee2
//
//  Created by MA21AS on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "iphoneHF.h"
#import "OpenClikViewController.h"

@implementation iphoneHF

-(IBAction)tohome:(id)sender
{
    //[self dismissModalViewControllerAnimated:YES];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    OpenClikViewController *openclikViewController =[OpenClikViewController getInstance];
    //[openclikViewController show:openclikfull];
    [openclikViewController share];
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
    //[openclikViewController setKey:@"56D166FD-EE8D-463C-9698-A8F759DB5AFF"];
    [openclikViewController setKey:@"A5BBBB1D-7FF5-4194-9973-AF3E6175B504"];
    [self.view addSubview: openclikViewController.view];
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
     (interfaceOrientation != UIInterfaceOrientationPortrait)
     &&
     (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)
     );
}

@end
