//
//  ShareService.m
//  Utility
//


#import "ShareService.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "MFMailComposeViewController+Landscape.h"
#import "NSString+URLEncode.h"

@implementation ShareService

+(void)shareInTwitterFromWeb:(NSString *)message url:(NSString *)urlString {
    NSString *u = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?original_referer=&url=%@&text=%@", urlString, message ];
    NSURL *url = [NSURL URLWithString:[u stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

+(void)shareInTwitter:(NSString *)message url:(NSString *)urlString image:(UIImage *)image viewController:(UIViewController *)viewController {
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ( 6 == [[versionCompatibility objectAtIndex:0] intValue] ) {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        
        NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
        
        if (arrayOfAccounts && arrayOfAccounts.count > 0) {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    [controller dismissViewControllerAnimated:YES completion:Nil];
                };
                controller.completionHandler = myBlock;
                
                [controller setInitialText:message];
                
                if (image) {
                    [controller addImage:image];
                }
                else if (urlString) {
                    [controller addURL:[NSURL URLWithString:urlString]];
                }
                
                [viewController presentViewController:controller animated:YES completion:Nil];
                
                
            }
            else {
                [self shareInTwitterFromWeb:message url:urlString];
            }
        }
        else {
            [self shareInTwitterFromWeb:message url:urlString];
        }
        
    }
    else if ( 5 == [[versionCompatibility objectAtIndex:0] intValue] ) {
        if ([TWTweetComposeViewController canSendTweet]) {
            
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            [twitter setInitialText:message];
            
            if (image) {
                [twitter addImage:image];
            }
            else if (urlString) {
                [twitter addURL:[NSURL URLWithString:urlString]];
            }
            
            [viewController presentViewController:twitter animated:YES completion:nil];
            
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
                if (res == TWTweetComposeViewControllerResultDone) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:NSLocalizedString(@"Tweet Ok", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Button OK", nil), nil ];
                    
                    [alert show];
                }
                
                [viewController dismissModalViewControllerAnimated:YES];
            };
            
        }
        else {
            [self shareInTwitterFromWeb:message url:urlString];
        }
    }
    else {
        [self shareInTwitterFromWeb:message url:urlString];
    }
    
}

+(void)shareInFacebookFromWeb:(NSString *)message url:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=%@&amp;t=%@", urlString, [NSString encodeHTMLEntities:message]]];
    [[UIApplication sharedApplication] openURL:url];
}


+(void)shareInFacebook:(NSString *)message url:(NSString *)urlString image:(UIImage *)image viewController:(UIViewController *)viewController {
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ( 6 == [[versionCompatibility objectAtIndex:0] intValue] ) {
        
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
        
        // Request access from the user to access their Twitter account
        
        if (arrayOfAccounts && arrayOfAccounts.count > 0) {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    [controller dismissViewControllerAnimated:YES completion:Nil];
                };
                controller.completionHandler =myBlock;
                
                [controller setInitialText:message];
                
                if (image) {
                    [controller addImage:image];
                }
                else if (urlString) {
                    [controller addURL:[NSURL URLWithString:urlString]];
                }
                
                [viewController presentViewController:controller animated:YES completion:Nil];
                
            }
            else {
                [self shareInFacebookFromWeb:message url:urlString];
            }
        }
        else {
            [self shareInFacebookFromWeb:message url:urlString];
        }
        
    }
    else {
        [self shareInFacebookFromWeb:message url:urlString];
    }
}

+(void)contactPublisher:(NSArray *)toContact subject:(NSString *)subject message:(NSString *)message inLandScape:(BOOL)landscape viewController:(UIViewController *)controller delegate:(id<MFMailComposeViewControllerDelegate>)delegate {
    // if the device can send emails show the email interface. if the device CANNOT send emails notify the user that he/she must configure the device first
	if ([MFMailComposeViewController canSendMail]) {
		// create the mail composer
		MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
		[MFMailComposeViewController setOnlyLandscape:landscape];
		// setup the email composer with subject, message body and recipients
		[emailComposer setMailComposeDelegate:delegate];
        
        if (toContact) {
            [emailComposer setToRecipients:toContact];
        }
        
		[emailComposer setSubject:subject];
        
		[emailComposer setMessageBody:message isHTML:YES];
        
		// show the email composer
        [controller presentModalViewController:emailComposer animated:YES];
	} else {
		// inform the user that he/she needs to configure the device first
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:NSLocalizedString (@"Device cannot send email", nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString (@"OK button", nil)
											  otherButtonTitles:nil];
		[alert show];
	}
}

+(void)shareInEmail:(NSString *)subject message:(NSString *)message url:(NSString *)urlString toContact:(NSArray *)toContact inLandScape:(BOOL)landscape viewController:(UIViewController *)controller delegate:(id<MFMailComposeViewControllerDelegate>)delegate {
    NSString *messageBody = [NSString stringWithFormat:message, urlString];
    [self contactPublisher:toContact subject:subject message:messageBody inLandScape:landscape viewController:controller delegate:delegate];
}

@end
