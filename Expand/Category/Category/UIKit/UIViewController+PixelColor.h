
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PixelColor)

/**
 判断颜色是否相等
 @return YES相等
 */
- (BOOL) isEqualColor:(UIColor*)color1 withColor:(UIColor*)color2;

/**
 获取屏幕截图
 @return 返回屏幕截图
 */
- (UIImage *)fullScreenshots;

/**
 获取点击的颜色
 @param point 点击位置
 @return 返回点击地方的颜色
 */
- (UIColor*)getPixelColorAtLocation:(CGPoint)point;

/**
 获取点击的颜色
 @param point 点击位置
 @param image 屏幕截图
 @return 返回点击地方的颜色
 */
- (UIColor*)getPixelColorAtLocation:(CGPoint)point withImage:(UIImage*)image;


@end

NS_ASSUME_NONNULL_END
