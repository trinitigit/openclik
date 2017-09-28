//
//  OpenClikViewController.m
//  OpenClik Framework
//
//  Created by  OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import "OpenClik.h"
#define TRINITI
#ifdef TRINITI
#import "OpenClikViewController.h"
#import "GoogleMobileAds/GoogleMobileAds.h";
BOOL charboostshow;
BOOL trinitiConfigComplete = NO;
NSMutableData *receivedchartboostData;
int adType_;
NSString *adName;
GADInterstitial *interstitial_;
#endif
@implementation OpenClikViewController
@synthesize isVisible = _isVisible;
@synthesize ockey = _ockey;
OpenClik *openclikClass;
static OpenClikViewController *opencliksharedInstance = nil;
extern UIViewController* AdMobGetRootViewController();

+(OpenClikViewController*)getInstance
{
	if(!opencliksharedInstance)
        opencliksharedInstance = [[OpenClikViewController alloc] init];
	return opencliksharedInstance;
}

-(void)setKey:(NSString*)key
{
	openclikClass= [[OpenClik alloc] initWithKey:key];
#ifdef TRINITI
    self.ockey = key;
    trinitiConfigComplete = false;
    NSURL *url =[NSURL URLWithString:@"http://www.trinitigame.com/trinitiadconfig.txt"];
    //NSURL *url =[NSURL URLWithString:@"http://192.168.5.235:8080/tadconfig.txt"];
    NSLog(@"url is %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:20];
    //设置请求方式为get
    [request setHTTPMethod:@"GET"];
    //添加用户会话id
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    //连接发送请求
    receivedchartboostData=[[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [request release];
    [conn release];
#endif
}
- (void)connection:(NSURLConnection *)aConn didReceiveResponse:(NSURLResponse *)response {
    trinitiConfigComplete = YES;
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
}
//接收NSData数据
- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data {
    [receivedchartboostData appendData:data];
}
- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error{
    trinitiConfigComplete = YES;
    NSLog(@"[error %@",[error localizedDescription]);
}
//接收完毕,显示结果
- (void)connectionDidFinishLoading:(NSURLConnection *)aConn {
    trinitiConfigComplete = YES;
    [self process];
    
    
}

-(void) process
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedchartboostData options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"json parse failed \r\n");
        return;
    };
    //NSLog(@"%@",[json descriptionInStringsFileFormat]);
    NSArray *config = [json objectForKey:self.ockey];
    NSString *charboost = (NSString*)[config objectAtIndex:0];
    
    //Chartboost *cb = [Chartboost sharedChartboost];
    charboostshow = [charboost boolValue];
    NSString *appId = (NSString *)[config objectAtIndex:1];
    NSString *appSignature = (NSString *)[config objectAtIndex:2];
    [Chartboost startWithAppId:appId
                                   appSignature:appSignature
                                       delegate:self];
    NSString *gameName =(NSString *)[config objectAtIndex:3];
    adName =(NSString *)[config objectAtIndex:4];
    [adName retain];
    NSLog(@"ad name process get is %@",adName);
    NSLog(@"game name process get is %@",gameName);
    NSString *admobId =(NSString *)[config objectAtIndex:5];
    
    if ([adName isEqualToString:@"admob"])
    {
        interstitial_ = [[GADInterstitial alloc] init];
        interstitial_.adUnitID = admobId;
        GADRequest *request =[GADRequest request];
        //request.testDevices = @[ GAD_SIMULATOR_ID ];
        [interstitial_ loadRequest:request];
       
        
    }else if([adName isEqualToString:@"chartboost"])
    {
            [Chartboost cacheInterstitial:CBLocationHomeScreen];
    }
    else if([adName isEqualToString:@"openclik"])
    {
        [self request:adType_];
        //[self show:adType_];
    }
    else
    {
        [self request:adType_];
        //[self show:adType_];
    }
    

}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

-(id)initWith:(NSString*)key {
    self = [OpenClikViewController getInstance];
    [self setKey:key];
    return self;
}
/*-(void)bottom:(BOOL)bottom top:(BOOL)top interstitial:(BOOL)interstitial icon:(BOOL)icon
 {
 [openclikClass bottom:bottom top:top interstitial:interstitial icon:icon];
 }*/
-(void)request:(int)adType
{
    adType_ = adType;
    [openclikClass requestAdType:adType];
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
    _isVisible = NO;
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
    _isVisible = YES;
     NSLog(@"ad name is %@",adName);
    if (trinitiConfigComplete) {
        if ([adName isEqualToString:@"admob"] && openclikadfull)
        {
            [interstitial_ presentFromRootViewController:AdMobGetRootViewController()];
            openclikadfull = false;
            
        }else if([adName isEqualToString:@"chartboost"] && openclikadfull)
        {
            [Chartboost showInterstitial:CBLocationHomeScreen];
            openclikadfull = false;
        }
        else
            [self performSelector:@selector(showAd) withObject:nil afterDelay:0.001];

    }
}

