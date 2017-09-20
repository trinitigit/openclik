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
extern void report_memory();
-(IBAction)tohome:(id)sender
{
    //[self dismissModalViewControllerAnimated:YES];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    OpenClikViewController *openclikViewController =[OpenClikViewController getInstance];
    [openclikViewController show:interstitial];
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

-(void) reportMemory:(id)userinfo
{
    report_memory();
}

- (void)viewDidLoad
{
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reportMemory:) userInfo:nil repeats:YES];
    [super viewDidLoad];
    OpenClikViewController *openclikViewController =[OpenClikViewController getInstance];
    [openclikViewController setKey:@"46DD94B1-E035-442D-975E-579079CF5CE3"];
    [openclikViewController request:interstitial];
    //self.view = openclikViewController.view;
    UIButton *btn = [[UIButton alloc] init];
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(50, 50, 300, 50);
    [btn setTitle:@"show" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Method) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view addSubview: openclikViewController.view];
    //[openclikViewController show:interstitial];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
- (void)Method
{
    
    OpenClikViewController *openclikViewController =[OpenClikViewController getInstance];
    if([openclikViewController IsAdReady])
        [openclikViewController show:interstitial];
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
