//
//  OpenClikViewController.h
//  OpenClik Framework
//
//  Created by OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import <Chartboost/Chartboost.h>
// update for website down from 1.5.6 to 1.5.7
#define OPENCLIKSDKVER @"1.5.7"
@interface OpenClikViewController : UIViewController<ChartboostDelegate>  {
    BOOL _isVisible;
@private   
    BOOL openclikadbanner;
    BOOL openclikadfull;
    BOOL openclikadtop;
    BOOL openclikadicon;
    int iconLocation;
    NSString *_ockey;
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
-(NSString*)getAward;
-(void)refresh;
@property (nonatomic, retain) NSString *ockey;
@property (nonatomic) BOOL isVisible;

@end
