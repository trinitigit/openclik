//
//  OpenClikViewController.m
//  OpenClik Framework
//
//  Created by  OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import "OpenClikViewController.h"
#import "OpenClik.h"
@implementation OpenClikViewController
@synthesize adStop = _adStop;

OpenClik *openclikClass;


extern UIViewController *rController;
static OpenClikViewController *opencliksharedInstance = nil;

+(OpenClikViewController*)getInstance
{
	if(!opencliksharedInstance)
		opencliksharedInstance = [[OpenClikViewController alloc] init];
	return opencliksharedInstance;
}
-(void)setKey:(NSString*)key
{
	openclikClass= [[OpenClik alloc] initWithKey:key];
    [self loadView];
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

-(id)initWith:(NSString*)key {
    self = [OpenClikViewController getInstance];
        // Custom initialization.
    openclikClass= [[OpenClik alloc] initWithKey:key]; 
        //NSLog(@"%@",key);
    return self;
}
/*
-(id)initWith:(NSString*)key orientation:(UIInterfaceOrientation)orientation; {
    self = [super init];
    if (self) {
        // Custom initialization.
		tadClass= [[OpenClik alloc] initWithKey:key orientation:orientation]; 
	}
    return self;
}
*/

-(void)setTop
{
	//[openclikClass setTop:YES];
}
-(void)hide
{
    _adStop = YES;
    openclikadfull = NO;
    openclikadbanner = NO;
    openclikadtop = NO;
   	[openclikClass hide];
    //[openclikClass createAdBannerView];
    //self.view.hidden = true;
  
}

-(void)show:(int)banner
{	

    if (banner == 2) {
        if(openclikadbanner)
            [self hide];
        openclikadtop=YES;
    }
    if (banner == 0) {
        if(openclikadtop)
            [self hide];
        openclikadbanner=YES;
            
    }
    if(banner == 1) {
        openclikadfull=YES;
    }
    _adStop = NO;
    [self performSelector:@selector(showAd) withObject:nil afterDelay:0.001];
}
-(void)showAd
{
    if (_adStop) 
        return;
        
    if (openclikadfull && (openclikadbanner || openclikadtop)) {
 
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2500, 2500)];
        self.view.frame = tempView.frame;

        
        //NSLog(@"self.view center is %f,%f",self.view.center.x,self.view.center.y);
 
        tempView.userInteractionEnabled = YES;
        self.view = tempView;
        
        [tempView addSubview:openclikClass.adFullView];
        
        if (openclikadbanner && openclikadtop) 
        {
            openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",3];
            [tempView addSubview:openclikClass.adBannerView];
            [tempView addSubview:openclikClass.adTopView];
        }
        else if (openclikadbanner)
        {
            openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",4];
            [tempView addSubview:openclikClass.adBannerView];
            openclikClass.adBannerView.frame = CGRectMake(2500, 2500, 1024, 1024);
        }
        else if(openclikadtop)
        {
            openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",5];
            [tempView addSubview:openclikClass.adTopView];
        }
        
    }
    else if(openclikadfull)
    {
        
        self.view.frame = openclikClass.adFullView.frame;
        self.view = openclikClass.adFullView;
        ((UIWebView*)self.view).scalesPageToFit = YES;
        
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",1];
    }
    else if(openclikadbanner)
    {
        self.view.frame = openclikClass.adBannerView.frame;
        self.view = openclikClass.adBannerView;
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",0];
    }
    else if(openclikadtop)
    {
        self.view.frame = CGRectMake(-200, -200, 1024, 50);
        self.view = openclikClass.adTopView;
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",2];
    }
	[openclikClass show];
    

}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    [openclikClass createAdBannerView];
    //tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2500, 2500)];
    self.view.hidden = YES;
   
  
}
-(BOOL)IsAdReady
{
    return openclikClass.adIsReady;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [openclikClass fixupAdView:toInterfaceOrientation];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    if (UIInterfaceOrientationIsLandscape(openclikClass.orientation)) {
        return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation==openclikClass.orientation);
    }

	//return NO;
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return
    (
     (interfaceOrientation != UIInterfaceOrientationPortrait)
     &&
     (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)
     );
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
