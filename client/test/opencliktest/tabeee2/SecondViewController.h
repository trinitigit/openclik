//
//  SecondViewController.h
//  tabeee2
//
//  Created by MA21AS on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iphoneHB.h"
#import "iphoneHF.h"
#import "ipadHB.h"
#import "ipadHF.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SecondViewController : UIViewController

<MFMailComposeViewControllerDelegate>

{}

-(IBAction)sendTweet;

-(IBAction)email;

-(IBAction)toiphoneHB:(id)sender;
-(IBAction)toiphoneHF:(id)sender;
-(IBAction)toipadHB:(id)sender;
-(IBAction)toipadHF:(id)sender;

@end
