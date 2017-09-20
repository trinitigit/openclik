//
//  OpenClik.m
//  OpenClik Framework
//
//  Created by  OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import "OpenClik.h"
#import "OpenClikViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <Security/Security.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "OCReachability.h"
#import <stdlib.h>
@implementation OpenClik
@synthesize adBannerView = _adBannerView;
@synthesize adFullView = _adFullView;
@synthesize adTopView = _adTopView;
@synthesize adIconView = _adIconView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;
@synthesize adFullViewIsVisible = _adFullViewIsVisible;
@synthesize adTopViewIsVisible = _adTopViewIsVisible;
@synthesize adIconViewIsVisible = _adIconViewIsVisible;
@synthesize top = _top;
@synthesize appStoreURL = _appStoreURL;
@synthesize adId = _adId;
@synthesize adType = _adType;
@synthesize key = _key;
@synthesize deviceType = _deviceType;
@synthesize OrientationType = _OrientationType;
@synthesize secureKey = _secureKey;
@synthesize orientation = _orientation;
@synthesize adIsReady = _adIsReady;
@synthesize adAppId = _adAppId;
@synthesize appUrl = _appUrl;
@synthesize iconLocation = _iconLocation;
@synthesize adRequestURL = _adRequestURL;
@synthesize fulladRequestURL = _fulladRequestURL;
@synthesize topadRequestURL = _topadRequestURL;
@synthesize iconadRequestURL = _iconadRequestURL;
@synthesize receiveResponse = _receiveResponse;
@synthesize resourcePath = _resourcePath;


int ocviewsender=0;
int gcd(int m, int n) {
    
    int t, r;
    
    if (m < n) {
        t = m;
        m = n;
        n = t;
    }
    
    r = m % n;
    
    if (r == 0) {
        return n;
    } else {
        return gcd(n, r);
    }
    
}

NSString *ocnetworkType =@"";

- (NSString *) platform
{
    int mib[2];
	size_t len;
	char *machine;
	
	mib[0] = CTL_HW;
	mib[1] = HW_MACHINE;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	machine = (char *)malloc(len);
	sysctl(mib, 2, machine, &len, NULL, 0);
	
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    /*if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";*/
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
	if ([platform isEqualToString:@"x86_64"])         return @"Simulator";
    free(machine);
	return platform;
}

