#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor*)colorWithRGB:(NSUInteger)rgbValue {
    return [UIColor colorWithRGB:rgbValue alpha:1.0];
}

+ (UIColor*)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha {
    CGFloat red = (CGFloat)((rgbValue >> 16) & 0xff) / 255.0;
    CGFloat green = (CGFloat)((rgbValue >> 8) & 0xff) / 255.0;
    CGFloat blue = (CGFloat)((rgbValue) & 0xff) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSArray<UIColor*>*)_randomBGColors {
    static NSArray<UIColor*>* placeholderBGColors = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        placeholderBGColors = @[
            [UIColor colorWithRGB:0xFFFCF7],
            [UIColor colorWithRGB:0xF6FDF7],
            [UIColor colorWithRGB:0xF5FDFF],
            [UIColor colorWithRGB:0xFFFAFD],
            [UIColor colorWithRGB:0xFFF9F9],
            [UIColor colorWithRGB:0xF9FAFF],
            [UIColor colorWithRGB:0xFBF9FF],
        ];
    });
    return placeholderBGColors;
}

@end
