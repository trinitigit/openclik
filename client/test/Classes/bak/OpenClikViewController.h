//
//  OpenClikViewController.h
//  OpenClik Framework
//
//  Created by OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenClikViewController : UIViewController  {
    BOOL _adStop;
@private   
    BOOL openclikadbanner;
    BOOL openclikadfull;
    BOOL openclikadtop;
}
-(id)initWith:(NSString*)key;
-(void)setKey:(NSString*)key;
-(void)setTop;
-(void)show:(int)adType;
-(void)hide;
+(OpenClikViewController*)getInstance;
-(BOOL)IsAdReady;
typedef enum OpenClikADType 
{
    openclikbanner = 0, //["Obsolete,Please Use bannerbottom instead"]
    bannerbottom = 0,
    openclikfull = 1,  //["Obsolete,Please Use interstitial instead"]
    interstitial = 1,
    opencliktop = 2, //["Obsolete,Please Use bannertop instead"]
    bannertop = 2
} OpenClikAdType;
@property (nonatomic) BOOL adStop;
@end
