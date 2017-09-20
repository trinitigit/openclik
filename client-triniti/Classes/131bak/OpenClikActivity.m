//
//  OpenClikActivity.m
//  tabeee114
//
//  Created by Chang Zhidong on 13-2-5.
//
//

#import "OpenClikActivity.h"

@implementation OpenClikActivity
@end
/*
@interface ActivityItemSource : NSObject <UIActivityItemSource>
@property (nonatomic, strong) id object;
- (id) initWithObject:(id) objectToUse;
@end

@implementation ActivityItemSource

- (id) initWithObject:(id) objectToUse
{
    self = [super init];
    if (self) {
        self.object = objectToUse;
    }
    return self;
}


- (id)activityViewController:(UIActivityViewController *)activityViewController                 itemForActivityType:(NSString *)activityType
{
    if([activityType isEqualToString:UIActivityTypeMail]) {
        //TODO: fix; this is a hack; but we have to wait till apple fixes the         inability to set subject and html body of email when using UIActivityViewController
        [self setEmailContent:activityViewController];
        return nil;
    }
    return self.object;
}
- (void) setEmailContent:(UIActivityViewController *)activityViewController
{
    
    MFMailComposeViewController *mailController = [MFMailComposeViewController mailComposeControllerWithObject: self.object withDelegate: activityViewController];
    
    [activityViewController presentViewController:mailController animated:YES completion:nil];
    
}
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    
    return self.object;
}
@end
@implementation ActivityViewController

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    switch (result)
    {
        case MFMailComposeResultSent:
        case MFMailComposeResultSaved:
            //successfully composed an email
            break;
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultFailed:
            break;
    }
    
    //dismiss the compose view and then the action view
    [self dismissViewControllerAnimated:YES completion:^() {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (id) initWithObject:(id) objectToUse
{
    
    self = [super initWithActivityItems:[NSArray arrayWithObjects:[[ActivityItemSource alloc] initWithObject:objectToUse], nil] applicationActivities:nil];
    
    if (self) {
        self.excludedActivityTypes = [NSArray arrayWithObjects: UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, nil];
        
        self.object = objectToUse;
    }
    return self;
}
@end
*/