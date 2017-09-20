//
//  OpenClikViewController.h
//  OpenClik Framework
//
//  Created by OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define OPENCLIKSDKVER @"1.5.5"
@interface OpenClikViewController : UIViewController  {
    BOOL _isVisible;
@private   
    BOOL openclikadbanner;
    BOOL openclikadfull;
    BOOL openclikadtop;
    BOOL openclikadicon;
    int iconLocation;
    UIVisualEffect *blurEffect;
    UIVisualEffectView *_visualEffectView;
}
typedef enum OpenClikADType
{
    bannerBottom = 0,
    interstitial = 1,
    bannerTop = 2,
    iconTopLeft = 3,
    iconTopRight = 4,
    iconBottomLeft = 5,
    iconBottomRight = 6
} OpenClikAdType;


-(id)initWith:(NSString*)key;
-(void)setKey:(NSString*)key;
-(void)request:(int)adType;
-(void)show:(int)adType;
-(void)hide;
+(OpenClikViewController*)getInstance;
-(BOOL)IsAdReady;
-(void)refresh;

@property (nonatomic) BOOL isVisible;
@end
