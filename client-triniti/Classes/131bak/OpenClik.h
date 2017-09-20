//
//  OpenClik.h
//  OpenClik Framework
//
//  Created by  OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenClikWebView.h"
@interface OpenClik : NSObject <UIWebViewDelegate,UIWebViewTappingDelegate,UIGestureRecognizerDelegate> {
	OpenClikWebView *_adBannerView;
	OpenClikWebView *_adFullView;
    OpenClikWebView *_adTopView;
	BOOL _adBannerViewIsVisible;
	BOOL _adFullViewIsVisible;
    BOOL _adTopViewIsVisible;
	BOOL _top;
	NSMutableData *receiveData;
	NSString *_appStoreURL;
	NSString *_adId;
	NSString *_key;
	NSString *_adType;
	NSString *_OrientationType;
	NSString *_deviceType;
	NSString *_secureKey;
	BOOL _webADViewIsReady;
	BOOL _webFullViewIsReady;
    BOOL _webTopViewIsReady;
	UIInterfaceOrientation _orientation;
    BOOL _adIsReady;
    NSString *_adAppId;
    NSURLConnection *_connection;
    NSString *_appUrl;

}
@property (nonatomic, retain) OpenClikWebView *adBannerView;
@property (nonatomic, retain) OpenClikWebView *adFullView;
@property (nonatomic, retain) OpenClikWebView *adTopView;
@property (nonatomic) BOOL adBannerViewIsVisible;
@property (nonatomic) BOOL adFullViewIsVisible;
@property (nonatomic) BOOL adTopViewIsVisible;
@property (nonatomic, retain) NSString *appStoreURL;
@property (nonatomic, retain) NSString *adId;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *adType;
@property (nonatomic, retain) NSString *OrientationType;
@property (nonatomic, retain) NSString *deviceType;
@property (nonatomic, retain) NSString *secureKey;
@property (nonatomic) BOOL top;
@property (nonatomic) UIInterfaceOrientation orientation;
@property (nonatomic) BOOL adIsReady;
@property (nonatomic, retain) NSString *adAppId;
@property (nonatomic, retain) NSString *appUrl;
-(id)initWithKey:(NSString*)key;
-(id)initWithKey:(NSString*)key orientation:(UIInterfaceOrientation)orientation;
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)createAdBannerView;
-(void)setTop:(BOOL)top;
-(BOOL)getTop;
-(int)getBannerWidth:(UIInterfaceOrientation)orientation;
- (int)getBannerHeight:(UIInterfaceOrientation)orientation;
-(void)hide;
-(void)show;
-(void)timeOpenAppStore;
-(BOOL)ShellIsiPad;
- (NSString *) platform;
- (NSString *) stringFromMD5:(NSString*)inString;
- (NSString *) uniqueGlobalDeviceIdentifier;
- (NSString *) macaddress;
-(void)touchView:(UITouch*)touch touchView:(UIView*)view;
//http://192.168.2.112:8080/openclik/openclikAction.do?action=showAd&appId=eef00fcb-4dbe-4a87-9952-4382aca6b7c7
//lipo -create Release-iphoneos/libopenclik.a  Release-iphonesimulator/libopenclik.a -o libopenclik.a
@end