-(void)showAd
{
    if (!_isVisible)
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
            self.view.frame = CGRectMake(0, 1024, iconSize, iconSize);
        }
        if (iconLocation == iconBottomRight) {
            self.view.frame = CGRectMake(screenwidth-iconSize, 1024, iconSize, iconSize);
        }
        if (iconLocation == iconTopLeft) {
            self.view.frame = CGRectMake(0, -200, iconSize, iconSize);
        }
        if (iconLocation == iconTopRight) {
            self.view.frame = CGRectMake(screenwidth-iconSize, -200, iconSize, iconSize);
        }
        
        self.view = openclikClass.adIconView;
        openclikClass.iconLocation = iconLocation;
        openclikClass.adType = [[NSString alloc] initWithFormat:@"%d",6];
    }
    
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
    if ([adName isEqualToString:@"admob"])
    {
        return [interstitial_ isReady];
        
        
    }else if([adName isEqualToString:@"chartboost"])
    {
        return [Chartboost hasInterstitial:CBLocationHomeScreen];
    }
    else if([adName isEqualToString:@"openclik"])
    {
        return openclikClass.adIsReady ;
    }
    return false;

}
-(NSString*)getAward
{
    return openclikClass.award;
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


/*
 * Chartboost Delegate Methods
 *
 */


/*
 * shouldDisplayInterstitial
 *
 * This is used to control when an interstitial should or should not be displayed
 * The default is YES, and that will let an interstitial display as normal
 * If it's not okay to display an interstitial, return NO
 *
 * For example: during gameplay, return NO.
 *
 * Is fired on:
 * -Interstitial is loaded & ready to display
 */

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);
    
    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    // Otherwise return YES to display the interstitial
    return YES;
}


/*
 * didFailToLoadInterstitial
 *
 * This is called when an interstitial has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Interstitial, missing location parameter !");
        } break;
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
}

/*
 * didCacheInterstitial
 *
 * Passes in the location name that has successfully been cached.
 *
 * Is fired on:
 * - All assets loaded
 * - Triggered by cacheInterstitial
 *
 * Notes:
 * - Similar to this is: (BOOL)hasCachedInterstitial:(NSString *)location;
 * Which will return true if a cached interstitial exists for that location
 */

- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at location %@", location);
}

/*
 * didFailToLoadMoreApps
 *
 * This is called when the more apps page has failed to load for any reason
 *
 * Is fired on:
 * - No network connection
 * - No more apps page has been created (add a more apps page in the dashboard)
 * - No publishing campaign matches for that user (add more campaigns to your more apps page)
 *  -Find this inside the App > Edit page in the Chartboost dashboard
 */

- (void)didFailToLoadMoreApps:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load More Apps, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load More Apps, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load More Apps, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load More Apps, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load More Apps, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load More Apps, first session !");
        } break;
        case CBLoadErrorNoAdFound: {
            NSLog(@"Failed to load More Apps, Apps not found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load More Apps, session not started !");
        } break;
        default: {
            NSLog(@"Failed to load More Apps, unknown error !");
        }
    }
}

/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
}

/*
 * didDismissMoreApps
 *
 * This is called when the more apps page is dismissed
 *
 * Is fired on:
 * - More Apps click
 * - More Apps close
 *
 */

- (void)didDismissMoreApps:(NSString *)location {
    NSLog(@"dismissed more apps page at location %@", location);
}

/*
 * didCompleteRewardedVideo
 *
 * This is called when a rewarded video has been viewed
 *
 * Is fired on:
 * - Rewarded video completed view
 *
 */
- (void)didCompleteRewardedVideo:(CBLocation)location withReward:(int)reward {
    NSLog(@"completed rewarded video view at location %@ with reward amount %d", location, reward);
}

/*
 * didFailToLoadRewardedVideo
 *
 * This is called when a Rewarded Video has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadRewardedVideo:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Rewarded Video, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Rewarded Video, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Rewarded Video, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Rewarded Video, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Rewarded Video, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Rewarded Video, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Rewarded Video, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Rewarded Video, session not started !");
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Rewarded Video, missing location parameter !");
        } break;
        default: {
            NSLog(@"Failed to load Rewarded Video, unknown error !");
        }
    }
}

/*
 * didDisplayInterstitial
 *
 * Called after an interstitial has been displayed on the screen.
 */

- (void)didDisplayInterstitial:(CBLocation)location {
    NSLog(@"Did display interstitial");
    
    // We might want to pause our in-game audio, lets double check that an ad is visible
    if ([Chartboost isAnyViewVisible]) {
        // Use this function anywhere in your logic where you need to know if an ad is visible or not.
        NSLog(@"Pause audio");
    }
}



@end