-(id)initWithKey:(NSString*)key
{
    if ([key length]<36) {
        NSLog(@"oops! missing app key.");
    }
	if (self == [super init]) {
		_top = NO;
		self.key = key;
		self.adType = @"0";
		self.deviceType =@"";
		self.OrientationType=@"";
		self.adBannerViewIsVisible = NO;
		self.adFullViewIsVisible = NO;
		_webADViewIsReady = NO;
		_webFullViewIsReady = NO;
        _webTopViewIsReady = NO;
        _webTopViewIsReady = NO;
        _requestBottom = NO;
        _requestTop = NO;
        _requestInterstitial = NO;
        _requestIcon = NO;
        _receiveResponse = NO;
        self.adBannerView = [[OpenClikWebView alloc] initWithFrame:CGRectMake(2500, 2500, 1024, 1024)];
        self.adFullView = [[OpenClikWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        self.adTopView = [[OpenClikWebView alloc] initWithFrame:CGRectMake(-100, 0, 1024, 1024)];
        self.adIconView = [[OpenClikWebView alloc] initWithFrame:CGRectMake(2500, 0, 1024, 1024)];
        //[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(createAdBannerView) userInfo:nil repeats:YES];

		// orientation
        _orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        NSString* defaultOrientation = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIInterfaceOrientation"];
        if (defaultOrientation)
        {
            if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationPortrait"])
            {
                _orientation = UIInterfaceOrientationPortrait;
            }
            if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"])
            {
                _orientation = UIInterfaceOrientationPortraitUpsideDown;
            }
            if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationLandscapeLeft"])
            {
                _orientation = UIInterfaceOrientationLandscapeLeft;
            }
            if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationLandscapeRight"])
            {
                _orientation = UIInterfaceOrientationLandscapeRight;
            }
        }
        else
        {
            
            NSArray *supportOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
            if (supportOrientations!=nil &&[supportOrientations count] >0 )
            {
                defaultOrientation =[supportOrientations objectAtIndex:0];
                if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationPortrait"])
                {
                    _orientation = UIInterfaceOrientationPortrait;
                }
                if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"])
                {
                    _orientation = UIInterfaceOrientationPortraitUpsideDown;
                }
                if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationLandscapeLeft"])
                {
                    _orientation = UIInterfaceOrientationLandscapeLeft;
                }
                if ([defaultOrientation isEqualToString:@"UIInterfaceOrientationLandscapeRight"])
                {
                    _orientation = UIInterfaceOrientationLandscapeRight;
                }
                
            }

            
        }
        [self fixupAdView:_orientation];
		//NSLog(@"openclik init");
	}
	return self;
}
-(void)bottom:(BOOL)bottom top:(BOOL)top interstitial:(BOOL)interstitial icon:(BOOL)icon
{
    _requestBottom = bottom;
    _requestTop = top;
    _requestInterstitial = interstitial;
    _requestIcon = icon;
}
-(void)requestAdType:(int)adType
{
    if (adType == bannerBottom )
        _requestBottom = YES;
    if (adType == bannerTop )
        _requestTop = YES;
    if (adType == interstitial )
        _requestInterstitial = YES;
    if (adType >= iconTopLeft )
        _requestIcon = YES;
    [self loadWebView];
}
-(id)initWithKey:(NSString*)key orientation:(UIInterfaceOrientation)orientation
{
	if (self == [super init]) {
		_top = NO;
		self.key = key;
		self.adType = @"0";
		self.deviceType =@"";
		self.OrientationType=@"";
		self.adBannerViewIsVisible = NO;
		self.adFullViewIsVisible = NO;
		_webADViewIsReady = NO;
		_webFullViewIsReady = NO;
        _webTopViewIsReady = NO;
        _webIconViewIsReady = NO;
		_orientation = orientation;
		//NSLog(@"openclik init");
	}
	return self;
}
- (int)getBannerHeight:(UIInterfaceOrientation)orientation {
	if ([self ShellIsiPad]) 
	{
		return 100;
	}
	else {
		//iphone 
		if (UIInterfaceOrientationIsLandscape(orientation))  {
			return 40;
		}
		else {
			return 50;
		}

	}
}

-(int)getBannerWidth:(UIInterfaceOrientation)orientation {
	if ([self ShellIsiPad])  
	{
		
		//ipad 
		if (UIInterfaceOrientationIsLandscape(orientation))  {
			return 1024;
		}
		else {
			return 768;
		}
	}
	else {
		//iphone
        //iphone5
        if (iPhone5)
        {
            if (UIInterfaceOrientationIsLandscape(orientation))  {
                return 568;
            }
            else {
                return 320;
            }
        }
        else
        {
            if (UIInterfaceOrientationIsLandscape(orientation))  {
                return 480;
            }
            else {
                return 320;
            }
        }
		
		
	}
}
- (int)getFullHeight:(UIInterfaceOrientation)orientation {
	if ([self ShellIsiPad])  
	{
        if (UIInterfaceOrientationIsLandscape(orientation))  
            return 512;
        else
                return 692;

	}
	else {
		//iphone
        //iphone 5
        if(iPhone5)
        {
            if (UIInterfaceOrientationIsLandscape(orientation))  {
                return 320;
            }
            else {
                return 568;
            }
        }
        else
        {
            if (UIInterfaceOrientationIsLandscape(orientation))  {
                return 320;
            }
            else {
                return 432;
            }
        }
		
	}
}

-(int)getFullWidth:(UIInterfaceOrientation)orientation {
	if ([self ShellIsiPad])  
	{
		if (UIInterfaceOrientationIsLandscape(orientation))
            //ipad
            return 768;
        else
            return 512;
            
	}
	else {
		//iphone
        //iphone5
        if (iPhone5) {
            if (UIInterfaceOrientationIsLandscape(orientation))  {
                return 568;
            }
            else {
                return 320;
            }
        }
        else
        {
            if (UIInterfaceOrientationIsLandscape(orientation))  {
                return 480;
            }
            else {
                return 320;
            }
        }
	}
}
-(void)setTop:(BOOL)top
{
	_top = top;
	//NSLog(@"top is yes");
}
-(BOOL)getTop
{
    return _top;
}
-(void)hide
{
    [OpenClikViewController getInstance].isVisible = NO;
    _adFullViewIsVisible = NO;
	_adBannerViewIsVisible = NO;
    _adTopViewIsVisible = NO;
    _adIconViewIsVisible = NO;
	[self fixupAdView:_orientation];
}
-(void)resizeView
{
	[self fixupAdView:_orientation];
}
-(void)show
{
    [self hide];
    
	[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(resizeView) userInfo:nil repeats:NO];
	//[_adFullView.layer removeAllAnimations];
	//[_adBannerView.layer removeAllAnimations];
	if ([self.adType isEqualToString:@"0"]) {
        
		_adBannerViewIsVisible = YES;
	}
	else if([self.adType isEqualToString:@"1"])
		 _adFullViewIsVisible = YES;
    else if([self.adType isEqualToString:@"2"])
    {
        _adTopViewIsVisible = YES;
    }
    else if([self.adType isEqualToString:@"3"])
    {
        _adFullViewIsVisible = YES;
        _adTopViewIsVisible = YES;
        _adBannerViewIsVisible = YES;
    }
    else if([self.adType isEqualToString:@"4"])
    {
        _adFullViewIsVisible = YES;
        _adBannerViewIsVisible = YES;
    }
    else if([self.adType isEqualToString:@"5"])
    {
        _adFullViewIsVisible = YES;
        _adTopViewIsVisible = YES;
    }
    else if([self.adType isEqualToString:@"6"])
    {
        _adIconViewIsVisible = YES;
    }
    
}

- (void)createAdBannerView {
    OCReachability *reach = [OCReachability reachabilityForInternetConnection];
    [reach startNotifier];
    
    NetworkStatus stat = [reach currentReachabilityStatus];
    
    if(stat & NotReachable) {
        ocnetworkType =@"NO";
    }
    
    if(stat & ReachableViaWiFi) {
        ocnetworkType = @"wifi";
    }
    
    if(stat & ReachableViaWWAN) {
        ocnetworkType = @"wwan";
    }
	
	//UIInterfaceOrientation orientation = _orientation;
	 if (UIInterfaceOrientationIsLandscape(_orientation))
	 {
		 self.OrientationType = @"1";
	 }
	else
	{
		self.OrientationType = @"2";
	}
	if ([self ShellIsiPad])  {
		self.deviceType = @"2";
	}
	else {
		self.deviceType = @"1";
	}
	
	self.adType = @"0";
	NSString *model = [[UIDevice currentDevice] model];
	model = [self platform];
	NSString *deviceid=[self uniqueGlobalDeviceIdentifier ];
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	NSString *language = @"";
	NSString *locale = @"";
	if ([model isEqualToString:@"Simulator"]) {
		language = @"en";
		locale = @"US";
	}
	else
	{
		language = [[NSLocale preferredLanguages] objectAtIndex:0];
		locale = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:[[NSLocale currentLocale] localeIdentifier]];			 
	}
    //NSLog(@"Check install ,UIPasteboard pasteboardWithName:%@",self.key);
    // check install
    UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:self.key
                                                            create:YES];
	NSString *installkey = [appPasteBoard  valueForPasteboardType:@"public.utf8-plain-text"];
    
    //NSLog(@"%@",[self macaddress]);
    if(installkey==nil)
        installkey = @"";
    //NSLog(@"get install key:%@",installkey);
    
    int top=0;
	if(_top)
        top=1;
    NSString* iphone5 =@"false";
    if (iPhone5) {
        iphone5 = @"true";
    }
    CGRect bounds = [[UIScreen mainScreen] bounds];
    int width = (int)bounds.size.width;
    int height = (int)bounds.size.height;
    int gcdnumber = gcd (width,height);
    int ratioW = (int)width/gcdnumber;
    int ratioH = (int)height/gcdnumber;
    
	NSString *post = [NSString stringWithFormat:@"&action=%@&appId=%@&deviceType=%@&orientationType=%@&sdkver=%@&model=%@&deviceid=%@&systemversion=%@&locale=%@&language=%@&top=%d&installkey=%@&macaddress=%@&iphone5=%@&network=%@&width=%d&height=%d"
					  ,@"httpsShowAd",self.key,self.deviceType,self.OrientationType,OPENCLIKSDKVER,model,deviceid,systemVersion,locale,language,top,installkey,deviceid,iphone5,ocnetworkType,ratioW,ratioH];
	//NSLog(@"%@  is %@ is",locale,post);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if([model isEqualToString:@"iPod1,1"] || [model isEqualToString:@"iPod2,1"] ||[model isEqualToString:@"iPhone1,1"] || [model isEqualToString:@"iPhone1,2"] )
        //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.openclik.com/openclik/openclikAction.do"]]];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.133:8080/openclik/openclikAction.do"]]];
    else
        //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.openclik.com/openclik/openclikAction.do"]]];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.133:8080/openclik/openclikAction.do"]]];
	//[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.112:8080/openclik/openclikAction.do"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
	[request setHTTPBody:postData];
	//[request setValidatesSecureCertificate:NO];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	receiveData = [[NSMutableData data] retain];
		

	_adBannerView.opaque = NO;
	_adBannerView.backgroundColor = [UIColor clearColor];
    _adBannerView.allowsInlineMediaPlayback = YES;
    _adBannerView.mediaPlaybackRequiresUserAction = NO;
    
    _adTopView.opaque = NO;
	_adTopView.backgroundColor = [UIColor clearColor];
    _adTopView.allowsInlineMediaPlayback = YES;
    _adTopView.mediaPlaybackRequiresUserAction = NO;
	
	_adFullView.opaque = NO;
	_adFullView.backgroundColor = [UIColor clearColor];
    _adFullView.allowsInlineMediaPlayback = YES;
    _adFullView.mediaPlaybackRequiresUserAction = NO;
    
    _adIconView.opaque = NO;
	_adIconView.backgroundColor = [UIColor clearColor];
    _adIconView.allowsInlineMediaPlayback = YES;  
    _adIconView.mediaPlaybackRequiresUserAction = NO;

    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        _adBannerView.mediaPlaybackAllowsAirPlay = NO;
        _adTopView.mediaPlaybackAllowsAirPlay = NO;
        _adFullView.mediaPlaybackAllowsAirPlay = NO;
        _adIconView.mediaPlaybackAllowsAirPlay = NO;
    }


    
	_adFullView.scalesPageToFit = YES;
    self.adFullView.scalesPageToFit =YES;
	
	
