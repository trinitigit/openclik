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
typedef enum OpenClikADType
{
    bannerbottom = 0,
    interstitial = 1,
    bannertop = 2
} OpenClikAdType;

typedef enum OpenClikShareType
{
    messagesSuccess = 0,
    mailSuccess = 1,
    twitterSuccess = 2,
    facebookSuccess = 3,
    weiboSuccess = 4,
    shareFailure = 5
} OpenClikShareType;
-(id)initWith:(NSString*)key;
-(void)setKey:(NSString*)key;
-(void)show:(int)adType;
-(void)hide;
+(OpenClikViewController*)getInstance;
-(BOOL)IsAdReady;
-(void)refresh;
-(void)share;
-(enum OpenClikShareType)didShareSend;
@property (nonatomic) BOOL adStop;
@end
