//
//  OpenClikViewController.h
//  OpenClik Framework
//
//  Created by OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenClikViewController : UIViewController <UIPopoverControllerDelegate>  {
    BOOL _adStop;
@private   
    BOOL openclikadbanner;
    BOOL openclikadfull;
    BOOL openclikadtop;
    UIPopoverController *_popover;
}
-(id)initWith:(NSString*)key;
-(void)setKey:(NSString*)key;
-(void)setTop;
-(void)show:(int)adType;
-(void)hide;
+(OpenClikViewController*)getInstance;
-(BOOL)IsAdReady;
-(void)refresh;
-(enum OpenClikShareType)share;
typedef enum OpenClikADType 
{
    openclikbanner = 0, //["Obsolete,Please Use bannerbottom instead"]
    bannerbottom = 0,
    openclikfull = 1,  //["Obsolete,Please Use interstitial instead"]
    interstitial = 1,
    opencliktop = 2, //["Obsolete,Please Use bannertop instead"]
    bannertop = 2
} OpenClikAdType;

typedef enum OpenClikShareType
{
    opencliksharemessage = 0,
    openclikshareemail = 1,
    opencliksharetwitter = 2,
    opencliksharefacebook = 3,
    openclikshareweibo = 4,
    opencliksharefail = 5
} OpenClikShareType;
@property (nonatomic) BOOL adStop;
@end
