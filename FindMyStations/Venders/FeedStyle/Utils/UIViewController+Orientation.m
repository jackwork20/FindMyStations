//
//  UIViewController+UIViewController_Orientation.m
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

#import "UIViewController+Orientation.h"

@implementation UIViewController (UIViewController_Orientation)
// 获取当前Windows
- (UIWindow *)currentWindow {
    NSArray *connectedScenes = [UIApplication.sharedApplication.connectedScenes allObjects];
    for (id scene in connectedScenes) {
        if ([scene isKindOfClass:UIWindowScene.class]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            NSArray *windows = [windowScene windows];
            if (windows.count > 0) {
                return windows[0];
            }
        }
    }
    return nil;
}


- (BOOL)smovRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
#ifdef __IPHONE_16_0
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        __block BOOL result = YES;
        UIInterfaceOrientationMask mask = 1 << interfaceOrientation;
        UIWindow *window = self.view.window ?: [self currentWindow];  //UIApplication.sharedApplication.delegate.window;
        [window.windowScene requestGeometryUpdateWithPreferences:
         [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask] errorHandler:^(NSError * _Nonnull error) {
            if (error) {
                result = NO;
            }
        }];
        return result;
    }  else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            NSNumber *orientationUnknown = @(UIInterfaceOrientationUnknown);
            [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
        }
        /// 延时一下调用，否则无法横屏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [UIViewController attemptRotationToDeviceOrientation];
        });
        
        return YES;
    }
#else
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *orientationUnknown = @(UIInterfaceOrientationUnknown);
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
    }
    [UIViewController attemptRotationToDeviceOrientation];
    return YES;
#endif
}

- (void)smovSetNeedsUpdateOfSupportedInterfaceOrientations {
    
    if (@available(iOS 16.0, *)) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000
            [self setNeedsUpdateOfSupportedInterfaceOrientations];
#else
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL supportedInterfaceSelector = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
            [self performSelector:supportedInterfaceSelector];
#pragma clang diagnostic pop
            
#endif
        });
        
    }
}
@end
