//
//  iphoneHB.m
//  tabeee2
//
//  Created by MA21AS on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "iphoneHB.h"
#import "OpenClikViewController.h"

@implementation iphoneHB

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
    [openclikViewController setKey:@"8853F222-A86A-4087-9419-4A237A47555A"];
    [self.view addSubview: openclikViewController.view];
    [openclikViewController request:bannerTop];
    [openclikViewController show:bannerTop];
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
