//
//  FirstViewController.m
//  tabeee2
//
//  Created by MA21AS on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)checkLoad { 
    
    if(webeee0.loading) { 
        [spineee0 startAnimating]; 
    } 
    
} 

-(void)checkNotLoad { 
    
    if(!(webeee0.loading)) { 
        [spineee0 stopAnimating]; 
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webeee0 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.2.112:8080/openclik/openclikAction.do?action=loginForm"]]];
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkLoad) userInfo:nil repeats:YES]; 
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkNotLoad) userInfo:nil repeats:YES]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
