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
@implementation OpenClik
@synthesize adBannerView = _adBannerView;
@synthesize adFullView = _adFullView;
@synthesize adTopView = _adTopView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;
@synthesize adFullViewIsVisible = _adFullViewIsVisible;
@synthesize adTopViewIsVisible = _adTopViewIsVisible;
@synthesize top = _top;
@synthesize appStoreURL = _appStoreURL;
@synthesize adId = _adId;
@synthesize adType = _adType;
@synthesize key = _key;
@synthesize deviceType = _deviceType;
@synthesize OrientationType = _OrientationType;
@synthesize secureKey = _secureKey;
@synthesize orientation = _orientation;

#define OPENCLIKSDKVER @"1.1.6"

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
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
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
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
	if ([platform isEqualToString:@"x86_64"])         return @"Simulator";
    free(machine);
	return platform;
}

-(id)initWithKey:(NSString*)key
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
        self.adBannerView = [[OpenClikWebView alloc] initWithFrame:CGRectMake(2500, 2500, 1024, 1024)];
        self.adFullView = [[OpenClikWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        self.adTopView = [[OpenClikWebView alloc] initWithFrame:CGRectMake(-100, 0, 1024, 1024)];
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
		if (UIInterfaceOrientationIsLandscape(orientation))  {
			return 480;
		}
		else {
			return 320;
		}
		
	}
}
- (int)getFullHeight:(UIInterfaceOrientation)orientation {
	if ([self ShellIsiPad])  
	{
		//ipad full are 692 , banner are 66; 
		return 692;

	}
	else {
		//iphone 
		if (UIInterfaceOrientationIsLandscape(orientation))  {
			return 320;
		}
		else {
			return 432;
		}
		
	}
}

