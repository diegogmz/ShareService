#import <MessageUI/MessageUI.h>

/** This category "overrides" the 
 */
@interface MFMailComposeViewController (Landscape)

/** Set to YES if the view controller should support only landscape orientations, set to NO if it should support only portrait orientations.
 */
+ (void) setOnlyLandscape:(BOOL)onlyLandscape;

@end
