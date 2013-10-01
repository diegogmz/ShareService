//
//  ShareService.h
//  Utility
//


#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ShareService : NSObject

+(void)shareInTwitterFromWeb:(NSString *)message url:(NSString *)urlString;
+(void)shareInTwitter:(NSString *)message url:(NSString *)urlString image:(UIImage *)image viewController:(UIViewController *)viewController;
+(void)shareInFacebookFromWeb:(NSString *)message url:(NSString *)urlString;
+(void)shareInFacebook:(NSString *)message url:(NSString *)urlString image:(UIImage *)image viewController:(UIViewController *)viewController;
+(void)shareInEmail:(NSString *)subject message:(NSString *)message url:(NSString *)urlString toContact:(NSArray *)toContact inLandScape:(BOOL)landscape viewController:(UIViewController *)controller delegate:(id<MFMailComposeViewControllerDelegate>)delegate;

@end
