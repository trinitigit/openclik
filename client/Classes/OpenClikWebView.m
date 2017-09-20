//
//  OpenClikWebView.m
//  OpenCli Framework
//
//  Created by  OpenClik on 11-8-23.
//  Copyright 2011 OpenClik.com. All rights reserved.
//
#import <objc/runtime.h>
#import "OpenClikWebView.h"

@interface NSObject (UIWebViewTappingDelegate)
- (void)webView:(UIWebView*)sender zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender tappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

@interface OpenClikWebView (Private)
- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event;
@end

static BOOL hookInstalled = NO;
static Method targetMethod;
static Method newMethod;
static Class klass;
static UITouch *staticTouch;
@implementation OpenClikWebView (__TapHook)

- (void)__touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	//[self __touchesEnded:touches withEvent:event];
	/*
	id webView = [[self superview] superview];
	if (touches.count > 1) {
		if ([webView respondsToSelector:@selector(fireZoomingEndedWithTouches:event:)]) {
			[webView fireZoomingEndedWithTouches:touches event:event];
		}
		else {
			method_exchangeImplementations(newMethod,targetMethod); 
			[self touchesBegan:touches withEvent:event];
			method_exchangeImplementations(targetMethod, newMethod);
		}

	}
	else {
		if ([webView respondsToSelector:@selector(fireTappedWithTouch:event:)]) {
			[webView fireTappedWithTouch:[touches anyObject] event:event];
		}
		else {
			method_exchangeImplementations(newMethod,targetMethod); 
			[self touchesBegan:touches withEvent:event];
			method_exchangeImplementations(targetMethod, newMethod);
		}

	}*/
}

@end


static void installHook()
{
	if (hookInstalled) return;
	
	hookInstalled = YES;
   
	klass = objc_getClass("OpenClikWebView");
	targetMethod = class_getInstanceMethod(klass, @selector(touchesBegan:withEvent:));
	newMethod = class_getInstanceMethod(klass, @selector(__touchesBegan:withEvent:));
	method_exchangeImplementations(targetMethod, newMethod);
    
}

@implementation OpenClikWebView

- (void)initGesture
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = YES;
}
- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
		//installHook();
        [self initGesture];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		//installHook();
        [self initGesture];
    }
    return self;
}
- (void)handleSingleTap:(UITapGestureRecognizer *)gesture {
    //tap will be done in the gesture start ,give blank method for tap occurs
}

- (void)fireZoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:zoomingEndedWithTouches:event:)]) {
		[(NSObject*)self.delegate webView:self zoomingEndedWithTouches:touches event:event];
	}
}

- (void)fireTappedWithTouch:(UITouch*)touch event:(UIEvent*)event
{
	if ([self.delegate respondsToSelector:@selector(webView:tappedWithTouch:event:)]) {
		[(NSObject*)self.delegate webView:self tappedWithTouch:touch event:event];
	}
}

// UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  
    staticTouch = touch;
    return YES;
    //can not place here , it will cause drag bug
 
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(webView:tappedWithTouch:event:)]) {
		[(NSObject*)self.delegate webView:self tappedWithTouch:staticTouch event:nil];
	}
    return YES;
}
@end