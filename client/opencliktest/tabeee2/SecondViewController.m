//
//  SecondViewController.m
//  tabeee2
//
//  Created by MA21AS on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "Twitter/Twitter.h"

@implementation SecondViewController

-(IBAction)email {
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]) {
        [composer setToRecipients:[NSArray arrayWithObjects:@"andrew@openclik.com", nil]];
        [composer setSubject:@"inquiry from openclik dev center..."];
        [composer setMessageBody:@"" isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentModalViewController:composer animated:YES];
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
                                                        message:[NSString stringWithFormat:@"error %@", [error description]]
                                                       delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
        [alert show];

        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)sendTweet
{ TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init]; [twitter setInitialText:@"@openclik "];
//    [twitter addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://youtube.com/milmersXcode"]]];
    if([TWTweetComposeViewController canSendTweet])
//        [twitter setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:twitter animated:YES completion:nil];
    else { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to tweet" message:@"This only works with iOS 5 and a good connection. Please try again later" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]; [alertView show]; return; } twitter.completionHandler = ^(TWTweetComposeViewControllerResult res){ if (res == TWTweetComposeViewControllerResultDone) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"tweet sent!" message:@"we'll get back to you asap ;)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; } //else if
        //(res == TWTweetComposeViewControllerResultCancelled)
   // { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"oops!" message:@"tweet failed to send, plz try again later :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }
        [self dismissModalViewControllerAnimated:YES]; };
}

-(IBAction)toiphoneHB:(id)sender
{
    iphoneHB *anothaaa = [[iphoneHB alloc] initWithNibName:nil bundle:nil];
    anothaaa.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:anothaaa animated:YES];
}

-(IBAction)toiphoneHF:(id)sender
{
    iphoneHF *anothaaa = [[iphoneHF alloc] initWithNibName:nil bundle:nil];
    anothaaa.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:anothaaa animated:YES];
}

-(IBAction)toipadHB:(id)sender
{
    ipadHB *anothaaa = [[ipadHB alloc] initWithNibName:nil bundle:nil];
    anothaaa.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:anothaaa animated:YES];
}

-(IBAction)toipadHF:(id)sender
{
    ipadHF *anothaaa = [[ipadHF alloc] initWithNibName:nil bundle:nil];
    anothaaa.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:anothaaa animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        ||
        (interfaceOrientation == UIInterfaceOrientationPortrait)
        ;
    } else {
        return YES;
    }
}

@end
