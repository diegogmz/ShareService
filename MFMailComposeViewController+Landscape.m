
#import "MFMailComposeViewController+Landscape.h"

/** Flags that controls which orientations are supported by the MFMailComposeViewController.
 */
static BOOL MFMCVC_ONLY_LANDSCAPE = NO;

@implementation MFMailComposeViewController (Landscape)

#pragma mark Public methods

/** Set to YES if the view controller should support only landscape orientations, set to NO if it should support only portrait orientations.
 */
+ (void) setOnlyLandscape:(BOOL)onlyLandscape {
    MFMCVC_ONLY_LANDSCAPE = onlyLandscape;
}

#pragma mark UIViewController

/** Returns a Boolean value indicating whether the view controller supports the specified orientation.
 @param toInterfaceOrientation The orientation of the application’s user interface after the rotation. The possible values are described in UIInterfaceOrientation.
 @return YES if the view controller supports the specified orientation or NO if it does not.
 */
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // the email composer is only available in landscape mode if MFMCVC_ONLY_LANDSCAPE is set to YES
    if (MFMCVC_ONLY_LANDSCAPE)
        return UIInterfaceOrientationIsLandscape (interfaceOrientation);
    
    return UIInterfaceOrientationIsPortrait (interfaceOrientation);
}

@end
