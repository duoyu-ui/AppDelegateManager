
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Create)

/**
 根据图片生成UIBarButtonItem
 @param target target对象
 @param action 响应方法
 @param image 图片
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(nullable UIImage *)image;

/**
 根据图片生成UIBarButtonItem
 @param target target对象
 @param action 响应方法
 @param image 图片
 @param imageEdgeInsets 图片偏移
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(nullable UIImage *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

/**
 根据图片生成UIBarButtonItem
 @param target target对象
 @param action 响应方法
 @param nomalImage 正常图片
 @param higeLightedImage 选中图片
 @param imageEdgeInsets 图片偏移
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                         nomalImage:(nullable UIImage *)nomalImage
                   higeLightedImage:(nullable UIImage *)higeLightedImage
                    imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

/**
 根据文字生成UIBarButtonItem
 @param target target对象
 @param action 响应方法
 @param title 标题
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(nullable NSString *)title;

/**
 根据文字生成UIBarButtonItem
 @param target target对象
 @param action 响应方法
 @param title 标题
 @param titleEdgeInsets 文字偏移
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(nullable NSString *)title titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;

/**
 根据文字生成UIBarButtonItem
 @param target target对象
 @param action 响应方法
 @param title 标题
 @param font 标题字体
 @param titleColor 字体颜色
 @param highlightedColor 高亮颜色
 @param titleEdgeInsets 文字偏移
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              title:(nullable NSString *)title
                               font:(nullable UIFont *)font
                         titleColor:(nullable UIColor *)titleColor
                   highlightedColor:(nullable UIColor *)highlightedColor
                    titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;

/**
 用作修正位置的UIBarButtonItem
 @param width 修正宽度
 @return 修正位置的UIBarButtonItem
 */
+ (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END