//##################
// only for test
	
	//NSString *adRequestURL = @"http://openclik.com/ads/iphoneHB.html";
	//NSString *fulladRequestURL =@"http://openclik.com/ads/iphoneFULL.html";
   // NSURLRequest *requestAdURL = [NSURLRequest requestWithURL:[NSURL URLWithString:adRequestURL]];
	//NSURLRequest *requestFullURL = [NSURLRequest requestWithURL:[NSURL URLWithString:fulladRequestURL]];
	//[_adBannerView loadRequest:requestAdURL];
	//[_adFullView loadRequest:requestFullURL];
    
    //clean installkey
    [appPasteBoard setValue:@"" forPasteboardType:@"public.utf8-plain-text"];
    //NSLog(@"clear install key:%@",@"");


}
-(int) getReverseWidth:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		if ([self ShellIsiPad])  {
			return 768;
		}
        else {
			return 320;
		}
	}
	else {
		if ([self ShellIsiPad])  {
			return 1024;
		}
        else {
            if (iPhone5) 
                return 568;
            else
                return 480;
		}
	}

}
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
	//toInterfaceOrientation = 3;
	
	 
    if (_adBannerView != nil) 
	{        
			CGRect adBannerViewFrame = [_adBannerView frame];
            //[_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier480x32];
			if (_adBannerViewIsVisible && _webADViewIsReady) 
			{
                [OpenClikViewController getInstance].view.hidden = NO;
				[UIView beginAnimations:@"fixupAdfViews" context:nil];
	
                [UIView setAnimationDuration: 0.50];
    

				adBannerViewFrame.size.width = [self getBannerWidth:toInterfaceOrientation];
				adBannerViewFrame.size.height = [self getBannerHeight:toInterfaceOrientation];

                adBannerViewFrame.origin.x = 0;
                adBannerViewFrame.origin.y =  [self getReverseWidth:toInterfaceOrientation]-[self getBannerHeight:toInterfaceOrientation];
				[_adBannerView setFrame:adBannerViewFrame];
				 [UIView commitAnimations];
				
			} else 
			{
                //NSLog(@"%f,%f",adBannerViewFrame.origin.x,adBannerViewFrame.origin.y);
                [UIView beginAnimations:@"fixupAdhViews" context:nil];
				adBannerViewFrame.origin.x = 0;
                adBannerViewFrame.origin.y = [self getReverseWidth:toInterfaceOrientation] + [self getBannerHeight:toInterfaceOrientation];
                [UIView setAnimationDuration: 0.6];
					//NSLog(@"bottom y is %d",adBannerViewFrame.origin.y);

				adBannerViewFrame.size.width = [self getBannerWidth:toInterfaceOrientation];
				adBannerViewFrame.size.height = [self getBannerHeight:toInterfaceOrientation];
				
				
				[_adBannerView setFrame:adBannerViewFrame];
				[UIView commitAnimations];
			}
    }   
    if (_adTopView != nil) 
	{        
        CGRect adTopViewFrame = [_adTopView frame];
        //[_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier480x32];
        if (_adTopViewIsVisible && _webTopViewIsReady) 
        {
            [OpenClikViewController getInstance].view.hidden = NO;
            [UIView beginAnimations:@"fixupAdfViews" context:nil];
            [UIView setAnimationDuration: 0.50];
            
            adTopViewFrame.size.width = [self getBannerWidth:toInterfaceOrientation];
            adTopViewFrame.size.height = [self getBannerHeight:toInterfaceOrientation];
           
            adTopViewFrame.origin.x = 0;
            adTopViewFrame.origin.y = 0;
        
            [_adTopView setFrame:adTopViewFrame];
            [UIView commitAnimations];
            
        } else 
        {
            //NSLog(@"%f,%f",adBannerViewFrame.origin.x,adBannerViewFrame.origin.y);
            [UIView beginAnimations:@"fixupAdhViews" context:nil];
            adTopViewFrame.origin.x = 0;
            adTopViewFrame.origin.y = - [self getBannerHeight:toInterfaceOrientation];
                //NSLog(@"top y is %d",adBannerViewFrame.origin.y);
            [UIView setAnimationDuration: 0.6];
           
            
            adTopViewFrame.size.width = [self getBannerWidth:toInterfaceOrientation];
            adTopViewFrame.size.height = [self getBannerHeight:toInterfaceOrientation];
            
            
            [_adTopView setFrame:adTopViewFrame];
            [UIView commitAnimations];
        }
    }
	if (_adFullView != nil) 
	{        
		CGRect adFullViewFrame = [_adFullView frame];
		
		
		//[_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier480x32];
		if (_adFullViewIsVisible && _webFullViewIsReady) 
		{
            [OpenClikViewController getInstance].view.hidden = NO;
            _adFullView.hidden = NO;
			//NSLog(@"start pos x is %f,y is %f",adFullViewFrame.origin.x,adFullViewFrame.origin.y);
			[UIView beginAnimations:@"fixupFullsViews" context:nil];
			[UIView setAnimationDuration: 0.77];
			
			adFullViewFrame.size.width = [self getFullWidth:toInterfaceOrientation];
			adFullViewFrame.size.height = [self getFullHeight:toInterfaceOrientation];
			
			if ([self ShellIsiPad]) 
			{
				if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
					adFullViewFrame.origin.x = 128;
					adFullViewFrame.origin.y = 128;
				}
				else {
					adFullViewFrame.origin.x = 128;
					adFullViewFrame.origin.y = 166;
				}

			}
			else {
				if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
					adFullViewFrame.origin.x = 0;
					adFullViewFrame.origin.y = 0;
				}
				else {
                    //iphone5
                    if (iPhone5) {
                        adFullViewFrame.origin.x = 0;
                        adFullViewFrame.origin.y = 0;
                    }
                    else
                    {
                        adFullViewFrame.origin.x = 0;
                        adFullViewFrame.origin.y = 24;
                    }
					
				}


			}

			[_adFullView setFrame:adFullViewFrame];
		
			
			[UIView commitAnimations];
	
			//NSLog(@"start pos x is %f,y is %f",adFullViewFrame.origin.x,adFullViewFrame.origin.y);
						
		} else 
		{
			if ([self ShellIsiPad]) 
			{
				if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
					adFullViewFrame.origin.x = 256;
				}
				else {
					adFullViewFrame.origin.x = 128;
				}
				
			}
			else {
				if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
					adFullViewFrame.origin.x = 121;
				}
				else {
					adFullViewFrame.origin.x = 0;
                    //NSLog(@"adFullViewFrame.origin.x is%f",adFullViewFrame.origin.x);
				}
				
				
			}
			
			adFullViewFrame.size.width = [self getFullWidth:toInterfaceOrientation];
			adFullViewFrame.size.height = [self getFullHeight:toInterfaceOrientation];
			adFullViewFrame.origin.y = [self getReverseWidth:toInterfaceOrientation] + [self getFullHeight:toInterfaceOrientation];
			adFullViewFrame.origin.x = ([self getBannerWidth:toInterfaceOrientation] - adFullViewFrame.size.width) /2;
			[UIView beginAnimations:@"fixupFullhViews" context:nil];
			[UIView setAnimationDuration:1.1];
			[_adFullView setFrame:adFullViewFrame];
			[UIView commitAnimations];
		}
    }
    
    if (_adIconView != nil)
	{
		CGRect adIconViewFrame = [_adIconView frame];
        int iconSize =0;
        if ([self ShellIsiPad])
        {
            iconSize= 92;
        }
        else
        {
            iconSize = 67;
        }
        adIconViewFrame.size.width= iconSize;
        adIconViewFrame.size.height = iconSize;

		int screenwidth = 0;
        int screenheight = 0;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            if ([self ShellIsiPad])
            {
                screenwidth = 1024;
                screenheight = 768;
            }
            else
            {
                if (iPhone5)
                {
                    screenwidth = 480+88;
                    screenheight = 320;
                }
                else
                {
                    screenwidth = 480;
                    screenheight = 320;
                }
            }
        }
        else
        {
            if ([self ShellIsiPad])
            {
                screenwidth = 768;
                screenheight = 1024;
            }
            else
            {
                if (iPhone5)
                {
                    screenwidth = 320;
                    screenheight = 480+88;
                }
                else
                {
                    screenwidth = 320;
                    screenheight = 480;
                }
            }
        }
		
		//[_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier480x32];
		if (_adIconViewIsVisible && _webIconViewIsReady)
		{
            [OpenClikViewController getInstance].view.hidden = NO;
            _adIconView.hidden = NO;
			//NSLog(@"start pos x is %f,y is %f",adFullViewFrame.origin.x,adFullViewFrame.origin.y);
			[UIView beginAnimations:@"fixupIconViews" context:nil];
			[UIView setAnimationDuration: 0.77];
			
            if(self.iconLocation == iconTopLeft)
            {
                adIconViewFrame.origin.x = 0;
                adIconViewFrame.origin.y = 0;
			}
            if(self.iconLocation == iconTopRight)
            {
                adIconViewFrame.origin.x = screenwidth-iconSize;
                adIconViewFrame.origin.y = 0;
			}
            
            if(self.iconLocation == iconBottomLeft)
            {
                adIconViewFrame.origin.x = 0;
                adIconViewFrame.origin.y = screenheight-iconSize;
			}
            if(self.iconLocation == iconBottomRight)
            {
                adIconViewFrame.origin.x = screenwidth-iconSize;
                adIconViewFrame.origin.y = screenheight-iconSize;
			}
            
            
			[_adIconView setFrame:adIconViewFrame];
            
			
			[UIView commitAnimations];
            
			//NSLog(@"start pos x is %f,y is %f",adFullViewFrame.origin.x,adFullViewFrame.origin.y);
            
		}
        else 
		{
			if(self.iconLocation == iconTopLeft)
            {
                adIconViewFrame.origin.x = 0;
                adIconViewFrame.origin.y = -200;
			}
            if(self.iconLocation == iconTopRight)
            {
                adIconViewFrame.origin.x = screenwidth-iconSize;
                adIconViewFrame.origin.y = -200;
			}
            
            if(self.iconLocation == iconBottomLeft)
            {
                adIconViewFrame.origin.x = 0;
                adIconViewFrame.origin.y = 1024; 
			}
            if(self.iconLocation == iconBottomRight)
            {
                adIconViewFrame.origin.x = screenwidth-iconSize;
                adIconViewFrame.origin.y = 1024;
			}
            
			[UIView beginAnimations:@"fixupIconViews" context:nil];
			[UIView setAnimationDuration:1.1];
			[_adIconView setFrame:adIconViewFrame];
			[UIView commitAnimations];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	//NSLog(@"receive data");
	[receiveData appendData:data];
	
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//NSLog(@"connection error %@",error );
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //only request ad connection handle and skip click conenction
    if (_connection != connection)
        return ;
    //i++;
	NSString *responseURL = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
	//NSLog(@"response url is %@",responseURL);
	//[responseURL JSONValue];
	NSArray *response = [responseURL componentsSeparatedByString:@"|||"];

	if ([response count] <2 ) {
		self.adRequestURL = [response objectAtIndex:0];
        [[OpenClikViewController getInstance] hide];
        [OpenClikViewController getInstance].view.hidden = YES;

        return;
	}
	else if ([response count] <3 ) {
		self.adRequestURL = [response objectAtIndex:0];
		self.fulladRequestURL = [response objectAtIndex:1];
        [[OpenClikViewController getInstance] hide];
        [OpenClikViewController getInstance].view.hidden = YES;

        return ;
	}
	else if ([response count] <4 ) {
		self.adRequestURL = [response objectAtIndex:0];
		self.fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
        return ;
		
	}
	else if ([response count] <5 ) {
		self.adRequestURL = [response objectAtIndex:0];
		self.fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		self.adId = [response objectAtIndex:3];
        [[OpenClikViewController getInstance] hide];
        [OpenClikViewController getInstance].view.hidden = YES;
        return ;
		//NSLog(@"requestURL is%@,fulladRequestURL is %@,appStoreURL is %@,adId is %@",adRequestURL,fulladRequestURL ,self.appStoreURL,self.adId);
		
	}
	else if ([response count] <6 ) {
		self.adRequestURL = [response objectAtIndex:0];
		self.fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		self.adId = [response objectAtIndex:3];
        NSString *keyTop = [response objectAtIndex:4];
        NSRange range = [keyTop rangeOfString:@"_"];
        self.secureKey = [keyTop substringToIndex:range.location];
        self.topadRequestURL = [keyTop substringFromIndex:range.location+1];
        [[OpenClikViewController getInstance] hide];
        [OpenClikViewController getInstance].view.hidden = YES;
        return ;
        //NSArray *keytopArr = [keyTop componentsSeparatedByString:@"_"];
		//self.secureKey = [keytopArr objectAtIndex:0];
        //topadRequestURL = [keytopArr objectAtIndex:1];
        
		//NSLog(@"requestURL is%@,fulladRequestURL is %@,appStoreURL is %@,adId is %@",adRequestURL,fulladRequestURL ,self.appStoreURL,self.adId);
		
	}
    
    else if ([response count] <7 ) {
		_adRequestURL = [response objectAtIndex:0];
		_fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		self.adId = [response objectAtIndex:3];
        self.adAppId = [response objectAtIndex:4];
        NSString *keyTop = [response objectAtIndex:5];
        NSRange range = [keyTop rangeOfString:@"_"];
        self.secureKey = [keyTop substringToIndex:range.location];
        _topadRequestURL = [keyTop substringFromIndex:range.location+1];
        [[OpenClikViewController getInstance] hide];
        [OpenClikViewController getInstance].view.hidden = YES;
        return;
        //NSArray *keytopArr = [keyTop componentsSeparatedByString:@"_"];
		//self.secureKey = [keytopArr objectAtIndex:0];
        //topadRequestURL = [keytopArr objectAtIndex:1];
        
		//NSLog(@"requestURL is%@,fulladRequestURL is %@,appStoreURL is %@,adId is %@",adRequestURL,fulladRequestURL ,self.appStoreURL,self.adId);
		
	}
    else if ([response count] <8 ) {
		self.adRequestURL = [response objectAtIndex:0];
		self.fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		self.adId = [response objectAtIndex:3];
        self.adAppId = [response objectAtIndex:4];
        NSString *keyTop = [response objectAtIndex:5];
        NSRange range = [keyTop rangeOfString:@"_"];
        self.secureKey = [keyTop substringToIndex:range.location];
        self.topadRequestURL = [keyTop substringFromIndex:range.location+1];
        self.appUrl = [response objectAtIndex:6];
        [[OpenClikViewController getInstance] hide];
        [OpenClikViewController getInstance].view.hidden = YES;
        return ;
        //iconadRequestURL = @"http://openclik.com/openclik/iphoneICON.html";
        //NSArray *keytopArr = [keyTop componentsSeparatedByString:@"_"];
		//self.secureKey = [keytopArr objectAtIndex:0];
        //topadRequestURL = [keytopArr objectAtIndex:1];
        
		//NSLog(@"requestURL is%@,fulladRequestURL is %@,appStoreURL is %@,adId is %@",adRequestURL,fulladRequestURL ,self.appStoreURL,self.adId);
		
	}
    
    else if ([response count] <9 ) {
		self.adRequestURL = [response objectAtIndex:0];
		self.fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		self.adId = [response objectAtIndex:3];
        self.adAppId = [response objectAtIndex:4];
        NSString *keyTop = [response objectAtIndex:5];
        NSRange range = [keyTop rangeOfString:@"_"];
        self.secureKey = [keyTop substringToIndex:range.location];
        self.topadRequestURL = [keyTop substringFromIndex:range.location+1];
        self.appUrl = [response objectAtIndex:6];
        self.iconadRequestURL = [response objectAtIndex:7];
        //NSLog(@"icon is %@",iconadRequestURL);
        //NSArray *keytopArr = [keyTop componentsSeparatedByString:@"_"];
		//self.secureKey = [keytopArr objectAtIndex:0];
        //topadRequestURL = [keytopArr objectAtIndex:1];
        
		//NSLog(@"requestURL is%@,fulladRequestURL is %@,appStoreURL is %@,adId is %@",adRequestURL,fulladRequestURL ,self.appStoreURL,self.adId);
	}
    _receiveResponse = YES;
    [self loadWebView];
   	
	
	//NSLog("%s",responseUrl);
}
-(void)loadWebView
{
    if (!self.receiveResponse) {
        return;
    }
    _resourcePath = [[NSBundle mainBundle] resourcePath];
    _resourcePath = [_resourcePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    _resourcePath = [_resourcePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //NSLog(@"icon ad url is %@",self.iconadRequestURL);
    if(![_adBannerView isLoading] && _requestBottom)
        [_adBannerView loadHTMLString:self.adRequestURL baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",_resourcePath]]];
    if(![_adFullView isLoading] && _requestInterstitial)
        [_adFullView loadHTMLString:self.fulladRequestURL baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",_resourcePath]]];
    if(![_adTopView isLoading] && _requestTop)
        [_adTopView loadHTMLString:self.topadRequestURL baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",_resourcePath]]];
    if(![_adIconView isLoading] && _requestIcon)
        [_adIconView loadHTMLString:self.iconadRequestURL baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",_resourcePath]]];
    //[_adIconView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:iconadRequestURL]]];
	self.adBannerView.delegate = self;
	self.adFullView.delegate = self;
    self.adTopView.delegate = self;
    self.adIconView.delegate = self;

}

-(void)timeOpenAppStore
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appStoreURL]];
    
    ocviewsender=0;

	//NSLog(@"appStoreURL is %@",self.appStoreURL);
	
}
#pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
		{
            _adIsReady = YES;
            if (webView == _adBannerView) {
				_webADViewIsReady = YES;
				if (_adBannerViewIsVisible)
				{        
					[self fixupAdView:_orientation];
				}
				
			}
            if (webView == _adTopView) {
				_webTopViewIsReady = YES;
				if (_adTopViewIsVisible)
				{        
					[self fixupAdView:_orientation];
				}
				
			}
			if (webView == _adFullView) {
				_webFullViewIsReady = YES;
				if (_adFullViewIsVisible)
				{        
					[self fixupAdView:_orientation];
				}
            }
            if (webView == _adIconView) {
				_webIconViewIsReady = YES;
				if (_adIconViewIsVisible)
				{
					[self fixupAdView:_orientation];
				}
            }
		}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
		 { 
			 if (webView == _adBannerView) {
				 if (_adBannerViewIsVisible)
				 {        
					 _adBannerViewIsVisible = NO;
					 [self fixupAdView:_orientation];
				 }
			 }
             if (webView == _adTopView) {
				 if (_adTopViewIsVisible)
				 {        
					 _adTopViewIsVisible = NO;
					 [self fixupAdView:_orientation];
				 }
			 }
			 if (webView == _adFullView) {
				 if (_adFullViewIsVisible)
				 { 
					 _adFullViewIsVisible = NO;
					 [self fixupAdView:_orientation];
				 }
			 }
		 }

-(void)touchView:(UITouch*)touch touchView:(UIView*)view
{
    CGPoint touchPoint = [touch locationInView:view];
    if (touchPoint.x<0 || touchPoint.y<0 || ocviewsender>1) {
        return;
    }
    ocviewsender++;
    int touchX=0;
    int touchY=0;
    if ([self ShellIsiPad]) {
        touchX = 768;
        touchY = 120;
    }
    else
    {
        if (iPhone5)
            touchX = 568;
        else
            touchX = 480;
        if (iPhone5)
        {
            if(UIInterfaceOrientationIsLandscape(_orientation) )
                touchY = 75;
            else
                touchY = 100;
        }
        else
            touchY = 75;
    }
	if (touchPoint.x>0 && touchPoint.x<touchX && touchPoint.y>0 && touchPoint.y<touchY && view ==_adFullView) {
		_adFullView.hidden = true;
        //if(_adBannerViewIsVisible || _adTopViewIsVisible)
        {
            [[OpenClikViewController getInstance] hide];
            [OpenClikViewController getInstance].view.hidden = YES;
            ocviewsender = 0 ;
        }
        
	}
	else {
        if((_adBannerViewIsVisible || _adTopViewIsVisible) && _adFullViewIsVisible)
        {
            [[OpenClikViewController getInstance] hide];
            [OpenClikViewController getInstance].view.hidden = YES;
        }
		[self hide];
		//NSLog(@"user language is %@,Locale is %@" , language,locale);
		NSString *model = [[UIDevice currentDevice] model];
		model = [self platform];
		NSString *language = @"";
		NSString *locale = @"";
		if ([model isEqualToString:@"Simulator"]) {
			language = @"en";
			locale = @"US";
		}
        else
		{
			language = [[NSLocale preferredLanguages] objectAtIndex:0];
			locale = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:[[NSLocale currentLocale] localeIdentifier]];
		}
        
        // Get the string representation of CFUUID object.
        long currnettime = CFAbsoluteTimeGetCurrent();
        NSString *installkey = [NSString  stringWithFormat:@"%ld",currnettime];
        UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:self.adAppId
                                                                create:YES];
        [appPasteBoard setValue:installkey forPasteboardType:@"public.utf8-plain-text"];
        //NSLog(@"UIPasteboard pasteboardWithName:%@",self.adAppId);
        //NSLog(@"set install key:%@",installkey);
        NSString *deviceid=[self uniqueGlobalDeviceIdentifier ];
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
		NSString *post = [NSString stringWithFormat:@"&action=%@&appId=%@&adId=%@&deviceType=%@&orientationType=%@&fullScreen=%@&locale=%@&language=%@&securekey=%@&model=%@&deviceid=%@&installkey=%@&macaddress=%@&sdkver=%@&systemversion=%@&network=%@",@"httpsClickAd",self.key,self.adId,self.deviceType,self.OrientationType,self.adType,locale,language,self.secureKey,model,deviceid,installkey,[self uniqueGlobalDeviceIdentifier],OPENCLIKSDKVER,systemVersion,ocnetworkType];
		
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        if([model isEqualToString:@"iPod Touch 1G"] || [model isEqualToString:@"iPod Touch 2G"] ||[model isEqualToString:@"iPhone 1G"] || [model isEqualToString:@"iPhone 3G"] )
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.openclik.com/openclik/openclikAction.do"]]];
        else
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.openclik.com/openclik/openclikAction.do"]]];
        
		//[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.133:8080/openclik/openclikAction.do"]]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
		[request setHTTPBody:postData];
		//[request setValidatesSecureCertificate:NO];
		//NSError        *error = nil;
		//NSURLResponse  *response = nil;
		[NSURLConnection connectionWithRequest:request delegate:self];
		[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(timeOpenAppStore) userInfo:nil repeats:NO];
		//[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	}
}
- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
    [self touchView:touch touchView:sender];
}
- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
}
-(BOOL)ShellIsiPad
{
	NSArray* deviceFamily = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIDeviceFamily"];
	if (deviceFamily == nil)
	{
		return false;
	}
	
	bool supportediPhone = false;
	bool supportediPad = false;
	
	for(int i = 0; i < [deviceFamily count]; i++)
	{
		NSNumber* value = (NSNumber*)[deviceFamily objectAtIndex:i];
		int item = [value intValue];
		
		if (item == 1)
		{
			supportediPhone = true;
		}
		if (item == 2)
		{
			supportediPad = true;
		}
	}
	
	// iphone
	if (!supportediPad)
	{
		return false;
	}
	
	// just ipad
	if (!supportediPhone)
	{
		return true;
	}
	
	// both iphone and ipad
	const char* currentDeviceModel = [[[UIDevice currentDevice] model] UTF8String];
	char device_model[128];
	strncpy(device_model, currentDeviceModel, 4) [4] = 0;
	if (0 == strcmp(device_model, "iPad"))
	{
		return true;
	}
	
	return false;
}
- (NSString *) stringFromMD5:(NSString*)inString{
    
    const char *value = [inString UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = @"";
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.0)
        macaddress = [self macaddress];
    else
        macaddress = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *uniqueIdentifier = [self stringFromMD5:macaddress ];
    return uniqueIdentifier;
}

@end
