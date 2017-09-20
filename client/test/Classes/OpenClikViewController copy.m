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
/*-(void)bottom:(BOOL)bottom top:(BOOL)top interstitial:(BOOL)interstitial icon:(BOOL)icon
{
    [openclikClass bottom:bottom top:top interstitial:interstitial icon:icon];
}*/
-(void)request:(int)adType
{
    [openclikClass requestAdType:adType ];
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

-(void)hide
{
    _adStop = YES;
    openclikadfull = NO;
    openclikadbanner = NO;
    openclikadtop = NO;
    openclikadicon = NO;
   	[openclikClass hide];
    //[openclikClass createAdBannerView];
    //self.view.hidden = true;
  
}

-(void)show:(int)banner
{	

    if (banner == bannerTop) {
        if(openclikadbanner)
            [self hide];
        openclikadtop=YES;
    }
    if (banner == bannerBottom) {
        if(openclikadtop)
            [self hide];
        openclikadbanner=YES;
            
    }
    if(banner == interstitial) {
        openclikadfull=YES;
    }
    
    if(banner >= iconTopLeft) {
        openclikadicon=YES;
        iconLocation = banner;
    }
    
    _adStop = NO;
    [self performSelector:@selector(showAd) withObject:nil afterDelay:0.001];
}


-(void)showAd
{
    
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _visualEffectView.frame =CGRectMake(0,  0, 4096 , 4096);
    if (_adStop)
        return;
        
    if (openclikadfull && (openclikadbanner || openclikadtop)) {
 
        //UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2500, 2500)];
        self.view.frame = _visualEffectView.frame;

        
        //NSLog(@"self.view center is %f,%f",self.view.center.x,self.view.center.y);
 
        _visualEffectView.userInteractionEnabled = YES;
        //self.view = tempView;
        
        [_visualEffectView addSubview:openclikClass.adFullView];
        
        if (openclikadbanner && openclikadtop) 
        {
            openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",3];
            [_visualEffectView addSubview:openclikClass.adBannerView];
            [_visualEffectView addSubview:openclikClass.adTopView];
        }
        else if (openclikadbanner)
        {
            openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",4];
            [_visualEffectView addSubview:openclikClass.adBannerView];
            openclikClass.adBannerView.frame = CGRectMake(2500, 2500, 1024, 1024);
        }
        else if(openclikadtop)
        {
            openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",5];
            [_visualEffectView addSubview:openclikClass.adTopView];
        }
        
    }
    else if(openclikadfull)
    {
        
        //self.view.frame = openclikClass.adFullView.frame;
        //self.view = openclikClass.adFullView;
        //((UIWebView*)self.view).scalesPageToFit = YES;
        [_visualEffectView addSubview:openclikClass.adFullView];
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",1];
    }
    else if(openclikadbanner)
    {
        //self.view.frame = openclikClass.adBannerView.frame;
        //self.view = openclikClass.adBannerView;
        [_visualEffectView addSubview:openclikClass.adBannerView];
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",0];
    }
    else if(openclikadtop)
    {
        //self.view.frame = CGRectMake(-200, -200, 1024, 50);
        //self.view = openclikClass.adTopView;
        [_visualEffectView addSubview:openclikClass.adTopView];
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",2];
    }    
    else if(openclikadicon)
    {
        int screenwidth = 0;
        int iconSize = 0;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            if ([openclikClass ShellIsiPad]) 
                screenwidth = 1024;
            else
            {
                if (iPhone5)
                    screenwidth = 480+88;
                else
                    screenwidth = 480;
            }
        }
        else
        {
            if ([openclikClass ShellIsiPad])
                screenwidth = 768;
            else
            {
                if (iPhone5)
                    screenwidth = 320;
                else
                    screenwidth = 320;
            }
        }
        if ([openclikClass ShellIsiPad]) {
            iconSize = 92;
        }
        else {
            iconSize = 67;
        }
        if (iconLocation == iconBottomLeft) {
            openclikClass.adIconView.frame = CGRectMake(0, 1024, iconSize, iconSize);
        }
        if (iconLocation == iconBottomRight) {
            openclikClass.adIconView.frame = CGRectMake(screenwidth-iconSize, 1024, iconSize, iconSize);
        }
        if (iconLocation == iconTopLeft) {
            openclikClass.adIconView.frame = CGRectMake(0, -200, iconSize, iconSize);
        }
        if (iconLocation == iconTopRight) {
            openclikClass.adIconView.frame = CGRectMake(screenwidth-iconSize, -200, iconSize, iconSize);
        }
        
        //self.view = openclikClass.adIconView;
        [_visualEffectView addSubview:openclikClass.adIconView];
        openclikClass.iconLocation = iconLocation;
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",6];
    }
    self.view = _visualEffectView;
	[openclikClass show];
    

}
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    [self refresh];
    //tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2500, 2500)];
    self.view.hidden = YES;
   
  
}
-(BOOL)IsAdReady
{
    return openclikClass.adIsReady;
}
-(void)refresh
{
    [openclikClass createAdBannerView];
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
