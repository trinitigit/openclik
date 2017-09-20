//
//  OpenClikWebView.h
//  OpenCli Framework
//
//  Created by  OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface OpenClikWebView : UIWebView
@end
@protocol UIWebViewTappingDelegate <NSObject>
- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end