-(int)getFullWidth:(UIInterfaceOrientation)orientation {
	if ([self ShellIsiPad])  
	{
		
		//ipad 
		return 512;
	}
	else {
		//iphone 
		if (UIInterfaceOrientationIsLandscape(orientation))  {
			return 238;
		}
		else {
			return 320;
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
    _adFullViewIsVisible = NO;
	_adBannerViewIsVisible = NO;
    _adTopViewIsVisible = NO;
	[self fixupAdView:_orientation];
}
-(void)resizeView
{
	[self fixupAdView:_orientation];
}
-(void)show
{
    [self hide];
    
	[NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(resizeView) userInfo:nil repeats:NO];
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

    
}

- (void)createAdBannerView {
	
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
    // check install
    UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:@"openclikInstall"
                                                            create:YES];
	NSString *installkey = [appPasteBoard  valueForPasteboardType:@"public.utf8-plain-text"];
    if(installkey==nil)
        installkey = @"";
    int top=0;
	if(_top)
        top=1;
	NSString *post = [NSString stringWithFormat:@"&action=%@&appId=%@&deviceType=%@&orientationType=%@&sdkver=%@&model=%@&deviceid=%@&systemversion=%@&locale=%@&language=%@&top=%d&installkey=%@"
					  ,@"httpsShowAd",self.key,self.deviceType,self.OrientationType,OPENCLIKSDKVER,model,deviceid,systemVersion,locale,language,top,installkey];
	//NSLog(@"%@  is %@ is",locale,language);
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if([model isEqualToString:@"iPod Touch 1G"] || [model isEqualToString:@"iPod Touch 2G"] ||[model isEqualToString:@"iPhone 1G"] || [model isEqualToString:@"iPhone 3G"] )
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.openclik.com/openclik/openclikAction.do"]]];
        //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.112:8080/openclik/openclikAction.do"]]];
    else
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.openclik.com/openclik/openclikAction.do"]]];
        //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.112:8080/openclik/openclikAction.do"]]];
	//[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.112:8080/openclik/openclikAction.do"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
	[request setHTTPBody:postData];
	//[request setValidatesSecureCertificate:NO];
	NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	receiveData = [[NSMutableData data] retain];
    //receiveData = [NSMutableData data];
	if(conn)
	{
		//NSLog(@"Connection openClik Successful");
	}
	else
	{
		//NSLog(@"Connection could not be made");
	}
		

	_adBannerView.opaque = NO;
	_adBannerView.backgroundColor = [UIColor clearColor];
    
    _adTopView.opaque = NO;
	_adTopView.backgroundColor = [UIColor clearColor];
	
	_adFullView.opaque = NO;
	_adFullView.backgroundColor = [UIColor clearColor];

	
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
    
	_adBannerView.delegate = self;
	_adFullView.delegate = self;
	




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
                adBannerViewFrame.origin.y = [self getReverseWidth:toInterfaceOrientation]-[self getBannerHeight:toInterfaceOrientation];
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
			[UIView setAnimationDuration: 0.8];
			
			adFullViewFrame.size.width = [self getFullWidth:toInterfaceOrientation];
			adFullViewFrame.size.height = [self getFullHeight:toInterfaceOrientation];
			
			if ([self ShellIsiPad]) 
			{
				if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
					adFullViewFrame.origin.x = 256;
					adFullViewFrame.origin.y = 38;
				}
				else {
					adFullViewFrame.origin.x = 128;
					adFullViewFrame.origin.y = 166;
				}

			}
			else {
				if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
					adFullViewFrame.origin.x = 121;
					adFullViewFrame.origin.y = 0;
				}
				else {
					adFullViewFrame.origin.x = 0;
					adFullViewFrame.origin.y = 24;
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
	NSString *responseURL = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
	//NSLog(@"response url is %@",responseURL);
	//[responseURL JSONValue];
	NSArray *response = [responseURL componentsSeparatedByString:@"||"];
	NSString *adRequestURL =nil;
	NSString *fulladRequestURL=nil;
    NSString *topadRequestURL = nil;
	if ([response count] <2 ) {
		adRequestURL = [response objectAtIndex:0];
	}
	else if ([response count] <3 ) {
		adRequestURL = [response objectAtIndex:0];
		fulladRequestURL = [response objectAtIndex:1];
	}
	else if ([response count] <4 ) {
		adRequestURL = [response objectAtIndex:0];
		fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		
	}
	else if ([response count] <5 ) {
		adRequestURL = [response objectAtIndex:0];
		fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		self.adId = [response objectAtIndex:3];
		//NSLog(@"requestURL is%@,fulladRequestURL is %@,appStoreURL is %@,adId is %@",adRequestURL,fulladRequestURL ,self.appStoreURL,self.adId);
		
	}
	else if ([response count] <6 ) {
		adRequestURL = [response objectAtIndex:0];
		fulladRequestURL = [response objectAtIndex:1];
		self.appStoreURL = [response objectAtIndex:2];
		self.adId = [response objectAtIndex:3];
        NSString *keyTop = [response objectAtIndex:4];
        NSArray *keytopArr = [keyTop componentsSeparatedByString:@"_"];
		self.secureKey = [keytopArr objectAtIndex:0];
        topadRequestURL = [keytopArr objectAtIndex:1];
		//NSLog(@"requestURL is%@,fulladRequestURL is %@,appStoreURL is %@,adId is %@",adRequestURL,fulladRequestURL ,self.appStoreURL,self.adId);
		
	}


    NSURLRequest *requestAdURL = [NSURLRequest requestWithURL:[NSURL URLWithString:adRequestURL]];
	NSURLRequest *requestFullURL = [NSURLRequest requestWithURL:[NSURL URLWithString:fulladRequestURL]];
    NSURLRequest *requestTopURL = [NSURLRequest requestWithURL:[NSURL URLWithString:topadRequestURL]];
    if(![_adBannerView isLoading])
        [_adBannerView loadRequest:requestAdURL];
    if(![_adFullView isLoading])
        [_adFullView loadRequest:requestFullURL];
    if(![_adTopView isLoading])
       [_adTopView loadRequest:requestTopURL];
	_adBannerView.delegate = self;
	_adFullView.delegate = self;
    _adTopView.delegate = self;
	
	
	//NSLog("%s",responseUrl);
}

-(void)timeOpenAppStore
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appStoreURL]];

	//NSLog(@"appStoreURL is %@",self.appStoreURL);
	
}
#pragma mark UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
		{
            
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

- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{

	
	CGPoint touchPoint = [touch locationInView:_adFullView];
	if (touchPoint.x>0 && touchPoint.x<70 && touchPoint.y>0 && touchPoint.y<70) {
		_adFullView.hidden = true;
        //if(_adBannerViewIsVisible || _adTopViewIsVisible)
        {
            [[OpenClikViewController getInstance] hide];
            [OpenClikViewController getInstance].view.hidden = YES;
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
        CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
        
        // Get the string representation of CFUUID object.
        NSString *installkey = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
        UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:@"openclikInstall"
                                                                create:YES];
        [appPasteBoard setValue:installkey forPasteboardType:@"public.utf8-plain-text"];
        NSString *deviceid=[self uniqueGlobalDeviceIdentifier ];
		NSString *post = [NSString stringWithFormat:@"&action=%@&appId=%@&adId=%@&deviceType=%@&orientationType=%@&fullScreen=%@&locale=%@&language=%@&securekey=%@&model=%@&deviceid=%@&installkey=%@",@"httpsClickAd",self.key,self.adId,self.deviceType,self.OrientationType,self.adType,locale,language,self.secureKey,model,deviceid,installkey];
		
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        if([model isEqualToString:@"iPod Touch 1G"] || [model isEqualToString:@"iPod Touch 2G"] ||[model isEqualToString:@"iPhone 1G"] || [model isEqualToString:@"iPhone 3G"] )
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.openclik.com/openclik/openclikAction.do"]]];
        else
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.openclik.com/openclik/openclikAction.do"]]];
        
		//[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.112:8080/openclik/openclikAction.do"]]];
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
    NSString *macaddress = [self macaddress];
    NSString *uniqueIdentifier = [self stringFromMD5:macaddress ];
    
    return uniqueIdentifier;
}

@end
