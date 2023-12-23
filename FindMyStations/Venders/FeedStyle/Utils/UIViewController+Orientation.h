//
//  UIViewController+UIViewController_Orientation.h
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UIViewController_Orientation)
- (UIWindow *)currentWindow;
- (BOOL)smovRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)smovSetNeedsUpdateOfSupportedInterfaceOrientations;
@end

NS_ASSUME_NONNULL_END
