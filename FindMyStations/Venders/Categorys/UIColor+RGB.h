#import <UIKit/UIKit.h>

@interface UIColor (RGB)

/// 根据 RGB 值生成 UIColor
/// @param rgbValue 16位RGB值，如 0x0
+ (UIColor*)colorWithRGB:(NSUInteger)rgbValue;

/// 根据 RGB 值生成 UIColor
/// @param rgbValue 16位RGB值，如 0xffffff
/// @param alpha [0.0, 1.0]
+ (UIColor*)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha;

@end
